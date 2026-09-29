import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/data/local/local_game_store.dart';
import 'package:kopikot/data/repositories/local_game_repository.dart';
import 'package:kopikot/domain/rules/market_game_rules.dart';

import 'support/native_isar.dart';

void main() {
  setUpAll(initializeTestIsar);

  test('корзина Котомаркета сохраняется, награда не повторяется', () async {
    final directory = await Directory.systemTemp.createTemp('kopikot_market_');
    var store = await LocalGameStore.open(
      directory: directory.path,
      name: 'market',
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
      var profile = await repository.marketAction('saved', MarketAction.start);
      final balance = profile.balance;
      profile = await repository.marketAction(
        'saved',
        MarketAction.toggle,
        itemId: 'food',
      );
      expect(profile.marketSessions.single.selectedIds, ['food']);
      await store.close();

      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'market',
      );
      repository = LocalGameRepository(store, catalog, clock: clock);
      profile = (await repository.loadProfile())!;
      expect(profile.marketSessions.single.selectedIds, ['food']);
      for (final id in ['shampoo', 'toy']) {
        profile = await repository.marketAction(
          'saved',
          MarketAction.toggle,
          itemId: id,
        );
      }
      profile = await repository.marketAction('saved', MarketAction.confirm);
      profile = await repository.marketAction('saved', MarketAction.finish);
      expect(profile.marketSessions.single.completed, isTrue);
      expect(profile.marketSessions.single.paidReward, 6);
      expect(profile.balance, balance + 6);
      profile = await repository.marketAction('saved', MarketAction.finish);
      expect(profile.balance, balance + 6);
    } finally {
      await store.close();
      await directory.delete(recursive: true);
    }
  });
}
