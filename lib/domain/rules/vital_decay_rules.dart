import '../models/game_profile.dart';

/// Результат пересчёта шкал и момент последнего учтённого полного часа.
class VitalDecayResult {
  const VitalDecayResult(this.profile, this.updatedAt);

  final GameProfile profile;
  final DateTime updatedAt;
}

/// Шкалы убывают по реальному времени, даже если приложение было закрыто.
abstract final class VitalDecayRules {
  static const int pointsPerHour = 3;
  static const int hoursWithoutCheckup = 72;
  static const int _hourMicroseconds = Duration.microsecondsPerHour;

  static VitalDecayResult advance(
    GameProfile profile, {
    required DateTime updatedAt,
    required DateTime lastCheckupAt,
    required DateTime now,
  }) {
    final elapsed = now.difference(updatedAt).inHours;
    if (elapsed <= 0) return VitalDecayResult(profile, updatedAt);

    final doubleRateFrom = lastCheckupAt.add(
      const Duration(hours: hoursWithoutCheckup),
    );
    final untilDouble = doubleRateFrom.difference(updatedAt).inMicroseconds;
    // Час до границы 72 часов ещё обычный; следующий расходуется вдвое быстрее.
    final normalHours = untilDouble <= 0
        ? 0
        : (untilDouble ~/ _hourMicroseconds).clamp(0, elapsed);
    final fastHours = elapsed - normalHours;
    final energyLoss = pointsPerHour * (normalHours + 2 * fastHours);

    return VitalDecayResult(
      profile.copyWith(
        satiety: (profile.satiety - elapsed * pointsPerHour).clamp(0, 100),
        mood: (profile.mood - elapsed * pointsPerHour).clamp(0, 100),
        energy: (profile.energy - energyLoss).clamp(0, 100),
      ),
      updatedAt.add(Duration(hours: elapsed)),
    );
  }
}
