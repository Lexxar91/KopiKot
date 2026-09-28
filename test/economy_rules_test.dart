import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/game_transaction.dart';
import 'package:kopikot/domain/rules/economy_rules.dart';
import 'package:kopikot/domain/rules/game_rules.dart';

import 'game_rules_test.dart' show initialProfile;

void main() {
  final source = File('assets/content/catalog.json').readAsStringSync();
  final catalog = parseGameCatalog(source);
  late GameProfile profile;

  setUp(() {
    profile = initialProfile.withPlan(
      GameRules.confirmBudget(
        initialProfile,
        needs: 50,
        wants: 20,
        savings: 30,
      ),
    );
  });

  test('Срок накопления округляется вверх и зависит от регулярного взноса', () {
    expect(EconomyRules.periodsToGoal(price: 120, saved: 30, perPeriod: 30), 3);
    expect(EconomyRules.periodsToGoal(price: 120, saved: 20, perPeriod: 30), 4);
    expect(EconomyRules.periodsToGoal(price: 120, saved: 120, perPeriod: 0), 0);
    expect(
      EconomyRules.periodsToGoal(price: 120, saved: 20, perPeriod: 0),
      isNull,
    );
  });

  test('Каталог содержит покупки трёх типов и три цели', () {
    expect(catalog.products.length, greaterThanOrEqualTo(8));
    expect(catalog.products.map((item) => item.category).toSet().length, 3);
    expect(catalog.goals.length, greaterThanOrEqualTo(3));
    expect(catalog.goal('tent').title, 'Беговая дорожка');
    expect(catalog.goal('tent').price, 400);
    expect(catalog.goal('telescope').title, 'Лежанка');
    expect(catalog.goal('telescope').price, 300);
    expect(catalog.goal('garden').title, 'Редкий саженец');
    expect(catalog.goal('garden').price, 500);
    expect(
      catalog.products.fold<int>(0, (sum, product) => sum + product.price),
      greaterThan(initialProfile.balance),
    );
  });

  test('Каталог отклоняет повтор ID, неверную цену и неизвестную версию', () {
    for (final field in ['id', 'price', 'version']) {
      final data = jsonDecode(source) as Map<String, dynamic>;
      if (field == 'version') {
        data[field] = 99;
      } else if (field == 'id') {
        data['products'][1]['id'] = data['products'][0]['id'];
      } else {
        data['products'][0]['price'] = -1;
      }
      expect(() => parseGameCatalog(jsonEncode(data)), throwsFormatException);
    }
  });

  test('До подтверждения плана денежные действия запрещены', () {
    expect(
      () =>
          EconomyRules.purchase(initialProfile, catalog.product('water'), 'a'),
      throwsA(isA<GameRuleException>()),
    );
    final selected = EconomyRules.selectGoal(
      initialProfile,
      catalog.goal('tent'),
    );
    expect(
      () => EconomyRules.transfer(
        selected,
        catalog.goal('tent'),
        10,
        commandId: 'b',
        withdraw: false,
      ),
      throwsA(isA<GameRuleException>()),
    );
  });

  test(
    'Покупка меняет баланс, состояние и факт; исходная модель неизменна',
    () {
      final next = EconomyRules.purchase(
        profile,
        catalog.product('soup'),
        'soup-1',
      );
      expect(next.balance, 65);
      expect(next.satiety, 100);
      expect(next.mood, 75);
      expect(next.actualNeeds, 35);
      expect(next.actualWants, 0);
      expect(next.transactions.single.balanceAfter, 65);
      expect(profile.balance, 100);
      expect(profile.transactions, isEmpty);
    },
  );

  test(
    'Необязательная покупка сверх плана допустима, но получает объяснение',
    () {
      final next = EconomyRules.purchase(
        profile,
        catalog.product('ball'),
        'ball-1',
      );
      expect(next.balance, 70);
      expect(next.actualWants, 30);
      expect(next.feedback, contains('больше плана'));
    },
  );

  test('Подарок учитывается отдельно в плане и факте', () {
    profile = initialProfile.withPlan(
      GameRules.confirmBudget(
        initialProfile,
        needs: 30,
        wants: 20,
        gifts: 20,
        savings: 30,
      ),
    );
    final next = EconomyRules.purchase(
      profile,
      catalog.product('owl_seedlings'),
      'gift-1',
    );
    expect(next.actualGifts, 20);
    expect(next.transactions.single.kind, TransactionKind.giftPurchase);
    expect(next.plan!.gifts, 20);
  });

  test('Купленный аксессуар можно надеть, снять и надеть снова', () {
    final bought = EconomyRules.purchase(
      profile,
      catalog.product('berry_bow'),
      'bow-1',
    );
    expect(bought.ownsAccessory(PetAccessory.scarf), isTrue);
    expect(bought.ownsAccessory(PetAccessory.bow), isTrue);
    final equipped = EconomyRules.equipAccessory(bought, PetAccessory.bow);
    expect(equipped.accessory, PetAccessory.bow);
    final removed = EconomyRules.equipAccessory(equipped, null);
    expect(removed.accessory, isNull);
    expect(removed.ownsAccessory(PetAccessory.scarf), isTrue);
    expect(
      EconomyRules.equipAccessory(removed, PetAccessory.scarf).accessory,
      PetAccessory.scarf,
    );
    expect(
      () => EconomyRules.purchase(
        bought,
        catalog.product('star_scarf'),
        'scarf-2',
      ),
      throwsA(isA<GameRuleException>()),
    );
  });

  test(
    'Повтор покупки с тем же ID не списывает деньги и не улучшает питомца',
    () {
      final first = EconomyRules.purchase(
        profile,
        catalog.product('soup'),
        'same',
      );
      final second = EconomyRules.purchase(
        first,
        catalog.product('soup'),
        'same',
      );
      expect(identical(first, second), isTrue);
      expect(second.transactions.length, 1);
      expect(
        () => EconomyRules.purchase(second, catalog.product('water'), 'same'),
        throwsA(isA<GameRuleException>()),
      );
    },
  );

  test('Нехватка денег отклоняет покупку и оставляет исходное состояние', () {
    final first = EconomyRules.purchase(
      profile,
      catalog.product('puzzle'),
      'first',
    );
    expect(
      () => EconomyRules.purchase(first, catalog.product('porridge'), 'second'),
      throwsA(isA<GameRuleException>()),
    );
    expect(first.balance, 20);
    expect(first.actualNeeds, 0);
  });

  test('Перевод туда и обратно не увеличивает чистые накопления', () {
    final goal = catalog.goal('tent');
    profile = EconomyRules.selectGoal(profile, goal);
    profile = EconomyRules.transfer(
      profile,
      goal,
      30,
      commandId: 'deposit',
      withdraw: false,
    );
    expect(profile.balance, 70);
    expect(profile.savedFor('tent'), 30);
    expect(profile.savings, 30);
    expect(profile.netSaved, 30);
    profile = EconomyRules.transfer(
      profile,
      goal,
      30,
      commandId: 'withdraw',
      withdraw: true,
    );
    expect(profile.balance, 100);
    expect(profile.savings, 0);
    expect(profile.netSaved, 0);
    expect(profile.totalFor(TransactionKind.deposit), 30);
    expect(profile.totalFor(TransactionKind.withdrawal), 30);
  });

  test('Смена цели не переносит её монеты; снять с другой цели нельзя', () {
    profile = EconomyRules.selectGoal(
      profile.copyWith(goalChoicesUnlocked: true),
      catalog.goal('tent'),
    );
    profile = EconomyRules.transfer(
      profile,
      catalog.goal('tent'),
      30,
      commandId: 'one',
      withdraw: false,
    );
    profile = EconomyRules.selectGoal(profile, catalog.goal('garden'));
    expect(profile.savedFor('tent'), 30);
    expect(profile.savedFor('garden'), 0);
    expect(profile.savings, 30);
    expect(
      () => EconomyRules.transfer(
        profile,
        catalog.goal('garden'),
        10,
        commandId: 'two',
        withdraw: true,
      ),
      throwsA(isA<GameRuleException>()),
    );
    expect(
      () => EconomyRules.transfer(
        profile,
        catalog.goal('tent'),
        10,
        commandId: 'three',
        withdraw: true,
      ),
      throwsA(isA<GameRuleException>()),
    );
  });

  test(
    'Другие цели открываются после достижения первой и остаются открыты',
    () {
      final firstGoal = catalog.goal('tent');
      final nextGoal = catalog.goal('telescope');
      profile = profile.copyWith(selectedGoalId: firstGoal.id, balance: 400);
      expect(
        () => EconomyRules.selectGoal(profile, nextGoal),
        throwsA(isA<GameRuleException>()),
      );
      profile = EconomyRules.transfer(
        profile,
        firstGoal,
        firstGoal.price,
        commandId: 'reach-first-goal',
        withdraw: false,
      );
      expect(profile.goalChoicesUnlocked, isTrue);
      profile = EconomyRules.transfer(
        profile,
        firstGoal,
        10,
        commandId: 'take-after-goal',
        withdraw: true,
      );
      expect(profile.goalChoicesUnlocked, isTrue);
      expect(
        EconomyRules.selectGoal(profile, nextGoal).selectedGoalId,
        nextGoal.id,
      );
    },
  );

  test('Нулевые, отрицательные и слишком большие переводы отклоняются', () {
    profile = EconomyRules.selectGoal(profile, catalog.goal('tent'));
    for (final amount in [0, -1, 101]) {
      expect(
        () => EconomyRules.transfer(
          profile,
          catalog.goal('tent'),
          amount,
          commandId: 'transfer-$amount',
          withdraw: false,
        ),
        throwsA(isA<GameRuleException>()),
      );
    }
    expect(
      () => EconomyRules.transfer(
        profile,
        catalog.goal('tent'),
        1,
        commandId: 'empty',
        withdraw: true,
      ),
      throwsA(isA<GameRuleException>()),
    );
  });

  test('Цель нельзя переполнить; повтор пополнения и снятия идемпотентен', () {
    final goal = catalog.goal('tent');
    profile = EconomyRules.selectGoal(profile.copyWith(balance: 500), goal);
    profile = EconomyRules.transfer(
      profile,
      goal,
      400,
      commandId: 'full',
      withdraw: false,
    );
    expect(profile.feedback, contains('Цель достигнута'));
    expect(
      identical(
        profile,
        EconomyRules.transfer(
          profile,
          goal,
          400,
          commandId: 'full',
          withdraw: false,
        ),
      ),
      isTrue,
    );
    expect(
      () => EconomyRules.transfer(
        profile,
        goal,
        1,
        commandId: 'over',
        withdraw: false,
      ),
      throwsA(isA<GameRuleException>()),
    );
    profile = EconomyRules.transfer(
      profile,
      goal,
      20,
      commandId: 'take',
      withdraw: true,
    );
    final repeat = EconomyRules.transfer(
      profile,
      goal,
      20,
      commandId: 'take',
      withdraw: true,
    );
    expect(identical(profile, repeat), isTrue);
    expect(repeat.savedFor(goal.id), 380);
    expect(repeat.balance + repeat.savings, 500);
  });

  test(
    'Достигнутая цель покупается только из своей копилки и ровно один раз',
    () {
      final goal = catalog.goal('telescope');
      profile = EconomyRules.selectGoal(
        profile.copyWith(balance: 400, selectedGoalId: goal.id),
        goal,
      );
      expect(
        () => EconomyRules.purchaseGoal(profile, goal, 'too-early'),
        throwsA(isA<GameRuleException>()),
      );
      profile = EconomyRules.transfer(
        profile,
        goal,
        goal.price,
        commandId: 'save',
        withdraw: false,
      );
      final wallet = profile.balance;
      final purchased = EconomyRules.purchaseGoal(profile, goal, 'buy-goal');
      expect(purchased.balance, wallet);
      expect(purchased.savedFor(goal.id), 0);
      expect(purchased.savings, 0);
      expect(purchased.transactions.last.kind, TransactionKind.wantPurchase);
      expect(purchased.transactions.last.referenceId, goal.id);
      expect(purchased.transactions.last.amount, goal.price);
      expect(
        purchased.transactions[purchased.transactions.length - 2].kind,
        TransactionKind.withdrawal,
      );
      expect(purchased.feedback, contains('из накоплений'));
      expect(
        identical(
          purchased,
          EconomyRules.purchaseGoal(purchased, goal, 'buy-goal'),
        ),
        isTrue,
      );
      expect(
        () => EconomyRules.purchaseGoal(purchased, goal, 'buy-again'),
        throwsA(isA<GameRuleException>()),
      );
    },
  );

  test(
    'Резерв отделён от цели, перевод обратим и повтор команды безопасен',
    () {
      profile = EconomyRules.selectGoal(profile, catalog.goal('tent'));
      profile = EconomyRules.transfer(
        profile,
        catalog.goal('tent'),
        20,
        commandId: 'goal-save',
        withdraw: false,
      );
      final beforeGoal = profile.savedFor('tent');
      profile = EconomyRules.transferReserve(
        profile,
        30,
        commandId: 'reserve-save',
        withdraw: false,
      );
      expect(profile.balance, 50);
      expect(profile.savings, 50);
      expect(profile.reserveSavings, 30);
      expect(profile.savedFor('tent'), beforeGoal);
      expect(
        identical(
          profile,
          EconomyRules.transferReserve(
            profile,
            30,
            commandId: 'reserve-save',
            withdraw: false,
          ),
        ),
        isTrue,
      );
      expect(
        () => EconomyRules.transferReserve(
          profile,
          31,
          commandId: 'too-much',
          withdraw: true,
        ),
        throwsA(isA<GameRuleException>()),
      );
      profile = EconomyRules.transferReserve(
        profile,
        10,
        commandId: 'reserve-take',
        withdraw: true,
      );
      expect(profile.balance, 60);
      expect(profile.savings, 40);
      expect(profile.reserveSavings, 20);
      expect(profile.savedFor('tent'), beforeGoal);
      expect(profile.transactions.last.referenceId, GameProfile.reserveId);
    },
  );
}
