import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:kopikot/data/local/local_game_store.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/data/local/profile_record.dart';
import 'package:kopikot/data/repositories/local_game_repository.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/learning_task.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/domain/rules/growth_rules.dart';
import 'package:kopikot/domain/rules/mini_game_rules.dart';
import 'support/native_isar.dart';

void main() {
  late Directory directory;
  late LocalGameStore store;
  late LocalGameRepository repository;
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
    taskSource: File('assets/content/tasks.json').readAsStringSync(),
  );

  Future<GameProfile> create() => repository.createProfile(
    petName: '  Финни  ',
    coat: PetCoat.grey,
    accessory: PetAccessory.bow,
  );

  setUpAll(initializeTestIsar);

  test('Одновременные правильные ответы дают одну награду', () async {
    await repository.createProfile(
      petName: 'Финни',
      coat: PetCoat.grey,
      accessory: PetAccessory.bow,
    );
    await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
    await Future.wait([
      repository.submitTask('saving_start', const TaskAnswer(savings: 10)),
      repository.submitTask('saving_start', const TaskAnswer(savings: 10)),
    ]);
    final profile = (await repository.loadProfile())!;
    expect(profile.balance, 122);
    expect(profile.taskProgress.single.attempts, 1);
    expect(profile.transactions.length, 3);
    final reward = profile.transactions.last;
    expect(reward.baseReward, 12);
    expect(reward.startSatiety, 70);
    expect(reward.startEnergy, 70);
  });

  test(
    'Подсказка, разбор и награда после «Понятно» переживают перезапуск',
    () async {
      await create();
      await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
      await repository.submitTask('saving_start', const TaskAnswer());
      await repository.submitTask('saving_start', const TaskAnswer());
      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'test',
      );
      repository = LocalGameRepository(store, catalog);
      var profile = (await repository.loadProfile())!;
      expect(profile.taskProgress.single.hintUsed, isTrue);
      expect(profile.taskProgress.single.solutionShown, isTrue);
      expect(profile.balance, 110);
      profile = await repository.acknowledgeTask('saving_start');
      expect(profile.balance, 122);
      expect(profile.taskProgress.single.reviewed, isTrue);
      profile = await repository.acknowledgeTask('saving_start');
      expect(profile.balance, 122);
    },
  );

  test(
    'Настройка движения переживает переключение, сброс, удаление и перезапуск',
    () async {
      expect(await repository.loadReduceMotion(), isFalse);
      await repository.saveReduceMotion(true);
      await create();
      await repository.switchProfile(testProfile: true);
      expect(await repository.loadReduceMotion(), isTrue);
      await repository.resetTestProfile();
      await Future.wait([
        repository.saveReduceMotion(false),
        repository.switchProfile(testProfile: false),
      ]);
      expect(await repository.loadReduceMotion(), isFalse);
      expect((await repository.loadProfile())!.isTest, isFalse);
      await repository.saveReduceMotion(true);
      await repository.deleteRegularProfile();
      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'test',
      );
      repository = LocalGameRepository(store, catalog);
      expect(await repository.loadReduceMotion(), isTrue);
      expect(await repository.loadProfile(), isNull);
      expect(
        (await repository.switchProfile(testProfile: true))!.isTest,
        isTrue,
      );
      expect(await repository.loadReduceMotion(), isTrue);
    },
  );

  test(
    'Добавление коллекции настроек сохраняет старую базу с одним профилем',
    () async {
      final legacyDirectory = await Directory(
        '${directory.path}/legacy',
      ).create();
      final legacy = await Isar.open(
        [ProfileRecordSchema],
        directory: legacyDirectory.path,
        name: 'legacy',
      );
      await legacy.writeTxn(
        () => legacy.profileRecords.put(
          ProfileRecord()
            ..petName = 'Старый друг'
            ..coat = PetCoat.grey.name
            ..accessory = PetAccessory.bow.name
            ..balance = 67
            ..incomeSource = 'Подарок на знакомство'
            ..incomeAmount = 100,
        ),
      );
      await legacy.close();
      final upgraded = await LocalGameStore.open(
        directory: legacyDirectory.path,
        name: 'legacy',
      );
      try {
        final upgradedRepository = LocalGameRepository(upgraded, catalog);
        final regular = (await upgradedRepository.loadProfile())!;
        expect(regular.petName, 'Старый друг');
        expect(regular.balance, 67);
        expect(regular.isTest, isFalse);
        await upgradedRepository.switchProfile(testProfile: true);
        expect(
          (await upgradedRepository.switchProfile(testProfile: false))!.balance,
          67,
        );
      } finally {
        await upgraded.close();
      }
    },
  );

  test(
    'Тестовый профиль сохраняется отдельно и выбор переживает перезапуск',
    () async {
      await create();
      await repository.confirmBudget(needs: 25, wants: 0, savings: 20);
      await repository.purchase('porridge', commandId: 'regular-food');
      final demo = (await repository.switchProfile(testProfile: true))!;
      expect(demo.isTest, isTrue);
      expect(demo.petName, 'Финни Тест');
      expect(demo.selectedGoalId, 'tent');
      expect(demo.balance, 100);
      await repository.confirmBudget(needs: 25, wants: 0, savings: 20);
      await repository.submitTask(
        'saving_start',
        const TaskAnswer(savings: 10),
      );
      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'test',
      );
      repository = LocalGameRepository(store, catalog);
      final restored = (await repository.loadProfile())!;
      expect(restored.isTest, isTrue);
      expect(restored.balance, 112);
      expect(restored.completedTask('saving_start'), isTrue);
      final regular = (await repository.switchProfile(testProfile: false))!;
      expect(regular.isTest, isFalse);
      expect(regular.petName, 'Финни');
      expect(regular.balance, 75);
      expect(regular.transactions.last.id, 'regular-food');
      expect(regular.taskProgress, isEmpty);
      expect((await repository.switchProfile(testProfile: true))!.balance, 112);
    },
  );

  test(
    'Пять тестовых периодов и полный сброс не меняют обычный прогресс',
    () async {
      await create();
      await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
      await repository.submitTask(
        'saving_start',
        const TaskAnswer(savings: 10),
      );
      await repository.switchProfile(testProfile: true);
      for (var period = 1; period <= 5; period++) {
        await repository.confirmBudget(needs: 25, wants: 0, savings: 20);
        await repository.purchase('porridge', commandId: 'test-food-$period');
        await repository.transfer(
          'tent',
          20,
          commandId: 'test-save-$period',
          withdraw: false,
        );
        await repository.submitTask(
          'saving_start',
          const TaskAnswer(savings: 10),
        );
        await repository.finishPeriod(period);
      }
      expect((await repository.loadProfile())!.growthStage, 3);
      final reset = await repository.resetTestProfile();
      expect(reset.isTest, isTrue);
      expect(reset.balance, 100);
      expect(reset.savings, 0);
      expect(reset.goalSavings, isEmpty);
      expect(reset.transactions.length, 1);
      expect(reset.transactions.single.id, 'initial-income');
      expect(reset.taskProgress, isEmpty);
      expect(reset.periodSummaries, isEmpty);
      expect(reset.period, 1);
      expect(reset.growthStage, 1);
      expect(reset.plan, isNull);
      expect(reset.satiety, 70);
      expect(reset.mood, 70);
      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'test',
      );
      repository = LocalGameRepository(store, catalog);
      expect((await repository.loadProfile())!.balance, 100);
      final regular = (await repository.switchProfile(testProfile: false))!;
      expect(regular.balance, 112);
      expect(regular.completedTask('saving_start'), isTrue);
      expect(regular.plan, isNotNull);
      expect(regular.period, 1);
    },
  );

  test(
    'Удаление обычного профиля полное, тестовое сохранение остаётся',
    () async {
      await create();
      await repository.confirmBudget(needs: 25, wants: 0, savings: 20);
      await repository.selectGoal('tent');
      await repository.transfer('tent', 20, commandId: 'save', withdraw: false);
      await repository.submitTask(
        'saving_start',
        const TaskAnswer(savings: 10),
      );
      await repository.finishPeriod(1);
      await repository.switchProfile(testProfile: true);
      await repository.confirmBudget(needs: 25, wants: 0, savings: 20);
      await repository.purchase('porridge', commandId: 'test-buy');
      await expectLater(
        repository.deleteRegularProfile(),
        throwsA(isA<GameRuleException>()),
      );
      await repository.switchProfile(testProfile: false);
      await repository.deleteRegularProfile();
      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'test',
      );
      repository = LocalGameRepository(store, catalog);
      expect(await repository.loadProfile(), isNull);
      expect((await repository.switchProfile(testProfile: true))!.balance, 75);
      await repository.switchProfile(testProfile: false);
      final recreated = await create();
      expect(recreated.balance, 100);
      expect(recreated.savings, 0);
      expect(recreated.transactions.length, 1);
      expect(recreated.taskProgress, isEmpty);
      expect(recreated.periodSummaries, isEmpty);
    },
  );

  test('Демо доступно без обычного профиля; сброс вне демо запрещён', () async {
    await expectLater(
      repository.resetTestProfile(),
      throwsA(isA<GameRuleException>()),
    );
    expect((await repository.switchProfile(testProfile: true))!.balance, 100);
    expect(await repository.switchProfile(testProfile: false), isNull);
    expect(await repository.loadProfile(), isNull);
    expect(
      (await repository.switchProfile(testProfile: true))!.transactions.length,
      1,
    );
  });

  test(
    'Ошибка открытия повреждённого тестового профиля не меняет режим',
    () async {
      await create();
      await repository.switchProfile(testProfile: true);
      await store.updateProfile((current) => current!..balance = -1);
      await repository.switchProfile(testProfile: false);
      await expectLater(
        repository.switchProfile(testProfile: true),
        throwsStateError,
      );
      expect((await repository.loadProfile())!.isTest, isFalse);
      expect((await repository.loadProfile())!.balance, 100);
    },
  );

  test('Пять периодов проходят в Isar с перезапуском после каждого', () async {
    await repository.createProfile(
      petName: 'Финни',
      coat: PetCoat.grey,
      accessory: PetAccessory.bow,
    );
    await repository.selectGoal('tent');
    for (int period = 1; period <= 5; period++) {
      await repository.confirmBudget(needs: 25, wants: 0, savings: 20);
      await repository.purchase('porridge', commandId: 'food-$period');
      await repository.transfer(
        'tent',
        20,
        commandId: 'save-$period',
        withdraw: false,
      );
      await repository.finishPeriod(period);
      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'test',
      );
      repository = LocalGameRepository(store, catalog);
      final profile = (await repository.loadProfile())!;
      expect(profile.period, period + 1);
      expect(profile.periodSummaries.length, period);
      expect(GrowthRules.qualifyingPeriods(profile), period);
      expect(profile.plan, isNull);
    }
    expect((await repository.loadProfile())!.growthStage, 3);
    // Пять периодов дают только базовый доход; награда — отдельное действие.
    expect((await repository.loadProfile())!.balance, 375);
  });

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('finny_isar_test_');
    store = await LocalGameStore.open(directory: directory.path, name: 'test');
    repository = LocalGameRepository(store, catalog);
  });

  tearDown(() async {
    await store.close();
    await directory.delete(recursive: true);
  });

  test(
    'Награда мини-игры сохраняется и одна команда не платит дважды',
    () async {
      await create();
      await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
      final first = await repository.claimMiniGame(
        MiniGameKind.accountant,
        'accountant-round-1',
      );
      expect(first.balance, 116);
      await repository.claimMiniGame(
        MiniGameKind.accountant,
        'accountant-round-1',
      );

      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'test',
      );
      repository = LocalGameRepository(store, catalog);
      final restored = (await repository.loadProfile())!;
      expect(restored.balance, 116);
      expect(
        restored.transactions.where(
          (entry) => entry.referenceId == MiniGameKind.accountant.name,
        ),
        hasLength(1),
      );
      final payout = restored.transactions.firstWhere(
        (entry) => entry.referenceId == MiniGameKind.accountant.name,
      );
      expect(payout.baseReward, 6);
      expect(payout.startEnergy, 70);

      final next = await repository.claimMiniGame(
        MiniGameKind.accountant,
        'accountant-round-2',
      );
      expect(next.balance, 116);
    },
  );

  test('Саженцы, серия, прогулка и энергия переживают перезапуск', () async {
    await create();
    await repository.confirmBudget(needs: 20, wants: 0, savings: 0);
    await repository.plantSapling('sapling_10', 'seed');
    await repository.walk();
    await repository.claimDailyReward();
    await repository.finishPeriod(1);
    await store.close();
    store = await LocalGameStore.open(directory: directory.path, name: 'test');
    repository = LocalGameRepository(store, catalog);
    final profile = (await repository.loadProfile())!;
    expect(profile.saplings.single.definitionId, 'sapling_10');
    expect(profile.saplings.single.plantedPeriod, 1);
    expect(profile.streak, 2);
    expect(profile.lastRewardAt, isNotNull);
    expect(profile.walkPeriod, 1);
    expect(profile.energy, 70);
    expect(profile.balance, 185);
    final claimedAgain = await repository.claimDailyReward();
    expect(claimedAgain.balance, 185);
    expect(
      claimedAgain.transactions.where(
        (entry) => entry.label.startsWith('Ежедневная награда:'),
      ),
      hasLength(1),
    );
    // Повторная прогулка в новом периоде доступна и бодрит.
    final walked = await repository.walk();
    expect(walked.energy, 85);
    expect(walked.walkPeriod, 2);
  });

  test('Миграция схемы 4 сохраняет прогресс и добавляет новые поля', () async {
    await create();
    await repository.confirmBudget(needs: 25, wants: 0, savings: 20);
    await repository.purchase('porridge', commandId: 'old-buy');
    await store.updateProfile((current) => current!..schemaVersion = 4);
    final profile = (await repository.loadProfile())!;
    expect(profile.balance, 75);
    expect(profile.energy, 70);
    expect(profile.streak, 1);
    expect(profile.walkPeriod, 0);
    expect(profile.saplings, isEmpty);
    expect((await store.readProfile())!.schemaVersion, 8);
  });

  test(
    'Награда задания и итоги периода сохраняются без повторных начислений',
    () async {
      await create();
      await repository.confirmBudget(needs: 25, wants: 0, savings: 20);
      await repository.submitTask('budget_lunch', const TaskAnswer());
      await repository.submitTask(
        'budget_lunch',
        const TaskAnswer(needs: 30, wants: 20, savings: 10),
      );
      await repository.selectGoal('tent');
      await repository.purchase('porridge', commandId: 'food');
      await repository.transfer('tent', 20, commandId: 'save', withdraw: false);
      await repository.finishPeriod(1);
      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'test',
      );
      repository = LocalGameRepository(store, catalog);
      var profile = (await repository.loadProfile())!;
      // Награда за вход отдельна от дохода следующего периода.
      expect(profile.balance, 163);
      expect(profile.period, 2);
      expect(profile.plan, isNull);
      expect(profile.completedTask('budget_lunch'), isTrue);
      expect(profile.taskProgress.single.attempts, 2);
      expect(profile.periodSummaries.single.supportsGrowth, isTrue);
      await repository.submitTask(
        'budget_lunch',
        const TaskAnswer(needs: 30, wants: 20, savings: 10),
      );
      await repository.finishPeriod(1);
      profile = (await repository.loadProfile())!;
      expect(profile.balance, 163);
      expect(profile.periodSummaries.length, 1);
    },
  );

  test('Покупки и переводы восстанавливаются после перезапуска Isar', () async {
    await create();
    await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
    await repository.purchase('porridge', commandId: 'buy');
    await repository.selectGoal('tent');
    await repository.transfer('tent', 30, commandId: 'put', withdraw: false);
    await repository.transfer('tent', 10, commandId: 'take', withdraw: true);
    await store.close();
    store = await LocalGameStore.open(directory: directory.path, name: 'test');
    repository = LocalGameRepository(store, catalog);
    final profile = (await repository.loadProfile())!;
    expect(profile.balance, 55);
    expect(profile.savings, 20);
    expect(profile.selectedGoalId, 'tent');
    expect(profile.savedFor('tent'), 20);
    expect(profile.actualNeeds, 25);
    expect(profile.netSaved, 20);
    expect(profile.satiety, 90);
    expect(profile.transactions.length, 4);
    await repository.purchase('porridge', commandId: 'buy');
    expect((await repository.loadProfile())!.balance, 55);
  });

  test('Открытый выбор целей сохраняется после перезапуска', () async {
    final created = await create();
    expect(created.goalChoicesUnlocked, isFalse);
    await store.updateProfile(
      (current) => current!..goalChoicesUnlocked = true,
    );
    await store.close();
    store = await LocalGameStore.open(directory: directory.path, name: 'test');
    repository = LocalGameRepository(store, catalog);
    expect((await repository.loadProfile())!.goalChoicesUnlocked, isTrue);
  });

  test('Несогласованные накопления не исправляются потерей монет', () async {
    await create();
    await store.updateProfile((current) => current!..savings = 40);
    await expectLater(repository.loadProfile(), throwsStateError);
    expect((await store.readProfile())!.savings, 40);
  });

  test('Две одновременные покупки не создают отрицательный баланс', () async {
    await create();
    await repository.confirmBudget(needs: 0, wants: 100, savings: 0);
    final results = await Future.wait([
      repository
          .purchase('puzzle', commandId: 'one')
          .then<Object>((value) => value, onError: (Object error) => error),
      repository
          .purchase('puzzle', commandId: 'two')
          .then<Object>((value) => value, onError: (Object error) => error),
    ]);
    expect(results.whereType<GameProfile>().length, 1);
    expect(results.whereType<GameRuleException>().length, 1);
    final profile = (await repository.loadProfile())!;
    expect(profile.balance, 20);
    expect(profile.transactions.length, 2);
  });

  test('Неудачная покупка и снятие не оставляют частичную историю', () async {
    await create();
    await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
    await repository.selectGoal('tent');
    await repository.transfer(
      'tent',
      90,
      commandId: 'deposit',
      withdraw: false,
    );
    await expectLater(
      repository.purchase('ball', commandId: 'buy'),
      throwsA(isA<GameRuleException>()),
    );
    await expectLater(
      repository.transfer('tent', 91, commandId: 'withdraw', withdraw: true),
      throwsA(isA<GameRuleException>()),
    );
    final profile = (await repository.loadProfile())!;
    expect(profile.balance, 10);
    expect(profile.savings, 90);
    expect(profile.transactions.length, 2);
  });

  test(
    'Миграция версии 1 сохраняет профиль и план и создаёт одну запись дохода',
    () async {
      await store.updateProfile(
        (_) => ProfileRecord()
          ..schemaVersion = 1
          ..petName = 'Старый друг'
          ..coat = 'cream'
          ..accessory = 'cap'
          ..balance = 100
          ..incomeAmount = 100
          ..incomeSource = 'Подарок на знакомство'
          ..budgetConfirmed = true
          ..plannedBalance = 100
          ..plannedNeeds = 50
          ..plannedWants = 20
          ..plannedSavings = 30,
      );
      final profile = (await repository.loadProfile())!;
      expect(profile.petName, 'Старый друг');
      expect(profile.plan!.savings, 30);
      expect(profile.balance, 100);
      expect(profile.transactions.single.amount, 100);
      await repository.loadProfile();
      expect((await store.readProfile())!.schemaVersion, 8);
      expect((await repository.loadProfile())!.transactions.length, 1);
    },
  );

  test('Профиль, доход и план восстанавливаются после закрытия Isar', () async {
    expect(await repository.loadProfile(), isNull);
    await create();
    await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
    await store.close();
    store = await LocalGameStore.open(directory: directory.path, name: 'test');
    repository = LocalGameRepository(store, catalog);
    final profile = (await repository.loadProfile())!;
    expect(profile.petName, 'Финни');
    expect(profile.coat, PetCoat.grey);
    expect(profile.accessory, PetAccessory.bow);
    expect(profile.balance, 100);
    expect(profile.savings, 0);
    expect(profile.incomeAmount, 100);
    expect(profile.incomeSource, 'Подарок на знакомство');
    expect(profile.plan!.needs, 50);
    expect(profile.plan!.wants, 20);
    expect(profile.plan!.savings, 30);
  });

  test('Прогноз и пересмотр бюджета переживают перезапуск', () async {
    await create();
    await repository.confirmBudget(
      needs: 40,
      wants: 20,
      savings: 20,
      kept: 26,
      expectedIncome: 6,
      sourceIds: const ['game:accountant'],
    );
    await repository.reviseBudget(
      needs: 35,
      wants: 25,
      savings: 20,
      kept: 26,
      expectedIncome: 6,
      sourceIds: const ['game:accountant'],
    );
    await store.close();
    store = await LocalGameStore.open(directory: directory.path, name: 'test');
    repository = LocalGameRepository(store, catalog);
    final profile = (await repository.loadProfile())!;
    expect(profile.balance, 100);
    expect(profile.plan!.openingBalance, 100);
    expect(profile.plan!.expectedIncome, 6);
    expect(profile.plan!.kept, 26);
    expect(profile.budgetRevisions.single.plan.needs, 40);
  });

  test('Купленные аксессуары и снятый вид переживают перезапуск', () async {
    await create();
    await repository.confirmBudget(needs: 20, wants: 50, savings: 30);
    await repository.purchase('explorer_cap', commandId: 'buy-cap');
    await repository.equipAccessory(PetAccessory.cap);
    await repository.equipAccessory(null);
    await store.close();
    store = await LocalGameStore.open(directory: directory.path, name: 'test');
    repository = LocalGameRepository(store, catalog);
    final profile = (await repository.loadProfile())!;
    expect(profile.accessory, isNull);
    expect(profile.ownsAccessory(PetAccessory.bow), isTrue);
    expect(profile.ownsAccessory(PetAccessory.cap), isTrue);
  });

  test('Новые аксессуары остаются в гардеробе после перезапуска', () async {
    await create();
    await repository.confirmBudget(needs: 35, wants: 65, savings: 0);
    await repository.purchase('sport_headband', commandId: 'buy-headband');
    await repository.purchase('blue_wristbands', commandId: 'buy-wristbands');
    await repository.equipAccessory(PetAccessory.headband);
    await store.close();
    store = await LocalGameStore.open(directory: directory.path, name: 'test');
    repository = LocalGameRepository(store, catalog);

    var profile = (await repository.loadProfile())!;
    expect(profile.accessory, PetAccessory.headband);
    expect(profile.ownsAccessory(PetAccessory.headband), isTrue);
    expect(profile.ownsAccessory(PetAccessory.wristbands), isTrue);
    expect(profile.balance, 35);

    await repository.equipAccessory(PetAccessory.wristbands);
    await repository.equipAccessory(null);
    profile = (await repository.loadProfile())!;
    expect(profile.accessory, isNull);
    expect(profile.ownsAccessory(PetAccessory.headband), isTrue);
    expect(profile.ownsAccessory(PetAccessory.wristbands), isTrue);
    expect(profile.balance, 35);
  });

  test(
    'Местная дата закрывает день и начисляет награду только один раз',
    () async {
      var now = DateTime(2026, 9, 28, 12);
      repository = LocalGameRepository(store, catalog, clock: () => now);
      final first = await create();
      expect(first.dayKey, '2026-09-28');
      expect(first.balance, 110);
      await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
      expect((await repository.loadProfile())!.balance, 110);

      now = DateTime(2026, 9, 29, 9);
      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'test',
      );
      repository = LocalGameRepository(store, catalog, clock: () => now);
      final second = (await repository.loadProfile())!;
      expect(second.period, 2);
      expect(second.dayKey, '2026-09-29');
      expect(second.balance, 122);
      expect(second.plan, isNull);
      expect(second.periodSummaries.single.period, 1);
      expect(second.periodSummaries.single.plannedIncome, 0);
      expect((await repository.loadProfile())!.balance, 122);

      now = DateTime(2026, 10, 1, 9);
      final afterGap = (await repository.loadProfile())!;
      expect(afterGap.period, 3);
      expect(afterGap.balance, 134);
      expect(afterGap.periodSummaries.length, 2);
      expect(afterGap.periodSummaries.last.missedDays, 1);
      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'test',
      );
      repository = LocalGameRepository(store, catalog, clock: () => now);
      final restored = (await repository.loadProfile())!;
      expect(restored.balance, 134);
      expect(restored.periodSummaries.first.plannedIncome, 0);
      expect(restored.periodSummaries.last.missedDays, 1);
    },
  );

  test('Ручной следующий день доступен только в деморежиме', () async {
    var now = DateTime(2026, 9, 28, 12);
    repository = LocalGameRepository(store, catalog, clock: () => now);
    await create();
    await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
    await expectLater(
      repository.finishPeriod(1),
      throwsA(isA<GameRuleException>()),
    );
    await repository.switchProfile(testProfile: true);
    await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
    final next = await repository.finishPeriod(1);
    expect(next.period, 2);
    expect(next.balance, 122);
    expect(next.plan, isNull);
  });

  test(
    'Повторное создание не перезаписывает профиль и не начисляет доход',
    () async {
      await create();
      await expectLater(create(), throwsA(isA<GameRuleException>()));
      expect((await repository.loadProfile())!.balance, 100);
    },
  );

  test('Ошибка бюджета не записывает частичные изменения', () async {
    await create();
    await expectLater(
      repository.confirmBudget(needs: 100, wants: 1, savings: 0),
      throwsA(isA<GameRuleException>()),
    );
    final profile = (await repository.loadProfile())!;
    expect(profile.balance, 100);
    expect(profile.plan, isNull);
  });

  test('Одновременные подтверждения сохраняют ровно один план', () async {
    await create();
    final results = await Future.wait([
      repository
          .confirmBudget(needs: 50, wants: 20, savings: 30)
          .then<Object>((value) => value, onError: (Object error) => error),
      repository
          .confirmBudget(needs: 70, wants: 10, savings: 20)
          .then<Object>((value) => value, onError: (Object error) => error),
    ]);
    expect(results.whereType<GameProfile>().length, 1);
    expect(results.whereType<GameRuleException>().length, 1);
    expect((await repository.loadProfile())!.balance, 100);
  });
}
