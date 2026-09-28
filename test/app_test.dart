import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/period_summary.dart';
import 'package:kopikot/domain/models/game_transaction.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/rules/economy_rules.dart';
import 'package:kopikot/domain/rules/learning_rules.dart';
import 'package:kopikot/domain/rules/learning_difficulty_rules.dart';
import 'package:kopikot/domain/rules/period_rules.dart';
import 'package:kopikot/domain/rules/activity_rules.dart';
import 'package:kopikot/domain/rules/daily_reward_rules.dart';
import 'package:kopikot/domain/rules/mini_game_rules.dart';
import 'package:kopikot/domain/rules/accountant_rules.dart';
import 'package:kopikot/domain/rules/market_game_rules.dart';
import 'package:kopikot/domain/rules/activity_reward_rules.dart';
import 'package:kopikot/domain/rules/sapling_rules.dart';
import 'package:kopikot/domain/models/learning_task.dart';
import 'package:kopikot/domain/repositories/game_repository.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/main.dart';
import 'package:kopikot/presentation/providers/game_controller.dart';
import 'package:kopikot/presentation/widgets/pet_portrait.dart';
import 'package:kopikot/presentation/screens/tasks_screen.dart';
import 'package:kopikot/presentation/screens/accountant_screen.dart';
import 'package:kopikot/presentation/screens/market_game_screen.dart';
import 'package:kopikot/presentation/screens/budget_screen.dart';
import 'package:kopikot/presentation/screens/shop_screen.dart';
import 'package:kopikot/presentation/screens/savings_screen.dart';
import 'package:kopikot/presentation/screens/garden_screen.dart';
import 'package:kopikot/presentation/screens/history_screen.dart';
import 'package:kopikot/presentation/screens/progress_screen.dart';
import 'package:kopikot/presentation/screens/vet_screen.dart';
import 'package:kopikot/presentation/screens/adult_screen.dart';
import 'package:kopikot/presentation/screens/wardrobe_screen.dart';
import 'package:kopikot/presentation/widgets/accessible_motion.dart';

import 'game_rules_test.dart' show initialProfile;

class _MemoryRepository implements GameRepository {
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
    taskSource: File('assets/content/tasks.json').readAsStringSync(),
  );
  final profiles = <bool, GameProfile>{};
  bool testProfile = false;
  GameProfile? get profile => profiles[testProfile];
  set profile(GameProfile? value) {
    if (value == null) {
      profiles.remove(testProfile);
    } else {
      profiles[testProfile] = value;
    }
  }

  bool failCreate = false;
  bool failProfileAction = false;
  bool reduceMotion = false;
  @override
  Future<bool> loadReduceMotion() async => reduceMotion;
  @override
  Future<void> saveReduceMotion(bool value) async {
    if (failProfileAction) throw StateError('Simulated disk failure');
    reduceMotion = value;
  }

  GameProfile _demo() => const GameProfile(
    petName: 'Финни Тест',
    coat: PetCoat.ginger,
    accessory: PetAccessory.scarf,
    balance: 100,
    savings: 0,
    period: 1,
    satiety: 70,
    mood: 70,
    incomeSource: 'Подарок на знакомство',
    incomeAmount: 100,
    isTest: true,
    selectedGoalId: 'tent',
  );

  @override
  Future<GameProfile?> switchProfile({required bool testProfile}) async {
    if (failProfileAction) throw StateError('Simulated disk failure');
    this.testProfile = testProfile;
    if (testProfile) profiles.putIfAbsent(true, _demo);
    return profile;
  }

  @override
  Future<GameProfile> resetTestProfile() async {
    if (failProfileAction) throw StateError('Simulated disk failure');
    if (!testProfile) throw StateError('Test profile required');
    return profile = _demo();
  }

  @override
  Future<void> deleteRegularProfile() async {
    if (failProfileAction) throw StateError('Simulated disk failure');
    if (testProfile) throw StateError('Regular profile required');
    profile = null;
  }

  @override
  Future<GameProfile> submitTask(
    String taskId,
    TaskAnswer answer, {
    ActivityRewardSnapshot? snapshot,
  }) async => profile = LearningRules.submit(
    profile!,
    catalog,
    catalog.task(taskId),
    answer,
    snapshot: snapshot,
  );
  @override
  Future<GameProfile> acknowledgeTask(
    String taskId, {
    ActivityRewardSnapshot? snapshot,
  }) async => profile = LearningRules.acknowledge(
    profile!,
    catalog.task(taskId),
    snapshot: snapshot,
  );
  @override
  Future<GameProfile> chooseLearningDifficulty(
    String topic,
    LearningDifficulty difficulty,
  ) async =>
      profile = LearningDifficultyRules.choose(profile!, topic, difficulty);
  @override
  Future<GameProfile> dismissLearningDowngrade(String topic) async =>
      profile = LearningDifficultyRules.dismissDowngrade(profile!, topic);
  @override
  Future<GameProfile> claimMiniGame(
    MiniGameKind kind,
    String commandId, {
    ActivityRewardSnapshot? snapshot,
  }) async => profile = MiniGameRules.claim(
    profile!,
    kind,
    commandId,
    snapshot: snapshot,
  );
  @override
  Future<GameProfile> accountantAction(
    String sessionId,
    AccountantAction action, {
    int? answer,
  }) async => profile = AccountantRules.apply(
    profile!,
    sessionId,
    action,
    answer: answer,
  );
  @override
  Future<GameProfile> marketAction(
    String sessionId,
    MarketAction action, {
    String? itemId,
  }) async => profile = MarketGameRules.apply(
    profile!,
    sessionId,
    action,
    itemId: itemId,
  );
  @override
  Future<GameProfile> claimDailyReward() async =>
      profile = DailyRewardRules.claim(profile!);
  @override
  Future<GameProfile> finishPeriod(int expectedPeriod) async =>
      profile = PeriodRules.finish(profile!, expectedPeriod);

  @override
  Future<GameProfile> purchase(
    String productId, {
    required String commandId,
  }) async => profile = EconomyRules.purchase(
    profile!,
    catalog.product(productId),
    commandId,
  );
  @override
  Future<GameProfile> purchaseGoal(String goalId, String commandId) async =>
      profile = EconomyRules.purchaseGoal(
        profile!,
        catalog.goal(goalId),
        commandId,
      );
  @override
  Future<GameProfile> transferReserve(
    int amount, {
    required String commandId,
    required bool withdraw,
  }) async => profile = EconomyRules.transferReserve(
    profile!,
    amount,
    commandId: commandId,
    withdraw: withdraw,
  );
  @override
  Future<GameProfile> equipAccessory(PetAccessory? accessory) async =>
      profile = EconomyRules.equipAccessory(profile!, accessory);
  @override
  Future<GameProfile> walk() async => profile = ActivityRules.walk(profile!);
  @override
  Future<GameProfile> plantSapling(
    String definitionId,
    String commandId,
  ) async => profile = SaplingRules.plant(
    profile!,
    catalog.sapling(definitionId),
    commandId,
  );
  @override
  Future<GameProfile> harvestSapling(String saplingId, String commandId) async {
    final state = profile!.saplings.firstWhere(
      (sapling) => sapling.id == saplingId,
    );
    return profile = SaplingRules.harvest(
      profile!,
      state,
      catalog.sapling(state.definitionId),
      commandId,
    );
  }

  @override
  Future<GameProfile> selectGoal(String goalId) async =>
      profile = EconomyRules.selectGoal(profile!, catalog.goal(goalId));
  @override
  Future<GameProfile> transfer(
    String goalId,
    int amount, {
    required String commandId,
    required bool withdraw,
  }) async => profile = EconomyRules.transfer(
    profile!,
    catalog.goal(goalId),
    amount,
    commandId: commandId,
    withdraw: withdraw,
  );

  @override
  Future<GameProfile?> loadProfile() async => profile;

  @override
  Future<GameProfile> createProfile({
    required String petName,
    required PetCoat coat,
    required PetAccessory accessory,
  }) async {
    if (failCreate) throw StateError('Simulated disk failure');
    return profile = GameProfile(
      petName: GameRules.validatePetName(petName),
      coat: coat,
      accessory: accessory,
      balance: 100,
      savings: 0,
      period: 1,
      satiety: 70,
      mood: 70,
      incomeSource: 'Подарок на знакомство',
      incomeAmount: 100,
    );
  }

  @override
  Future<GameProfile> confirmBudget({
    required int needs,
    required int wants,
    required int savings,
    int gifts = 0,
    int kept = 0,
    int expectedIncome = 0,
    List<String> sourceIds = const [],
  }) async => profile = profile!.withPlan(
    GameRules.confirmBudget(
      profile!,
      needs: needs,
      wants: wants,
      gifts: gifts,
      savings: savings,
      kept: kept,
      expectedIncome: expectedIncome,
      sourceIds: sourceIds,
    ),
  );

  @override
  Future<GameProfile> reviseBudget({
    required int needs,
    required int wants,
    required int savings,
    int gifts = 0,
    int kept = 0,
    int expectedIncome = 0,
    List<String> sourceIds = const [],
  }) async => profile = GameRules.reviseBudget(
    profile!,
    needs: needs,
    wants: wants,
    savings: savings,
    gifts: gifts,
    kept: kept,
    expectedIncome: expectedIncome,
    sourceIds: sourceIds,
  );
}

void main() {
  Future<void> launch(
    WidgetTester tester,
    _MemoryRepository repository, {
    double scale = 1,
    GlobalKey? captureKey,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWith((ref) async => repository),
        ],
        child: captureKey == null
            ? const KopiKotApp()
            : RepaintBoundary(key: captureKey, child: const KopiKotApp()),
      ),
    );
    // В приложении репозиторий ожидает каталог при запуске. Тестовый репозиторий
    // не имеет этой зависимости, поэтому ждём реальный asset явно.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    await tester.runAsync(() => container.read(gameCatalogProvider.future));
    await tester.pumpAndSettle();
  }

  test('Награда: один раз в день, пропуск снижает серию на один шаг', () {
    final start = DateTime(2026, 9, 1, 10);
    final first = DailyRewardRules.claim(initialProfile, now: start);
    expect(first.balance, 105);
    expect(first.streak, 2);
    expect(first.transactions.last.amount, 5);
    expect(DailyRewardRules.canClaim(first, now: start), isFalse);
    expect(DailyRewardRules.claim(first, now: start), same(first));

    final second = DailyRewardRules.claim(
      first,
      now: start.add(const Duration(days: 1)),
    );
    expect(second.balance, 115);
    expect(second.streak, 3);
    expect(second.transactions.last.amount, 10);

    final afterMiss = DailyRewardRules.claim(
      second,
      now: start.add(const Duration(days: 3)),
    );
    expect(afterMiss.balance, 125);
    expect(afterMiss.streak, 3);
    expect(afterMiss.transactions.last.amount, 10);
    expect(afterMiss.feedback, contains('уменьшилась всего на один шаг'));
  });

  test('Демо: награда доступна в новом периоде без ожидания даты', () {
    final now = DateTime(2026, 9, 1, 10);
    final first = DailyRewardRules.claim(_MemoryRepository()._demo(), now: now);
    expect(first.balance, 105);
    expect(DailyRewardRules.canClaim(first, now: now), isFalse);
    final second = DailyRewardRules.claim(first.copyWith(period: 2), now: now);
    expect(second.balance, 115);
    expect(second.streak, 3);
    expect(second.transactions.last.amount, 10);
  });

  Future<void> advanceOnboarding(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Дальше'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Дальше'));
    await tester.pumpAndSettle();
  }

  Future<void> openAdultGate(WidgetTester tester) async {
    if (find.byTooltip('Для взрослого').evaluate().isNotEmpty) {
      await tester.tap(find.byTooltip('Для взрослого'));
    } else {
      if (find.text('Для взрослых').evaluate().isEmpty) {
        await tester.tap(find.text('Ещё'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Для взрослых'));
    }
    await tester.pumpAndSettle();
  }

  Future<void> openAdult(WidgetTester tester) async {
    await openAdultGate(tester);
    final question = tester
        .widget<Text>(find.byKey(const Key('adult-challenge')))
        .data!;
    final numbers = RegExp(
      r'\d+',
    ).allMatches(question).map((match) => int.parse(match[0]!));
    await tester.enterText(
      find.byKey(const Key('adult-answer')),
      '${numbers.reduce((a, b) => a + b)}',
    );
    await tester.tap(find.text('Открыть раздел'));
    await tester.pumpAndSettle();
  }

  Future<void> adultAction(WidgetTester tester, String label) async {
    if (label == 'Открыть тестовый профиль' ||
        label == 'Вернуться в обычный профиль') {
      await tester.scrollUntilVisible(
        find.text('Демонстрационный режим'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Демонстрационный режим'));
      await tester.pumpAndSettle();
      return;
    }
    if (find.text(label).evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        find.text('Как работает игра'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Как работает игра'));
      await tester.pumpAndSettle();
    }
    await tester.scrollUntilVisible(
      find.text(label),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).first);
    await tester.pumpAndSettle();
  }

  testWidgets('Барьер взрослого и вход в демо без обычного профиля на 360 dp', (
    tester,
  ) async {
    final repository = _MemoryRepository();
    await launch(tester, repository, scale: 2);
    await openAdultGate(tester);
    expect(find.text('Сбросить тестовый профиль'), findsNothing);
    await tester.enterText(find.byKey(const Key('adult-answer')), '0');
    await tester.tap(find.text('Открыть раздел'));
    await tester.pumpAndSettle();
    expect(find.text('Проверьте ответ и попробуйте ещё раз.'), findsOneWidget);
    expect(find.text('Родительское меню'), findsNothing);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    await openAdult(tester);
    expect(find.text('Родительское меню'), findsOneWidget);
    expect(find.text('Учебный прогресс ребёнка'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(
        'Коткоины — только игровая валюта.\nПокупок за реальные деньги нет.',
      ),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      find.text(
        'Коткоины — только игровая валюта.\nПокупок за реальные деньги нет.',
      ),
      findsOneWidget,
    );
    await adultAction(tester, 'Открыть тестовый профиль');
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(repository.testProfile, isFalse);
    await adultAction(tester, 'Открыть тестовый профиль');
    await tester.tap(find.text('Подтвердить'));
    await tester.pumpAndSettle();
    expect(repository.profile!.isTest, isTrue);
    expect(
      find.text('Тестовый профиль · отдельное сохранение'),
      findsOneWidget,
    );
    await openAdult(tester);
    await adultAction(tester, 'Вернуться в обычный профиль');
    await tester.tap(find.text('Подтвердить'));
    await tester.pumpAndSettle();
    expect(repository.profile, isNull);
    expect(find.text('Привет! Это КопиКот'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Сброс демо: отмена, ошибка записи, повтор и защита обычного профиля',
    (tester) async {
      final repository = _MemoryRepository()
        ..profile = initialProfile.copyWith(balance: 74);
      repository.profiles[true] = LearningRules.submit(
        repository._demo().copyWith(
          plan: const BudgetPlan(
            availableAtConfirmation: 100,
            needs: 50,
            wants: 20,
            savings: 30,
          ),
        ),
        repository.catalog,
        repository.catalog.task('saving_start'),
        const TaskAnswer(savings: 10),
      );
      await launch(tester, repository);
      await openAdult(tester);
      await adultAction(tester, 'Открыть тестовый профиль');
      await tester.tap(find.text('Подтвердить'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 112);
      await openAdult(tester);
      await adultAction(tester, 'Сбросить тестовый профиль');
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 112);
      await adultAction(tester, 'Сбросить тестовый профиль');
      repository.failProfileAction = true;
      await tester.tap(
        find.widgetWithText(FilledButton, 'Сбросить тестовый профиль'),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Не удалось сохранить действие. Попробуй ещё раз.'),
        findsOneWidget,
      );
      expect(repository.profile!.balance, 112);
      expect(repository.profiles[false]!.balance, 74);
      repository.failProfileAction = false;
      await tester.tap(
        find.widgetWithText(FilledButton, 'Сбросить тестовый профиль'),
      );
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 100);
      expect(repository.profile!.taskProgress, isEmpty);
      expect(find.textContaining('Я Финни Тест'), findsOneWidget);
      await openAdult(tester);
      await adultAction(tester, 'Вернуться в обычный профиль');
      await tester.tap(find.text('Подтвердить'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 74);
      expect(find.textContaining('Я Финни'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Удаление обычного профиля требует подтверждения и допускает повтор ошибки',
    (tester) async {
      final repository = _MemoryRepository()..profile = initialProfile;
      repository.profiles[true] = repository._demo().copyWith(balance: 87);
      await launch(tester, repository);
      await openAdult(tester);
      await adultAction(tester, 'Удалить обычный профиль');
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(repository.profile, isNotNull);
      await adultAction(tester, 'Удалить обычный профиль');
      repository.failProfileAction = true;
      await tester.tap(find.text('Удалить профиль'));
      await tester.pumpAndSettle();
      expect(repository.profile, isNotNull);
      expect(
        find.text('Не удалось сохранить действие. Попробуй ещё раз.'),
        findsOneWidget,
      );
      repository.failProfileAction = false;
      await tester.tap(find.text('Удалить профиль'));
      await tester.pumpAndSettle();
      expect(repository.profile, isNull);
      expect(repository.profiles[true]!.balance, 87);
      expect(find.text('Привет! Это КопиКот'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Все пять верхних разделов открывают новое меню', (tester) async {
    final repository = _MemoryRepository()..profile = initialProfile;
    await launch(tester, repository);
    for (final (section, destination) in [
      ('Игры', 'Бухгалтер'),
      ('Учимся', 'Задания'),
      ('Котик', 'Ветеринар'),
      ('Планы', 'Бюджет'),
      ('Ещё', 'История'),
    ]) {
      await tester.tap(find.text(section).first);
      await tester.pumpAndSettle();
      expect(find.text(destination), findsOneWidget);
      expect(find.byTooltip('Закрыть раздел'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Закрыть раздел'));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('История покупок показывает карточки и фильтры', (tester) async {
    final repository = _MemoryRepository()
      ..profile = initialProfile.copyWith(
        period: 4,
        transactions: const [
          GameTransaction(
            id: 'brush',
            period: 4,
            kind: TransactionKind.needPurchase,
            amount: 8,
            label: 'Щётка',
            referenceId: 'shop_brush',
            balanceAfter: 158,
            savingsAfter: 0,
            satietyAfter: 70,
            moodAfter: 70,
          ),
          GameTransaction(
            id: 'bow',
            period: 4,
            kind: TransactionKind.wantPurchase,
            amount: 25,
            label: 'Ягодный бантик',
            referenceId: 'shop_bow',
            balanceAfter: 113,
            savingsAfter: 0,
            satietyAfter: 70,
            moodAfter: 70,
          ),
        ],
      );
    await launch(tester, repository);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const HistoryScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.text('История покупок'), findsOneWidget);
    expect(find.text('Ягодный бантик'), findsOneWidget);
    expect(find.text('После покупки: осталось 113 монет'), findsOneWidget);
    expect(find.text('Период 4'), findsOneWidget);
    await tester.ensureVisible(find.text('Хочется').first);
    await tester.tap(find.text('Хочется').first);
    await tester.pumpAndSettle();
    expect(find.text('Ягодный бантик'), findsOneWidget);
    expect(find.text('Щётка'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'Компоновка и доступность игровых разделов на 360 dp с текстом ×$scale',
      (tester) async {
        final repository = _MemoryRepository()
          ..profile = initialProfile.copyWith(
            selectedGoalId: 'tent',
            plan: const BudgetPlan(
              availableAtConfirmation: 100,
              needs: 50,
              wants: 20,
              savings: 30,
            ),
          );
        await launch(tester, repository, scale: scale);
        final logoContext = tester.element(find.byType(Scaffold).first);
        await tester.runAsync(() async {
          await precacheImage(
            const AssetImage('assets/images/logo_wood.png'),
            logoContext,
          );
        });
        await tester.pumpAndSettle();
        final semantics = tester.ensureSemantics();
        try {
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          final screens = <Widget>[
            const BudgetScreen(),
            const ShopScreen(),
            const SavingsScreen(),
            const GardenScreen(),
            const HistoryScreen(),
            const WardrobeScreen(),
            const ProgressScreen(),
            const AdultScreen(),
            const TasksScreen(),
            for (final id in ['budget_lunch', 'basket_food', 'saving_start'])
              TaskScreen(
                task: repository.catalog.task(id),
                catalog: repository.catalog,
              ),
          ];
          for (final screen in screens) {
            final navigator = tester.state<NavigatorState>(
              find.byType(Navigator),
            );
            navigator.push(MaterialPageRoute<void>(builder: (_) => screen));
            await tester.pumpAndSettle();
            expect(
              tester.takeException(),
              isNull,
              reason: '${screen.runtimeType}: top',
            );
            await expectLater(
              tester,
              meetsGuideline(androidTapTargetGuideline),
              reason: '${screen.runtimeType}: touch',
            );
            await expectLater(
              tester,
              meetsGuideline(textContrastGuideline),
              reason: '${screen.runtimeType}: contrast',
            );
            final scrollable = find.byType(Scrollable).first;
            for (var step = 0; step < 80; step++) {
              final position = tester
                  .state<ScrollableState>(scrollable)
                  .position;
              if (position.pixels >= position.maxScrollExtent) break;
              await tester.drag(scrollable, const Offset(0, -450));
              await tester.pumpAndSettle();
              expect(
                tester.takeException(),
                isNull,
                reason: '${screen.runtimeType}: step $step',
              );
            }
            navigator.pop();
            await tester.pumpAndSettle();
          }
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  testWidgets(
    'Уменьшение движения: ошибка записи, повтор и диалог без анимации',
    (tester) async {
      final repository = _MemoryRepository()..profile = initialProfile;
      await launch(tester, repository);
      await openAdult(tester);
      await tester.tap(find.text('Как работает игра'));
      await tester.pumpAndSettle();
      final setting = find.text('Отключить анимации переходов');
      await tester.scrollUntilVisible(
        setting,
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      repository.failProfileAction = true;
      await tester.tap(setting);
      await tester.pumpAndSettle();
      expect(repository.reduceMotion, isFalse);
      expect(
        find.text('Не удалось сохранить настройку. Попробуйте ещё раз.'),
        findsOneWidget,
      );
      repository.failProfileAction = false;
      await tester.tap(setting);
      await tester.pumpAndSettle();
      expect(repository.reduceMotion, isTrue);
      expect(MediaQuery.disableAnimationsOf(tester.element(setting)), isTrue);
      Navigator.of(tester.element(setting)).popUntil((route) => route.isFirst);
      await tester.pumpAndSettle();
      await openAdultGate(tester);
      final gateContext = tester.element(
        find.byKey(const Key('adult-challenge')),
      );
      expect(ModalRoute.of(gateContext)!.transitionDuration, Duration.zero);
      const marker = SizedBox(key: Key('motion-marker'));
      expect(
        identical(
          const AccessiblePageTransitions().buildTransitions(
            MaterialPageRoute<void>(builder: (_) => marker),
            gateContext,
            kAlwaysCompleteAnimation,
            kAlwaysDismissedAnimation,
            marker,
          ),
          marker,
        ),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Системное уменьшение движения действует независимо от настройки приложения',
    (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final repository = _MemoryRepository()..profile = initialProfile;
      await launch(tester, repository);
      expect(repository.reduceMotion, isFalse);
      expect(
        MediaQuery.disableAnimationsOf(
          tester.element(find.textContaining('Я Финни')),
        ),
        isTrue,
      );
      await openAdultGate(tester);
      expect(
        ModalRoute.of(
          tester.element(find.byKey(const Key('adult-challenge'))),
        )!.transitionDuration,
        Duration.zero,
      );
    },
  );

  testWidgets('Создание питомца, отмена и подтверждение бюджета на 360 dp', (
    tester,
  ) async {
    final repository = _MemoryRepository();
    await launch(tester, repository);
    await advanceOnboarding(tester);
    await tester.tap(find.text('Дымок'));
    await advanceOnboarding(tester);
    await tester.enterText(find.byType(TextFormField), 'Луна');
    await tester.ensureVisible(find.text('Начать игру'));
    await tester.tap(find.text('Начать игру'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Я Луна'), findsOneWidget);
    expect(repository.profile!.coat, PetCoat.grey);
    expect(repository.profile!.accessory, PetAccessory.scarf);
    await tester.tap(find.text('Планы'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Бюджет'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '60');
    await tester.enterText(find.byType(TextField).at(1), '20');
    await tester.enterText(find.byType(TextField).at(2), '30');
    await tester.pump();
    expect(find.text('Не хватает: 10 монет'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(2), '20');
    await tester.pump();
    await tester.drag(find.byType(ListView).last, const Offset(0, -560));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Сохранить план'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Изменить'));
    await tester.pumpAndSettle();
    expect(repository.profile!.plan, isNull);
    await tester.drag(find.byType(ListView).last, const Offset(0, -560));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Сохранить план'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Подтвердить'));
    await tester.pumpAndSettle();
    expect(find.text('План подтверждён'), findsOneWidget);
    expect(find.text('Сравни план с тратами.'), findsOneWidget);
    expect(find.text('План готов!\nСмотрим,\nкак идут дела.'), findsOneWidget);
    expect(repository.profile!.balance, 100);
    expect(repository.profile!.plan!.savings, 20);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Окрас «Темныш» выбирается и сохраняется', (tester) async {
    final repository = _MemoryRepository();
    await launch(tester, repository);
    await advanceOnboarding(tester);
    await tester.ensureVisible(find.text('Темныш'));
    await tester.tap(find.text('Темныш'));
    await advanceOnboarding(tester);
    await tester.enterText(find.byType(TextFormField), 'Мур');
    await tester.ensureVisible(find.text('Начать игру'));
    await tester.tap(find.text('Начать игру'));
    await tester.pumpAndSettle();
    expect((await repository.loadProfile())!.coat, PetCoat.dark);
    expect(find.bySemanticsLabel('Темныш кот, Платок'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final taskId in ['saving_start']) {
    testWidgets('$taskId: ответ через форму сохраняет награду', (tester) async {
      final repository = _MemoryRepository()
        ..profile = initialProfile.withPlan(
          GameRules.confirmBudget(
            initialProfile,
            needs: 50,
            wants: 20,
            savings: 30,
          ),
        );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameRepositoryProvider.overrideWith((ref) async => repository),
          ],
          child: MaterialApp(
            home: TaskScreen(
              task: repository.catalog.task(taskId),
              catalog: repository.catalog,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '35');
      await tester.pumpAndSettle();
      expect(find.text('Осталось распределить: 0'), findsOneWidget);
      expect(
        find.text('Это больше бюджета: осталось только 0 коткоинов.'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField), '10');
      await tester.scrollUntilVisible(
        find.text('Проверить план'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Проверить план'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 100);
      await tester.tap(find.text('Забрать награду · 12'));
      await tester.pumpAndSettle();
      expect(repository.profile!.completedTask(taskId), isTrue);
      expect(repository.profile!.balance, 112);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Повторение пройденного задания не начисляет награду снова', (
    tester,
  ) async {
    final repository = _MemoryRepository();
    final task = repository.catalog.task('saving_start');
    repository.profile = LearningRules.submit(
      initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      ),
      repository.catalog,
      task,
      const TaskAnswer(savings: 10),
    ).copyWith(clearPlan: true);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWith((ref) async => repository),
        ],
        child: MaterialApp(
          home: TaskScreen(task: task, catalog: repository.catalog),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '10');
    await tester.ensureVisible(find.text('Проверить план'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Проверить план'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Умное решение!'), findsOneWidget);
    expect(repository.profile!.balance, 112);
    expect(repository.profile!.taskProgress.single.attempts, 1);
    expect(find.textContaining('Забрать награду'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('После двух ошибок кнопка «Понятно» закрывает задание', (
    tester,
  ) async {
    final repository = _MemoryRepository()
      ..profile = initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWith((ref) async => repository),
        ],
        child: MaterialApp(
          home: TaskScreen(
            task: repository.catalog.task('saving_start'),
            catalog: repository.catalog,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final check = find.text('Проверить план');
    await tester.ensureVisible(check);
    await tester.tap(check);
    await tester.pumpAndSettle();
    expect(find.textContaining('Подсказка:'), findsOneWidget);
    await tester.ensureVisible(check);
    await tester.tap(check);
    await tester.pumpAndSettle();
    expect(find.textContaining('Разбор по шагам:'), findsOneWidget);
    final understood = find.text('Понятно');
    await tester.drag(find.byType(ListView), const Offset(0, -220));
    await tester.pumpAndSettle();
    await tester.tap(understood);
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 112);
    expect(repository.profile!.taskProgress.single.reviewed, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Выбор покупки: ошибку можно исправить без потери монет', (
    tester,
  ) async {
    final repository = _MemoryRepository()
      ..profile = initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWith((ref) async => repository),
        ],
        child: MaterialApp(
          home: TaskScreen(
            task: repository.catalog.task('basket_food'),
            catalog: repository.catalog,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Сначала мышку'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Сначала мышку'));
    await tester.ensureVisible(find.text('Проверить план'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Проверить план'));
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 100);
    await tester.scrollUntilVisible(
      find.text('Вернуть мышку и купить корм'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Вернуть мышку и купить корм'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Всё исправлено!'), findsOneWidget);
    await tester.ensureVisible(find.text('Проверить план'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Проверить план'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Забрать награду · 8'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Забрать награду · 8'));
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 108);
    expect(repository.profile!.completedTask('basket_food'), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Экран покупки 360×640 без переполнения', (tester) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SizedBox.shrink())),
    );
    final imageContext = tester.element(find.byType(Scaffold));
    await tester.runAsync(() async {
      for (final path in [
        'assets/images/quest_market_background.png',
        'assets/images/logo_wood.png',
        'assets/images/cat_coin.png',
        'assets/images/orange_kitten.png',
        'assets/images/quest_cat_food.png',
        'assets/images/quest_toy_mouse.png',
      ]) {
        await precacheImage(AssetImage(path), imageContext);
      }
    });
    final key = GlobalKey();
    final repository = _MemoryRepository()
      ..profile = initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWith((ref) async => repository),
        ],
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Nunito'),
          home: RepaintBoundary(
            key: key,
            child: TaskScreen(
              task: repository.catalog.task('basket_food'),
              catalog: repository.catalog,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('На покупки: 30'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_purchase_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });
  });

  for (final taskId in const [
    'budget_lunch',
    'budget_reserve',
    'basket_care',
    'saving_start',
    'saving_finish',
  ]) {
    testWidgets('$taskId: экран задания помещается на 360×640', (tester) async {
      await tester.runAsync(() async {
        await ui.loadFontFromList(
          await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
          fontFamily: 'Nunito',
        );
      });
      final repository = _MemoryRepository()
        ..profile = initialProfile.withPlan(
          GameRules.confirmBudget(
            initialProfile,
            needs: 50,
            wants: 20,
            savings: 30,
          ),
        );
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameRepositoryProvider.overrideWith((ref) async => repository),
          ],
          child: MaterialApp(
            theme: ThemeData(fontFamily: 'Nunito'),
            home: TaskScreen(
              task: repository.catalog.task(taskId),
              catalog: repository.catalog,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final scenario in const [
    (
      id: 'basket_care',
      wrong: 'Да, хватит на всё',
      fix: 'Выбрать корм и лекарство',
    ),
    (
      id: 'saving_finish',
      wrong: 'Уголёк — ждать большую награду',
      fix: 'Начать откладывать понемногу',
    ),
  ]) {
    testWidgets('${scenario.id}: неверный выбор можно исправить', (
      tester,
    ) async {
      final repository = _MemoryRepository()
        ..profile = initialProfile.withPlan(
          GameRules.confirmBudget(
            initialProfile,
            needs: 50,
            wants: 20,
            savings: 30,
          ),
        );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameRepositoryProvider.overrideWith((ref) async => repository),
          ],
          child: MaterialApp(
            home: TaskScreen(
              task: repository.catalog.task(scenario.id),
              catalog: repository.catalog,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text(scenario.wrong),
        130,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(scenario.wrong));
      await tester.scrollUntilVisible(
        find.text('Проверить план'),
        130,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Проверить план'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 100);
      await tester.scrollUntilVisible(
        find.text(scenario.fix),
        130,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(scenario.fix));
      await tester.pumpAndSettle();
      expect(find.textContaining('Всё исправлено!'), findsOneWidget);
      await tester.ensureVisible(find.text('Проверить план'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Проверить план'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Забрать награду · 8'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 108);
      expect(repository.profile!.completedTask(scenario.id), isTrue);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('План на день: выбор дел и отдельное получение награды', (
    tester,
  ) async {
    final repository = _MemoryRepository()
      ..profile = initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWith((ref) async => repository),
        ],
        child: MaterialApp(
          home: TaskScreen(
            task: repository.catalog.task('budget_reserve'),
            catalog: repository.catalog,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Покормить Барсика'));
    await tester.tap(find.text('Осмотр у ветеринара'));
    await tester.ensureVisible(find.text('Купить бантик'));
    await tester.tap(find.text('Купить бантик'));
    await tester.pumpAndSettle();
    expect(
      find.text('Это больше бюджета: осталось только 10 коткоинов.'),
      findsOneWidget,
    );
    expect(find.text('Сумма плана 35 / 45'), findsOneWidget);
    await tester.ensureVisible(find.text('Поиграть с мышкой'));
    await tester.tap(find.text('Поиграть с мышкой'));
    await tester.pumpAndSettle();
    expect(find.text('Сумма плана 45 / 45'), findsOneWidget);
    expect(find.textContaining('Это больше бюджета:'), findsNothing);
    await tester.tap(find.text('Поиграть с мышкой'));
    await tester.ensureVisible(find.text('Проверить план'));
    await tester.tap(find.text('Проверить план'));
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 100);
    await tester.ensureVisible(find.text('Забрать награду · 12'));
    await tester.tap(find.text('Забрать награду · 12'));
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 112);
    expect(repository.profile!.completedTask('budget_reserve'), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Учебный бюджет даёт награду, завершение периода открывает новый план',
    (tester) async {
      final repository = _MemoryRepository()
        ..profile = initialProfile.withPlan(
          GameRules.confirmBudget(
            initialProfile,
            needs: 50,
            wants: 20,
            savings: 30,
          ),
        );
      await launch(tester, repository);
      await tester.tap(find.text('Учимся'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Задания'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Недельный бюджет'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.widgetWithText(TextField, 'Нужное'),
        -150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.widgetWithText(TextField, 'Нужное'), '20');
      await tester.enterText(find.widgetWithText(TextField, 'Радость'), '30');
      await tester.enterText(find.widgetWithText(TextField, 'Копилка'), '10');
      await tester.enterText(find.widgetWithText(TextField, 'Радость'), '35');
      await tester.pumpAndSettle();
      expect(find.text('Осталось распределить: 0'), findsOneWidget);
      expect(
        find.text('Это больше бюджета: осталось только 0 коткоинов.'),
        findsOneWidget,
      );
      await tester.enterText(find.widgetWithText(TextField, 'Радость'), '30');
      await tester.ensureVisible(find.text('Проверить план'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Проверить план'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 100);
      expect(repository.profile!.taskProgress.single.completed, isFalse);
      await tester.scrollUntilVisible(
        find.widgetWithText(TextField, 'Нужное'),
        -150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.widgetWithText(TextField, 'Нужное'), '30');
      await tester.enterText(find.widgetWithText(TextField, 'Радость'), '20');
      await tester.scrollUntilVisible(
        find.text('Проверить план'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Проверить план'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 100);
      await tester.tap(find.text('Забрать награду · 8'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 108);
      expect(find.text('Проверить план'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Назад'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Планы'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Бюджет'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Подвести итоги'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Подвести итоги'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(repository.profile!.period, 1);
      await tester.tap(find.text('Подвести итоги'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Следующий период'));
      await tester.pumpAndSettle();
      expect(repository.profile!.period, 2);
      // Награда за вход получается отдельно; завершение периода даёт доход 100.
      expect(repository.profile!.balance, 208);
      expect(repository.profile!.plan, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Покупка и пополнение на 360 dp без старой формы накоплений', (
    tester,
  ) async {
    final repository = _MemoryRepository()
      ..profile = initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
    await launch(tester, repository);
    await tester.tap(find.text('Магазин'));
    await tester.pumpAndSettle();
    expect(find.text('Котомаркет'), findsWidgets);
    expect(find.text('Для заботы о котике'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('shop-buy-shop_food')),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('shop-buy-shop_food')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 100);
    await tester.tap(find.byKey(const Key('shop-buy-shop_food')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Купить').last);
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 85);
    expect(repository.profile!.satiety, 90);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Планы'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Накопления'));
    await tester.pumpAndSettle();
    expect(find.text('Моя цель: беговая дорожка'), findsOneWidget);
    expect(find.text('0 / 400'), findsOneWidget);
    expect(find.text('Я коплю\nна мечту!'), findsOneWidget);
    final reserveField = tester.widget<TextField>(find.byType(TextField));
    expect(reserveField.decoration?.labelText, 'Сумма для резерва');
    expect(find.text('Взять с цели'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Выбрать цель').first,
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Выбрать цель').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Выбрать цель').last);
    await tester.pumpAndSettle();
    expect(repository.profile!.selectedGoalId, 'tent');
    await tester.scrollUntilVisible(
      find.text('Отложить 20'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Отложить 20'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отложить'));
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 65);
    expect(repository.profile!.savings, 20);
    expect(repository.profile!.netSaved, 20);
    await tester.scrollUntilVisible(
      find.text('Редкий саженец'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byIcon(Icons.lock_rounded), findsNWidgets(2));
    expect(repository.profile!.selectedGoalId, 'tent');
    await tester.scrollUntilVisible(
      find.text('Я коплю\nна мечту!'),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Я коплю\nна мечту!'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byTooltip('Назад'),
      -250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Бюджет'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('budget-plan-Нужно')),
        matching: find.text('50'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('budget-actual-Нужно')),
        matching: find.text('15'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('budget-plan-Хочется')),
        matching: find.text('20'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('budget-actual-Хочется')),
        matching: find.text('0'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('budget-plan-На мечту')),
        matching: find.text('30'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('budget-actual-На мечту')),
        matching: find.text('20'),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Попытка покупки при нехватке показывает выход и не списывает монеты',
    (tester) async {
      final repository = _MemoryRepository()
        ..profile = initialProfile
            .withPlan(
              GameRules.confirmBudget(
                initialProfile,
                needs: 50,
                wants: 20,
                savings: 30,
              ),
            )
            .copyWith(balance: 20);
      await launch(tester, repository);
      await tester.tap(find.text('Магазин'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Радость'));
      await tester.pumpAndSettle();
      expect(find.text('Ягодный бантик'), findsOneWidget);
      expect(find.text('Бирюзовый платок'), findsOneWidget);
      expect(find.text('Спортивная повязка'), findsOneWidget);
      expect(find.text('Синие напульсники'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byKey(const Key('shop-buy-berry_bow')),
        -200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byKey(const Key('shop-buy-berry_bow')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Купить').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('Не хватает 5 монет.'), findsWidgets);
      expect(repository.profile!.balance, 20);
      expect(repository.profile!.transactions, isEmpty);
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Ошибка сохранения оставляет введённое имя для повторной попытки',
    (tester) async {
      final repository = _MemoryRepository()..failCreate = true;
      await launch(tester, repository);
      await advanceOnboarding(tester);
      await advanceOnboarding(tester);
      await tester.enterText(find.byType(TextFormField), 'Финни');
      await tester.ensureVisible(find.text('Начать игру'));
      await tester.tap(find.text('Начать игру'));
      await tester.pumpAndSettle();
      expect(
        find.text('Не удалось сохранить питомца. Попробуй ещё раз.'),
        findsOneWidget,
      );
      expect(find.text('Финни'), findsOneWidget);
      expect(repository.profile, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Существующий профиль открывается сразу; справка доступна офлайн',
    (tester) async {
      final repository = _MemoryRepository()..profile = initialProfile;
      await launch(tester, repository, scale: 2);
      expect(find.textContaining('Я Финни'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      await tester.tap(find.text('Ещё'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Как играть'));
      await tester.pumpAndSettle();
      expect(find.text('Как играть'), findsOneWidget);
      expect(find.text('Давай\nразберёмся!'), findsOneWidget);
      expect(find.text('Играй'), findsOneWidget);
      expect(find.text('Заботься'), findsOneWidget);
      expect(find.text('Выбирай'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Копи'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Копи'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Коткоины — игровые.\nПокупок за реальные деньги нет.'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        find.text('Коткоины — игровые.\nПокупок за реальные деньги нет.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  Future<void> cacheCatImages(WidgetTester tester, List<String> paths) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SizedBox.shrink())),
    );
    final context = tester.element(find.byType(Scaffold));
    await tester.runAsync(() async {
      for (final path in paths) {
        await precacheImage(AssetImage(path), context);
      }
    });
    await tester.pump();
  }

  testWidgets('Список заданий 360×640 показывает значки, темы и карточки', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/fairytale_background.png',
      'assets/images/orange_kitten.png',
      'assets/images/logo_wood.png',
      'assets/images/cat_coin.png',
      'assets/images/quest_budget.png',
      'assets/images/quest_purchases.png',
      'assets/images/quest_savings.png',
      'assets/images/quest_badge_plan.png',
      'assets/images/quest_badge_purchases.png',
      'assets/images/quest_badge_savings.png',
      'assets/images/quest_hero_ginger.png',
    ]);
    final key = GlobalKey();
    final repository = _MemoryRepository()..profile = initialProfile;
    await launch(tester, repository, captureKey: key);
    tester.view.physicalSize = const Size(360, 640);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Учимся'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Задания'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Мур! Потренируем финансовый ум?'),
      findsOneWidget,
    );
    expect(find.text('Значки за темы'), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/images/quest_badge_plan.png')),
      findsWidgets,
    );
    expect(find.text('Распределяй коткоины с умом'), findsOneWidget);
    expect(find.text('Сначала нужное, потом радость'), findsOneWidget);
    expect(find.text('Копи понемногу и регулярно'), findsOneWidget);
    expect(find.text('Планирование бюджета'), findsWidgets);
    expect(find.text('Платежи и покупки'), findsWidgets);
    expect(find.text('Формирование сбережений'), findsWidgets);
    expect(tester.getTopLeft(find.text('Недельный бюджет')).dy, lessThan(570));
    expect(tester.takeException(), isNull);

    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_tasks_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });

    await tester.tap(find.byTooltip('Фильтр по темам'));
    await tester.pumpAndSettle();
    expect(find.text('Все темы'), findsOneWidget);
    await tester.tap(find.text('Платежи и покупки').last);
    await tester.pumpAndSettle();
    expect(find.text('Недельный бюджет'), findsNothing);
    expect(find.text('Что купить сначала'), findsOneWidget);
    await tester.tap(find.byTooltip('Фильтр по темам'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Все темы'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Недельный бюджет'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Недельный бюджет'));
    await tester.pumpAndSettle();
    expect(find.text('Недельный бюджет'), findsOneWidget);
    expect(
      find.textContaining('В начале недели Барсик получил 60 коткоинов'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Три шага знакомства на экране 360×640', (tester) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/fairytale_background.png',
      'assets/images/orange_kitten.png',
      'assets/images/cream_kitten.png',
      'assets/images/grey_kitten.png',
      'assets/images/dark_kitten.png',
      'assets/images/white_kitten.png',
      'assets/images/action_feed.png',
      'assets/images/action_play.png',
    ]);
    final key = GlobalKey();
    await launch(tester, _MemoryRepository(), captureKey: key);
    tester.view.physicalSize = const Size(360, 640);
    await tester.pumpAndSettle();

    Future<void> capture(String stage) async {
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
        await File(
          '/tmp/kopikot_onboarding_$stage.png',
        ).writeAsBytes(bytes.buffer.asUint8List());
        image.dispose();
      });
    }

    expect(find.text('Привет! Это КопиКот'), findsOneWidget);
    expect(find.text('Сначала нужное'), findsOneWidget);
    expect(find.text('Потом радость'), findsOneWidget);
    expect(find.text('И немного в копилку'), findsOneWidget);
    await capture('intro');
    await advanceOnboarding(tester);
    expect(find.text('Выбери котика'), findsOneWidget);
    expect(find.text('Темныш'), findsOneWidget);
    await capture('coat');
    await tester.tap(find.text('Темныш'));
    await advanceOnboarding(tester);
    expect(find.text('Как назвать котика?'), findsOneWidget);
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller!.text,
      isEmpty,
    );
    expect(find.text('Привет, давай придумаем мне имя?'), findsOneWidget);
    await capture('name');
    await tester.enterText(find.byType(TextFormField), 'Луна');
    await tester.pump();
    expect(find.textContaining('Я Луна'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Бюджет 360×640: три категории и ограничение суммы', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/fairytale_background.png',
      'assets/images/orange_kitten.png',
      'assets/images/action_feed.png',
      'assets/images/action_play.png',
      'assets/images/cat_coin.png',
      'assets/images/logo_wood.png',
      'assets/images/budget_needs.png',
      'assets/images/budget_joy.png',
      'assets/images/budget_savings.png',
      'assets/images/budget_hero_ginger.png',
    ]);
    final key = GlobalKey();
    final repository = _MemoryRepository()..profile = initialProfile;
    await launch(tester, repository, captureKey: key);
    tester.view.physicalSize = const Size(360, 640);
    await tester.pumpAndSettle();

    expect(find.text('Можно запланировать:'), findsOneWidget);
    expect(find.text('Нужное'), findsOneWidget);
    expect(find.text('Радость'), findsOneWidget);
    expect(find.text('Копилка'), findsOneWidget);
    expect(find.text('Оставить в кошельке'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      '50',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      '25',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(2)).controller!.text,
      '25',
    );
    expect(
      tester.widget<Text>(find.byKey(const Key('budget-remaining'))).data,
      '0',
    );
    final saveButton = find.ancestor(
      of: find.text('Сохранить план'),
      matching: find.byType(FilledButton),
    );
    expect(saveButton, findsOneWidget);
    expect(tester.takeException(), isNull);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_budget_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });

    await tester.ensureVisible(find.byTooltip('Уменьшить: Радость'));
    await tester.tap(find.byTooltip('Уменьшить: Радость'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('budget-remaining'))).data,
      '5',
    );
    await tester.ensureVisible(find.byTooltip('Увеличить: Нужное'));
    await tester.tap(find.byTooltip('Увеличить: Нужное'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('budget-remaining'))).data,
      '0',
    );
    expect(
      tester
          .widget<IconButton>(
            find.ancestor(
              of: find.byTooltip('Увеличить: Копилка'),
              matching: find.byType(IconButton),
            ),
          )
          .onPressed,
      isNull,
    );
    expect(repository.profile!.plan, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Итог дня 360×640 показывает суммы и возвращает к котику', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/fairytale_background.png',
      'assets/images/orange_kitten.png',
      'assets/images/action_feed.png',
      'assets/images/action_care.png',
      'assets/images/budget_savings.png',
      'assets/images/cat_coin.png',
      'assets/images/daily_reward_hero_ginger.png',
    ]);
    final key = GlobalKey();
    GameTransaction entry(
      String id,
      TransactionKind kind,
      int amount, {
      String? referenceId,
    }) => GameTransaction(
      id: id,
      period: 1,
      kind: kind,
      amount: amount,
      label: id,
      referenceId: referenceId,
      balanceAfter: 15,
      savingsAfter: 20,
      satietyAfter: 70,
      moodAfter: 70,
    );
    final repository = _MemoryRepository()
      ..profile = GameProfile(
        petName: 'Рут',
        coat: PetCoat.ginger,
        accessory: PetAccessory.scarf,
        balance: 15,
        savings: 20,
        period: 1,
        satiety: 70,
        mood: 70,
        incomeSource: 'Подарок',
        incomeAmount: 60,
        transactions: [
          entry('initial-income', TransactionKind.income, 60),
          entry(
            'food',
            TransactionKind.needPurchase,
            15,
            referenceId: 'porridge',
          ),
          entry(
            'care',
            TransactionKind.needPurchase,
            10,
            referenceId: 'shampoo',
          ),
          entry('dream', TransactionKind.deposit, 20),
        ],
      );
    await launch(tester, repository, captureKey: key);
    tester.view.physicalSize = const Size(360, 640);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ещё'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Итог дня'));
    await tester.pumpAndSettle();

    expect(find.text('Твои коткоины сегодня'), findsOneWidget);
    expect(find.text('Заработано'), findsOneWidget);
    expect(find.text('Потрачено'), findsOneWidget);
    expect(find.text('Отложено'), findsOneWidget);
    expect(find.text('Осталось'), findsOneWidget);
    expect(find.text('На что потрачено и отложено'), findsOneWidget);
    expect(find.text('Всего заработано: 60'), findsOneWidget);
    expect(
      find.text('Сегодня у нас получилось и позаботиться, и накопить!'),
      findsOneWidget,
    );
    expect(find.text('60'), findsOneWidget);
    expect(find.text('25'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_daily_summary_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });

    final feedbackText = find.text('На нужное хватило, и цель стала ближе');
    await tester.ensureVisible(feedbackText);
    await tester.pumpAndSettle();
    expect(
      tester.getBottomLeft(feedbackText).dy,
      lessThan(tester.getTopLeft(find.byType(FilledButton).last).dy),
    );
    expect(tester.getBottomLeft(find.text('Продолжить')).dy, lessThan(640));
    await tester.tap(find.text('Продолжить'));
    await tester.pumpAndSettle();
    expect(find.text('Как я себя чувствую'), findsOneWidget);
    expect(find.text('Радость'), findsOneWidget);
  });

  testWidgets(
    'Ежедневная награда начисляется один раз и видна после возврата',
    (tester) async {
      await tester.runAsync(() async {
        await ui.loadFontFromList(
          await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
          fontFamily: 'Nunito',
        );
      });
      await cacheCatImages(tester, const [
        'assets/images/fairytale_background.png',
        'assets/images/orange_kitten.png',
        'assets/images/logo_wood.png',
        'assets/images/cat_coin.png',
        'assets/images/daily_reward_chest.png',
        'assets/images/daily_reward_hero_ginger.png',
      ]);
      final key = GlobalKey();
      final repository = _MemoryRepository()..profile = initialProfile;
      await launch(tester, repository, captureKey: key);
      tester.view.physicalSize = const Size(360, 640);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Награда'));
      await tester.pumpAndSettle();
      expect(find.text('Ежедневная награда'), findsOneWidget);
      expect(find.text('Серия: 1 день'), findsOneWidget);
      for (var day = 1; day <= 7; day++) {
        expect(find.text('День $day'), findsOneWidget);
      }
      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
        await File(
          '/tmp/kopikot_daily_reward_preview.png',
        ).writeAsBytes(bytes.buffer.asUint8List());
        image.dispose();
      });
      await tester.scrollUntilVisible(
        find.text('Забрать 5'),
        220,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Забрать 5'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 105);
      expect(find.text('Награда получена'), findsOneWidget);
      expect(find.text('Получено 5 коткоинов!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(
        repository.profile!.transactions.where(
          (entry) => entry.id.startsWith('daily-reward-'),
        ),
        hasLength(1),
      );

      await tester.tap(find.byTooltip('Назад'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Награда'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Награда получена'),
        220,
        scrollable: find.byType(Scrollable).last,
      );
      expect(repository.profile!.balance, 105);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Итог дня доступен с увеличенным текстом', (tester) async {
    final repository = _MemoryRepository()..profile = initialProfile;
    await launch(tester, repository, scale: 2);
    tester.view.physicalSize = const Size(360, 640);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ещё'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Итог дня'));
    await tester.pumpAndSettle();
    expect(find.text('Твои коткоины сегодня'), findsOneWidget);
    expect(find.text('Продолжить'), findsOneWidget);
    expect(tester.getBottomLeft(find.text('Продолжить')).dy, lessThan(640));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Главный экран 360×640 показывает игровые действия без ошибок', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/orange_kitten.png',
      'assets/images/fairytale_background.png',
      'assets/images/action_feed.png',
      'assets/images/action_play.png',
      'assets/images/action_walk.png',
      'assets/images/action_care.png',
      'assets/images/home_coin_tree.png',
      'assets/images/home_goal_sapling.png',
      'assets/images/cat_coin.png',
      'assets/images/logo_wood.png',
    ]);
    final key = GlobalKey();
    final repository = _MemoryRepository()..profile = initialProfile;
    await launch(tester, repository, captureKey: key);
    tester.view.physicalSize = const Size(360, 640);
    await tester.pumpAndSettle();
    expect(find.text('КопиКот'), findsOneWidget);
    expect(find.text('Как я себя чувствую'), findsOneWidget);
    expect(find.text('Кормить'), findsOneWidget);
    expect(find.text('Играть'), findsOneWidget);
    expect(find.text('Гулять'), findsOneWidget);
    expect(find.text('Уход'), findsOneWidget);
    final goal = tester.getRect(find.byKey(const Key('home-goal-panel')));
    final bottomBar = tester.getRect(find.byKey(const Key('home-bottom-bar')));
    expect(goal.bottom, lessThanOrEqualTo(bottomBar.top));
    expect(tester.takeException(), isNull);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_home_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });
    await tester.tap(find.byKey(const Key('home-goal-panel')));
    await tester.pumpAndSettle();
    expect(find.text('Накопления'), findsOneWidget);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Котодерево'));
    await tester.pumpAndSettle();
    expect(find.text('Котодерево'), findsOneWidget);
    expect(find.text('Посадить деревце'), findsOneWidget);
    expect(find.text('Саженец на 10 дней'), findsNothing);
  });

  testWidgets('Выбранная цель и окрас видны на главной и в Котомаркете', (
    tester,
  ) async {
    final repository = _MemoryRepository()
      ..profile = const GameProfile(
        petName: 'Тема',
        coat: PetCoat.dark,
        accessory: PetAccessory.scarf,
        balance: 100,
        savings: 0,
        period: 1,
        satiety: 70,
        mood: 70,
        incomeSource: 'Подарок на знакомство',
        incomeAmount: 100,
        selectedGoalId: 'telescope',
      );
    await launch(tester, repository);
    expect(
      find.descendant(
        of: find.byKey(const Key('home-goal-panel')),
        matching: find.image(const AssetImage('assets/images/savings_bed.png')),
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Магазин'));
    await tester.pumpAndSettle();
    expect(
      find.image(const AssetImage('assets/images/dark_kitten.png')),
      findsOneWidget,
    );
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(
          MaterialPageRoute<void>(builder: (_) => const AccountantScreen()),
        );
    await tester.pumpAndSettle();
    expect(
      find.image(const AssetImage('assets/images/dark_kitten.png')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ветеринар 360×640 открыт из виджета и проводит осмотр', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/orange_kitten.png',
      'assets/images/fairytale_background.png',
      'assets/images/vet_rabbit.png',
      'assets/images/cat_coin.png',
      'assets/images/logo_wood.png',
      'assets/images/action_care.png',
      'assets/images/budget_savings.png',
    ]);
    final key = GlobalKey();
    final repository = _MemoryRepository()
      ..profile = initialProfile.copyWith(
        plan: const BudgetPlan(
          availableAtConfirmation: 100,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
    await launch(tester, repository, captureKey: key);
    tester.view.physicalSize = const Size(360, 640);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Котик'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ветеринар'));
    await tester.pumpAndSettle();
    expect(find.text('Плановый осмотр'), findsOneWidget);
    expect(find.text('Проверим, всё ли хорошо?'), findsOneWidget);
    expect(find.text('Стоимость'), findsOneWidget);
    expect(find.text('Резерв помощи'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_vet_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });

    await tester.scrollUntilVisible(
      find.text('Запланировать осмотр'),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Запланировать осмотр'));
    await tester.pumpAndSettle();
    expect(find.text('Запланировать осмотр?'), findsOneWidget);
    expect(
      find.textContaining(
        'Добрый врач осмотрит ${initialProfile.petName}: радость +10.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('даст совет'), findsNothing);
    await tester.tap(find.text('Запланировать'));
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 75);
    expect(repository.profile!.mood, 80);
    expect(repository.profile!.transactions.last.referenceId, 'vet_checkup');
    expect(find.text('Всё хорошо, котик полностью здоров!'), findsOneWidget);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();
    navigator.push(MaterialPageRoute<void>(builder: (_) => const VetScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Проверим, всё ли хорошо?'), findsOneWidget);
    expect(find.text('Всё хорошо, котик полностью здоров!'), findsNothing);
  });

  testWidgets('Прогресс показывает задания, цель и план с результатом', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/fairytale_background.png',
      'assets/images/orange_kitten.png',
      'assets/images/logo_wood.png',
      'assets/images/cat_coin.png',
      'assets/images/quest_badge_plan.png',
      'assets/images/quest_badge_purchases.png',
      'assets/images/quest_badge_savings.png',
      'assets/images/savings_treadmill.png',
      'assets/images/budget_needs.png',
      'assets/images/budget_joy.png',
      'assets/images/budget_savings.png',
    ]);
    final repository = _MemoryRepository();
    repository.profile = initialProfile.copyWith(
      selectedGoalId: 'tent',
      goalSavings: const {'tent': 110},
      taskProgress: [
        for (final task in repository.catalog.tasks.take(4))
          TaskProgress(
            taskId: task.id,
            attempts: 1,
            completed: true,
            feedback: 'Готово',
          ),
      ],
      periodSummaries: const [
        PeriodSummary(
          period: 1,
          plannedNeeds: 30,
          plannedWants: 15,
          plannedSavings: 15,
          actualNeeds: 25,
          actualWants: 10,
          netSaved: 20,
          needsMet: true,
          withinPlan: true,
          savedRegularly: true,
          explanation: 'Хороший план.',
        ),
      ],
    );
    final previewKey = GlobalKey();
    await launch(tester, repository, captureKey: previewKey);
    tester.view.physicalSize = const Size(360, 640);
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(MaterialPageRoute<void>(builder: (_) => const ProgressScreen()));
    await tester.pumpAndSettle();
    final previewBoundary =
        previewKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await previewBoundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_progress_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });
    expect(find.text('Мой прогресс'), findsOneWidget);
    expect(find.text('Выполни задания и изучай новые темы.'), findsOneWidget);
    expect(find.text('4 из 6'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('110 / 400'),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Беговая дорожка'), findsOneWidget);
    expect(find.text('290'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('На нужное хватило'),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('План и результат'), findsOneWidget);
    expect(find.text('На нужное хватило, на цель отложено 20'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Котодерево 360×640 показывает обе награды саженца', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/grey_kitten.png',
      'assets/images/garden_background.png',
      'assets/images/garden_coin_sapling.png',
      'assets/images/cat_coin.png',
      'assets/images/logo_wood.png',
    ]);
    final key = GlobalKey();
    final repository = _MemoryRepository()
      ..profile = const GameProfile(
        petName: 'Финни',
        coat: PetCoat.grey,
        accessory: PetAccessory.scarf,
        balance: 80,
        savings: 0,
        period: 1,
        satiety: 70,
        mood: 70,
        incomeSource: 'Подарок на знакомство',
        incomeAmount: 100,
        saplings: [
          SaplingState(
            id: 'seed-1',
            definitionId: 'sapling_5',
            plantedPeriod: 1,
          ),
        ],
      );
    await launch(tester, repository, captureKey: key);
    tester.view.physicalSize = const Size(360, 640);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const GardenScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Моё деревце'), findsOneWidget);
    expect(find.text('До урожая: 5 дней'), findsOneWidget);
    expect(find.text('Собрать сейчас'), findsOneWidget);
    expect(find.text('Подождать 5 дней'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('50'), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/images/grey_kitten.png')),
      findsOneWidget,
    );
    expect(find.text('Посадить новый'), findsNothing);
    expect(tester.takeException(), isNull);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_garden_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });

    await tester.scrollUntilVisible(
      find.text('Собрать сейчас'),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Собрать сейчас'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Собрать сейчас: +30 монет.'), findsOneWidget);
  });

  testWidgets('Гардероб 360×640 показывает образ и бесплатно меняет вещь', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/orange_kitten.png',
      'assets/images/grey_kitten.png',
      'assets/images/grey_kitten_no_scarf.png',
      'assets/images/wardrobe_background.png',
      'assets/images/cat_coin.png',
      'assets/images/logo_wood.png',
      'assets/images/wardrobe_scarf.png',
      'assets/images/wardrobe_bow.png',
      'assets/images/wardrobe_headband.png',
      'assets/images/wardrobe_wristbands.png',
    ]);
    final key = GlobalKey();
    final repository = _MemoryRepository()
      ..profile = const GameProfile(
        petName: 'Финни',
        coat: PetCoat.grey,
        accessory: PetAccessory.scarf,
        balance: 100,
        savings: 0,
        period: 1,
        satiety: 70,
        mood: 70,
        incomeSource: 'Подарок на знакомство',
        incomeAmount: 100,
        ownedAccessories: [
          PetAccessory.bow,
          PetAccessory.headband,
          PetAccessory.wristbands,
        ],
      );
    await launch(tester, repository, captureKey: key);
    tester.view.physicalSize = const Size(360, 640);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const WardrobeScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Гардероб'), findsOneWidget);
    expect(find.text('Выбирай мой образ! 🐾'), findsOneWidget);
    expect(find.text('Мои аксессуары'), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/images/wardrobe_background.png')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/grey_kitten.png')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/wardrobe_scarf.png')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/wardrobe_bow.png')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_wardrobe_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });

    await tester.scrollUntilVisible(
      find.text('Напульсники'),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Повязка'), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/images/wardrobe_headband.png')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/wardrobe_wristbands.png')),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.text('Бантик'),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.byKey(const Key('wardrobe-bow')));
    await tester.ensureVisible(find.text('Надеть'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Надеть'));
    await tester.pumpAndSettle();
    expect(repository.profile!.accessory, PetAccessory.bow);
    expect(repository.profile!.coat, PetCoat.grey);
    await tester.scrollUntilVisible(
      find.text('Гардероб'),
      -180,
      scrollable: find.byType(Scrollable).last,
    );
    expect(
      find.image(const AssetImage('assets/images/grey_kitten_no_scarf.png')),
      findsOneWidget,
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_wardrobe_bow_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });
    await tester.ensureVisible(find.text('Снять'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Снять'));
    await tester.pumpAndSettle();
    expect(repository.profile!.accessory, isNull);
    expect(repository.profile!.coat, PetCoat.grey);
    await tester.scrollUntilVisible(
      find.text('Гардероб'),
      -180,
      scrollable: find.byType(Scrollable).last,
    );
    expect(
      find.image(const AssetImage('assets/images/grey_kitten_no_scarf.png')),
      findsOneWidget,
    );
  });

  testWidgets('Пять окрасов и аксессуары различимы на трёх стадиях', (
    tester,
  ) async {
    await cacheCatImages(tester, const [
      'assets/images/orange_kitten.png',
      'assets/images/grey_kitten.png',
      'assets/images/cream_kitten.png',
      'assets/images/dark_kitten.png',
      'assets/images/white_kitten.png',
      'assets/images/orange_kitten_no_scarf.png',
      'assets/images/grey_kitten_no_scarf.png',
      'assets/images/cream_kitten_no_scarf.png',
      'assets/images/dark_kitten_no_scarf.png',
      'assets/images/white_kitten_no_scarf.png',
      'assets/images/wardrobe_bow.png',
      'assets/images/wardrobe_headband.png',
      'assets/images/wardrobe_wristbands.png',
    ]);
    final key = GlobalKey();
    final Set<int> fingerprints = {};
    for (final coat in PetCoat.values) {
      for (final accessory in PetAccessory.values) {
        for (var stage = 1; stage <= 3; stage++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: RepaintBoundary(
                    key: key,
                    child: PetPortrait(
                      coat: coat,
                      accessory: accessory,
                      stage: stage,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            find.bySemanticsLabel(
              '${coatLabels[coat]} кот, ${accessoryLabels[accessory]}',
            ),
            findsOneWidget,
          );
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final ui.Image image = await boundary.toImage();
            final bytes = (await image.toByteData(
              format: ui.ImageByteFormat.png,
            ))!;
            fingerprints.add(Object.hashAll(bytes.buffer.asUint8List()));
            if (coat == PetCoat.ginger && accessory == PetAccessory.scarf) {
              await File(
                '/tmp/kopikot_pet_stage_$stage.png',
              ).writeAsBytes(bytes.buffer.asUint8List());
            }
            image.dispose();
          });
        }
      }
    }
    expect(fingerprints.length, 75);
  });

  testWidgets('Шесть эмоций питомца визуально различимы', (tester) async {
    await cacheCatImages(tester, const ['assets/images/grey_kitten.png']);
    final key = GlobalKey();
    final Set<int> fingerprints = {};
    for (final emotion in PetEmotion.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: key,
                child: PetPortrait(
                  coat: PetCoat.grey,
                  accessory: PetAccessory.scarf,
                  emotion: emotion,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final ui.Image image = await boundary.toImage();
        final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
        fingerprints.add(Object.hashAll(bytes.buffer.asUint8List()));
        image.dispose();
      });
    }
    expect(fingerprints.length, PetEmotion.values.length);
  });

  testWidgets('Бухгалтер: ошибка безопасна, два ответа дают одну награду', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/orange_kitten.png',
      'assets/images/fairytale_background.png',
      'assets/images/quest_cat_food.png',
      'assets/images/budget_joy.png',
      'assets/images/cat_coin.png',
      'assets/images/logo_wood.png',
    ]);
    final key = GlobalKey();
    final repository = _MemoryRepository()
      ..profile = initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
    await launch(tester, repository, captureKey: key);
    tester.view.physicalSize = const Size(360, 640);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const AccountantScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('accountant-start')), findsOneWidget);
    await tester.tap(find.byKey(const Key('accountant-start')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Корм стоит 8 коткоинов'), findsOneWidget);
    expect(find.text('Можно попробовать ещё раз'), findsOneWidget);
    expect(find.byKey(const Key('accountant-hint')), findsOneWidget);
    expect(tester.takeException(), isNull);

    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_accountant_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });

    Future<void> tapVisible(Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    await tapVisible(find.byKey(const Key('accountant-hint')));
    expect(find.textContaining('Сначала сравни, сколько дали'), findsWidgets);

    await tapVisible(find.byKey(const Key('accountant-answer-10')));
    expect(repository.profile!.balance, 100);
    expect(
      repository.profile!.accountantSessions.single.progress.first.hintUsed,
      isTrue,
    );

    await tapVisible(find.byKey(const Key('accountant-answer-12')));
    await tapVisible(find.byKey(const Key('accountant-primary')));
    expect(find.textContaining('Молочко стоит 6 коткоинов'), findsOneWidget);

    await tapVisible(find.byKey(const Key('accountant-answer-9')));
    await tapVisible(find.byKey(const Key('accountant-primary')));
    expect(repository.profile!.balance, 106);
    expect(repository.profile!.transactions.last.referenceId, 'accountant');
    expect(find.textContaining('получил 6 коткоинов'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Котомаркет: выбор исправляется до награды без списания', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await ui.loadFontFromList(
        await File('assets/fonts/Nunito-Variable.ttf').readAsBytes(),
        fontFamily: 'Nunito',
      );
    });
    await cacheCatImages(tester, const [
      'assets/images/orange_kitten.png',
      'assets/images/quest_market_background.png',
      'assets/images/quest_cat_food.png',
      'assets/images/market_shampoo.png',
      'assets/images/quest_toy_mouse.png',
      'assets/images/market_basket.png',
      'assets/images/cat_coin.png',
      'assets/images/logo_wood.png',
    ]);
    final key = GlobalKey();
    final repository = _MemoryRepository()
      ..profile = initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
    await launch(tester, repository, captureKey: key);
    tester.view.physicalSize = const Size(360, 640);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const MarketGameScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Котомаркет'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      await File(
        '/tmp/kopikot_market_game_preview.png',
      ).writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });

    Future<void> tapVisible(Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    await tapVisible(find.byKey(const Key('market-start')));
    await tapVisible(find.byKey(const Key('market-item-toy')));
    await tapVisible(find.byKey(const Key('market-item-food')));
    await tapVisible(find.byKey(const Key('market-primary')));
    expect(repository.profile!.balance, 100);
    expect(find.textContaining('шампунь'), findsWidgets);

    await tapVisible(find.byKey(const Key('market-item-shampoo')));
    await tapVisible(find.byKey(const Key('market-primary')));
    expect(repository.profile!.balance, 100);
    await tapVisible(find.byKey(const Key('market-primary')));
    expect(repository.profile!.balance, 106);
    expect(repository.profile!.transactions.last.referenceId, 'kotomarket');
    expect(find.textContaining('23'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Котомаркет принимает перетаскивание товара в корзину', (
    tester,
  ) async {
    await cacheCatImages(tester, const [
      'assets/images/orange_kitten.png',
      'assets/images/quest_market_background.png',
      'assets/images/quest_cat_food.png',
      'assets/images/market_shampoo.png',
      'assets/images/quest_toy_mouse.png',
      'assets/images/market_basket.png',
      'assets/images/cat_coin.png',
      'assets/images/logo_wood.png',
    ]);
    final repository = _MemoryRepository()
      ..profile = initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
    await launch(tester, repository);
    tester.view.physicalSize = const Size(390, 850);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const MarketGameScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('market-start')));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('market-item-food'))),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await gesture.moveTo(
      tester.getCenter(find.byKey(const Key('market-basket'))),
    );
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(repository.profile!.balance, 100);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Накопления: достигнутую цель можно купить из копилки', (
    tester,
  ) async {
    final repository = _MemoryRepository()
      ..profile = initialProfile.copyWith(
        selectedGoalId: 'telescope',
        savings: 300,
        goalSavings: const {'telescope': 300},
        plan: const BudgetPlan(
          availableAtConfirmation: 100,
          needs: 40,
          wants: 30,
          savings: 30,
        ),
      );
    await launch(tester, repository);
    tester.view.physicalSize = const Size(390, 850);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const SavingsScreen()),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.widgetWithText(FilledButton, 'Купить цель'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Снять'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Купить цель'));
    await tester.pumpAndSettle();
    expect(find.textContaining('именно с этой цели'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Купить цель').last);
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 100);
    expect(repository.profile!.savedFor('telescope'), 0);
    expect(repository.profile!.savings, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Накопления: резерв пополняется отдельно и снимается обратно', (
    tester,
  ) async {
    final repository = _MemoryRepository()
      ..profile = initialProfile.copyWith(
        selectedGoalId: 'tent',
        plan: const BudgetPlan(
          availableAtConfirmation: 100,
          needs: 40,
          wants: 30,
          savings: 30,
        ),
      );
    await launch(tester, repository);
    tester.view.physicalSize = const Size(360, 640);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const SavingsScreen()),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Отложить в резерв'),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Этот запас не входит'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, '13');
    await tester.tap(find.text('Отложить в резерв'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Отложить').last);
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 87);
    expect(repository.profile!.savings, 13);
    expect(repository.profile!.reserveSavings, 13);
    expect(repository.profile!.savedFor('tent'), 0);
    await tester.ensureVisible(
      find.widgetWithText(OutlinedButton, 'Снять из резерва'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Снять из резерва'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Снять').last);
    await tester.pumpAndSettle();
    expect(repository.profile!.balance, 100);
    expect(repository.profile!.savings, 0);
    expect(repository.profile!.reserveSavings, 0);
    expect(tester.takeException(), isNull);
  });
}
