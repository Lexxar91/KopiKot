import '../models/game_catalog.dart';
import '../models/game_profile.dart';
import '../models/game_transaction.dart';
import 'game_rules.dart';

/// Чистые правила покупок и накоплений. Повтор команды не меняет баланс.
abstract final class EconomyRules {
  static GameProfile purchase(
    GameProfile profile,
    ShopProduct product,
    String commandId,
  ) {
    final kind = product.category == ExpenseCategory.needs
        ? TransactionKind.needPurchase
        : TransactionKind.wantPurchase;
    if (_isReplay(profile, commandId, kind, product.id, product.price)) {
      return profile;
    }
    _requirePlan(profile);
    _requirePositive(product.price);
    _requireBalance(profile, product.price);
    final int satiety = (profile.satiety + product.satiety).clamp(0, 100);
    final int mood = (profile.mood + product.mood).clamp(0, 100);
    final String effect =
        'Сытость: ${profile.satiety} → $satiety. '
        'Настроение: ${profile.mood} → $mood.';
    final int spent = product.category == ExpenseCategory.needs
        ? profile.actualNeeds
        : profile.actualWants;
    final int planned = product.category == ExpenseCategory.needs
        ? profile.plan!.needs
        : profile.plan!.wants;
    final String next = spent + product.price > planned
        ? 'По этой категории потрачено больше плана. Следующую покупку можно перенести.'
        : 'Сверь оставшиеся монеты с планом.';
    return _record(
      profile,
      commandId,
      kind,
      product.price,
      product.title,
      product.id,
      profile.copyWith(
        balance: profile.balance - product.price,
        satiety: satiety,
        mood: mood,
        feedback: '${product.title}: −${product.price} монет. $effect $next',
      ),
    );
  }

  static GameProfile selectGoal(
    GameProfile profile,
    GoalDefinition goal,
  ) => profile.copyWith(
    selectedGoalId: goal.id,
    feedback:
        'Мечта — ${goal.title}. Нужно ${goal.price} монет. '
        'На эту цель отложено ${profile.savedFor(goal.id)}. Накопления на другие цели сохранены.',
  );

  static GameProfile transfer(
    GameProfile profile,
    GoalDefinition goal,
    int amount, {
    required String commandId,
    required bool withdraw,
  }) {
    final kind = withdraw
        ? TransactionKind.withdrawal
        : TransactionKind.deposit;
    if (_isReplay(profile, commandId, kind, goal.id, amount)) return profile;
    _requirePlan(profile);
    _requirePositive(amount);
    if (profile.selectedGoalId != goal.id) {
      throw const GameRuleException(
        'Цель изменилась. Открой её заново перед переводом.',
      );
    }
    final int saved = profile.savedFor(goal.id);
    if (withdraw && amount > saved) {
      throw GameRuleException(
        'На этой цели только $saved монет. Уменьши сумму снятия.',
      );
    }
    if (!withdraw) {
      _requireBalance(profile, amount);
      if (saved + amount > goal.price) {
        throw GameRuleException(
          'До этой цели осталось ${goal.price - saved} монет. Уменьши перевод.',
        );
      }
    }
    final int delta = withdraw ? -amount : amount;
    final int after = saved + delta;
    final String feedback = withdraw
        ? 'Взяли $amount монет с цели «${goal.title}». Осталось $after из ${goal.price}. '
              'Баланс вырос на $amount; до цели теперь ${goal.price - after} монет. '
              'Настроение и сытость не изменились.'
        : 'Отложили $amount монет на «${goal.title}». Теперь $after из ${goal.price}. '
              'На балансе стало на $amount меньше. Настроение и сытость не изменились. '
              '${after == goal.price ? 'Цель достигнута!' : 'Даже небольшие переводы приближают мечту.'}';
    return _record(
      profile,
      commandId,
      kind,
      amount,
      '${withdraw ? 'Снятие' : 'Пополнение'}: ${goal.title}',
      goal.id,
      profile.copyWith(
        balance: profile.balance - delta,
        savings: profile.savings + delta,
        goalSavings: {...profile.goalSavings, goal.id: after},
        feedback: feedback,
      ),
    );
  }

  static void _requirePlan(GameProfile profile) {
    if (profile.plan == null) {
      throw const GameRuleException(
        'Сначала составь и подтверди бюджет этого периода.',
      );
    }
  }

  static void _requirePositive(int amount) {
    if (amount <= 0) {
      throw const GameRuleException('Укажи хотя бы одну монету.');
    }
  }

  static void _requireBalance(GameProfile profile, int amount) {
    if (amount > profile.balance) {
      throw GameRuleException(
        'Не хватает ${amount - profile.balance} монет. '
        'Выбери покупку дешевле, перенеси её или верни часть накоплений с подтверждением.',
      );
    }
  }

  static bool _isReplay(
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

  static GameProfile _record(
    GameProfile before,
    String id,
    TransactionKind kind,
    int amount,
    String label,
    String reference,
    GameProfile after,
  ) => after.copyWith(
    transactions: [
      ...before.transactions,
      GameTransaction(
        id: id,
        period: before.period,
        kind: kind,
        amount: amount,
        label: label,
        referenceId: reference,
        balanceAfter: after.balance,
        savingsAfter: after.savings,
        satietyAfter: after.satiety,
        moodAfter: after.mood,
      ),
    ],
  );
}
