import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/models/learning_scenario.dart';
import 'package:kopikot/domain/models/learning_task.dart';
import 'package:kopikot/domain/rules/activity_reward_rules.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/domain/rules/learning_difficulty_rules.dart';
import 'package:kopikot/domain/rules/learning_rules.dart';

import 'game_rules_test.dart' show initialProfile;

void main() {
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
    taskSource: File('assets/content/tasks.json').readAsStringSync(),
  );
  final planned = initialProfile.withPlan(
    GameRules.confirmBudget(initialProfile, needs: 50, wants: 20, savings: 30),
  );

  test('Шесть новых заданий: по два на тему, простые варианты проверяемы', () {
    expect(catalog.tasks, hasLength(6));
    for (final topic in ['Планирование', 'Покупки', 'Сбережения']) {
      expect(catalog.tasks.where((task) => task.topic == topic), hasLength(2));
      expect(
        planned.learningTopic(topic).difficulty,
        LearningDifficulty.simple,
      );
    }
    expect(
      LearningScenario.forTask(
        'need_first',
        LearningDifficulty.simple,
      ).accepts(const TaskAnswer(choice: 'food')),
      isTrue,
    );
    expect(
      LearningScenario.forTask(
        'day_plan',
        LearningDifficulty.simple,
      ).accepts(const TaskAnswer(products: ['feed', 'vet', 'cheap'])),
      isTrue,
    );
    expect(
      LearningScenario.forTask(
        'regular_saving',
        LearningDifficulty.simple,
      ).accepts(const TaskAnswer(needs: 15)),
      isTrue,
    );
    expect(
      LearningScenario.forTask(
        'saving_target',
        LearningDifficulty.simple,
      ).accepts(const TaskAnswer(needs: 5)),
      isTrue,
    );
    expect(
      LearningScenario.forTask(
        'compare_price',
        LearningDifficulty.simple,
      ).accepts(const TaskAnswer(choice: 'a')),
      isTrue,
    );
    expect(
      LearningScenario.forTask(
        'free_paid',
        LearningDifficulty.simple,
      ).accepts(const TaskAnswer(needs: 5)),
      isTrue,
    );
  });

  test('Средняя и сложная ступени меняют числа и ответы', () {
    for (final level in [LearningDifficulty.medium, LearningDifficulty.hard]) {
      expect(
        LearningScenario.forTask('need_first', level).prompt,
        isNot(
          LearningScenario.forTask(
            'need_first',
            LearningDifficulty.simple,
          ).prompt,
        ),
      );
    }
    expect(
      LearningScenario.forTask('day_plan', LearningDifficulty.hard).accepts(
        const TaskAnswer(products: ['feed', 'vet', 'ride', 'expensive']),
      ),
      isTrue,
    );
    expect(
      LearningScenario.forTask(
        'regular_saving',
        LearningDifficulty.hard,
      ).accepts(const TaskAnswer(needs: 40)),
      isTrue,
    );
    expect(
      LearningScenario.forTask(
        'saving_target',
        LearningDifficulty.hard,
      ).accepts(const TaskAnswer(needs: 17)),
      isTrue,
    );
    expect(
      LearningScenario.forTask(
        'compare_price',
        LearningDifficulty.medium,
      ).accepts(const TaskAnswer(choice: 'b')),
      isTrue,
    );
    expect(
      LearningScenario.forTask(
        'free_paid',
        LearningDifficulty.hard,
      ).accepts(const TaskAnswer(needs: 21)),
      isTrue,
    );
  });

  test('Два первых ответа без подсказки повышают только свою тему', () {
    var profile = LearningRules.submit(
      planned,
      catalog,
      catalog.task('day_plan'),
      const TaskAnswer(products: ['feed', 'vet', 'cheap']),
    );
    expect(profile.learningTopic('Планирование').cleanStreak, 1);
    profile = LearningRules.submit(
      profile,
      catalog,
      catalog.task('free_paid'),
      const TaskAnswer(needs: 5),
    );
    expect(
      profile.learningTopic('Планирование').difficulty,
      LearningDifficulty.medium,
    );
    expect(
      profile.learningTopic('Покупки').difficulty,
      LearningDifficulty.simple,
    );
    expect(profile.balance, 124);
  });

  test(
    'Подсказка не уменьшает награду; повтор идёт с новыми числами и без выплаты',
    () {
      final task = catalog.task('saving_target');
      var profile = LearningRules.submit(
        planned,
        catalog,
        task,
        const TaskAnswer(needs: 1),
      );
      expect(profile.feedback, startsWith('Подсказка:'));
      profile = LearningRules.submit(
        profile,
        catalog,
        task,
        const TaskAnswer(needs: 5),
      );
      expect(profile.balance, 112);
      expect(profile.learningTopic('Сбережения').cleanStreak, 0);
      final practice = LearningScenario.forTask(
        task.id,
        LearningDifficulty.simple,
        practice: true,
      );
      expect(
        practice.prompt,
        isNot(
          LearningScenario.forTask(task.id, LearningDifficulty.simple).prompt,
        ),
      );
      profile = LearningRules.submit(
        profile,
        catalog,
        task,
        const TaskAnswer(needs: 4),
      );
      expect(profile.balance, 112);
      expect(profile.transactions, hasLength(1));
    },
  );

  test('После трёх заданий с помощью снижение только предлагается', () {
    var profile = LearningDifficultyRules.choose(
      planned,
      'Покупки',
      LearningDifficulty.medium,
    );
    profile = LearningDifficultyRules.afterTask(
      profile,
      'Покупки',
      clean: false,
    );
    profile = LearningDifficultyRules.afterTask(
      profile,
      'Покупки',
      clean: false,
    );
    profile = LearningDifficultyRules.afterTask(
      profile,
      'Покупки',
      clean: false,
    );
    expect(
      profile.learningTopic('Покупки').difficulty,
      LearningDifficulty.medium,
    );
    expect(profile.learningTopic('Покупки').downgradePending, isTrue);
    profile = LearningDifficultyRules.dismissDowngrade(profile, 'Покупки');
    expect(profile.learningTopic('Покупки').downgradePending, isFalse);
    profile = LearningDifficultyRules.afterTask(
      profile,
      'Покупки',
      clean: false,
    );
    expect(profile.learningTopic('Покупки').downgradePending, isFalse);
  });

  test('Низкая шкала на старте даёт 11, даже если позже восстановилась', () {
    final low = planned.copyWith(satiety: 49, energy: 49);
    final snapshot = ActivityRewardSnapshot.fromProfile(low);
    final recovered = low.copyWith(satiety: 100, energy: 100);
    final result = LearningRules.submit(
      recovered,
      catalog,
      catalog.task('saving_target'),
      const TaskAnswer(needs: 5),
      snapshot: snapshot,
    );
    expect(result.balance, 111);
    expect(result.transactions.single.amount, 11);
    expect(result.transactions.single.startSatiety, 49);
  });

  test('После двух ошибок «Понятно» закрывает задание с той же наградой', () {
    final task = catalog.task('regular_saving');
    var profile = LearningRules.submit(
      planned,
      catalog,
      task,
      const TaskAnswer(needs: 1),
    );
    profile = LearningRules.submit(
      profile,
      catalog,
      task,
      const TaskAnswer(needs: 2),
    );
    expect(profile.taskProgress.single.solutionShown, isTrue);
    expect(profile.balance, 100);
    profile = LearningRules.acknowledge(profile, task);
    expect(profile.balance, 112);
    expect(profile.taskProgress.single.reviewed, isTrue);
    expect(profile.learningTopic('Сбережения').cleanStreak, 0);
  });
}
