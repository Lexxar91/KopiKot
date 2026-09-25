import 'dart:math' as math;

import 'game_profile.dart';
import 'game_transaction.dart';

/// Итог текущего игрового периода, который на экране называется днём.
///
/// Использует сохранённые операции, а не примерные числа из макета.
class DailySummary {
  const DailySummary({
    required this.earned,
    required this.spent,
    required this.saved,
    required this.remaining,
    required this.food,
    required this.care,
    required this.other,
  });

  factory DailySummary.fromProfile(GameProfile profile) {
    var earned = 0;
    var food = 0;
    var care = 0;
    var other = 0;
    var deposits = 0;
    var withdrawals = 0;
    var hasInitialIncome = false;

    for (final transaction in profile.transactions) {
      if (transaction.period != profile.period) continue;
      switch (transaction.kind) {
        case TransactionKind.income:
          earned += transaction.amount;
          hasInitialIncome |= transaction.id == 'initial-income';
        case TransactionKind.needPurchase:
          if (const {
            'porridge',
            'water',
            'soup',
          }.contains(transaction.referenceId)) {
            food += transaction.amount;
          } else if (const {
            'shampoo',
            'vet_checkup',
          }.contains(transaction.referenceId)) {
            care += transaction.amount;
          } else {
            other += transaction.amount;
          }
        case TransactionKind.wantPurchase:
        case TransactionKind.giftPurchase:
        case TransactionKind.saplingPurchase:
          other += transaction.amount;
        case TransactionKind.deposit:
          deposits += transaction.amount;
        case TransactionKind.withdrawal:
          withdrawals += transaction.amount;
      }
    }

    // Старые и тестовые профили могут не хранить стартовый подарок как операцию.
    if (profile.period == 1 && !hasInitialIncome) {
      earned += profile.incomeAmount;
    }

    return DailySummary(
      earned: earned,
      spent: food + care + other,
      saved: math.max(0, deposits - withdrawals),
      remaining: profile.balance,
      food: food,
      care: care,
      other: other,
    );
  }

  final int earned;
  final int spent;
  final int saved;
  final int remaining;
  final int food;
  final int care;
  final int other;
}
