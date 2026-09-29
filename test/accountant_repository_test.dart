import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/data/local/local_game_store.dart';
import 'package:kopikot/data/repositories/local_game_repository.dart';
import 'package:kopikot/domain/rules/accountant_rules.dart';

import 'support/native_isar.dart';

void main() {
  setUpAll(initializeTestIsar);

  test('Ответы и награда Бухгалтера сохраняются после перезапуска', () async {
    final directory = await Directory.systemTemp.createTemp(
      'kopikot_accountant_',
    );
    var store = await LocalGameStore.open(
      directory: directory.path,
      name: 'accountant',
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
      var profile = await repository.accountantAction(
        'persist',
        AccountantAction.start,
      );
      final balance = profile.balance;
      final question = profile.accountantSessions.single.questions.first;
      final wrong = question.choices.firstWhere(
        (answer) => !question.isCorrect(answer),
      );
      profile = await repository.accountantAction(
        'persist',
        AccountantAction.answer,
        answer: wrong,
      );
      expect(profile.accountantSessions.single.progress.first.answers, [wrong]);
      await store.close();

      store = await LocalGameStore.open(
        directory: directory.path,
        name: 'accountant',
      );
      repository = LocalGameRepository(store, catalog, clock: clock);
      profile = (await repository.loadProfile())!;
      expect(profile.accountantSessions.single.progress.first.answers, [wrong]);
      profile = await repository.accountantAction(
        'persist',
        AccountantAction.answer,
        answer: question.correctChange,
      );
      final second = profile.accountantSessions.single.questions.last;
      profile = await repository.accountantAction(
        'persist',
        AccountantAction.answer,
        answer: second.correctChange,
      );
      profile = await repository.accountantAction(
        'persist',
        AccountantAction.finish,
      );
      expect(profile.accountantSessions.single.completed, isTrue);
      expect(profile.accountantSessions.single.paidReward, 6);
      expect(profile.balance, balance + 6);
      profile = await repository.accountantAction(
        'persist',
        AccountantAction.finish,
      );
      expect(profile.balance, balance + 6);
    } finally {
      await store.close();
      await directory.delete(recursive: true);
    }
  });
}
