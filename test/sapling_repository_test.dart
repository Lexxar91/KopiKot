import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/data/local/local_game_store.dart';
import 'package:kopikot/data/repositories/local_game_repository.dart';

import 'support/native_isar.dart';

void main() {
  setUpAll(initializeTestIsar);

  test('дата посадки сохраняется после перезапуска', () async {
    final directory = await Directory.systemTemp.createTemp('kopikot_tree_');
    var store = await LocalGameStore.open(
      directory: directory.path,
      name: 'tree',
    );
    final catalog = parseGameCatalog(
      File('assets/content/catalog.json').readAsStringSync(),
      taskSource: File('assets/content/tasks.json').readAsStringSync(),
    );
    DateTime clock() => DateTime(2026, 9, 28, 12);
    try {
      var repository = LocalGameRepository(store, catalog, clock: clock);
      await repository.switchProfile(testProfile: true);
      await repository.reviseBudget(needs: 40, wants: 20, savings: 10);
      var profile = await repository.plantSapling('sapling_5', 'seed');
      expect(profile.saplings.single.plantedDayKey, '2026-09-28');
      expect(profile.transactions.last.amount, 20);
      await store.close();

      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'tree',
      );
      repository = LocalGameRepository(store, catalog, clock: clock);
      profile = (await repository.loadProfile())!;
      expect(profile.saplings.single.plantedDayKey, '2026-09-28');
      expect(profile.saplings.single.definitionId, 'sapling_5');
    } finally {
      await store.close();
      await directory.delete(recursive: true);
    }
  });
}
