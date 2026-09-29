import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/rules/game_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/adult_access_button.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/home_scene.dart';
import '../widgets/home_section_navigation.dart';
import 'accountant_screen.dart';
import 'badges_screen.dart';
import 'budget_screen.dart';
import 'daily_reward_screen.dart';
import 'daily_tip_screen.dart';
import 'daily_summary_screen.dart';
import 'garden_screen.dart';
import 'help_screen.dart';
import 'history_screen.dart';
import 'market_game_screen.dart';
import 'progress_screen.dart';
import 'savings_screen.dart';
import 'shop_screen.dart';
import 'story_screen.dart';
import 'tasks_screen.dart';
import 'vet_screen.dart';
import 'wardrobe_screen.dart';

enum _DemoAction { nextDay, exit }

/// Связывает игровую сцену с сохранённым профилем и разделами приложения.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({required this.profile, super.key});
  final GameProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(gameCatalogProvider).asData?.value;
    final selectedGoal = profile.selectedGoalId == null || catalog == null
        ? null
        : catalog.goal(profile.selectedGoalId!);
    final suggestedGoal = catalog?.goal('tent');
    final goal = selectedGoal ?? suggestedGoal;
    final vetVisits = profile.transactions
        .where((entry) => entry.referenceId == 'vet_checkup')
        .toList();
    final lastVetPeriod = vetVisits.isEmpty ? null : vetVisits.last.period;
    final needsVetVisit = lastVetPeriod == null
        ? profile.period >= 3
        : profile.period - lastVetPeriod >= 3;

    void open(Widget screen) => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => screen));

    final sections = [
      HomeSection(
        title: 'Игры',
        shortTitle: 'Игры',
        icon: Icons.sports_esports_rounded,
        color: const Color(0xFF862BB6),
        destinations: [
          HomeDestination(
            title: 'Бухгалтер',
            icon: Icons.calculate_rounded,
            onTap: () => open(const AccountantScreen()),
          ),
          HomeDestination(
            title: 'Котомаркет',
            icon: Icons.shopping_basket_rounded,
            onTap: () => open(const MarketGameScreen()),
          ),
        ],
      ),
      HomeSection(
        title: 'Учимся',
        shortTitle: 'Учимся',
        icon: Icons.school_rounded,
        color: const Color(0xFF1D5CB4),
        destinations: [
          HomeDestination(
            title: 'Задания',
            icon: Icons.auto_stories_rounded,
            onTap: () => open(const TasksScreen()),
          ),
          HomeDestination(
            title: 'Прогресс',
            icon: Icons.insights_rounded,
            onTap: () => open(const ProgressScreen()),
          ),
        ],
      ),
      HomeSection(
        title: 'Забота о котике',
        shortTitle: 'Котик',
        icon: Icons.pets_rounded,
        color: const Color(0xFF087F82),
        destinations: [
          HomeDestination(
            title: 'Ветеринар',
            icon: Icons.medical_services_rounded,
            onTap: () => open(const VetScreen()),
          ),
          HomeDestination(
            title: 'Еда и уход',
            icon: Icons.restaurant_rounded,
            onTap: () => open(const ShopScreen()),
          ),
          HomeDestination(
            title: 'Гардероб',
            icon: Icons.checkroom_rounded,
            onTap: () => open(const WardrobeScreen()),
          ),
          HomeDestination(
            title: 'Котодерево',
            icon: Icons.park_rounded,
            onTap: () => open(const GardenScreen()),
          ),
        ],
      ),
      HomeSection(
        title: 'Планы',
        shortTitle: 'Планы',
        icon: Icons.track_changes_rounded,
        color: const Color(0xFFA95A00),
        destinations: [
          HomeDestination(
            title: 'Бюджет',
            icon: Icons.pie_chart_rounded,
            onTap: () => open(const BudgetScreen()),
          ),
          HomeDestination(
            title: 'Накопления',
            icon: Icons.savings_rounded,
            onTap: () => open(const SavingsScreen()),
          ),
        ],
      ),
      HomeSection(
        title: 'Ещё',
        shortTitle: 'Ещё',
        icon: Icons.more_horiz_rounded,
        color: const Color(0xFF586C98),
        destinations: [
          HomeDestination(
            title: 'Итог дня',
            icon: Icons.insights_rounded,
            onTap: () => open(const DailySummaryScreen()),
          ),
          HomeDestination(
            title: 'История',
            icon: Icons.receipt_long_rounded,
            onTap: () => open(const HistoryScreen()),
          ),
          HomeDestination(
            title: 'Как играть',
            icon: Icons.help_outline_rounded,
            onTap: () => open(const HelpScreen()),
          ),
          HomeDestination(
            title: 'Для взрослых',
            icon: Icons.lock_outline_rounded,
            onTap: () => openAdultSection(context),
          ),
        ],
      ),
    ];

    return HomeScene(
      profile: profile,
      sections: sections,
      goalTitle: goal?.title ?? 'Беговая дорожка',
      goalSaved: goal == null
          ? 0
          : profile.purchasedGoal(goal.id)
          ? goal.price
          : profile.savedFor(goal.id),
      goalPrice: goal?.price ?? 400,
      needsVetVisit: needsVetVisit,
      onGarden: () => open(const GardenScreen()),
      onShop: () => open(const ShopScreen()),
      onVet: () => open(const VetScreen()),
      onTasks: () => open(const TasksScreen()),
      onDemo: () => _demo(context, ref, profile),
      onWalk: () => _walk(context, ref),
      onBadges: () => open(const BadgesScreen()),
      onDailyTip: () => open(DailyTipScreen(dayKey: profile.dayKey)),
      onStory: () => open(const StoryScreen()),
      onSavings: () => open(const SavingsScreen()),
      onReward: () => open(const DailyRewardScreen()),
    );
  }

  Future<void> _demo(
    BuildContext context,
    WidgetRef ref,
    GameProfile profile,
  ) async {
    if (!profile.isTest) {
      await showAccessibleDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => GameActionDialog(
          title: 'Перейти в демо-режим?',
          description:
              'Откроется отдельный тестовый профиль с 1000 коткоинов и доступом ко всем целям. '
              'Предыдущее демосохранение будет сброшено; обычный профиль останется без изменений. '
              'Игровые дни можно переключать вручную.',
          confirmLabel: 'Открыть демо',
          action: (_) => ref.read(gameControllerProvider.notifier).startDemo(),
        ),
      );
      return;
    }

    final choice = await showAccessibleDialog<_DemoAction>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Демо-режим'),
        content: const Text(
          'Можно сразу перейти к следующему игровому дню или вернуться к обычному питомцу.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, _DemoAction.exit),
            child: const Text('Обычный профиль'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, _DemoAction.nextDay),
            child: const Text('Следующий день'),
          ),
        ],
      ),
    );
    if (choice == null || !context.mounted) return;
    try {
      switch (choice) {
        case _DemoAction.nextDay:
          await ref
              .read(gameControllerProvider.notifier)
              .finishPeriod(profile.period);
          break;
        case _DemoAction.exit:
          await ref
              .read(gameControllerProvider.notifier)
              .switchProfile(testProfile: false);
          break;
      }
    } on GameRuleException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось переключить демо-режим.')),
        );
      }
    }
  }

  Future<void> _walk(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(gameControllerProvider.notifier).walk();
    } on GameRuleException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Прогулка пока не сохранилась. Попробуй ещё раз.'),
          ),
        );
      }
    }
  }
}
