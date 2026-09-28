import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/story_logo.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

/// Правила игры доступны до создания питомца и из самой игры.
class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                child: ref
                    .watch(helpProvider)
                    .when(
                      loading: () => const Center(child: LoadingStatus()),
                      error: (_, _) => Center(
                        child: FilledButton(
                          onPressed: () => ref.invalidate(helpProvider),
                          child: const Text('Повторить загрузку'),
                        ),
                      ),
                      data: (topics) => ListView(
                        padding: const EdgeInsets.fromLTRB(10, 6, 10, 16),
                        children: [
                          const StoryLogo(height: 49),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Material(
                                color: const Color(0xFF08A99D),
                                shape: const CircleBorder(
                                  side: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  tooltip: 'Назад',
                                  onPressed: () =>
                                      Navigator.of(context).maybePop(),
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _panel(
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.menu_book_rounded,
                                        color: Color(0xFF2166C6),
                                        size: 30,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Как играть',
                                            style: TextStyle(
                                              color: _brown,
                                              fontSize: 29,
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
                            height: compact ? 105 : 140,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 7,
                                  bottom: -2,
                                  child: Image.asset(
                                    'assets/images/orange_kitten.png',
                                    width: compact ? 140 : 175,
                                    height: compact ? 108 : 142,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  right: 12,
                                  top: compact ? 18 : 30,
                                  child: _panel(
                                    child: const Text(
                                      'Давай\nразберёмся!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _brown,
                                        fontSize: 19,
                                        height: 1.05,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          for (
                            var index = 0;
                            index < topics.length;
                            index++
                          ) ...[
                            _card(
                              index,
                              topics[index].title,
                              topics[index].text,
                              compact,
                            ),
                            const SizedBox(height: 6),
                          ],
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
                                    'Коткоины — игровые.\nПокупок за реальные деньги нет.',
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
                                colors: [Color(0xFFFFF467), Color(0xFFFFAE15)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFFFF8F16),
                                width: 2,
                              ),
                            ),
                            child: FilledButton.icon(
                              onPressed: () => Navigator.of(context).maybePop(),
                              icon: const Icon(Icons.pets_rounded),
                              label: const Text('Понятно'),
                              style: FilledButton.styleFrom(
                                foregroundColor: _brown,
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                minimumSize: const Size.fromHeight(54),
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            child: const Text(
                              'Назад',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _panel({required Widget child}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(
      color: _cream,
      borderRadius: BorderRadius.circular(25),
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

  static Widget _card(int index, String title, String text, bool compact) {
    const colors = [
      Color(0xFF8732DD),
      Color(0xFFFF4864),
      Color(0xFF1A9DE1),
      Color(0xFF0AAA72),
    ];
    const images = [
      'assets/images/action_play.png',
      'assets/images/action_feed.png',
      'assets/images/quest_budget.png',
      'assets/images/budget_savings.png',
    ];
    return _panel(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: compact ? 61 : 80),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Image.asset(
              images[index],
              width: compact ? 87 : 105,
              height: compact ? 60 : 79,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      maxLines: 1,
                      style: TextStyle(
                        color: colors[index],
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: _brown,
                      fontSize: 12,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
