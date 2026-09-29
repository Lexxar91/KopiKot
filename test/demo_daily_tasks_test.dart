import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/data/local/local_game_store.dart';
import 'package:kopikot/data/repositories/local_game_repository.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/learning_task.dart';

import 'support/native_isar.dart';

void main() {
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
    taskSource: File('assets/content/tasks.json').readAsStringSync(),
  );
  setUpAll(initializeTestIsar);

  test('Демо: 10000 коткоинов, рост по дням и повтор заданий', () async {
    final directory = await Directory.systemTemp.createTemp('kopikot_demo_');
    final store = await LocalGameStore.open(
      directory: directory.path,
      name: 'demo',
    );
    try {
      final repository = LocalGameRepository(
        store,
        catalog,
        clock: () => DateTime(2026, 9, 29, 12),
      );
      var profile = await repository.startDemo();
      expect(profile.balance, 10000);
      expect(profile.growthLabel, 'Малыш');

      profile = await repository.submitTask(
        'need_first',
        const TaskAnswer(choice: 'food'),
      );
      final afterFirstReward = profile.balance;
      expect(profile.completedTaskToday('need_first'), isTrue);
      expect(profile.completedTask('need_first'), isTrue);
      profile = await repository.submitTask(
        'need_first',
        const TaskAnswer(choice: 'food'),
      );
      expect(profile.balance, afterFirstReward);

      profile = await repository.finishPeriod(1);
      expect(profile.growthLabel, 'Малыш');
      expect(profile.completedTaskToday('need_first'), isFalse);
      expect(profile.completedTask('need_first'), isTrue);
      await repository.confirmBudget(needs: 0, wants: 0, savings: 0);
      profile = await repository.submitTask(
        'need_first',
        const TaskAnswer(choice: 'food'),
      );
      expect(profile.completedTaskToday('need_first'), isTrue);
      expect(
        profile.taskProgress.where((entry) => entry.taskId == 'need_first'),
        hasLength(2),
      );
      expect(
        profile.transactions.where(
          (entry) => entry.referenceId == 'need_first',
        ),
        hasLength(2),
      );

      profile = await repository.finishPeriod(2);
      expect(profile.growthLabel, 'Исследователь');
      await repository.confirmBudget(needs: 0, wants: 0, savings: 0);
      profile = await repository.finishPeriod(3);
      expect(profile.growthLabel, 'Исследователь');
      await repository.confirmBudget(needs: 0, wants: 0, savings: 0);
      profile = await repository.finishPeriod(4);
      expect(profile.growthLabel, 'Опытный друг');
    } finally {
      await store.close();
      await directory.delete(recursive: true);
    }
  });

  test(
    'Обычный профиль: новый календарный день открывает задания снова',
    () async {
      final directory = await Directory.systemTemp.createTemp('kopikot_tasks_');
      final store = await LocalGameStore.open(
        directory: directory.path,
        name: 'tasks',
      );
      try {
        var now = DateTime(2026, 9, 29, 12);
        final repository = LocalGameRepository(
          store,
          catalog,
          clock: () => now,
        );
        await repository.createProfile(
          petName: 'Мурзик',
          coat: PetCoat.grey,
          accessory: PetAccessory.scarf,
        );
        await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
        var profile = await repository.submitTask(
          'need_first',
          const TaskAnswer(choice: 'food'),
        );
        expect(profile.completedTaskToday('need_first'), isTrue);
        now = DateTime(2026, 9, 30, 12);
        profile = (await repository.loadProfile())!;
        expect(profile.period, 2);
        expect(profile.growthLabel, 'Малыш');
        expect(profile.completedTaskToday('need_first'), isFalse);
        expect(profile.completedTask('need_first'), isTrue);
        await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
        profile = await repository.submitTask(
          'need_first',
          const TaskAnswer(choice: 'food'),
        );
        expect(profile.completedTaskToday('need_first'), isTrue);
        expect(
          profile.taskProgress.where((entry) => entry.taskId == 'need_first'),
          hasLength(2),
        );
      } finally {
        await store.close();
        await directory.delete(recursive: true);
      }
    },
  );

  test('Старый демопрофиль получает доплату один раз', () async {
    final directory = await Directory.systemTemp.createTemp('kopikot_upgrade_');
    final store = await LocalGameStore.open(
      directory: directory.path,
      name: 'upgrade',
    );
    try {
      final repository = LocalGameRepository(
        store,
        catalog,
        clock: () => DateTime(2026, 9, 29, 12),
      );
      await repository.startDemo();
      await store.updateProfile(
        (record) => record!
          ..schemaVersion = 8
          ..balance = 1000
          ..plannedBalance = 1000
          ..budgetOpeningBalance = 990,
      );
      final upgraded = (await repository.loadProfile())!;
      expect(upgraded.balance, 10000);
      expect((await repository.loadProfile())!.balance, 10000);
      expect(
        upgraded.transactions.where(
          (entry) => entry.id == 'demo-balance-upgrade',
        ),
        hasLength(1),
      );
    } finally {
      await store.close();
      await directory.delete(recursive: true);
    }
  });
}
