import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/adult_access_button.dart';
import 'budget_screen.dart';
import 'help_screen.dart';
import 'shop_screen.dart';
import 'savings_screen.dart';
import 'history_screen.dart';
import 'tasks_screen.dart';
import 'progress_screen.dart';

/// Первый игровой экран: питомец, доход, состояние и следующий доступный шаг.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({required this.profile, super.key});
  final GameProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(gameCatalogProvider).asData?.value;
    final activeTask = catalog?.tasks
        .where((task) => !profile.completedTask(task.id))
        .firstOrNull;
    final goal = catalog == null || profile.selectedGoalId == null
        ? null
        : catalog.goal(profile.selectedGoalId!);
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.petName),
        actions: [
          const AdultAccessButton(),
          IconButton(
            tooltip: 'Как играть',
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const HelpScreen())),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (profile.isTest)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('Тестовый профиль · отдельное сохранение'),
                  ),
                Text(
                  'Период ${profile.period} · ${profile.growthLabel}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.toll_outlined),
                      label: Text('Баланс: ${profile.balance}'),
                    ),
                    Chip(
                      avatar: const Icon(Icons.savings_outlined),
                      label: Text('Накопления: ${profile.savings}'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: PetPortrait(
                    coat: profile.coat,
                    accessory: profile.accessory,
                    size: 155,
                    stage: profile.growthStage,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Сытость: ${profile.satiety}/100 · Настроение: ${profile.mood}/100',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  goal == null
                      ? 'Мечта пока не выбрана'
                      : '${goal.title}: ${profile.savedFor(goal.id)} из ${goal.price}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  activeTask == null
                      ? 'Все задания пройдены'
                      : 'Задание: ${activeTask.title}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Semantics(
                  liveRegion: true,
                  child: Text(profile.feedback, textAlign: TextAlign.center),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '+${profile.incomeAmount} монет',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(profile.incomeSource),
                        const SizedBox(height: 8),
                        const Text(
                          'Подарок начислен один раз. Все изменения — в истории монет.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.plan == null
                      ? 'Первое решение — составить план'
                      : 'Первый план сохранён',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  profile.plan == null
                      ? 'Сколько оставить на нужное, желаемое и мечту?'
                      : 'План — это намерение. Монеты остаются на балансе до покупки или перевода.',
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const BudgetScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.pie_chart_outline),
                  label: Text(
                    profile.plan == null
                        ? 'Составить бюджет'
                        : 'Посмотреть бюджет',
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const ShopScreen()),
                  ),
                  icon: const Icon(Icons.shopping_basket_outlined),
                  label: const Text('Покупки'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SavingsScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.savings_outlined),
                  label: const Text('На мечту'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const HistoryScreen(),
                    ),
                  ),
                  child: const Text('История монет'),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const TasksScreen(),
                    ),
                  ),
                  child: const Text('Задания'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProgressScreen(),
                    ),
                  ),
                  child: const Text('Наш прогресс'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
