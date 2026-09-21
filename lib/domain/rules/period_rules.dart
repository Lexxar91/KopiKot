import '../models/game_profile.dart';
import '../models/game_transaction.dart';
import '../models/period_summary.dart';
import 'game_rules.dart';

/// Период завершается вручную; старый запрос никогда не начисляет доход повторно.
abstract final class PeriodRules {
  static const income = 100;

  static PeriodSummary summarize(GameProfile profile) {
    final plan = profile.plan;
    if (plan == null) {
      throw const GameRuleException(
        'Сначала составь и подтверди план периода.',
      );
    }
    final needsMet = profile.actualNeeds > 0 && profile.satiety >= 60;
    final withinPlan =
        profile.actualNeeds <= plan.needs &&
        profile.actualWants <= plan.wants &&
        profile.actualGifts <= plan.gifts;
    final savedRegularly =
        profile.netSaved > 0 && profile.netSaved >= plan.savings;
    final messages = [
      needsMet
          ? 'Нужные покупки сделаны, питомец сыт.'
          : 'В следующем периоде запланируй еду и уход: сытость можно восстановить.',
      withinPlan
          ? 'Траты уложились в план. Отложить желаемое — нормально.'
          : 'Траты превысили план. В следующий раз можно выбрать покупку дешевле.',
      savedRegularly
          ? 'На мечту отложено не меньше запланированного.'
          : 'В следующем периоде попробуй отложить немного на цель и свериться с планом.',
    ];
    return PeriodSummary(
      period: profile.period,
      plannedNeeds: plan.needs,
      plannedWants: plan.wants,
      plannedSavings: plan.savings,
      plannedGifts: plan.gifts,
      actualNeeds: profile.actualNeeds,
      actualWants: profile.actualWants,
      actualGifts: profile.actualGifts,
      netSaved: profile.netSaved,
      needsMet: needsMet,
      withinPlan: withinPlan,
      savedRegularly: savedRegularly,
      explanation: messages.join(' '),
    );
  }

  static GameProfile finish(
    GameProfile profile,
    int expectedPeriod, {
    DateTime? now,
  }) {
    if (profile.periodSummaries.any(
      (summary) => summary.period == expectedPeriod,
    )) {
      return profile;
    }
    if (expectedPeriod != profile.period) {
      throw const GameRuleException(
        'Период уже изменился. Открой его итоги заново.',
      );
    }
    final summary = summarize(profile);
    final nextPeriod = profile.period + 1;
    final DateTime moment = now ?? DateTime.now();
    // Пропуск не обнуляет серию: она мягко уменьшается на один уровень.
    final DateTime? last = profile.lastRewardAt;
    int streak = profile.streak;
    String seriesNote = '';
    if (last != null && _calendarDays(last, moment) >= 2) {
      if (streak > 1) {
        seriesNote =
            'Прошло несколько дней — серия уменьшилась на один уровень, '
            'но ничего не обнулилось. ';
      } else {
        seriesNote =
            'Рад тебя видеть! Продолжим с того места, где остановились. ';
      }
      streak = streak > 1 ? streak - 1 : 1;
    }
    final int bonus = GameRules.dailyRewardLadder[streak - 1];
    final int nextStreak = (streak + 1).clamp(1, 7);
    final int afterBase = profile.balance + income;
    final int balance = afterBase + bonus;
    final int satiety = (profile.satiety - 20).clamp(30, 100);
    final int energy = (profile.energy - 15).clamp(20, 100);
    var next = profile.copyWith(
      period: nextPeriod,
      balance: balance,
      satiety: satiety,
      energy: energy,
      streak: nextStreak,
      lastRewardAt: moment,
      clearPlan: true,
      periodSummaries: [...profile.periodSummaries, summary],
    );
    next = next.copyWith(
      transactions: [
        ...next.transactions,
        GameTransaction(
          id: 'period-income-$nextPeriod',
          period: nextPeriod,
          kind: TransactionKind.income,
          amount: income,
          label: 'Начало периода $nextPeriod',
          balanceAfter: afterBase,
          savingsAfter: profile.savings,
          satietyAfter: satiety,
          moodAfter: profile.mood,
        ),
        GameTransaction(
          id: 'streak-bonus-$nextPeriod',
          period: nextPeriod,
          kind: TransactionKind.income,
          amount: bonus,
          label: 'Подарок за день $streak серии',
          balanceAfter: balance,
          savingsAfter: profile.savings,
          satietyAfter: satiety,
          moodAfter: profile.mood,
        ),
      ],
    );
    return next.copyWith(
      feedback:
          '${summary.explanation} $seriesNote'
          '${next.growthStage > profile.growthStage ? 'Новая стадия: ${next.growthLabel}!' : 'Достигнутый рост сохранён.'} '
          'Период $nextPeriod: +$income монет и подарок серии +$bonus (день $streak из 7). '
          'В следующий раз подарок: +${GameRules.dailyRewardLadder[nextStreak - 1]}. '
          'Энергия уменьшилась на ${profile.energy - energy}: полезная еда и бесплатная прогулка вернут бодрость.',
    );
  }

  /// Разница календарных дат без учёта времени суток.
  static int _calendarDays(DateTime from, DateTime to) =>
      DateTime.utc(to.year, to.month, to.day)
          .difference(DateTime.utc(from.year, from.month, from.day))
          .inDays;
}
