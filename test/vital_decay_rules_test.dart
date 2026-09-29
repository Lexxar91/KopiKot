import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/rules/vital_decay_rules.dart';

import 'game_rules_test.dart' show initialProfile;

void main() {
  final start = DateTime(2026, 9, 1, 12);

  test('Полные часы уменьшают все три шкалы на 3 без повторного списания', () {
    final beforeHour = VitalDecayRules.advance(
      initialProfile,
      updatedAt: start,
      lastCheckupAt: start,
      now: start.add(const Duration(minutes: 59)),
    );
    expect(beforeHour.profile.energy, 70);
    expect(beforeHour.updatedAt, start);

    final afterHour = VitalDecayRules.advance(
      beforeHour.profile,
      updatedAt: beforeHour.updatedAt,
      lastCheckupAt: start,
      now: start.add(const Duration(hours: 1)),
    );
    expect(afterHour.profile.satiety, 67);
    expect(afterHour.profile.mood, 67);
    expect(afterHour.profile.energy, 67);
    expect(afterHour.updatedAt, start.add(const Duration(hours: 1)));
    final repeated = VitalDecayRules.advance(
      afterHour.profile,
      updatedAt: afterHour.updatedAt,
      lastCheckupAt: start,
      now: start.add(const Duration(hours: 1)),
    );
    expect(repeated.profile.energy, 67);
  });

  test('После 72 часов без осмотра только энергия теряется вдвое быстрее', () {
    final result = VitalDecayRules.advance(
      initialProfile.copyWith(satiety: 80, mood: 80, energy: 80),
      updatedAt: start.add(const Duration(hours: 70)),
      lastCheckupAt: start,
      now: start.add(const Duration(hours: 73)),
    );
    expect(result.profile.satiety, 71);
    expect(result.profile.mood, 71);
    expect(result.profile.energy, 68); // −3, −3, затем −6.

    final afterCheckup = VitalDecayRules.advance(
      result.profile,
      updatedAt: result.updatedAt,
      lastCheckupAt: start.add(const Duration(hours: 73)),
      now: start.add(const Duration(hours: 74)),
    );
    expect(afterCheckup.profile.energy, 65);
  });

  test('За длительное отсутствие шкалы не уходят ниже нуля', () {
    final result = VitalDecayRules.advance(
      initialProfile,
      updatedAt: start,
      lastCheckupAt: start,
      now: start.add(const Duration(days: 8)),
    );
    expect(result.profile.satiety, 0);
    expect(result.profile.mood, 0);
    expect(result.profile.energy, 0);
  });
}
