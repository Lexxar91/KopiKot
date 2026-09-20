import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/rules/game_rules.dart';

const initialProfile = GameProfile(
  petName: 'Финни',
  coat: PetCoat.ginger,
  accessory: PetAccessory.scarf,
  balance: 100,
  savings: 0,
  period: 1,
  satiety: 70,
  mood: 70,
  incomeSource: 'Подарок на знакомство',
  incomeAmount: 100,
);

void main() {
  test('План учитывает остаток и не списывает баланс', () {
    final BudgetPlan plan = GameRules.confirmBudget(
      initialProfile,
      needs: 50,
      wants: 20,
      savings: 10,
    );
    expect(plan.remaining, 20);
    expect(initialProfile.balance, 100);
    expect(initialProfile.savings, 0);
  });

  test('Перерасход и отрицательные суммы отклоняются', () {
    for (final amounts in [
      [101, 0, 0],
      [50, 40, 20],
      [-1, 0, 0],
      [0, -1, 0],
      [0, 0, -1],
    ]) {
      expect(
        () => GameRules.confirmBudget(
          initialProfile,
          needs: amounts[0],
          wants: amounts[1],
          savings: amounts[2],
        ),
        throwsA(isA<GameRuleException>()),
      );
    }
  });

  test('Нулевые желаемые расходы допустимы', () {
    final plan = GameRules.confirmBudget(
      initialProfile,
      needs: 60,
      wants: 0,
      savings: 40,
    );
    expect(plan.remaining, 0);
  });

  test('Подтверждённый план нельзя переписать', () {
    final plan = GameRules.confirmBudget(
      initialProfile,
      needs: 60,
      wants: 0,
      savings: 40,
    );
    expect(
      () => GameRules.confirmBudget(
        initialProfile.withPlan(plan),
        needs: 20,
        wants: 80,
        savings: 0,
      ),
      throwsA(isA<GameRuleException>()),
    );
  });

  test('Имя очищается, пустое и слишком длинное отклоняются', () {
    expect(GameRules.validatePetName('  Финни  '), 'Финни');
    for (final name in [' ', 'я' * 21, 'Фин\nни']) {
      expect(
        () => GameRules.validatePetName(name),
        throwsA(isA<GameRuleException>()),
      );
    }
  });
}
