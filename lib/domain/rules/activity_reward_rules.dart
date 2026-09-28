import '../models/game_profile.dart';
import 'game_rules.dart';

/// Состояние котика при старте активности, неизменное до её завершения.
class ActivityRewardSnapshot {
  const ActivityRewardSnapshot({
    required this.period,
    required this.dayKey,
    required this.satiety,
    required this.energy,
    required this.mood,
  });

  factory ActivityRewardSnapshot.fromProfile(GameProfile profile) =>
      ActivityRewardSnapshot(
        period: profile.period,
        dayKey: profile.dayKey,
        satiety: profile.satiety,
        energy: profile.energy,
        mood: profile.mood,
      );

  final int period;
  final String? dayKey;
  final int satiety;
  final int energy;
  final int mood;

  int get taskReward => 12 - (satiety < 50 || energy < 50 ? 1 : 0);
  int get gameReward => 6 - (energy < 50 || mood < 50 ? 1 : 0);

  String get taskPreview {
    final low = [if (satiety < 50) 'сытость', if (energy < 50) 'энергия'];
    return low.isEmpty
        ? 'Сытость и энергия не ниже 50: ожидается 12 коткоинов.'
        : '${low.join(' и ')} ниже 50: ожидается 11 вместо 12.';
  }

  String get gamePreview {
    final low = [if (energy < 50) 'энергия', if (mood < 50) 'радость'];
    return low.isEmpty
        ? 'Энергия и радость не ниже 50: ожидается 6 коткоинов.'
        : '${low.join(' и ')} ниже 50: ожидается 5 вместо 6.';
  }

  void requireCurrentDay(GameProfile profile) {
    if (period != profile.period || dayKey != profile.dayKey) {
      throw const GameRuleException(
        'Начался новый игровой день. Открой задание или игру заново.',
      );
    }
    if ([satiety, energy, mood].any((value) => value < 0 || value > 100)) {
      throw const GameRuleException('Не удалось проверить шкалы котика.');
    }
  }

  String get taskExplanation {
    final low = [if (satiety < 50) 'сытость', if (energy < 50) 'энергия'];
    return low.isEmpty
        ? 'Сытость и энергия не ниже 50: начислено 12 коткоинов.'
        : '${low.join(' и ')} ниже 50: начислено 11 вместо 12. '
              'Уменьшение только на 1 коткоин.';
  }

  String get gameExplanation {
    final low = [if (energy < 50) 'энергия', if (mood < 50) 'радость'];
    return low.isEmpty
        ? 'Энергия и радость не ниже 50: начислено 6 коткоинов.'
        : '${low.join(' и ')} ниже 50: начислено 5 вместо 6. '
              'Уменьшение только на 1 коткоин.';
  }
}
