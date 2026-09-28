import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/models/learning_task.dart';
import 'package:kopikot/domain/rules/activity_reward_rules.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/domain/rules/learning_rules.dart';

import 'game_rules_test.dart' show initialProfile;

void main() {
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
    taskSource: File('assets/content/tasks.json').readAsStringSync(),
  );
  final task = catalog.task('saving_start');

  test('ошибка и повтор не уменьшают награду задания', () {
    var profile = initialProfile.withPlan(
      GameRules.confirmBudget(
        initialProfile,
        needs: 50,
        wants: 20,
        savings: 30,
      ),
    );
    final snapshot = ActivityRewardSnapshot.fromProfile(profile);
    profile = LearningRules.submit(
      profile,
      catalog,
      task,
      const TaskAnswer(),
      snapshot: snapshot,
    );
    expect(profile.balance, 100);
    profile = LearningRules.submit(
      profile,
      catalog,
      task,
      const TaskAnswer(savings: 10),
      snapshot: snapshot,
    );
    expect(profile.balance, 112);
    expect(profile.transactions.single.baseReward, 12);
    final repeated = LearningRules.submit(
      profile,
      catalog,
      task,
      const TaskAnswer(savings: 10),
    );
    expect(repeated.balance, 112);
    expect(repeated.transactions, hasLength(1));
  });

  test('снимок низкой шкалы фиксирует 11 даже после восстановления', () {
    final start = initialProfile.copyWith(satiety: 49, energy: 49);
    final planned = start.withPlan(
      GameRules.confirmBudget(start, needs: 50, wants: 20, savings: 30),
    );
    final snapshot = ActivityRewardSnapshot.fromProfile(planned);
    final recovered = planned.copyWith(satiety: 100, energy: 100);
    final finished = LearningRules.submit(
      recovered,
      catalog,
      task,
      const TaskAnswer(savings: 10),
      snapshot: snapshot,
    );
    expect(finished.balance, 111);
    expect(finished.transactions.single.startSatiety, 49);
    expect(finished.transactions.single.startEnergy, 49);
    expect(finished.transactions.single.amount, 11);
    expect(finished.feedback, contains('Уменьшение только на 1'));
  });

  test('порог 50 включён в полную выплату', () {
    final normal = initialProfile.copyWith(satiety: 50, energy: 50);
    expect(ActivityRewardSnapshot.fromProfile(normal).taskReward, 12);
    final low = initialProfile.copyWith(satiety: 49, energy: 50);
    expect(ActivityRewardSnapshot.fromProfile(low).taskReward, 11);
  });

  test('первая ошибка даёт подсказку, вторая разбор, «Понятно» — награду', () {
    var profile = initialProfile.withPlan(
      GameRules.confirmBudget(
        initialProfile,
        needs: 50,
        wants: 20,
        savings: 30,
      ),
    );
    final snapshot = ActivityRewardSnapshot.fromProfile(profile);
    profile = LearningRules.submit(
      profile,
      catalog,
      task,
      const TaskAnswer(),
      snapshot: snapshot,
    );
    expect(profile.taskProgress.single.attempts, 1);
    expect(profile.taskProgress.single.hintUsed, isTrue);
    expect(profile.taskProgress.single.solutionShown, isFalse);
    expect(profile.feedback, startsWith('Подсказка:'));
    profile = LearningRules.submit(
      profile,
      catalog,
      task,
      const TaskAnswer(),
      snapshot: snapshot,
    );
    expect(profile.taskProgress.single.attempts, 2);
    expect(profile.taskProgress.single.solutionShown, isTrue);
    expect(profile.feedback, contains('Разбор по шагам:'));
    expect(profile.balance, 100);

    profile = LearningRules.acknowledge(profile, task, snapshot: snapshot);
    expect(profile.balance, 112);
    expect(profile.taskProgress.single.completed, isTrue);
    expect(profile.taskProgress.single.reviewed, isTrue);
    expect(profile.taskProgress.single.attempts, 2);
    expect(profile.transactions, hasLength(1));
    expect(LearningRules.acknowledge(profile, task).balance, 112);
  });
}
