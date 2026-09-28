import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/models/day_financial_report.dart';
import 'package:kopikot/domain/models/game_transaction.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/domain/rules/period_rules.dart';

import 'game_rules_test.dart' show initialProfile;

void main() {
  GameTransaction transaction(
    String id,
    int period,
    TransactionKind kind,
    int amount,
    String label,
    int wallet,
    int savings,
  ) => GameTransaction(
    id: id,
    period: period,
    kind: kind,
    amount: amount,
    label: label,
    balanceAfter: wallet,
    savingsAfter: savings,
    satietyAfter: 70,
    moodAfter: 70,
  );

  test('Итог дня не считает стартовый подарок доходом и отделяет переводы', () {
    final profile = initialProfile.copyWith(
      period: 2,
      balance: 86,
      savings: 7,
      transactions: [
        transaction(
          'initial-income',
          1,
          TransactionKind.income,
          100,
          'Подарок',
          100,
          0,
        ),
        transaction(
          'daily-1',
          1,
          TransactionKind.income,
          10,
          'Ежедневная награда',
          110,
          0,
        ),
        transaction('food', 1, TransactionKind.needPurchase, 15, 'Корм', 95, 0),
        transaction(
          'toy',
          1,
          TransactionKind.wantPurchase,
          20,
          'Игрушка',
          75,
          0,
        ),
        transaction(
          'save',
          1,
          TransactionKind.deposit,
          10,
          'В копилку',
          65,
          10,
        ),
        transaction(
          'take',
          1,
          TransactionKind.withdrawal,
          3,
          'Из копилки',
          68,
          7,
        ),
        transaction('game', 1, TransactionKind.income, 6, 'Мини-игра', 74, 7),
        transaction(
          'daily-2',
          2,
          TransactionKind.income,
          12,
          'Ежедневная награда',
          86,
          7,
        ),
      ],
    );

    final first = DayFinancialReport.fromProfile(profile, 1);
    expect(first.openingWallet, 100);
    expect(first.openingSavings, 0);
    expect(first.income, 16);
    expect(first.incomeBySource, {'Ежедневная награда': 10, 'Мини-игра': 6});
    expect(first.needs, 15);
    expect(first.wants, 20);
    expect(first.deposits, 10);
    expect(first.withdrawals, 3);
    expect(first.closingWallet, 74);
    expect(first.closingSavings, 7);

    final second = DayFinancialReport.fromProfile(profile, 2);
    expect(second.openingWallet, 74);
    expect(second.openingSavings, 7);
    expect(second.income, 12);
    expect(second.closingWallet, 86);
  });

  test('Прогноз дохода фиксируется в итоге закрываемого дня', () {
    final plan = GameRules.confirmBudget(
      initialProfile,
      needs: 40,
      wants: 20,
      savings: 10,
      expectedIncome: 6,
    );
    final summary = PeriodRules.summarize(initialProfile.withPlan(plan));
    expect(summary.plannedIncome, 6);
  });
}
