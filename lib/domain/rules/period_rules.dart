import '../models/game_profile.dart';
import '../models/period_summary.dart';
import 'daily_reward_rules.dart';
import 'game_rules.dart';
import 'growth_rules.dart';

/// Игровой день следует местной дате; деморежим может перейти к следующему дню вручную.
abstract final class PeriodRules {
  static String dayKey(DateTime date) {
    final local = date.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  static int daysBetween(String from, String to) {
    DateTime utcDate(String key) {
      final parts = key.split('-').map(int.parse).toList();
      return DateTime.utc(parts[0], parts[1], parts[2]);
    }

    return utcDate(to).difference(utcDate(from)).inDays;
  }

  static PeriodSummary summarize(GameProfile profile, {int missedDays = 0}) {
    final plan = profile.plan;
    final actualNeeds = profile.actualNeeds;
    final actualWants = profile.actualWants;
    final netSaved = profile.netSaved;
    final withinPlan =
        plan != null &&
        actualNeeds <= plan.needs &&
        actualWants <= plan.wants &&
        profile.actualGifts <= plan.gifts;
    final savedRegularly =
        plan != null && netSaved > 0 && netSaved >= plan.savings;
    return PeriodSummary(
      period: profile.period,
      dayKey: profile.dayKey,
      missedDays: missedDays,
      plannedIncome: plan?.expectedIncome,
      plannedNeeds: plan?.needs ?? 0,
      plannedWants: plan?.wants ?? 0,
      plannedSavings: plan?.savings ?? 0,
      plannedGifts: plan?.gifts ?? 0,
      actualNeeds: actualNeeds,
      actualWants: actualWants,
      actualGifts: profile.actualGifts,
      netSaved: netSaved,
      needsMet: actualNeeds > 0 && profile.satiety >= 60,
      withinPlan: withinPlan,
      savedRegularly: savedRegularly,
      explanation: plan == null
          ? 'День завершён без плана. Коткоины остаются у тебя; завтра можно составить новый план.'
          : 'Сегодня на нужное ушло $actualNeeds, на радость — $actualWants, '
                'в копилку отправлено $netSaved. План помог сравнить ожидания с результатом.',
    );
  }

  /// Идемпотентно открывает сегодняшний день и зачисляет его награду до плана.
  static GameProfile openToday(GameProfile profile, DateTime now) {
    final today = dayKey(now);
    final previous = profile.dayKey;
    if (previous == null) {
      return GrowthRules.refresh(
        DailyRewardRules.claim(profile.copyWith(dayKey: today), now: now),
      );
    }
    if (today.compareTo(previous) <= 0) return profile;
    final summary = summarize(
      profile,
      missedDays: daysBetween(previous, today) - 1,
    );
    final next = profile.copyWith(
      period: profile.period + 1,
      dayKey: today,
      clearPlan: true,
      periodSummaries: [...profile.periodSummaries, summary],
    );
    return GrowthRules.refresh(DailyRewardRules.claim(next, now: now));
  }

  /// Только демонстрация может перейти к следующей дате без ожидания календаря.
  static GameProfile finish(GameProfile profile, int expectedPeriod) {
    if (!profile.isTest) {
      throw const GameRuleException(
        'Игровой день завершится при наступлении следующей даты.',
      );
    }
    if (profile.periodSummaries.any((item) => item.period == expectedPeriod)) {
      return profile;
    }
    if (expectedPeriod != profile.period) {
      throw const GameRuleException('Игровой день уже изменился.');
    }
    final date = profile.dayKey ?? dayKey(DateTime.now());
    final parts = date.split('-').map(int.parse).toList();
    final nextDate = DateTime(parts[0], parts[1], parts[2] + 1, 12);
    final summary = summarize(profile);
    final next = profile.copyWith(
      period: profile.period + 1,
      dayKey: dayKey(nextDate),
      clearPlan: true,
      periodSummaries: [...profile.periodSummaries, summary],
    );
    return GrowthRules.refresh(DailyRewardRules.claim(next, now: nextDate));
  }
}
