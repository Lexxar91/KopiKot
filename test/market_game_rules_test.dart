import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/rules/market_game_rules.dart';

void main() {
  test('нужное сначала оставляет 35 коткоинов учебного бюджета', () {
    final selection = ['food', 'shampoo'];
    final result = MarketGameRules.evaluate(selection);

    expect(result.canClaim, isTrue);
    expect(result.spent, 25);
    expect(result.remaining, 35);
    expect(selection, ['food', 'shampoo']);
  });

  test('игрушка до нужного даёт подсказку, но выбор можно исправить', () {
    final selection = ['toy', 'food', 'shampoo'];
    expect(MarketGameRules.evaluate(selection).canClaim, isFalse);

    selection.remove('toy');
    selection.add('toy');
    final result = MarketGameRules.evaluate(selection);
    expect(result.canClaim, isTrue);
    expect(result.spent, 45);
    expect(result.remaining, 15);
  });

  test('без обязательного товара завершить игру нельзя', () {
    final result = MarketGameRules.evaluate(['food', 'toy']);
    expect(result.canClaim, isFalse);
    expect(result.message, contains('шампунь'));
  });
}
