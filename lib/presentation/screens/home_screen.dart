import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/rules/game_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/adult_access_button.dart';
import '../widgets/home_scene.dart';
import '../widgets/home_section_navigation.dart';
import 'accountant_screen.dart';
import 'budget_screen.dart';
import 'daily_reward_screen.dart';
import 'daily_summary_screen.dart';
import 'garden_screen.dart';
import 'help_screen.dart';
import 'history_screen.dart';
import 'market_game_screen.dart';
import 'progress_screen.dart';
import 'savings_screen.dart';
import 'shop_screen.dart';
import 'tasks_screen.dart';
import 'vet_screen.dart';
import 'wardrobe_screen.dart';

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
    final suggestedGoal = catalog?.goal('tree_bank');
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
      goalTitle: goal?.title ?? 'Дерево-копилка',
      goalSaved: goal == null ? 0 : profile.savedFor(goal.id),
      goalPrice: goal?.price ?? 400,
      needsVetVisit: needsVetVisit,
      onGarden: () => open(const GardenScreen()),
      onShop: () => open(const ShopScreen()),
      onVet: () => open(const VetScreen()),
      onTasks: () => open(const TasksScreen()),
      onWalk: () => _walk(context, ref),
      onSavings: () => open(const SavingsScreen()),
      onReward: () => open(const DailyRewardScreen()),
    );
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
