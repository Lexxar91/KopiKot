import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/goal_medal.dart';
import '../widgets/pet_portrait.dart';

const _badgeInk = Color(0xFF642818);

/// Значки за накопленные цели; состояние берётся из истории профиля.
class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    final catalog = ref.watch(gameCatalogProvider).asData?.value;
    if (profile == null || catalog == null) {
      return const Scaffold(body: Center(child: LoadingStatus()));
    }
    final goals = [
      catalog.goal('tent'),
      catalog.goal('garden'),
      catalog.goal('telescope'),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFF85C9F5),
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
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 22),
                  children: [
                    _BadgeHeader(profile: profile),
                    for (final goal in goals) ...[
                      const SizedBox(height: 10),
                      _GoalBadgeCard(
                        goal: goal,
                        earned: profile.reachedGoal(goal.id, goal.price),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeHeader extends StatelessWidget {
  const _BadgeHeader({required this.profile});

  final GameProfile profile;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 220,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Material(
            color: const Color(0xFFFFBD41),
            elevation: 5,
            shape: const CircleBorder(
              side: BorderSide(color: Colors.white, width: 3),
            ),
            child: IconButton(
              tooltip: 'Назад',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded),
              color: _badgeInk,
              iconSize: 29,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 65,
          right: 0,
          height: 78,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/logo_wood.png',
                  fit: BoxFit.fill,
                ),
              ),
              const Text(
                'Значки',
                style: TextStyle(
                  color: Color(0xFFFFDE59),
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      color: Color(0xFF6B2706),
                      offset: Offset(2, 3),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 83,
          left: 48,
          right: 29,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFFFD27A), width: 2),
              boxShadow: const [
                BoxShadow(color: Color(0x55662D0F), blurRadius: 7),
              ],
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Награды за достигнутые цели',
                style: TextStyle(
                  color: _badgeInk,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -20,
          bottom: -7,
          child: PetPortrait(
            coat: profile.coat,
            accessory: profile.accessory,
            emotion: PetEmotion.happy,
            stage: profile.growthStage,
            size: 150,
          ),
        ),
      ],
    ),
  );
}

class _GoalBadgeCard extends StatelessWidget {
  const _GoalBadgeCard({required this.goal, required this.earned});

  final GoalDefinition goal;
  final bool earned;

  Color get accent => switch (goal.id) {
    'tent' => const Color(0xFFFFA915),
    'garden' => const Color(0xFF00BD75),
    _ => const Color(0xFF963EDE),
  };

  String get imagePath => switch (goal.id) {
    'tent' => 'assets/images/savings_treadmill.png',
    'garden' => 'assets/images/savings_rare_sapling.png',
    _ => 'assets/images/savings_bed.png',
  };

  @override
  Widget build(BuildContext context) => Semantics(
    label: '${goal.title}. ${earned ? 'Значок получен' : 'Пока не получен'}',
    child: Container(
      height: 153,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFEF1), Color(0xFFFFF0CE)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFFD16D), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x8845220B),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final artWidth = constraints.maxWidth * 0.55;
          return Row(
            children: [
              SizedBox(
                width: artWidth,
                height: 148,
                child: Opacity(
                  opacity: earned ? 1 : 0.55,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 1,
                        top: 13,
                        child: GoalMedal(size: 111, accent: accent),
                      ),
                      Positioned(
                        right: -5,
                        bottom: 0,
                        width: artWidth * 0.72,
                        height: 112,
                        child: Image.asset(imagePath, fit: BoxFit.contain),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 9, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              goal.title,
                              style: const TextStyle(
                                color: _badgeInk,
                                fontSize: 19,
                                height: 1.03,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: earned
                                  ? const Color(0xFF1BD466)
                                  : const Color(0xFFBBB5A9),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              earned ? Icons.check_rounded : Icons.lock_rounded,
                              color: Colors.white,
                              size: 23,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Text(
                        earned
                            ? 'Накоплено\nна ${goal.title.toLowerCase()}'
                            : 'Накопи ${goal.price}\nкоткоинов',
                        style: const TextStyle(
                          color: _badgeInk,
                          fontSize: 14,
                          height: 1.15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
