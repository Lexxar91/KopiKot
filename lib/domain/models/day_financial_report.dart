import 'game_profile.dart';
import 'game_transaction.dart';

/// Восстанавливает денежный итог дня из неизменяемого журнала операций.
class DayFinancialReport {
  const DayFinancialReport({
    required this.openingWallet,
    required this.openingSavings,
    required this.incomeBySource,
    required this.needs,
    required this.wants,
    required this.gifts,
    required this.saplings,
    required this.deposits,
    required this.withdrawals,
    required this.closingWallet,
    required this.closingSavings,
  });

  factory DayFinancialReport.fromProfile(GameProfile profile, int period) {
    final entries = profile.transactions
        .where((entry) => entry.period == period)
        .toList();
    final previous = profile.transactions
        .where((entry) => entry.period < period)
        .lastOrNull;
    final first = entries.firstOrNull;
    final last = entries.lastOrNull;
    final firstIsStartingGift = first != null && _isStartingGift(first);
    final openingWallet = firstIsStartingGift
        ? first.balanceAfter
        : first != null
        ? first.balanceAfter - first.balanceChange
        : previous?.balanceAfter ?? profile.balance;
    final openingSavings = first == null
        ? previous?.savingsAfter ?? profile.savings
        : first.savingsAfter -
              switch (first.kind) {
                TransactionKind.deposit => first.amount,
                TransactionKind.withdrawal => -first.amount,
                _ => 0,
              };
    final incomeBySource = <String, int>{};
    var needs = 0;
    var wants = 0;
    var gifts = 0;
    var saplings = 0;
    var deposits = 0;
    var withdrawals = 0;
    for (final entry in entries) {
      switch (entry.kind) {
        case TransactionKind.income:
          if (!_isStartingGift(entry)) {
            incomeBySource.update(
              entry.label,
              (amount) => amount + entry.amount,
              ifAbsent: () => entry.amount,
            );
          }
        case TransactionKind.needPurchase:
          needs += entry.amount;
        case TransactionKind.wantPurchase:
          wants += entry.amount;
        case TransactionKind.giftPurchase:
          gifts += entry.amount;
        case TransactionKind.saplingPurchase:
          saplings += entry.amount;
        case TransactionKind.deposit:
          deposits += entry.amount;
        case TransactionKind.withdrawal:
          withdrawals += entry.amount;
      }
    }
    return DayFinancialReport(
      openingWallet: openingWallet,
      openingSavings: openingSavings,
      incomeBySource: Map.unmodifiable(incomeBySource),
      needs: needs,
      wants: wants,
      gifts: gifts,
      saplings: saplings,
      deposits: deposits,
      withdrawals: withdrawals,
      closingWallet: last?.balanceAfter ?? openingWallet,
      closingSavings: last?.savingsAfter ?? openingSavings,
    );
  }

  static bool _isStartingGift(GameTransaction entry) =>
      entry.id == 'initial-income' || entry.id.startsWith('period-income-');

  final int openingWallet;
  final int openingSavings;
  final Map<String, int> incomeBySource;
  final int needs;
  final int wants;
  final int gifts;
  final int saplings;
  final int deposits;
  final int withdrawals;
  final int closingWallet;
  final int closingSavings;

  int get income => incomeBySource.values.fold(0, (sum, value) => sum + value);
  int get purchases => needs + wants + gifts + saplings;
  int get netSaved => deposits - withdrawals;
}
