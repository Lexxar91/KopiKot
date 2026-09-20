import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_controller.dart';

/// Объясняет рост и показывает неизменяемые итоги завершённых периодов.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    final catalog = ref.watch(gameCatalogProvider).asData?.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Наш прогресс')),
      body: profile == null
          ? const Center(child: Text('Сначала создай питомца.'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  profile.growthLabel,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text('Периодов для роста: ${profile.growthPeriods}'),
                const SizedBox(height: 12),
                const Text(
                  'Питомец растёт, когда в нескольких периодах сделаны нужные покупки, траты укладываются в план и на мечту отложено не меньше плана. '
                  'Два таких периода — Исследователь, четыре — Опытный друг. Достигнутый рост не теряется.',
                ),
                const SizedBox(height: 20),
                Text(
                  'Выполнено заданий: ${profile.taskProgress.where((entry) => entry.completed).length} из ${catalog?.tasks.length ?? 0}',
                ),
                for (final task in catalog?.tasks ?? [])
                  if (profile.completedTask(task.id))
                    Text('✓ ${task.topic}: ${task.title}'),
                const SizedBox(height: 20),
                if (profile.periodSummaries.isEmpty)
                  const Text(
                    'Итоги появятся после завершения первого периода.',
                  ),
                for (final summary in profile.periodSummaries.reversed)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Период ${summary.period}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'Нужно: план ${summary.plannedNeeds}, факт ${summary.actualNeeds}',
                          ),
                          Text(
                            'Хочется: план ${summary.plannedWants}, факт ${summary.actualWants}',
                          ),
                          Text(
                            'На мечту: план ${summary.plannedSavings}, факт ${summary.netSaved}',
                          ),
                          const SizedBox(height: 8),
                          Text(summary.explanation),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
