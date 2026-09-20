import '../models/game_profile.dart';

/// Ожидаемый отказ игрового действия с объяснением для игрока.
class GameRuleException implements Exception {
  const GameRuleException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Проверки выполняются повторно внутри транзакции, независимо от формы UI.
abstract final class GameRules {
  static const int startingBalance = 100;

  static String validatePetName(String name) {
    final String result = name.trim();
    if (result.isEmpty || result.runes.length > 20) {
      throw const GameRuleException('Придумай имя от 1 до 20 символов.');
    }
    if (RegExp(r'[\x00-\x1F\x7F]').hasMatch(result)) {
      throw const GameRuleException('Напиши имя питомца в одну строку.');
    }
    return result;
  }

  static BudgetPlan confirmBudget(
    GameProfile profile, {
    required int needs,
    required int wants,
    required int savings,
  }) {
    if (profile.plan != null) {
      throw const GameRuleException(
        'План уже подтверждён. Новый составим в следующем периоде.',
      );
    }
    if (needs < 0 || wants < 0 || savings < 0) {
      throw const GameRuleException(
        'В каждой части плана должно быть 0 или больше монет.',
      );
    }
    if (needs + wants + savings > profile.balance) {
      throw const GameRuleException(
        'Монет не хватает на такой план. Уменьши одну из сумм.',
      );
    }
    return BudgetPlan(
      availableAtConfirmation: profile.balance,
      needs: needs,
      wants: wants,
      savings: savings,
    );
  }
}
