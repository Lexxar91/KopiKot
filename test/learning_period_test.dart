import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/models/learning_task.dart';
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
    'budget_lunch': const TaskAnswer(needs: 30, savings: 10),
    'budget_reserve': const TaskAnswer(needs: 40, savings: 20),
    'basket_food': const TaskAnswer(products: ['porridge', 'water']),
    'basket_care': const TaskAnswer(products: ['shampoo', 'water', 'ribbon']),
    'saving_start': const TaskAnswer(savings: 10),
    'saving_finish': const TaskAnswer(savings: 15),
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
      expect(profile.feedback, contains(task.retry));
      expect(profile.satiety, 70);
      profile = LearningRules.submit(profile, catalog, task, answers[task.id]!);
      expect(profile.balance, 100 + task.reward);
      expect(profile.completedTask(task.id), isTrue);
      expect(profile.taskProgress.single.attempts, 2);
      expect(profile.feedback, contains(task.success));
      expect(profile.transactions.single.label, 'Задание: ${task.title}');
      profile = LearningRules.submit(profile, catalog, task, answers[task.id]!);
      expect(profile.balance, 100 + task.reward);
      expect(profile.transactions.length, 1);
    });
  }

  test(
    'Недопустимая корзина, перерасход и слишком большой перевод не вознаграждаются',
    () {
      final profile = initialProfile.withPlan(
        GameRules.confirmBudget(
          initialProfile,
          needs: 50,
          wants: 20,
          savings: 30,
        ),
      );
      for (final answer in [
        const TaskAnswer(products: ['missing']),
        const TaskAnswer(products: ['water', 'water', 'porridge']),
        const TaskAnswer(products: ['water', 'porridge', 'ball']),
      ]) {
        expect(
          LearningRules.submit(
            profile,
            catalog,
            catalog.task('basket_food'),
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
          const TaskAnswer(savings: 30),
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
    },
  );

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
      // Базовый доход 500 и подарки серии за пять периодов: 2+3+5+7+10.
      expect(profile.balance, 402);
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
    const balances = [137, 195, 255, 317, 382];
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
          const TaskAnswer(needs: 60),
        );
        expect(profile.balance, 100);
        profile = LearningRules.submit(
          profile,
          catalog,
          task,
          const TaskAnswer(needs: 30, wants: 20, savings: 10),
        );
        expect(profile.balance, 110);
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
        expect(profile.balance, 55);
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
        expect(profile.balance, 35);
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
    const bonuses = [2, 3, 5, 7, 10, 14, 20];
    for (var period = 1; period <= 8; period++) {
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
      final bonus = profile.transactions
          .where((entry) => entry.id == 'streak-bonus-${period + 1}')
          .single;
      expect(bonus.amount, bonuses[(period - 1).clamp(0, 6)]);
      expect(bonus.label, contains('серии'));
    }
    expect(profile.streak, 7);
    // 100 стартовых + 800 дохода + 81 подарок − 200 еды − 160 накоплений.
    expect(profile.balance, 621);
    expect(profile.savings, 160);
  });

  test('Пропуск дней уменьшает серию на один уровень, не обнуляя её', () {
    final DateTime start = DateTime(2026, 9, 1, 10);
    var profile = initialProfile
        .copyWith(streak: 7, lastRewardAt: start)
        .withPlan(
          GameRules.confirmBudget(initialProfile, needs: 0, wants: 0, savings: 0),
        );
    profile = PeriodRules.finish(
      profile,
      1,
      now: start.add(const Duration(days: 4)),
    );
    // 7 → 6 после пропуска, начислен подарок шестого дня, серия снова растёт.
    final bonus = profile.transactions
        .where((entry) => entry.id == 'streak-bonus-2')
        .single;
    expect(bonus.amount, 14);
    expect(bonus.label, 'Подарок за день 6 серии');
    expect(profile.streak, 7);
    expect(profile.feedback, contains('уменьшилась на один уровень'));

    // Серия первого уровня не обнуляется: приветствие остаётся тёплым.
    profile = initialProfile
        .copyWith(streak: 1, lastRewardAt: start)
        .withPlan(
          GameRules.confirmBudget(initialProfile, needs: 0, wants: 0, savings: 0),
        );
    profile = PeriodRules.finish(
      profile,
      1,
      now: start.add(const Duration(days: 4)),
    );
    expect(profile.streak, 2);
    expect(profile.feedback, contains('Рад тебя видеть'));
    expect(profile.transactions.last.amount, 2);
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
    profile = EconomyRules.purchase(profile, catalog.product('porridge'), 'eat');
    expect(profile.energy, 65);
  });
}
