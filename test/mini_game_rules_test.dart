import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/rules/activity_reward_rules.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/domain/rules/mini_game_rules.dart';

GameProfile profile({
  int satiety = 70,
  int energy = 70,
  int mood = 70,
  bool withPlan = true,
}) => GameProfile(
  petName: 'Финни',
  coat: PetCoat.ginger,
  accessory: null,
  balance: 50,
  savings: 0,
  period: 1,
  dayKey: '2026-09-28',
  satiety: satiety,
  energy: energy,
  mood: mood,
  incomeSource: 'Начало',
  incomeAmount: 50,
  plan: withPlan
      ? const BudgetPlan(
          availableAtConfirmation: 50,
          needs: 25,
          wants: 15,
          savings: 10,
        )
      : null,
);

void main() {
  test('игра даёт 6 или 5 только по энергии и радости', () {
    expect(MiniGameRules.rewardFor(profile(energy: 50, mood: 50)), 6);
    expect(MiniGameRules.rewardFor(profile(satiety: 1)), 6);
    expect(MiniGameRules.rewardFor(profile(energy: 49)), 5);
    expect(MiniGameRules.rewardFor(profile(energy: 49, mood: 49)), 5);
  });

  test('выплата использует снимок шкал на старте', () {
    final started = profile(energy: 49, mood: 80);
    final snapshot = ActivityRewardSnapshot.fromProfile(started);
    final finished = started.copyWith(energy: 100, mood: 100);
    final updated = MiniGameRules.claim(
      finished,
      MiniGameKind.accountant,
      'session',
      snapshot: snapshot,
    );
    expect(updated.balance, 55);
    expect(updated.transactions.single.amount, 5);
    expect(updated.transactions.single.baseReward, 6);
    expect(updated.transactions.single.startEnergy, 49);
    expect(updated.transactions.single.startMood, 80);
  });

  test('вторая сессия той же игры за день — тренировка без награды', () {
    final first = MiniGameRules.claim(
      profile(),
      MiniGameKind.accountant,
      'one',
    );
    final training = MiniGameRules.claim(first, MiniGameKind.accountant, 'two');
    expect(training.balance, 56);
    expect(training.transactions, hasLength(1));
    final otherGame = MiniGameRules.claim(
      training,
      MiniGameKind.kotomarket,
      'three',
    );
    expect(otherGame.balance, 62);
  });

  test('без плана и со снимком прошлого дня награда не начисляется', () {
    expect(
      () => MiniGameRules.claim(
        profile(withPlan: false),
        MiniGameKind.accountant,
        'no-plan',
      ),
      throwsA(isA<GameRuleException>()),
    );
    final started = profile();
    final snapshot = ActivityRewardSnapshot.fromProfile(started);
    final tomorrow = started.copyWith(period: 2, dayKey: '2026-09-29');
    expect(
      () => MiniGameRules.claim(
        tomorrow,
        MiniGameKind.accountant,
        'stale',
        snapshot: snapshot,
      ),
      throwsA(isA<GameRuleException>()),
    );
  });
}
