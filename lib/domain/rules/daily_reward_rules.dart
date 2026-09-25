import '../models/game_profile.dart';
import '../models/game_transaction.dart';

/// Начисляет награду отдельно от завершения игрового периода.
abstract final class DailyRewardRules {
  /// Суммы и порядок дней соответствуют экрану ежедневной награды.
  static const ladder = <int>[5, 10, 15, 20, 25, 30, 35];

  static bool canClaim(GameProfile profile, {DateTime? now}) {
    if (profile.isTest) {
      return !profile.transactions.any(
        (entry) =>
            entry.id == 'daily-reward-demo-${profile.period}' ||
            entry.id == 'streak-bonus-${profile.period}',
      );
    }
    final last = profile.lastRewardAt;
    if (last == null) return true;
    return _calendarDays(last, now ?? DateTime.now()) > 0;
  }

  static int rewardLevel(GameProfile profile, {DateTime? now}) {
    final last = profile.lastRewardAt;
    final elapsed = last == null
        ? 0
        : _calendarDays(last, now ?? DateTime.now());
    final level = profile.streak.clamp(1, ladder.length);
    return elapsed >= 2 ? (level - 1).clamp(1, ladder.length) : level;
  }

  static GameProfile claim(GameProfile profile, {DateTime? now}) {
    final moment = now ?? DateTime.now();
    if (!canClaim(profile, now: moment)) return profile;

    final level = rewardLevel(profile, now: moment);
    final amount = ladder[level - 1];
    final balance = profile.balance + amount;
    final missedDay =
        profile.lastRewardAt != null &&
        _calendarDays(profile.lastRewardAt!, moment) >= 2;
    final id = profile.isTest
        ? 'daily-reward-demo-${profile.period}'
        : 'daily-reward-${moment.year}-${moment.month}-${moment.day}';

    return profile.copyWith(
      balance: balance,
      streak: (level + 1).clamp(1, ladder.length),
      lastRewardAt: moment,
      transactions: [
        ...profile.transactions,
        GameTransaction(
          id: id,
          period: profile.period,
          kind: TransactionKind.income,
          amount: amount,
          label: 'Ежедневная награда: день $level',
          balanceAfter: balance,
          savingsAfter: profile.savings,
          satietyAfter: profile.satiety,
          moodAfter: profile.mood,
        ),
      ],
      feedback: missedDay
          ? 'Рад тебя видеть! Серия уменьшилась всего на один шаг. '
                'За день $level получили $amount коткоинов.'
          : 'За день $level получили $amount коткоинов. '
                'Загляни завтра за следующей наградой!',
    );
  }

  static int _calendarDays(DateTime from, DateTime to) => DateTime.utc(
    to.year,
    to.month,
    to.day,
  ).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
}
