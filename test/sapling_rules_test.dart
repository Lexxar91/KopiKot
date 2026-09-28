import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/game_transaction.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/domain/rules/sapling_rules.dart';

import 'game_rules_test.dart' show initialProfile;

void main() {
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
  );

  GameProfile planned() {
    final profile = initialProfile.copyWith(dayKey: '2026-09-28');
    return profile.withPlan(
      GameRules.confirmBudget(profile, needs: 50, wants: 20, savings: 30),
    );
  }

  test('Деревце стоит 20, ранний сбор 30, зрелый 50', () {
    expect(catalog.sapling('sapling_5').price, 20);
    expect(catalog.sapling('sapling_5').reward, 50);
    expect(catalog.sapling('sapling_5').term, 5);
    for (var day = 0; day < 5; day++) {
      expect(catalog.sapling('sapling_5').earlyReward(day), 30);
    }
    expect(catalog.sapling('sapling_5').earlyReward(5), 50);
  });

  test('Посадка списывает монеты, добавляет саженец и объясняет вариант', () {
    final planted = SaplingRules.plant(
      planned(),
      catalog.sapling('sapling_5'),
      'seed-1',
    );
    expect(planted.balance, 80);
    expect(planted.saplings.single.definitionId, 'sapling_5');
    expect(planted.saplings.single.plantedPeriod, 1);
    expect(planted.saplings.single.plantedDayKey, '2026-09-28');
    expect(planted.transactions.single.kind, TransactionKind.saplingPurchase);
    expect(planted.transactions.single.amount, 20);
    expect(planted.feedback, contains('30 коткоинов'));
    expect(planted.feedback, contains('50'));
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
    profile = profile.copyWith(dayKey: '2026-10-03', period: 2);
    expect(SaplingRules.elapsedDays(profile, profile.saplings.single), 5);
    final state = profile.saplings.single;
    final harvested = SaplingRules.harvest(
      profile,
      state,
      catalog.sapling('sapling_5'),
      'take-1',
    );
    expect(harvested.balance, 130);
    expect(harvested.saplings, isEmpty);
    expect(harvested.transactions.last.label, 'Урожай: Деревце');
    expect(harvested.transactions.last.amount, 50);
    expect(harvested.feedback, contains('Пять игровых дней прошли'));
  });

  test(
    'Досрочный сбор даёт меньше полной награды и объясняет оба варианта',
    () {
      final profile = SaplingRules.plant(
        planned(),
        catalog.sapling('sapling_5'),
        'seed-3',
      );
      final state = profile.saplings.single;
      final harvested = SaplingRules.harvest(
        profile,
        state,
        catalog.sapling('sapling_5'),
        'early-take',
      );
      expect(harvested.transactions.last.amount, 30);
      expect(harvested.balance, 110);
      expect(harvested.feedback, contains('Собрано сейчас'));
      expect(harvested.feedback, contains('50'));
      expect(
        () => SaplingRules.plant(
          harvested,
          catalog.sapling('sapling_5'),
          'again',
        ),
        throwsA(isA<GameRuleException>()),
      );
      final tomorrow = harvested.copyWith(dayKey: '2026-09-29', period: 2);
      expect(
        SaplingRules.plant(
          tomorrow,
          catalog.sapling('sapling_5'),
          'again',
        ).saplings,
        hasLength(1),
      );
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
    expect(
      () =>
          SaplingRules.plant(profile, catalog.sapling('sapling_5'), 'another'),
      throwsA(isA<GameRuleException>()),
    );
    expect(
      () => SaplingRules.plant(profile, catalog.sapling('sapling_10'), 'old'),
      throwsA(isA<GameRuleException>()),
    );
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
