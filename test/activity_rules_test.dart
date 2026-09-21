import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/rules/activity_rules.dart';

import 'game_rules_test.dart' show initialProfile;

void main() {
  test('Прогулка бесплатна, бодрит и не требует плана', () {
    final walked = ActivityRules.walk(initialProfile);
    expect(walked.energy, 85);
    expect(walked.mood, 80);
    expect(walked.walkPeriod, 1);
    expect(walked.balance, initialProfile.balance);
    expect(walked.transactions, isEmpty);
    expect(walked.feedback, contains('бесплатная'));
  });

  test('Повторная прогулка в том же периоде не даёт двойной эффект', () {
    final walked = ActivityRules.walk(initialProfile);
    final again = ActivityRules.walk(walked);
    expect(again.energy, 85);
    expect(again.mood, 80);
    expect(again.walkPeriod, 1);
    expect(again.feedback, contains('Сегодня уже гуляли'));
  });

  test('В новом периоде прогулка снова доступна', () {
    final nextPeriod = initialProfile.copyWith(
      period: 2,
      walkPeriod: 1,
      energy: 40,
    );
    final walked = ActivityRules.walk(nextPeriod);
    expect(walked.energy, 55);
    expect(walked.walkPeriod, 2);
    expect(walked.feedback, contains('без монет'));
  });
}