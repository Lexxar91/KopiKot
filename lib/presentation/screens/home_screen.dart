import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/models/game_transaction.dart';
import '../providers/game_controller.dart';
import '../widgets/adult_access_button.dart';
import '../widgets/pet_portrait.dart';
import 'budget_screen.dart';
import 'help_screen.dart';
import 'history_screen.dart';
import 'progress_screen.dart';
import 'savings_screen.dart';
import 'shop_screen.dart';
import 'tasks_screen.dart';
import 'wardrobe_screen.dart';

/// Дом питомца объединяет состояние, цель и последовательность решений дня.
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
    final bool boughtSomething =
        profile.actualNeeds + profile.actualWants + profile.actualGifts > 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.petName),
        actions: [
          const AdultAccessButton(),
          IconButton(
            tooltip: 'Как играть',
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => _open(context, const HelpScreen()),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFBF2), Color(0xFFF4F0FF)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  if (profile.isTest)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0C7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Тестовый профиль · отдельное сохранение',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  _PetHero(profile: profile),
                  const SizedBox(height: 20),
                  Text(
                    'Куда отправимся?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  _PrimaryActions(
                    children: [
                      _QuickAction(
                        title: profile.plan == null
                            ? 'Составить бюджет'
                            : 'Посмотреть бюджет',
                        icon: Icons.pie_chart_rounded,
                        color: const Color(0xFFDFF7F2),
                        onTap: () => _open(context, const BudgetScreen()),
                      ),
                      _QuickAction(
                        title: 'Задания',
                        icon: Icons.auto_stories_rounded,
                        color: const Color(0xFFFFE6B7),
                        onTap: () => _open(context, const TasksScreen()),
                      ),
                      _QuickAction(
                        title: 'Покупки',
                        icon: Icons.storefront_rounded,
                        color: const Color(0xFFFFDCE8),
                        onTap: () => _open(context, const ShopScreen()),
                      ),
                      _QuickAction(
                        title: 'На мечту',
                        icon: Icons.park_rounded,
                        color: const Color(0xFFDCEBFF),
                        onTap: () => _open(context, const SavingsScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _ActionsGrid(
                    children: [
                      _ActionCard(
                        title: 'Гардероб',
                        subtitle: 'Надеть или снять вещь',
                        icon: Icons.checkroom_rounded,
                        color: const Color(0xFFEAE1FF),
                        onTap: () => _open(context, const WardrobeScreen()),
                      ),
                      _ActionCard(
                        title: 'История покупок',
                        subtitle: 'Что и когда выбрали',
                        icon: Icons.receipt_long_rounded,
                        color: const Color(0xFFE7F5D6),
                        onTap: () => _open(context, const HistoryScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _StatusCard(
                          icon: Icons.restaurant_rounded,
                          label: 'Сытость',
                          value: profile.satiety,
                          color: const Color(0xFFFF8A65),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatusCard(
                          icon: Icons.sentiment_very_satisfied_rounded,
                          label: 'Радость',
                          value: profile.mood,
                          color: const Color(0xFFFFC857),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _GoalCard(
                    title: goal?.title,
                    saved: goal == null ? 0 : profile.savedFor(goal.id),
                    price: goal?.price,
                    onTap: () => _open(context, const SavingsScreen()),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Путь на сегодня',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Двигайся в своём темпе — любой шаг можно повторить.',
                  ),
                  const SizedBox(height: 12),
                  _DailyPath(
                    planned: profile.plan != null,
                    earned: activeTask == null,
                    bought: boughtSomething,
                    saved: profile.netSaved > 0,
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => _open(context, const ProgressScreen()),
                    icon: const Icon(Icons.insights_rounded),
                    label: const Text('Наш прогресс'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget screen) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => screen));
}

class _PetHero extends StatelessWidget {
  const _PetHero({required this.profile});
  final GameProfile profile;

  @override
  Widget build(BuildContext context) {
    final incomes = profile.transactions
        .where((entry) => entry.kind == TransactionKind.income)
        .toList();
    final latestIncome = incomes.isEmpty ? null : incomes.last;
    final int incomeAmount = latestIncome?.amount ?? profile.incomeAmount;
    final String incomeSource = latestIncome?.label ?? profile.incomeSource;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE7E2FF), Color(0xFFFFE1CF)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(
                icon: Icons.toll_rounded,
                label: 'Баланс: ${profile.balance}',
              ),
              _Pill(
                icon: Icons.auto_awesome_rounded,
                label: 'Период ${profile.period}',
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '+$incomeAmount монет · $incomeSource',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          PetPortrait(
            coat: profile.coat,
            accessory: profile.accessory,
            emotion: profile.emotion,
            size: 190,
            stage: profile.growthStage,
          ),
          Text(
            '${profile.growthLabel} · ${emotionLabels[profile.emotion]}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Semantics(
              liveRegion: true,
              child: Text(profile.feedback, textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.78),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    ),
  );
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 7),
              Expanded(child: Text(label)),
              Text('$value'),
            ],
          ),
          const SizedBox(height: 9),
          LinearProgressIndicator(
            value: value / 100,
            minHeight: 9,
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
        ],
      ),
    ),
  );
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.title,
    required this.saved,
    required this.price,
    required this.onTap,
  });
  final String? title;
  final int saved;
  final int? price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double progress = price == null ? 0 : (saved / price!).clamp(0, 1);
    return Card(
      color: const Color(0xFFE5F4FF),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.savings_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'Выбери мечту питомца',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 7),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      price == null
                          ? 'Начать копить'
                          : '$saved из $price монет',
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyPath extends StatelessWidget {
  const _DailyPath({
    required this.planned,
    required this.earned,
    required this.bought,
    required this.saved,
  });
  final bool planned;
  final bool earned;
  final bool bought;
  final bool saved;

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('План', Icons.pie_chart_outline_rounded, planned),
      ('Заработок', Icons.stars_rounded, earned),
      ('Забота', Icons.favorite_outline_rounded, bought),
      ('Мечта', Icons.park_outlined, saved),
    ];
    return Row(
      children: [
        for (int index = 0; index < steps.length; index++) ...[
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: steps[index].$3
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  foregroundColor: steps[index].$3
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  child: Icon(
                    steps[index].$3 ? Icons.check_rounded : steps[index].$2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  steps[index].$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          if (index < steps.length - 1)
            Container(
              width: 12,
              height: 3,
              margin: const EdgeInsets.only(bottom: 22),
              decoration: BoxDecoration(
                color: const Color(0xFFD5D0DF),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
        ],
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: color,
    margin: EdgeInsets.zero,
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30),
            const Spacer(),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: color,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final bool largeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
      final double width = largeText
          ? constraints.maxWidth
          : (constraints.maxWidth - 8) / 2;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final child in children)
            SizedBox(width: width, height: largeText ? 92 : 66, child: child),
        ],
      );
    },
  );
}

class _ActionsGrid extends StatelessWidget {
  const _ActionsGrid({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final double textScale = MediaQuery.textScalerOf(context).scale(1);
      final bool largeText = textScale > 1.3;
      final double width = largeText
          ? constraints.maxWidth
          : (constraints.maxWidth - 10) / 2;
      final double height = largeText ? 240 : 150;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final child in children)
            SizedBox(width: width, height: height, child: child),
        ],
      );
    },
  );
}
