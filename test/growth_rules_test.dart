import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/data/local/local_game_store.dart';
import 'package:kopikot/data/local/profile_record.dart';
import 'package:kopikot/data/repositories/local_game_repository.dart';
import 'package:kopikot/domain/models/period_summary.dart';
import 'package:kopikot/domain/rules/growth_rules.dart';

import 'game_rules_test.dart' show initialProfile;
import 'support/native_isar.dart';

PeriodSummary closedDay(
  int period, {
  bool needsMet = true,
  bool withinPlan = true,
  bool savedRegularly = true,
}) => PeriodSummary(
  period: period,
  plannedNeeds: 15,
  plannedWants: 5,
  plannedSavings: 10,
  actualNeeds: needsMet ? 15 : 0,
  actualWants: withinPlan ? 5 : 10,
  netSaved: savedRegularly ? 10 : 0,
  needsMet: needsMet,
  withinPlan: withinPlan,
  savedRegularly: savedRegularly,
  explanation: '',
);

void main() {
  test('До закрытия двух подходящих периодов роста нет', () {
    final profile = initialProfile.copyWith(
      savings: 200,
      bestDayIncome: 80,
      periodSummaries: [closedDay(1)],
    );
    final result = GrowthRules.refresh(profile);
    expect(result.growthStage, 1);
    expect(result.growthLabel, 'Малыш');
    expect(GrowthRules.nextStep(result), contains('стадии: 1'));
  });

  test('Каждый период требует нужное, соответствие плану и накопления', () {
    final profile = initialProfile.copyWith(
      periodSummaries: [
        closedDay(1),
        closedDay(2, needsMet: false),
        closedDay(3, withinPlan: false),
        closedDay(4, savedRegularly: false),
      ],
    );
    expect(GrowthRules.qualifyingPeriods(profile), 1);
    expect(GrowthRules.refresh(profile).growthStage, 1);
  });

  test('После двух и четырёх подходящих периодов открываются стадии', () {
    for (final (count, stage, label) in [
      (1, 1, 'Малыш'),
      (2, 2, 'Исследователь'),
      (3, 2, 'Исследователь'),
      (4, 3, 'Опытный друг'),
      (5, 3, 'Опытный друг'),
    ]) {
      final profile = GrowthRules.refresh(
        initialProfile.copyWith(
          periodSummaries: [
            for (var day = 1; day <= count; day++) closedDay(day),
          ],
        ),
      );
      expect(profile.growthStage, stage);
      expect(profile.growthLabel, label);
    }
  });

  test('Старый доходный рубеж не сохраняет прежнюю стадию', () {
    final legacy = initialProfile.copyWith(
      unlockedGrowthStage: 4,
      savings: 200,
      bestDayIncome: 80,
    );
    final migrated = GrowthRules.refresh(legacy);
    expect(migrated.growthStage, 1);
    expect(migrated.growthMilestones, isEmpty);
  });

  setUpAll(initializeTestIsar);

  test(
    'Рост по закрытым периодам сохраняется в Isar после перезапуска',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'kopikot_growth_',
      );
      var store = await LocalGameStore.open(
        directory: directory.path,
        name: 'growth',
      );
      try {
        var repository = LocalGameRepository(
          store,
          parseGameCatalog(
            File('assets/content/catalog.json').readAsStringSync(),
            taskSource: File('assets/content/tasks.json').readAsStringSync(),
          ),
        );
        await repository.switchProfile(testProfile: true);
        await store.updateProfile(
          (current) => current!
            ..periodSummaries = [
              for (var day = 1; day <= 2; day++)
                PeriodSummaryRecord()
                  ..period = day
                  ..needsMet = true
                  ..withinPlan = true
                  ..savedRegularly = true
                  ..explanation = '',
            ],
        );
        var profile = (await repository.loadProfile())!;
        expect(profile.growthStage, 2);
        expect(profile.feedback, contains('Исследователь'));
        await store.close();
        store = await LocalGameStore.open(
          directory: directory.path,
          name: 'growth',
        );
        repository = LocalGameRepository(store, repository.catalog);
        profile = (await repository.loadProfile())!;
        expect(profile.growthStage, 2);
        expect(GrowthRules.qualifyingPeriods(profile), 2);
      } finally {
        await store.close();
        await directory.delete(recursive: true);
      }
    },
  );

  test('Схема 5 переходит на актуальные стадии без потери баланса', () async {
    final directory = await Directory.systemTemp.createTemp(
      'kopikot_growth_migrate_',
    );
    final store = await LocalGameStore.open(
      directory: directory.path,
      name: 'growth_migrate',
    );
    try {
      final catalog = parseGameCatalog(
        File('assets/content/catalog.json').readAsStringSync(),
        taskSource: File('assets/content/tasks.json').readAsStringSync(),
      );
      final repository = LocalGameRepository(store, catalog);
      final before = (await repository.switchProfile(testProfile: true))!;
      await store.updateProfile((current) => current!..schemaVersion = 5);
      final after = (await repository.loadProfile())!;
      expect(after.balance, before.balance);
      expect(after.growthStage, 1);
      expect((await store.readProfile())!.schemaVersion, 8);
    } finally {
      await store.close();
      await directory.delete(recursive: true);
    }
  });
}
