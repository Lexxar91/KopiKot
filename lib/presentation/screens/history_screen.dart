import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_controller.dart';

/// Показывает сохранённые события, а не вычисленную задним числом историю.
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
            .reversed
            .toList() ??
        [];
    return Scaffold(
      appBar: AppBar(title: const Text('История монет')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: history.length,
        separatorBuilder: (_, _) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final entry = history[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.label, style: Theme.of(context).textTheme.titleMedium),
              Text(
                'Период ${entry.period} · ${entry.balanceChange > 0 ? '+' : ''}${entry.balanceChange} монет на балансе',
              ),
              Text(
                'После: баланс ${entry.balanceAfter}, накопления ${entry.savingsAfter}',
              ),
              Text(
                'Сытость ${entry.satietyAfter}/100 · настроение ${entry.moodAfter}/100',
              ),
            ],
          );
        },
      ),
    );
  }
}
