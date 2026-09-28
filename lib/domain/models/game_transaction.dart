enum TransactionKind {
  income,
  needPurchase,
  wantPurchase,
  giftPurchase,
  saplingPurchase,
  deposit,
  withdrawal,
}

/// Неизменяемое событие: источник, суммы и результат сохраняются вместе с балансом.
class GameTransaction {
  const GameTransaction({
    required this.id,
    required this.period,
    required this.kind,
    required this.amount,
    required this.label,
    required this.balanceAfter,
    required this.savingsAfter,
    required this.satietyAfter,
    required this.moodAfter,
    this.referenceId,
    this.startSatiety,
    this.startEnergy,
    this.startMood,
    this.baseReward,
  });
  final String id;
  final int period;
  final TransactionKind kind;
  final int amount;
  final String label;
  final String? referenceId;
  final int? startSatiety;
  final int? startEnergy;
  final int? startMood;
  final int? baseReward;
  final int balanceAfter;
  final int savingsAfter;
  final int satietyAfter;
  final int moodAfter;

  int get balanceChange => switch (kind) {
    TransactionKind.income || TransactionKind.withdrawal => amount,
    _ => -amount,
  };
}
