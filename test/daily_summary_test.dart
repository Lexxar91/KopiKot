import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/models/daily_summary.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/game_transaction.dart';

GameTransaction entry(
  String id,
  TransactionKind kind,
  int amount, {
  int period = 1,
  String? referenceId,
}) => GameTransaction(
  id: id,
  period: period,
  kind: kind,
  amount: amount,
  label: id,
  referenceId: referenceId,
  balanceAfter: 0,
  savingsAfter: 0,
  satietyAfter: 70,
  moodAfter: 70,
);

void main() {
  const profile = GameProfile(
    petName: 'Рут',
    coat: PetCoat.ginger,
    accessory: PetAccessory.scarf,
    balance: 15,
    savings: 20,
    period: 1,
    satiety: 70,
    mood: 70,
    incomeSource: 'Подарок',
    incomeAmount: 60,
  );

  test('Итог дня считает операции без повторного стартового подарка', () {
    final summary = DailySummary.fromProfile(
      profile.copyWith(
        transactions: [
          entry('initial-income', TransactionKind.income, 60),
          entry(
            'food',
            TransactionKind.needPurchase,
            15,
            referenceId: 'porridge',
          ),
          entry(
            'care',
            TransactionKind.needPurchase,
            10,
            referenceId: 'shampoo',
          ),
          entry('dream', TransactionKind.deposit, 20),
        ],
      ),
    );
    expect(summary.earned, 60);
    expect(summary.spent, 25);
    expect(summary.saved, 20);
    expect(summary.remaining, 15);
    expect(summary.food, 15);
    expect(summary.care, 10);
    expect(summary.other, 0);
  });

  test('Итог берёт только текущий период и учитывает другие покупки', () {
    final summary = DailySummary.fromProfile(
      profile.copyWith(
        period: 2,
        balance: 70,
        transactions: [
          entry('initial-income', TransactionKind.income, 60),
          entry('period-income', TransactionKind.income, 100, period: 2),
          entry(
            'toy',
            TransactionKind.wantPurchase,
            20,
            period: 2,
            referenceId: 'ball',
          ),
          entry('plant', TransactionKind.saplingPurchase, 10, period: 2),
          entry('save', TransactionKind.deposit, 5, period: 2),
          entry('take-back', TransactionKind.withdrawal, 5, period: 2),
        ],
      ),
    );
    expect(summary.earned, 100);
    expect(summary.spent, 30);
    expect(summary.saved, 0);
    expect(summary.other, 30);
    expect(summary.remaining, 70);
  });
}
