import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_transaction.dart';
import '../providers/game_controller.dart';

/// Показывает только покупки; доход и переводы не смешиваются с выбором товаров.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history =
        ref
            .watch(gameControllerProvider)
            .asData
            ?.value
            ?.transactions
            .where(
              (entry) => const {
                TransactionKind.needPurchase,
                TransactionKind.wantPurchase,
                TransactionKind.giftPurchase,
              }.contains(entry.kind),
            )
            .toList()
            .reversed
            .toList() ??
        [];
    return Scaffold(
      appBar: AppBar(title: const Text('История покупок')),
      body: history.isEmpty
          ? ListView(
              padding: const EdgeInsets.all(32),
              children: const [
                SizedBox(height: 120),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 56),
                    SizedBox(height: 12),
                    Text(
                      'Покупок пока нет',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'После выбора в Котомаркете здесь появятся цена и результат.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: history.length,
              separatorBuilder: (_, _) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final entry = history[index];
                final (String, IconData) category = switch (entry.kind) {
                  TransactionKind.needPurchase => (
                    'Нужно',
                    Icons.favorite_outline,
                  ),
                  TransactionKind.wantPurchase => (
                    'Хочется',
                    Icons.celebration_outlined,
                  ),
                  TransactionKind.giftPurchase => (
                    'Подарки',
                    Icons.redeem_outlined,
                  ),
                  _ => ('Покупка', Icons.shopping_bag_outlined),
                };
                return Card(
                  child: ListTile(
                    minVerticalPadding: 14,
                    leading: CircleAvatar(child: Icon(category.$2)),
                    title: Text(entry.label),
                    subtitle: Text(
                      '${category.$1} · период ${entry.period}\n'
                      'После покупки осталось ${entry.balanceAfter} монет',
                    ),
                    trailing: Text(
                      '−${entry.amount}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
