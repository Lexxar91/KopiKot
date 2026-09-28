import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/game_transaction.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/domain/rules/period_rules.dart';
import 'package:kopikot/domain/rules/sapling_rules.dart';

import 'game_rules_test.dart' show initialProfile;

void main() {
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
  );

  GameProfile planned() => initialProfile.withPlan(
    GameRules.confirmBudget(initialProfile, needs: 50, wants: 20, savings: 30),
  );

  test('Каталог содержит новое деревце и прежние варианты', () {
    expect(catalog.saplings.length, 3);
    expect(catalog.sapling('sapling_5').price, 30);
    expect(catalog.sapling('sapling_5').reward, 50);
    expect(catalog.saplings.map((sapling) => sapling.term).toSet(), {
      5,
      10,
      15,
    });
    for (final sapling in catalog.saplings) {
      expect(sapling.reward, greaterThan(sapling.price));
    }
  });

  test('Досрочная награда растёт пропорционально и не бывает ниже цены', () {
    final sapling = catalog.sapling('sapling_10');
    expect(sapling.earlyReward(0), sapling.price);
    expect(sapling.earlyReward(5), 35);
    expect(sapling.earlyReward(9), 47);
    expect(sapling.earlyReward(10), sapling.reward);
    expect(sapling.earlyReward(20), sapling.reward);
  });

  test('Посадка списывает монеты, добавляет саженец и объясняет вариант', () {
    final planted = SaplingRules.plant(
      planned(),
      catalog.sapling('sapling_5'),
      'seed-1',
    );
    expect(planted.balance, 70);
    expect(planted.saplings.single.definitionId, 'sapling_5');
    expect(planted.saplings.single.plantedPeriod, 1);
    expect(planted.transactions.single.kind, TransactionKind.saplingPurchase);
    expect(planted.transactions.single.amount, 30);
    expect(planted.feedback, contains('5 игровых дней'));
    expect(planted.feedback, contains('50 монет'));
    // Сытость и настроение не меняются: саженец не тратит заботу.
    expect(planted.satiety, 70);
    expect(planted.mood, 70);
  });

  test('Посадка без плана и без денег отклоняется', () {
    expect(
      () => SaplingRules.plant(
        initialProfile,
        catalog.sapling('sapling_5'),
        'no-plan',
      ),
      throwsA(isA<GameRuleException>()),
    );
    final poor = planned().copyWith(balance: 10);
    expect(
      () => SaplingRules.plant(poor, catalog.sapling('sapling_5'), 'poor'),
      throwsA(isA<GameRuleException>()),
    );
  });

  test('Полный сбор приносит полную награду и удаляет саженец', () {
    var profile = SaplingRules.plant(
      planned(),
      catalog.sapling('sapling_5'),
      'seed-2',
    );
    for (var period = 1; period <= 5; period++) {
      if (profile.plan == null) {
        profile = profile.withPlan(
          GameRules.confirmBudget(profile, needs: 0, wants: 0, savings: 0),
        );
      }
      profile = PeriodRules.finish(profile, period);
    }
    final state = profile.saplings.single;
    final harvested = SaplingRules.harvest(
      profile,
      state,
      catalog.sapling('sapling_5'),
      'take-1',
    );
    // 70 после посадки + 500 дохода + 50 урожая. Награда за вход отдельна.
    expect(harvested.balance, 620);
    expect(harvested.saplings, isEmpty);
    expect(harvested.transactions.last.label, 'Урожай: Деревце');
    expect(harvested.transactions.last.amount, 50);
    expect(harvested.feedback, contains('Котодерево созрело'));
    expect(harvested.feedback, contains('пассивного дохода'));
  });

  test(
    'Досрочный сбор даёт меньше полной награды и объясняет оба варианта',
    () {
      var profile = SaplingRules.plant(
        planned(),
        catalog.sapling('sapling_10'),
        'seed-3',
      );
      for (var period = 1; period <= 2; period++) {
        if (profile.plan == null) {
          profile = profile.withPlan(
            GameRules.confirmBudget(profile, needs: 0, wants: 0, savings: 0),
          );
        }
        profile = PeriodRules.finish(profile, period);
      }
      final state = profile.saplings.single;
      final harvested = SaplingRules.harvest(
        profile,
        state,
        catalog.sapling('sapling_10'),
        'early-take',
      );
      // elapsed = 2, payout = 20 + 30 * 2 / 10 = 26.
      expect(harvested.transactions.last.amount, 26);
      expect(harvested.feedback, contains('Собрали раньше срока'));
      expect(harvested.feedback, contains('50'));
    },
  );

  test('Повторная посадка и сбор безопасны, сбор чужой команды ошибается', () {
    var profile = SaplingRules.plant(
      planned(),
      catalog.sapling('sapling_5'),
      'seed-4',
    );
    final replay = SaplingRules.plant(
      profile,
      catalog.sapling('sapling_5'),
      'seed-4',
    );
    expect(identical(profile, replay), isTrue);
    final state = profile.saplings.single;
    profile = SaplingRules.harvest(
      profile,
      state,
      catalog.sapling('sapling_5'),
      'take-1',
    );
    expect(
      identical(
        profile,
        SaplingRules.harvest(
          profile,
          state,
          catalog.sapling('sapling_5'),
          'take-1',
        ),
      ),
      isTrue,
    );
    expect(
      () => SaplingRules.harvest(
        profile,
        state,
        catalog.sapling('sapling_5'),
        'take-2',
      ),
      throwsA(isA<GameRuleException>()),
    );
  });
}
