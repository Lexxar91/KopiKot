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

  test('Каталог содержит минимум восемь покупок двух типов и три цели', () {
    expect(catalog.products.length, greaterThanOrEqualTo(8));
    expect(catalog.products.map((item) => item.category).toSet().length, 2);
    expect(catalog.goals.length, greaterThanOrEqualTo(3));
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
    profile = EconomyRules.selectGoal(profile, catalog.goal('tent'));
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
    profile = EconomyRules.selectGoal(profile.copyWith(balance: 200), goal);
    profile = EconomyRules.transfer(
      profile,
      goal,
      120,
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
          120,
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
    expect(repeat.savedFor(goal.id), 100);
    expect(repeat.balance + repeat.savings, 200);
  });
}
