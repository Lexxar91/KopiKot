import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/data/local/local_game_store.dart';
import 'package:kopikot/data/repositories/local_game_repository.dart';
import 'package:kopikot/domain/models/day_financial_report.dart';
import 'package:kopikot/domain/models/game_profile.dart';

import 'support/native_isar.dart';

void main() {
  setUpAll(initializeTestIsar);

  test(
    'Закрытый день, прогноз и доступ к целям переживают перезапуск',
    () async {
      final directory = await Directory.systemTemp.createTemp('kopikot_day_');
      final catalog = parseGameCatalog(
        File('assets/content/catalog.json').readAsStringSync(),
        taskSource: File('assets/content/tasks.json').readAsStringSync(),
      );
      var now = DateTime(2026, 9, 28, 12);
      var store = await LocalGameStore.open(
        directory: directory.path,
        name: 'day',
      );
      try {
        var repository = LocalGameRepository(store, catalog, clock: () => now);
        final created = await repository.createProfile(
          petName: 'Мурзик',
          coat: PetCoat.grey,
          accessory: PetAccessory.scarf,
        );
        expect(created.balance, 110);
        expect(created.goalChoicesUnlocked, isFalse);
        await repository.confirmBudget(needs: 50, wants: 20, savings: 30);

        now = DateTime(2026, 9, 29, 12);
        await store.close();
        store = await LocalGameStore.open(
          directory: directory.path,
          name: 'day',
        );
        repository = LocalGameRepository(store, catalog, clock: () => now);
        var profile = (await repository.loadProfile())!;
        expect(profile.period, 2);
        expect(profile.balance, 122);
        expect(profile.plan, isNull);
        expect(profile.periodSummaries.single.plannedIncome, 0);
        final report = DayFinancialReport.fromProfile(profile, 1);
        expect(report.openingWallet, 100);
        expect(report.income, 10);
        expect(report.closingWallet, 110);

        await store.updateProfile(
          (record) => record!..goalChoicesUnlocked = true,
        );
        await store.close();
        store = await LocalGameStore.open(
          directory: directory.path,
          name: 'day',
        );
        repository = LocalGameRepository(store, catalog, clock: () => now);
        profile = (await repository.loadProfile())!;
        expect(profile.goalChoicesUnlocked, isTrue);
      } finally {
        await store.close();
        await directory.delete(recursive: true);
      }
    },
  );

  test('Время шкал и дата осмотра сохраняются между запусками', () async {
    final directory = await Directory.systemTemp.createTemp('kopikot_vitals_');
    final catalog = parseGameCatalog(
      File('assets/content/catalog.json').readAsStringSync(),
      taskSource: File('assets/content/tasks.json').readAsStringSync(),
    );
    var now = DateTime(2026, 9, 1, 12);
    var store = await LocalGameStore.open(
      directory: directory.path,
      name: 'vitals',
    );
    try {
      var repository = LocalGameRepository(store, catalog, clock: () => now);
      await repository.createProfile(
        petName: 'Мурзик',
        coat: PetCoat.grey,
        accessory: PetAccessory.scarf,
      );
      await repository.confirmBudget(needs: 50, wants: 0, savings: 0);
      now = now.add(const Duration(hours: 2));
      var profile = (await repository.loadProfile())!;
      expect(profile.energy, 64);
      expect(profile.satiety, 64);
      expect(profile.mood, 64);

      await store.close();
      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'vitals',
      );
      repository = LocalGameRepository(store, catalog, clock: () => now);
      profile = (await repository.loadProfile())!;
      expect(profile.energy, 64);

      await repository.purchase('vet_checkup', commandId: 'checkup-1');
      expect((await store.readProfile())!.lastVetCheckupAt, now);
      now = now.add(const Duration(hours: 1));
      profile = (await repository.loadProfile())!;
      expect(profile.energy, 61);
    } finally {
      await store.close();
      await directory.delete(recursive: true);
    }
  });
}
