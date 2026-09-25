import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/game_transaction.dart';
import 'package:kopikot/domain/rules/mini_game_rules.dart';

GameProfile profile({int satiety = 70, int energy = 70, int mood = 70}) =>
    GameProfile(
      petName: 'Финни',
      coat: PetCoat.ginger,
      accessory: null,
      balance: 50,
      savings: 0,
      period: 1,
      satiety: satiety,
      energy: energy,
      mood: mood,
      incomeSource: 'Начало',
      incomeAmount: 50,
    );

void main() {
  test('хорошее состояние даёт небольшой бонус и сохраняет доход', () {
    final updated = MiniGameRules.claim(
      profile(),
      MiniGameKind.accountant,
      'first',
    );

    expect(updated.balance, 62);
    expect(updated.transactions.single.kind, TransactionKind.income);
    expect(updated.transactions.single.referenceId, 'accountant');
    expect(updated.transactions.single.amount, 12);
  });

  test('низкая шкала только уменьшает новую награду', () {
    final updated = MiniGameRules.claim(
      profile(energy: 30),
      MiniGameKind.kotomarket,
      'second',
    );

    expect(updated.balance, 58);
    expect(updated.transactions.single.amount, 8);
  });

  test(
    'одну команду нельзя начислить дважды, новую игру можно пройти снова',
    () {
      final first = MiniGameRules.claim(
        profile(mood: 50),
        MiniGameKind.accountant,
        'same',
      );
      final repeated = MiniGameRules.claim(
        first,
        MiniGameKind.accountant,
        'same',
      );
      final next = MiniGameRules.claim(
        repeated,
        MiniGameKind.accountant,
        'new',
      );

      expect(repeated.balance, first.balance);
      expect(repeated.transactions, hasLength(1));
      expect(next.balance, 70);
      expect(next.transactions, hasLength(2));
    },
  );
}
