import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/models/learning_task.dart';
import 'package:kopikot/domain/rules/daily_reward_rules.dart';
import 'package:kopikot/domain/rules/economy_rules.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/domain/rules/learning_rules.dart';
import 'package:kopikot/domain/rules/period_rules.dart';

import 'game_rules_test.dart' show initialProfile;

void main() {
  final source = File('assets/content/catalog.json').readAsStringSync();
  final tasks = File('assets/content/tasks.json').readAsStringSync();
  final catalog = parseGameCatalog(source, taskSource: tasks);
  final answers = <String, TaskAnswer>{
    'budget_lunch': const TaskAnswer(needs: 30, wants: 20, savings: 10),
    'budget_reserve': const TaskAnswer(products: ['feed', 'vet']),
    'basket_food': const TaskAnswer(choice: 'food'),
    'basket_care': const TaskAnswer(choice: 'no'),
    'saving_start': const TaskAnswer(savings: 10),
    'saving_finish': const TaskAnswer(choice: 'fluffy'),
  };

  test('Шесть заданий по трём темам; разные способы взаимодействия', () {
    expect(catalog.tasks.length, 6);
    expect(catalog.tasks.map((task) => task.topic).toSet().length, 3);
    expect(catalog.tasks.map((task) => task.kind).toSet().length, 3);
  });

  for (final task in catalog.tasks) {
    test('${task.id}: ошибочный ответ, правильный ответ и повтор награды', () {
      var profile = initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
      profile = LearningRules.submit(
        profile,
        catalog,
        task,
        const TaskAnswer(),
      );
      expect(profile.balance, 100);
      expect(profile.completedTask(task.id), isFalse);
      if (task.id == 'budget_lunch') {
        expect(profile.feedback, contains('Распредели все 60 коткоинов'));
      } else if (task.id == 'basket_food') {
        expect(profile.feedback, contains('Выбери покупку'));
      } else if (task.id == 'basket_care') {
        expect(profile.feedback, contains('Посчитай полную цену'));
      } else if (task.id == 'saving_finish') {
        expect(profile.feedback, contains('Выбери способ копить'));
      } else {
        expect(profile.feedback, contains(task.retry));
      }
      expect(profile.satiety, 70);
      profile = LearningRules.submit(profile, catalog, task, answers[task.id]!);
      const expectedReward = 8;
      expect(profile.balance, 100 + expectedReward);
      expect(profile.completedTask(task.id), isTrue);
      expect(profile.taskProgress.single.attempts, 2);
      if (task.id == 'saving_start') {
        expect(profile.feedback, contains('Умное решение!'));
      } else {
        expect(profile.feedback, contains(task.success));
      }
      expect(profile.transactions.single.label, 'Задание: ${task.title}');
      profile = LearningRules.submit(profile, catalog, task, answers[task.id]!);
      expect(profile.balance, 100 + expectedReward);
      expect(profile.transactions.length, 1);
    });
  }

  test('Недельный бюджет: три исхода и 12 коткоинов с первой попытки', () {
    const missingNeeds = TaskAnswer(needs: 20, wants: 30, savings: 10);
    const littleSavings = TaskAnswer(needs: 30, wants: 30);
    const ideal = TaskAnswer(needs: 30, wants: 20, savings: 10);
    expect(
      LearningRules.evaluateWeeklyBudget(missingNeeds).title,
      'Ой, корм пропал из плана',
    );
    expect(
      LearningRules.evaluateWeeklyBudget(littleSavings).title,
      'Почти получилось!',
    );
    expect(LearningRules.evaluateWeeklyBudget(littleSavings).canClaim, isTrue);
    expect(LearningRules.evaluateWeeklyBudget(ideal).title, 'Отличный план!');
    expect(
      LearningRules.evaluateWeeklyBudget(const TaskAnswer(needs: 30)).canClaim,
      isFalse,
    );
    final profile = initialProfile.withPlan(
      GameRules.confirmBudget(
        initialProfile,
        needs: 50,
        wants: 20,
        savings: 30,
      ),
    );
    final completed = LearningRules.submit(
      profile,
      catalog,
      catalog.task('budget_lunch'),
      ideal,
    );
    expect(completed.balance, 112);
    expect(completed.transactions.single.amount, 12);
    expect(completed.feedback, contains('С первой попытки — ты молодец!'));
    final partial = LearningRules.submit(
      profile,
      catalog,
      catalog.task('budget_lunch'),
      littleSavings,
    );
    expect(partial.balance, 108);
    expect(partial.feedback, contains('Почти получилось!'));
  });

  test('План на день: нужное, полный расход и запас', () {
    const missingVet = TaskAnswer(products: ['feed', 'mouse']);
    const allSpent = TaskAnswer(products: ['feed', 'vet', 'mouse']);
    const withReserve = TaskAnswer(products: ['feed', 'vet']);
    expect(
      LearningRules.evaluateDayPlan(missingVet).title,
      'Нужное пропустили',
    );
    expect(LearningRules.evaluateDayPlan(allSpent).title, 'Нужное закрыто!');
    expect(LearningRules.evaluateDayPlan(allSpent).canClaim, isTrue);
    expect(LearningRules.evaluateDayPlan(withReserve).perfect, isTrue);
    expect(
      LearningRules.evaluateDayPlan(withReserve).consequence,
      '10 коткоинов можно отложить на мечту.',
    );
    expect(
      LearningRules.evaluateDayPlan(
        const TaskAnswer(products: ['feed', 'vet', 'bow']),
      ).canClaim,
      isFalse,
    );
    final profile = initialProfile.withPlan(
      GameRules.confirmBudget(
        initialProfile,
        needs: 50,
        wants: 20,
        savings: 30,
      ),
    );
    final task = catalog.task('budget_reserve');
    expect(
      LearningRules.submit(profile, catalog, task, withReserve).balance,
      112,
    );
    expect(LearningRules.submit(profile, catalog, task, allSpent).balance, 108);
  });

  test('Что купить сначала: мышку можно вернуть, награда за исправление 8', () {
    expect(
      LearningRules.evaluateFirstPurchase(
        const TaskAnswer(choice: 'mouse'),
      ).fixButton,
      'Вернуть мышку и купить корм',
    );
    expect(
      LearningRules.evaluateFirstPurchase(
        const TaskAnswer(choice: 'food'),
      ).consequence,
      'Останется 10 коткоинов, которые можно отложить на мышку.',
    );
    final profile = initialProfile.withPlan(
      GameRules.confirmBudget(
        initialProfile,
        needs: 50,
        wants: 20,
        savings: 30,
      ),
    );
    final task = catalog.task('basket_food');
    final wrong = LearningRules.submit(
      profile,
      catalog,
      task,
      const TaskAnswer(choice: 'mouse'),
    );
    expect(wrong.balance, 100);
    expect(wrong.completedTask(task.id), isFalse);
    final corrected = LearningRules.submit(
      wrong,
      catalog,
      task,
      const TaskAnswer(choice: 'food'),
    );
    expect(corrected.balance, 108);
    expect(corrected.completedTask(task.id), isTrue);
  });

  test('Полная цена: ответ 60 против 40 и исправление покупки', () {
    final wrong = LearningRules.evaluateFullPrice(
      const TaskAnswer(choice: 'yes'),
    );
    expect(wrong.title, 'Проверим цену ещё раз');
    expect(wrong.consequence, contains('не хватит денег'));
    expect(wrong.fixButton, 'Выбрать корм и лекарство');
    expect(wrong.canClaim, isFalse);
    final correct = LearningRules.evaluateFullPrice(
      const TaskAnswer(choice: 'no'),
    );
    expect(correct.title, 'Точно подсчитано!');
    expect(correct.perfect, isTrue);
  });

  test('Награда 30: пустая, малая и достаточная копилка', () {
    expect(
      LearningRules.evaluateRewardSaving(const TaskAnswer()).title,
      'Копилка стоит пустая',
    );
    final partial = LearningRules.evaluateRewardSaving(
      const TaskAnswer(savings: 7),
    );
    expect(partial.title, 'Неплохо, но можно больше');
    expect(partial.canClaim, isTrue);
    expect(partial.perfect, isFalse);
    final ideal = LearningRules.evaluateRewardSaving(
      const TaskAnswer(savings: 10),
    );
    expect(
      ideal.explanation,
      'Ты не тратишь всё сразу: 20 коткоинов — на игрушку, а 10 — в копилку.',
    );
    expect(ideal.perfect, isTrue);
    expect(
      LearningRules.evaluateRewardSaving(
        const TaskAnswer(savings: 31),
      ).canClaim,
      isFalse,
    );
    final profile = initialProfile.withPlan(
      GameRules.confirmBudget(
        initialProfile,
        needs: 50,
        wants: 20,
        savings: 30,
      ),
    );
    final task = catalog.task('saving_start');
    expect(
      LearningRules.submit(
        profile,
        catalog,
        task,
        const TaskAnswer(savings: 7),
      ).balance,
      108,
    );
    expect(
      LearningRules.submit(
        profile,
        catalog,
        task,
        const TaskAnswer(savings: 10),
      ).balance,
      112,
    );
  });

  test('Регулярные накопления: оба неверных ответа исправимы', () {
    final fluffy = LearningRules.evaluateDailySavings(
      const TaskAnswer(choice: 'fluffy'),
    );
    expect(fluffy.title, 'Верно! Копилка любит регулярность');
    expect(fluffy.perfect, isTrue);
    expect(
      LearningRules.evaluateDailySavings(
        const TaskAnswer(choice: 'coal'),
      ).fixButton,
      'Начать откладывать понемногу',
    );
    expect(
      LearningRules.evaluateDailySavings(
        const TaskAnswer(choice: 'same'),
      ).fixButton,
      'Понял! Маленькие шаги каждый день',
    );
  });

  test('Ошибочный ответ и сумма сверх награды не дают коткоинов', () {
    final profile = initialProfile.withPlan(
      GameRules.confirmBudget(
        initialProfile,
        needs: 50,
        wants: 20,
        savings: 30,
      ),
    );
    for (final answer in [
      const TaskAnswer(choice: 'yes'),
      const TaskAnswer(choice: 'invalid'),
    ]) {
      expect(
        LearningRules.submit(
          profile,
          catalog,
          catalog.task('basket_care'),
          answer,
        ).balance,
        100,
      );
    }
    expect(
      LearningRules.submit(
        profile,
        catalog,
        catalog.task('saving_start'),
        const TaskAnswer(savings: 31),
      ).balance,
      100,
    );
    expect(
      LearningRules.submit(
        profile,
        catalog,
        catalog.task('budget_lunch'),
        const TaskAnswer(needs: 50, wants: 30, savings: 10),
      ).balance,
      100,
    );
  });

  test('Невыполнимое задание отклоняется загрузчиком', () {
    final data = jsonDecode(tasks) as List<dynamic>;
    data[0]['minimumNeeds'] = 999;
    expect(
      () => parseGameCatalog(source, taskSource: jsonEncode(data)),
      throwsFormatException,
    );
  });

  test('Добавление задания существующего типа требует только данных', () {
    final data = jsonDecode(tasks) as List<dynamic>;
    data.add({...data.first as Map<String, dynamic>, 'id': 'budget_extra'});
    final expanded = parseGameCatalog(source, taskSource: jsonEncode(data));
    final profile = initialProfile.withPlan(
      GameRules.confirmBudget(
        initialProfile,
        needs: 50,
        wants: 20,
        savings: 30,
      ),
    );
    expect(
      LearningRules.submit(
        profile,
        expanded,
        expanded.task('budget_extra'),
        answers['budget_lunch']!,
      ).completedTask('budget_extra'),
      isTrue,
    );
  });

  test(
    'Пять периодов, три стадии, отсутствие повторного дохода и отката роста',
    () {
      var profile = EconomyRules.selectGoal(
        initialProfile,
        catalog.goal('tent'),
      );
      for (int period = 1; period <= 5; period++) {
        profile = profile.withPlan(
          GameRules.confirmBudget(profile, needs: 25, wants: 0, savings: 20),
        );
        profile = EconomyRules.purchase(
          profile,
          catalog.product('porridge'),
          'buy-$period',
        );
        profile = EconomyRules.transfer(
          profile,
          catalog.goal('tent'),
          20,
          commandId: 'save-$period',
          withdraw: false,
        );
        profile = PeriodRules.finish(profile, period);
        expect(profile.period, period + 1);
        expect(profile.plan, isNull);
        expect(profile.growthStage, period >= 4 ? 3 : (period >= 2 ? 2 : 1));
        expect(identical(PeriodRules.finish(profile, period), profile), isTrue);
      }
      expect(profile.periodSummaries.length, 5);
      expect(profile.savings, 100);
      // Серия не начисляется при завершении периода.
      expect(profile.balance, 375);
      profile = profile.withPlan(
        GameRules.confirmBudget(profile, needs: 0, wants: 0, savings: 0),
      );
      profile = PeriodRules.finish(profile, 6);
      expect(profile.growthStage, 3);
      expect(profile.growthPeriods, 5);
      expect(profile.savings, 100);
    },
  );

  test('Контрольные суммы полной демонстрации из docs/demo_scenario.md', () {
    var profile = EconomyRules.selectGoal(initialProfile, catalog.goal('tent'));
    const balances = [133, 188, 243, 298, 353];
    for (var period = 1; period <= 5; period++) {
      profile = profile.withPlan(
        GameRules.confirmBudget(
          profile,
          needs: 25,
          wants: period == 1 ? 30 : 0,
          savings: 20,
        ),
      );
      if (period == 1) {
        final task = catalog.task('budget_lunch');
        profile = LearningRules.submit(
          profile,
          catalog,
          task,
          const TaskAnswer(needs: 20, wants: 30, savings: 10),
        );
        expect(profile.balance, 100);
        profile = LearningRules.submit(
          profile,
          catalog,
          task,
          const TaskAnswer(needs: 30, wants: 20, savings: 10),
        );
        expect(profile.balance, 108);
      }
      profile = EconomyRules.purchase(
        profile,
        catalog.product('porridge'),
        'porridge-$period',
      );
      if (period == 1) {
        profile = EconomyRules.purchase(
          profile,
          catalog.product('ball'),
          'ball',
        );
        expect(profile.balance, 53);
      }
      profile = EconomyRules.transfer(
        profile,
        catalog.goal('tent'),
        20,
        commandId: 'deposit-$period',
        withdraw: false,
      );
      if (period == 1) {
        final before = profile;
        expect(profile.balance, 33);
        expect(
          () =>
              EconomyRules.purchase(profile, catalog.product('puzzle'), 'fail'),
          throwsA(isA<GameRuleException>()),
        );
        expect(identical(profile, before), isTrue);
        expect(profile.actualNeeds, 25);
        expect(profile.actualWants, 30);
        expect(profile.netSaved, 20);
      }
      profile = PeriodRules.finish(profile, period);
      expect(profile.period, period + 1);
      expect(profile.balance, balances[period - 1]);
      expect(profile.savings, period * 20);
      expect(profile.growthStage, period >= 4 ? 3 : (period >= 2 ? 2 : 1));
    }
    expect(profile.completedTask('budget_lunch'), isTrue);
    expect(profile.periodSummaries.length, 5);
  });

  test('Возврат отложенных монет не засчитывается для роста', () {
    var profile = EconomyRules.selectGoal(initialProfile, catalog.goal('tent'));
    profile = profile.withPlan(
      GameRules.confirmBudget(profile, needs: 25, wants: 0, savings: 20),
    );
    profile = EconomyRules.purchase(
      profile,
      catalog.product('porridge'),
      'buy',
    );
    profile = EconomyRules.transfer(
      profile,
      catalog.goal('tent'),
      20,
      commandId: 'save',
      withdraw: false,
    );
    profile = EconomyRules.transfer(
      profile,
      catalog.goal('tent'),
      20,
      commandId: 'take',
      withdraw: true,
    );
    expect(PeriodRules.summarize(profile).supportsGrowth, isFalse);
  });

  test('Подарки серии растут до седьмого дня и держатся на максимуме', () {
    var profile = EconomyRules.selectGoal(
      initialProfile,
      catalog.goal('garden'),
    );
    final start = DateTime(2026, 9, 1, 10);
    const bonuses = [5, 10, 15, 20, 25, 30, 35, 35];
    for (var period = 1; period <= 8; period++) {
      profile = DailyRewardRules.claim(
        profile,
        now: start.add(Duration(days: period - 1)),
      );
      final bonus = profile.transactions.last;
      expect(bonus.amount, bonuses[period - 1]);
      expect(bonus.label, 'Ежедневная награда: день ${period.clamp(1, 7)}');
      profile = profile.withPlan(
        GameRules.confirmBudget(profile, needs: 25, wants: 0, savings: 20),
      );
      profile = EconomyRules.purchase(
        profile,
        catalog.product('porridge'),
        'buy-$period',
      );
      profile = EconomyRules.transfer(
        profile,
        catalog.goal('garden'),
        20,
        commandId: 'save-$period',
        withdraw: false,
      );
      profile = PeriodRules.finish(profile, period);
      expect(profile.transactions.last.id, 'period-income-${period + 1}');
    }
    expect(profile.streak, 7);
    // 100 стартовых + 800 дохода + 175 наград − 200 еды − 160 накоплений.
    expect(profile.balance, 715);
    expect(profile.savings, 160);
  });

  test('Пропуск дней уменьшает серию на один уровень, не обнуляя её', () {
    final DateTime start = DateTime(2026, 9, 1, 10);
    var profile = DailyRewardRules.claim(
      initialProfile.copyWith(streak: 7, lastRewardAt: start),
      now: start.add(const Duration(days: 4)),
    );
    // 7 → 6 после пропуска, затем серия снова растёт.
    final bonus = profile.transactions.last;
    expect(bonus.amount, 30);
    expect(bonus.label, 'Ежедневная награда: день 6');
    expect(profile.streak, 7);
    expect(profile.feedback, contains('уменьшилась всего на один шаг'));

    // Серия первого уровня не обнуляется: приветствие остаётся тёплым.
    profile = DailyRewardRules.claim(
      initialProfile.copyWith(streak: 1, lastRewardAt: start),
      now: start.add(const Duration(days: 4)),
    );
    expect(profile.streak, 2);
    expect(profile.feedback, contains('Рад тебя видеть'));
    expect(profile.transactions.last.amount, 5);
  });

  test('Завершение периода снижает энергию, прогулка и еда её возвращают', () {
    var profile = initialProfile.withPlan(
      GameRules.confirmBudget(initialProfile, needs: 0, wants: 0, savings: 0),
    );
    profile = PeriodRules.finish(profile, 1);
    expect(profile.energy, 55);
    expect(profile.feedback, contains('бесплатная прогулка'));
    profile = profile.withPlan(
      GameRules.confirmBudget(profile, needs: 0, wants: 0, savings: 0),
    );
    profile = EconomyRules.purchase(
      profile,
      catalog.product('porridge'),
      'eat',
    );
    expect(profile.energy, 65);
  });
}
