import '../models/game_profile.dart';

/// Бесплатные активности: забота и радость не всегда стоят монет.
abstract final class ActivityRules {
  /// Бесплатная прогулка: раз в игровой день, без монет и плана.
  static GameProfile walk(GameProfile profile) {
    if (profile.walkPeriod == profile.period) {
      return profile.copyWith(
        feedback:
            'Сегодня уже гуляли. Прогулка бесплатная — можно повторить завтра.',
      );
    }
    final int energy = (profile.energy + 15).clamp(0, 100);
    final int mood = (profile.mood + 10).clamp(0, 100);
    return profile.copyWith(
      energy: energy,
      mood: mood,
      walkPeriod: profile.period,
      feedback:
          'Прогулка бесплатная: энергия ${profile.energy} → $energy, '
          'радость ${profile.mood} → $mood. '
          'Заботиться о питомце можно и без монет.',
    );
  }
}
