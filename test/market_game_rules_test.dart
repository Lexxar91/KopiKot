import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/local/market_session_codec.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/learning_task.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/domain/rules/market_game_rules.dart';

import 'game_rules_test.dart' show initialProfile;

GameProfile ready() => initialProfile.withPlan(
  GameRules.confirmBudget(initialProfile, needs: 40, wants: 20, savings: 10),
);

GameProfile solve(GameProfile profile, String id) {
  var next = MarketGameRules.apply(profile, id, MarketAction.start);
  for (final itemId in MarketGameRules.targetIds(
    next.marketSessions.last.scenario,
  )) {
    next = MarketGameRules.apply(next, id, MarketAction.toggle, itemId: itemId);
  }
  next = MarketGameRules.apply(next, id, MarketAction.confirm);
  return MarketGameRules.apply(next, id, MarketAction.finish);
}

void main() {
  test('три ступени имеют заданные суммы и подходящую корзину', () {
    for (final (difficulty, budget, reserve, total) in [
      (LearningDifficulty.simple, 30, 7, 23),
      (LearningDifficulty.medium, 60, 15, 45),
      (LearningDifficulty.hard, 100, 25, 75),
    ]) {
      final scenario = MarketGameRules.scenarioFor(difficulty);
      expect(scenario.budget, budget);
      expect(scenario.reserve, reserve);
      final result = MarketGameRules.evaluate(
        MarketGameRules.targetIds(scenario),
        scenario: scenario,
      );
      expect(result.canClaim, isTrue);
      expect(result.spent, total);
      expect(result.remaining, reserve);
    }
    expect(MarketGameRules.targetIds(MarketGameRules.hard).last, 'book');
  });

  test('без нужного, резерва или подходящего желания награды нет', () {
    final scenario = MarketGameRules.hard;
    expect(
      MarketGameRules.evaluate(['toy'], scenario: scenario).canClaim,
      isFalse,
    );
    expect(
      MarketGameRules.evaluate([
        'food',
        'shampoo',
        'vet',
        'toy',
      ], scenario: scenario).canClaim,
      isFalse,
    );
    expect(
      MarketGameRules.evaluate([
        'food',
        'shampoo',
        'vet',
      ], scenario: scenario).canClaim,
      isFalse,
    );
  });

  test('после ошибки доступен разбор, награда один раз за день', () {
    var profile = MarketGameRules.apply(ready(), 'first', MarketAction.start);
    profile = MarketGameRules.apply(
      profile,
      'first',
      MarketAction.toggle,
      itemId: 'toy',
    );
    profile = MarketGameRules.apply(profile, 'first', MarketAction.confirm);
    profile = MarketGameRules.apply(profile, 'first', MarketAction.confirm);
    expect(profile.marketSessions.single.attempts, 2);
    profile = MarketGameRules.apply(profile, 'first', MarketAction.understood);
    expect(profile.marketSessions.single.reviewed, isTrue);
    profile = MarketGameRules.apply(profile, 'first', MarketAction.finish);
    expect(profile.balance, 106);
    expect(profile.marketSessions.single.firstTry, isFalse);
    profile = solve(profile, 'second');
    expect(profile.balance, 106);
    expect(profile.marketSessions.last.paidReward, 0);
  });

  test(
    'корзина и снимок шкал сохраняются; сложность растёт за две чистые игры',
    () {
      var profile = ready().copyWith(energy: 49);
      profile = MarketGameRules.apply(profile, 'saved', MarketAction.start);
      profile = MarketGameRules.apply(
        profile,
        'saved',
        MarketAction.toggle,
        itemId: 'food',
      );
      final restored = decodeMarketSessions(
        encodeMarketSessions(profile.marketSessions),
      ).single;
      expect(restored.selectedIds, ['food']);
      expect(MarketGameRules.snapshot(restored).gameReward, 5);
      profile = ready();
      profile = solve(profile, 'clean-1');
      profile = solve(profile, 'clean-2');
      expect(
        profile.learningTopic('kotomarket').difficulty,
        LearningDifficulty.medium,
      );
    },
  );
}
