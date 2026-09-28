import '../models/game_catalog.dart';
import '../models/game_profile.dart';
import '../models/game_transaction.dart';
import 'game_rules.dart';

/// Котодерево-копилка: монеты работают, если дать им время.
///
/// Саженец покупается за баланс, растёт по игровым периодам и приносит
/// награду. Досрочный сбор не создаёт потерь: возвращается цена и часть
/// бонуса, поэтому любое решение ребёнка остаётся безопасным.
abstract final class SaplingRules {
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
    GameRules.requirePlan(profile);
    GameRules.requirePositive(sapling.price);
    GameRules.requireBalance(profile, sapling.price);
    final int balance = profile.balance - sapling.price;
    final SaplingState state = SaplingState(
      id: commandId,
      definitionId: sapling.id,
      plantedPeriod: profile.period,
    );
    final GameProfile planted = profile.copyWith(
      balance: balance,
      saplings: [...profile.saplings, state],
      feedback:
          'Саженец «${sapling.title}» посажен: −${sapling.price} монет. '
          'Через ${sapling.term} игровых дней он подарит ${sapling.reward} монет. '
          'Собрать раньше тоже можно — просто меньше. Сытость и радость не изменились.',
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
    final int elapsed = profile.period - state.plantedPeriod;
    final bool ripe = elapsed >= sapling.term;
    final int payout = ripe ? sapling.reward : sapling.earlyReward(elapsed);
    final int balance = profile.balance + payout;
    final String feedback = ripe
        ? 'Котодерево созрело: +$payout монет! '
              'Можно посадить новый саженец, выбрать долгий или потратить на радость — '
              'все пути хорошие. Без нового саженца пассивного дохода пока не будет.'
        : 'Собрали раньше срока: +$payout вместо ${sapling.reward} монет. '
              'Подождав ещё ${sapling.term - elapsed} дней, получилось бы ${sapling.reward}. '
              'Оба варианта — не ошибка: накопление можно начать снова в любой момент.';
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
