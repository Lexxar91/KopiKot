import '../models/game_profile.dart';
import '../models/game_transaction.dart';

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

  /// Повтор команды с теми же параметрами безопасен; с другими — ошибка.
  static bool isReplay(
    GameProfile profile,
    String id,
    TransactionKind kind,
    String reference,
    int amount,
  ) {
    if (id.trim().isEmpty || id.length > 128) {
      throw const GameRuleException(
        'Не удалось распознать действие. Повтори его.',
      );
    }
    for (final entry in profile.transactions) {
      if (entry.id != id) continue;
      if (entry.kind != kind ||
          entry.referenceId != reference ||
          entry.amount != amount) {
        throw const GameRuleException(
          'Это действие уже сохранено с другими параметрами. Открой раздел заново.',
        );
      }
      return true;
    }
    return false;
  }

  /// Траты и переводы возможны только после подтверждённого плана периода.
  static void requirePlan(GameProfile profile) {
    if (profile.plan == null) {
      throw const GameRuleException(
        'Сначала составь и подтверди бюджет этого периода.',
      );
    }
  }

  static void requirePositive(int amount) {
    if (amount <= 0) {
      throw const GameRuleException('Укажи хотя бы одну монету.');
    }
  }

  static void requireBalance(GameProfile profile, int amount) {
    if (amount > profile.balance) {
      throw GameRuleException(
        'Не хватает ${amount - profile.balance} монет. '
        'Выбери покупку дешевле, перенеси её или верни часть накоплений с подтверждением.',
      );
    }
  }

  static BudgetPlan confirmBudget(
    GameProfile profile, {
    required int needs,
    required int wants,
    required int savings,
    int gifts = 0,
  }) {
    if (profile.plan != null) {
      throw const GameRuleException(
        'План уже подтверждён. Новый составим в следующем периоде.',
      );
    }
    if (needs < 0 || wants < 0 || gifts < 0 || savings < 0) {
      throw const GameRuleException(
        'В каждой части плана должно быть 0 или больше монет.',
      );
    }
    if (needs + wants + gifts + savings > profile.balance) {
      throw const GameRuleException(
        'Монет не хватает на такой план. Уменьши одну из сумм.',
      );
    }
    return BudgetPlan(
      availableAtConfirmation: profile.balance,
      needs: needs,
      wants: wants,
      savings: savings,
      gifts: gifts,
    );
  }
}
