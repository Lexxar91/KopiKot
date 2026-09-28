import '../models/game_profile.dart';
import '../models/game_transaction.dart';
import 'activity_reward_rules.dart';
import 'game_rules.dart';

enum MiniGameKind { accountant, kotomarket }

/// Начисляет награду за завершённую мини-игру без потери прежнего заработка.
abstract final class MiniGameRules {
  static const int baseReward = 6;

  static String title(MiniGameKind kind) => switch (kind) {
    MiniGameKind.accountant => 'Бухгалтер',
    MiniGameKind.kotomarket => 'Котомаркет',
  };

  /// Снимок энергии и радости влияет максимум на один коткоин награды.
  static int rewardFor(GameProfile profile) {
    return ActivityRewardSnapshot.fromProfile(profile).gameReward;
  }

  /// Повтор той же команды безопасен после сбоя сохранения или двойного нажатия.
  static GameProfile claim(
    GameProfile profile,
    MiniGameKind kind,
    String commandId, {
    ActivityRewardSnapshot? snapshot,
  }) {
    if (commandId.trim().isEmpty) {
      throw ArgumentError.value(commandId, 'commandId', 'Must not be empty');
    }
    final id = 'mini-game-$commandId';
    if (profile.transactions.any((entry) => entry.id == id)) return profile;
    GameRules.requirePlan(profile);
    final started = snapshot ?? ActivityRewardSnapshot.fromProfile(profile);
    started.requireCurrentDay(profile);
    if (profile.transactions.any(
      (entry) =>
          entry.period == profile.period &&
          entry.kind == TransactionKind.income &&
          entry.referenceId == kind.name,
    )) {
      return profile.copyWith(
        feedback:
            '${title(kind)} уже принесла награду сегодня. Можно тренироваться без новых коткоинов.',
      );
    }

    final reward = started.gameReward;
    final balance = profile.balance + reward;
    final gameTitle = title(kind);
    return profile.copyWith(
      balance: balance,
      transactions: [
        ...profile.transactions,
        GameTransaction(
          id: id,
          period: profile.period,
          kind: TransactionKind.income,
          amount: reward,
          label: 'Мини-игра: $gameTitle',
          referenceId: kind.name,
          startSatiety: started.satiety,
          startEnergy: started.energy,
          startMood: started.mood,
          baseReward: baseReward,
          balanceAfter: balance,
          savingsAfter: profile.savings,
          satietyAfter: profile.satiety,
          moodAfter: profile.mood,
        ),
      ],
      feedback:
          '$gameTitle: ${started.gameExplanation} '
          'Уже заработанные коткоины остаются у тебя.',
    );
  }
}
