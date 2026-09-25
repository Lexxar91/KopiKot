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

  static GameProfile finish(GameProfile profile, int expectedPeriod) {
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
    final int balance = profile.balance + income;
    final int satiety = (profile.satiety - 20).clamp(30, 100);
    final int energy = (profile.energy - 15).clamp(20, 100);
    var next = profile.copyWith(
      period: nextPeriod,
      balance: balance,
      satiety: satiety,
      energy: energy,
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
          balanceAfter: balance,
          savingsAfter: profile.savings,
          satietyAfter: satiety,
          moodAfter: profile.mood,
        ),
      ],
    );
    return next.copyWith(
      feedback:
          '${summary.explanation} '
          '${next.growthStage > profile.growthStage ? 'Новая стадия: ${next.growthLabel}!' : 'Достигнутый рост сохранён.'} '
          'Период $nextPeriod: +$income монет. Ежедневную награду можно забрать отдельно. '
          'Энергия уменьшилась на ${profile.energy - energy}: полезная еда и бесплатная прогулка вернут бодрость.',
    );
  }
}
