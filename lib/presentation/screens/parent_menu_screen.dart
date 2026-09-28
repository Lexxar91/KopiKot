import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/daily_summary.dart';
import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';
import 'adult_screen.dart';
import 'daily_summary_screen.dart';
import 'progress_screen.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

/// Меню после барьера взрослого: обзор без решений за ребёнка.
class ParentMenuScreen extends ConsumerWidget {
  const ParentMenuScreen({super.key});

  Future<void> _switchProfile(
    BuildContext context,
    WidgetRef ref,
    bool testProfile,
  ) async {
    final saved = await showAccessibleDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameActionDialog(
        title: testProfile
            ? 'Вернуться в обычный профиль?'
            : 'Открыть тестовый профиль?',
        description:
            'Оба сохранения останутся на устройстве. '
            '${testProfile ? 'Если обычного питомца ещё нет, откроется знакомство.' : 'При первом входе создаётся Финни Тест со 100 стартовыми и 10 ежедневными коткоинами, целью «Беговая дорожка» и пустым прогрессом. Повторный вход продолжает тестовую игру.'}',
        confirmLabel: 'Подтвердить',
        action: (_) => ref
            .read(gameControllerProvider.notifier)
            .switchProfile(testProfile: !testProfile),
      ),
    );
    if (saved == true && context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    final catalog = ref.watch(gameCatalogProvider).asData?.value;
    final tasks = catalog?.tasks ?? [];
    final completed =
        profile?.taskProgress.where((item) => item.completed).length ?? 0;
    final summary = profile == null ? null : DailySummary.fromProfile(profile);
    final compact =
        MediaQuery.sizeOf(context).height < 850 &&
        MediaQuery.textScalerOf(context).scale(1) < 1.25;
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
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 17),
                  children: [
                    Row(
                      children: [
                        const Expanded(child: StoryLogo(height: 50)),
                        const SizedBox(width: 7),
                        _panel(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.lock_rounded,
                                color: Color(0xFFE6A400),
                                size: 27,
                              ),
                              SizedBox(width: 4),
                              SizedBox(
                                width: 90,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Раздел\nдля родителей',
                                    style: TextStyle(
                                      color: _brown,
                                      fontSize: 12,
                                      height: 1.05,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Material(
                          color: const Color(0xFF08A99D),
                          shape: const CircleBorder(
                            side: BorderSide(color: Colors.white, width: 2),
                          ),
                          child: IconButton(
                            tooltip: 'Назад',
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Родительское меню',
                                  style: TextStyle(
                                    color: _brown,
                                    fontSize: compact ? 26 : 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const Text(
                                'Учебный прогресс ребёнка',
                                style: TextStyle(
                                  color: Color(0xFF566174),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    _panel(
                      child: Row(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: compact ? 50 : 58,
                              height: compact ? 50 : 58,
                              child: PetPortrait(
                                coat: profile?.coat ?? PetCoat.ginger,
                                accessory:
                                    profile?.accessory ?? PetAccessory.scarf,
                                size: compact ? 50 : 58,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                profile == null
                                    ? 'Питомец ещё не создан'
                                    : 'Питомец: ${profile.petName} 🐾',
                                style: const TextStyle(
                                  color: _brown,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    _panel(
                      child: Column(
                        children: [
                          _sectionTitle(
                            context,
                            Icons.bar_chart_rounded,
                            'Учебный прогресс',
                            () => _open(context, const ProgressScreen()),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(
                                width: compact ? 94 : 112,
                                height: compact ? 94 : 112,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox.expand(
                                      child: CircularProgressIndicator(
                                        value: tasks.isEmpty
                                            ? 0
                                            : completed / tasks.length,
                                        strokeWidth: 9,
                                        color: const Color(0xFF0CBA9D),
                                        backgroundColor: const Color(
                                          0xFFE9E5E2,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '$completed из ${tasks.length}\nзаданий',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: _brown,
                                        fontSize: 17,
                                        height: 1.1,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              for (final topic in const [
                                (
                                  'Планирование',
                                  'Бюджет',
                                  'assets/images/quest_budget.png',
                                ),
                                (
                                  'Покупки',
                                  'Покупки',
                                  'assets/images/quest_purchases.png',
                                ),
                                (
                                  'Сбережения',
                                  'Накопления',
                                  'assets/images/quest_savings.png',
                                ),
                              ])
                                Expanded(
                                  child: _topic(
                                    topic.$2,
                                    topic.$3,
                                    tasks
                                        .where(
                                          (task) =>
                                              task.topic == topic.$1 &&
                                              profile?.completedTask(task.id) ==
                                                  true,
                                        )
                                        .length,
                                    tasks
                                        .where((task) => task.topic == topic.$1)
                                        .length,
                                    compact,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    _panel(
                      child: Column(
                        children: [
                          _sectionTitle(
                            context,
                            Icons.monetization_on_rounded,
                            'Итоги периода',
                            () => _open(context, const DailySummaryScreen()),
                            trailing: 'За последние задания',
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              _metric(
                                'Заработано',
                                summary?.earned ?? 0,
                                'assets/images/cat_coin.png',
                                const Color(0xFF00A887),
                              ),
                              _metric(
                                'Потрачено',
                                summary?.spent ?? 0,
                                'assets/images/quest_purchases.png',
                                const Color(0xFFE84851),
                              ),
                              _metric(
                                'Отложено',
                                summary?.saved ?? 0,
                                'assets/images/budget_savings.png',
                                const Color(0xFFE09B00),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    _menuRow(
                      context,
                      Icons.bar_chart_rounded,
                      const Color(0xFF06B79D),
                      'История и прогресс',
                      'Задания, результаты и активность',
                      () => _open(context, const ProgressScreen()),
                    ),
                    const SizedBox(height: 4),
                    _menuRow(
                      context,
                      Icons.lightbulb_rounded,
                      const Color(0xFF8939D9),
                      'Как работает игра',
                      'Правила, темы и советы для родителей',
                      () => _open(context, const AdultScreen()),
                    ),
                    const SizedBox(height: 4),
                    _menuRow(
                      context,
                      Icons.play_arrow_rounded,
                      const Color(0xFFFF8D29),
                      'Демонстрационный режим',
                      'Посмотрите, как устроена игра',
                      () => _switchProfile(
                        context,
                        ref,
                        profile?.isTest ?? false,
                      ),
                    ),
                    const SizedBox(height: 7),
                    _panel(
                      child: const Row(
                        children: [
                          Icon(
                            Icons.verified_user_rounded,
                            color: Color(0xFF1686D9),
                            size: 28,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Коткоины — только игровая валюта.\nПокупок за реальные деньги нет.',
                              style: TextStyle(
                                color: _brown,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF26D4BD), Color(0xFF008E89)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Вернуться к игре'),
                        style: FilledButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size.fromHeight(54),
                          textStyle: const TextStyle(
                            fontSize: 21,
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

  static void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  static Widget _panel({required Widget child, EdgeInsets? padding}) =>
      Container(
        padding: padding ?? const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: _cream,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x553A5A25),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: child,
      );

  static Widget _sectionTitle(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    String? trailing,
  }) => InkWell(
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFFF06528), size: 24),
        const SizedBox(width: 6),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                color: _brown,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        if (trailing != null)
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                trailing,
                style: const TextStyle(
                  color: Color(0xFF596375),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        const Icon(Icons.chevron_right_rounded, color: Color(0xFFC18C65)),
      ],
    ),
  );

  static Widget _topic(
    String title,
    String image,
    int done,
    int total,
    bool compact,
  ) => Column(
    children: [
      Container(
        width: compact ? 59 : 72,
        height: compact ? 59 : 72,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFE8FFF1),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Image.asset(image, fit: BoxFit.contain),
      ),
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: const TextStyle(
            color: _brown,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var index = 0; index < total; index++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: CircleAvatar(
                radius: 4,
                backgroundColor: index < done
                    ? const Color(0xFF0DBA9C)
                    : const Color(0xFFDCD7D3),
              ),
            ),
        ],
      ),
    ],
  );

  static Widget _metric(String label, int value, String image, Color color) =>
      Expanded(
        child: Column(
          children: [
            Image.asset(image, height: 47, fit: BoxFit.contain),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  color: _brown,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              '$value',
              style: TextStyle(
                color: color,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );

  static Widget _menuRow(
    BuildContext context,
    IconData icon,
    Color color,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) => Material(
    color: _cream,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 29),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: _brown,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF5C6574),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFC18C65)),
          ],
        ),
      ),
    ),
  );
}
