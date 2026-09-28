import '../models/game_catalog.dart';
import '../models/game_profile.dart';
import '../models/game_transaction.dart';
import 'game_rules.dart';
import 'period_rules.dart';

/// Одно дерево: 20 за посадку, 30 при раннем сборе, 50 через пять дней.
abstract final class SaplingRules {
  static bool harvestedToday(GameProfile profile) => profile.transactions.any(
    (entry) =>
        entry.period == profile.period &&
        entry.kind == TransactionKind.income &&
        entry.label.startsWith('Урожай:'),
  );

  static int elapsedDays(GameProfile profile, SaplingState state) {
    final planted = state.plantedDayKey;
    final today = profile.dayKey;
    if (planted != null && today != null) {
      return PeriodRules.daysBetween(planted, today).clamp(0, 100000);
    }
    return (profile.period - state.plantedPeriod).clamp(0, 100000);
  }

  static String maturityDayKey(String plantedDayKey, int term) {
    final parts = plantedDayKey.split('-').map(int.parse).toList();
    return PeriodRules.dayKey(
      DateTime(parts[0], parts[1], parts[2] + term, 12),
    );
  }

  static GameProfile plant(
    GameProfile profile,
    SaplingDefinition sapling,
    String commandId,
  ) {
    if (GameRules.isReplay(
      profile,
      commandId,
      TransactionKind.saplingPurchase,
      sapling.id,
      sapling.price,
    )) {
      return profile;
    }
    if (sapling.id != 'sapling_5') {
      throw const GameRuleException('Этот вид саженца больше не продаётся.');
    }
    if (profile.saplings.isNotEmpty) {
      throw const GameRuleException('Сначала собери урожай текущего дерева.');
    }
    if (harvestedToday(profile)) {
      throw const GameRuleException('Новое деревце можно посадить завтра.');
    }
    GameRules.requirePlan(profile);
    GameRules.requirePositive(sapling.price);
    GameRules.requireBalance(profile, sapling.price);
    final int balance = profile.balance - sapling.price;
    final SaplingState state = SaplingState(
      id: commandId,
      definitionId: sapling.id,
      plantedPeriod: profile.period,
      plantedDayKey: profile.dayKey,
    );
    final GameProfile planted = profile.copyWith(
      balance: balance,
      saplings: [...profile.saplings, state],
      feedback:
          'Саженец «${sapling.title}» посажен: −${sapling.price} монет. '
          'Собрать раньше можно за 30 коткоинов. '
          'Через ${sapling.term} полных игровых дней придёт ${sapling.reward}. '
          'Сытость и радость не изменились.',
    );
    return planted.copyWith(
      transactions: [
        ...planted.transactions,
        GameTransaction(
          id: commandId,
          period: profile.period,
          kind: TransactionKind.saplingPurchase,
          amount: sapling.price,
          label: 'Посадка: ${sapling.title}',
          referenceId: sapling.id,
          balanceAfter: balance,
          savingsAfter: profile.savings,
          satietyAfter: profile.satiety,
          moodAfter: profile.mood,
        ),
      ],
    );
  }

  static GameProfile harvest(
    GameProfile profile,
    SaplingState state,
    SaplingDefinition sapling,
    String commandId,
  ) {
    // Повтор успешного сбора безопасен: монеты уже начислены один раз.
    if (profile.transactions.any((entry) => entry.id == commandId)) {
      return profile;
    }
    if (!profile.saplings.any((growing) => growing.id == state.id)) {
      throw const GameRuleException(
        'Этот саженец уже собрали или его нет в саду.',
      );
    }
    final int elapsed = elapsedDays(profile, state);
    final bool ripe = elapsed >= sapling.term;
    final int payout = ripe ? sapling.reward : sapling.earlyReward(elapsed);
    final int balance = profile.balance + payout;
    final String feedback = ripe
        ? 'Пять игровых дней прошли. Теперь собрано $payout коткоинов.'
        : 'Собрано сейчас $payout коткоинов. Если бы подождали до зрелости, '
              'пришло бы ${sapling.reward} — на ${sapling.reward - payout} больше. '
              'Ранний сбор тоже хороший выбор.';
    final GameProfile harvested = profile.copyWith(
      balance: balance,
      saplings: profile.saplings
          .where((growing) => growing.id != state.id)
          .toList(growable: false),
      feedback: feedback,
    );
    return harvested.copyWith(
      transactions: [
        ...harvested.transactions,
        GameTransaction(
          id: commandId,
          period: profile.period,
          kind: TransactionKind.income,
          amount: payout,
          label: 'Урожай: ${sapling.title}',
          referenceId: state.id,
          balanceAfter: balance,
          savingsAfter: profile.savings,
          satietyAfter: profile.satiety,
          moodAfter: profile.mood,
        ),
      ],
    );
  }
}
