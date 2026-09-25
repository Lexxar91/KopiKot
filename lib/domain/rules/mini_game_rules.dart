import '../models/game_profile.dart';
import '../models/game_transaction.dart';

enum MiniGameKind { accountant, kotomarket }

/// Начисляет награду за завершённую мини-игру без потери прежнего заработка.
abstract final class MiniGameRules {
  static const int baseReward = 10;

  static String title(MiniGameKind kind) => switch (kind) {
    MiniGameKind.accountant => 'Бухгалтер',
    MiniGameKind.kotomarket => 'Котомаркет',
  };

  /// Хорошее состояние даёт небольшой бонус, низкая любая шкала — мягкое снижение.
  static int rewardFor(GameProfile profile) {
    if (profile.satiety < 40 || profile.energy < 40 || profile.mood < 40) {
      return baseReward - 2;
    }
    if (profile.satiety >= 70 && profile.energy >= 70 && profile.mood >= 70) {
      return baseReward + 2;
    }
    return baseReward;
  }

  /// Повтор той же команды безопасен после сбоя сохранения или двойного нажатия.
  static GameProfile claim(
    GameProfile profile,
    MiniGameKind kind,
    String commandId,
  ) {
    if (commandId.trim().isEmpty) {
      throw ArgumentError.value(commandId, 'commandId', 'Must not be empty');
    }
    final id = 'mini-game-$commandId';
    if (profile.transactions.any((entry) => entry.id == id)) return profile;

    final reward = rewardFor(profile);
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
          balanceAfter: balance,
          savingsAfter: profile.savings,
          satietyAfter: profile.satiety,
          moodAfter: profile.mood,
        ),
      ],
      feedback: '$gameTitle: +$reward коткоинов! Котик рад твоим стараниям.',
    );
  }
}
