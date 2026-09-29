import '../models/game_profile.dart';

/// В обычной игре рост зависит от решений; в демо стадии открываются по дням.
abstract final class GrowthRules {
  static int qualifyingPeriods(GameProfile profile) => profile.isTest
      ? profile.periodSummaries.length
      : profile.periodSummaries
            .where((summary) => summary.supportsGrowth)
            .length;

  static GameProfile refresh(GameProfile profile) {
    final count = qualifyingPeriods(profile);
    final stage = count >= 4 ? 3 : (count >= 2 ? 2 : 1);
    final next = profile.copyWith(
      unlockedGrowthStage: stage,
      // Старые рубежи дохода и накоплений больше не описывают развитие.
      growthMilestones: const [],
    );
    if (stage <= profile.growthStage) return next;
    return next.copyWith(
      feedback: profile.isTest
          ? '${profile.feedback} Деморежим: открыта стадия «${next.growthLabel}» после $count игровых дней.'
          : '${profile.feedback} ${next.growthLabel}: в нескольких игровых днях '
                'ты позаботился о нужном, сверил траты с планом и откладывал коткоины.',
    );
  }

  static String nextStep(GameProfile profile) {
    if (profile.growthStage >= 3) return 'Все стадии развития открыты!';
    final required = profile.growthStage == 1 ? 2 : 4;
    final remaining = required - qualifyingPeriods(profile);
    return profile.isTest
        ? 'Деморежим: заверши ещё $remaining игровых дней для следующей стадии.'
        : 'Осталось дней до следующей стадии: $remaining. '
              'В каждом позаботься о нужном, придерживайся плана и отложи коткоины.';
  }
}
