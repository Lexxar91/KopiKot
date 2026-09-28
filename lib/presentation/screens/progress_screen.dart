import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../../domain/models/period_summary.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';
import 'tasks_screen.dart';

const _ink = Color(0xFF552419);
const _cream = Color(0xFFFFFAEB);

/// Показывает выполненные задания, цель и итог последнего игрового периода.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    final catalog = ref.watch(gameCatalogProvider).asData?.value;
    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('Сначала создай питомца.')),
      );
    }
    final goal = catalog?.goal(profile.selectedGoalId ?? 'tent');
    final saved = goal == null ? 0 : profile.savedFor(goal.id);
    final total = catalog?.tasks.length ?? 0;
    final completed =
        catalog?.tasks.where((task) => profile.completedTask(task.id)).length ??
        0;
    final summary = profile.periodSummaries.lastOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFF88C9F6),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fairytale_background.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 5, 12, 20),
                  children: [
                    Row(
                      children: [
                        const Expanded(child: StoryLogo(height: 49)),
                        const SizedBox(width: 8),
                        _panel(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/cat_coin.png',
                                width: 37,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${profile.balance}',
                                style: const TextStyle(
                                  color: _ink,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const CircleAvatar(
                                radius: 16,
                                backgroundColor: Color(0xFF00AD78),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        IconButton.filled(
                          tooltip: 'Назад',
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFA42CE8),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(52, 52),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _panel(
                            child: const Row(
                              children: [
                                CircleAvatar(
                                  radius: 19,
                                  backgroundColor: Color(0xFFA42CE8),
                                  child: Icon(
                                    Icons.emoji_events_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 7),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Мой прогресс',
                                      style: TextStyle(
                                        color: _ink,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 142,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: PetPortrait(
                              coat: profile.coat,
                              accessory:
                                  profile.accessory ?? PetAccessory.scarf,
                              size: 140,
                              emotion: PetEmotion.happy,
                            ),
                          ),
                          Positioned(
                            right: 5,
                            top: 10,
                            child: _panel(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 10,
                              ),
                              child: const Text(
                                'Каждый шаг\nприближает\nк цели!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _ink,
                                  fontSize: 18,
                                  height: 1.08,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _tasksPanel(profile, catalog, completed, total),
                    const SizedBox(height: 9),
                    _goalPanel(goal, saved),
                    const SizedBox(height: 9),
                    _planPanel(summary),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 58,
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const TasksScreen(),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC627),
                          foregroundColor: _ink,
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        icon: Image.asset(
                          'assets/images/cat_coin.png',
                          width: 34,
                        ),
                        label: const Text(
                          'К заданиям ❯',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tasksPanel(
    GameProfile profile,
    GameCatalog? catalog,
    int completed,
    int total,
  ) => _panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.assignment_rounded, color: Color(0xFFFF7518), size: 28),
            SizedBox(width: 6),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Задания',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Text(
          'Выполни задания и изучай новые темы.',
          style: TextStyle(
            color: Color(0xFF5D6773),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            SizedBox(
              width: 92,
              height: 97,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.square(
                    dimension: 82,
                    child: CircularProgressIndicator(
                      value: total == 0 ? 0 : completed / total,
                      strokeWidth: 8,
                      color: const Color(0xFF1CCA65),
                      backgroundColor: const Color(0xFFE2DFDD),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.assignment_turned_in_rounded,
                        color: Color(0xFF09AC55),
                        size: 27,
                      ),
                      FittedBox(
                        child: Text(
                          '$completed из $total',
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _topic(
              'Бюджет',
              'Планирование',
              'assets/images/quest_badge_plan.png',
              profile,
              catalog,
            ),
            _topic(
              'Покупки',
              'Покупки',
              'assets/images/quest_badge_purchases.png',
              profile,
              catalog,
            ),
            _topic(
              'Копилка',
              'Сбережения',
              'assets/images/quest_badge_savings.png',
              profile,
              catalog,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _topic(
    String title,
    String topic,
    String image,
    GameProfile profile,
    GameCatalog? catalog,
  ) {
    final tasks =
        catalog?.tasks.where((task) => task.topic == topic).toList() ?? [];
    return Expanded(
      child: Column(
        children: [
          Image.asset(image, width: 52, height: 54, fit: BoxFit.contain),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: const TextStyle(
                color: _ink,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final task in tasks)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Icon(
                    profile.completedTask(task.id)
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: profile.completedTask(task.id)
                        ? const Color(0xFF00A965)
                        : const Color(0xFFC8C8C8),
                    size: 17,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _goalPanel(GoalDefinition? goal, int saved) {
    final price = goal?.price ?? 400;
    final remaining = math.max(0, price - saved);
    final image = switch (goal?.id) {
      'telescope' => 'assets/images/savings_bed.png',
      'garden' => 'assets/images/savings_rare_sapling.png',
      'tree_bank' => 'assets/images/home_coin_tree.png',
      _ => 'assets/images/savings_treadmill.png',
    };
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.track_changes_rounded,
                color: Color(0xFFEC542B),
                size: 28,
              ),
              SizedBox(width: 5),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Моя цель',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset(image, width: 90, height: 96, fit: BoxFit.contain),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        goal?.title ?? 'Беговая дорожка',
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: price == 0 ? 0 : (saved / price).clamp(0, 1),
                      minHeight: 13,
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF00C6C2),
                      backgroundColor: const Color(0xFFE9D8C2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$saved / $price',
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              SizedBox(
                width: 75,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Осталось:',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$remaining',
                          style: const TextStyle(
                            color: Color(0xFFE34D21),
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _planPanel(PeriodSummary? summary) => _panel(
    child: Column(
      children: [
        const Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: Color(0xFFFF7B19), size: 28),
            SizedBox(width: 5),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'План и результат',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (summary == null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 17),
            child: Text(
              'Итоги появятся после завершения первого периода.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        else ...[
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.circle, size: 13, color: Color(0xFF268BF2)),
              Text(' План  ', style: TextStyle(color: _ink, fontSize: 12)),
              Icon(Icons.circle, size: 13, color: Color(0xFF00C66C)),
              Text(' Получилось', style: TextStyle(color: _ink, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 5),
          _planRow(
            'Нужное',
            'assets/images/budget_needs.png',
            summary.plannedNeeds,
            summary.actualNeeds,
            const Color(0xFFE5F3FF),
          ),
          _planRow(
            'Радость',
            'assets/images/budget_joy.png',
            summary.plannedWants,
            summary.actualWants,
            const Color(0xFFFFEAF0),
          ),
          _planRow(
            'Копилка',
            'assets/images/budget_savings.png',
            summary.plannedSavings,
            summary.netSaved,
            const Color(0xFFFFF3D7),
          ),
          const SizedBox(height: 7),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFECA7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${summary.needsMet ? 'На нужное хватило' : 'На нужное пока не хватило'}, на цель отложено ${math.max(0, summary.netSaved)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _ink,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ],
    ),
  );

  Widget _planRow(
    String title,
    String image,
    int planned,
    int actual,
    Color tint,
  ) {
    final scale = math.max(1, math.max(planned, actual));
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Image.asset(image, width: 42, height: 42, fit: BoxFit.contain),
          const SizedBox(width: 3),
          SizedBox(
            width: 75,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _valueBar(planned, scale, const Color(0xFF268BF2)),
                const SizedBox(height: 4),
                _valueBar(actual, scale, const Color(0xFF00C66C)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _valueBar(int value, int scale, Color color) => Row(
    children: [
      Expanded(
        child: LinearProgressIndicator(
          value: (value / scale).clamp(0, 1),
          minHeight: 10,
          borderRadius: BorderRadius.circular(10),
          color: color,
          backgroundColor: const Color(0xFFD9DFDF),
        ),
      ),
      const SizedBox(width: 5),
      SizedBox(
        width: 25,
        child: Text(
          '$value',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    ],
  );

  Widget _panel({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(10),
  }) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: _cream,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: const [
        BoxShadow(
          color: Color(0x553E1D0A),
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: child,
  );
}
