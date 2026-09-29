import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/data/local/local_game_store.dart';
import 'package:kopikot/data/repositories/local_game_repository.dart';
import 'package:kopikot/domain/models/game_profile.dart';

import 'support/native_isar.dart';

void main() {
  setUpAll(initializeTestIsar);

  test('Демо даёт 1000, открывает цели и не меняет обычный профиль', () async {
    final directory = await Directory.systemTemp.createTemp('kopikot_demo_');
    final store = await LocalGameStore.open(
      directory: directory.path,
      name: 'demo',
    );
    final catalog = parseGameCatalog(
      File('assets/content/catalog.json').readAsStringSync(),
      taskSource: File('assets/content/tasks.json').readAsStringSync(),
    );
    final repository = LocalGameRepository(
      store,
      catalog,
      clock: () => DateTime(2026, 9, 28, 12),
    );
    try {
      final normal = await repository.createProfile(
        petName: 'Барсик',
        coat: PetCoat.grey,
        accessory: PetAccessory.scarf,
      );
      final demo = await repository.startDemo();
      expect(demo.isTest, isTrue);
      expect(demo.balance, 1000);
      expect(demo.goalChoicesUnlocked, isTrue);
      expect(demo.plan, isNotNull);

      final next = await repository.finishPeriod(demo.period);
      expect(next.period, 2);
      final restored = (await repository.switchProfile(testProfile: false))!;
      expect(restored.petName, normal.petName);
      expect(restored.balance, normal.balance);
      expect(restored.isTest, isFalse);

      final restarted = await repository.startDemo();
      expect(restarted.balance, 1000);
      expect(restarted.period, 1);
    } finally {
      await store.close();
      await directory.delete(recursive: true);
    }
  });
}
