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
    int kept = 0,
    int expectedIncome = 0,
    List<String> sourceIds = const [],
  }) {
    if (profile.plan != null) {
      throw const GameRuleException(
        'План уже подтверждён. Его можно пересмотреть или составить новый завтра.',
      );
    }
    return _budgetPlan(
      openingBalance: openingBalance(profile),
      needs: needs,
      wants: wants,
      savings: savings,
      gifts: gifts,
      kept: kept,
      expectedIncome: expectedIncome,
      sourceIds: sourceIds,
    );
  }

  /// Доход, уже полученный в текущем периоде, не входит в начальный кошелёк.
  static int openingBalance(GameProfile profile) {
    final received = profile.transactions
        .where(
          (entry) =>
              entry.period == profile.period &&
              entry.kind == TransactionKind.income &&
              entry.id != 'initial-income' &&
              !entry.id.startsWith('period-income-'),
        )
        .fold<int>(0, (sum, entry) => sum + entry.amount);
    return profile.balance - received;
  }

  static GameProfile reviseBudget(
    GameProfile profile, {
    required int needs,
    required int wants,
    required int savings,
    int gifts = 0,
    int kept = 0,
    int expectedIncome = 0,
    List<String> sourceIds = const [],
  }) {
    final old = profile.plan;
    if (old == null) {
      throw const GameRuleException('Сначала сохрани первый план.');
    }
    final revised = _budgetPlan(
      openingBalance: old.openingBalance,
      needs: needs,
      wants: wants,
      savings: savings,
      gifts: gifts,
      kept: kept,
      expectedIncome: expectedIncome,
      sourceIds: sourceIds,
    );
    return profile.copyWith(
      plan: revised,
      budgetRevisions: [
        ...profile.budgetRevisions,
        BudgetRevision(period: profile.period, plan: old),
      ],
    );
  }

  static BudgetPlan _budgetPlan({
    required int openingBalance,
    required int needs,
    required int wants,
    required int savings,
    required int gifts,
    required int kept,
    required int expectedIncome,
    required List<String> sourceIds,
  }) {
    if (needs < 0 ||
        wants < 0 ||
        gifts < 0 ||
        savings < 0 ||
        kept < 0 ||
        expectedIncome < 0) {
      throw const GameRuleException(
        'В каждой части плана должно быть 0 или больше монет.',
      );
    }
    if (sourceIds.toSet().length != sourceIds.length) {
      throw const GameRuleException(
        'Один источник дохода нельзя выбрать дважды.',
      );
    }
    final available = openingBalance + expectedIncome;
    if (needs + wants + gifts + savings + kept > available) {
      throw const GameRuleException(
        'Монет не хватает на такой план. Уменьши одну из сумм.',
      );
    }
    return BudgetPlan(
      availableAtConfirmation: available,
      openingBalance: openingBalance,
      expectedIncome: expectedIncome,
      needs: needs,
      wants: wants,
      savings: savings,
      gifts: gifts,
      kept: kept,
      sourceIds: List.unmodifiable(sourceIds),
    );
  }
}
