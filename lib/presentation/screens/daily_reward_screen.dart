import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/rules/daily_reward_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';
import 'tasks_screen.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

/// Линейка наград и отдельное подтверждение получения за сегодняшний день.
class DailyRewardScreen extends ConsumerStatefulWidget {
  const DailyRewardScreen({super.key});

  @override
  ConsumerState<DailyRewardScreen> createState() => _DailyRewardScreenState();
}

class _DailyRewardScreenState extends ConsumerState<DailyRewardScreen> {
  bool _claiming = false;
  String? _message;

  Future<void> _claim(GameProfile profile) async {
    if (_claiming || !DailyRewardRules.canClaim(profile)) return;
    final amount =
        DailyRewardRules.ladder[DailyRewardRules.rewardLevel(profile) - 1];
    setState(() {
      _claiming = true;
      _message = null;
    });
    try {
      await ref.read(gameControllerProvider.notifier).claimDailyReward();
      if (mounted) setState(() => _message = 'Получено $amount коткоинов!');
    } catch (_) {
      if (mounted) {
        setState(
          () => _message = 'Не удалось сохранить награду. Попробуй ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('Сначала создай питомца.')),
      );
    }
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final compact = size.height < 700 && textScale < 1.25;
    final largeText = textScale >= 1.5;
    final canClaim = DailyRewardRules.canClaim(profile);
    final nextLevel = DailyRewardRules.rewardLevel(profile);
    final lastReward = profile.transactions
        .where((entry) => entry.id.startsWith('daily-reward-'))
        .lastOrNull;
    final claimedLevel = lastReward == null
        ? 0
        : DailyRewardRules.ladder.indexOf(lastReward.amount) + 1;
    final activeLevel = canClaim
        ? nextLevel
        : claimedLevel > 0
        ? claimedLevel
        : (profile.streak - 1).clamp(1, DailyRewardRules.ladder.length);
    final amount = DailyRewardRules.ladder[nextLevel - 1];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
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
                    padding: const EdgeInsets.fromLTRB(12, 5, 12, 18),
                    children: [
                      _topBar(profile),
                      const SizedBox(height: 5),
                      _titleBar(),
                      _hero(profile, compact, largeText),
                      _ladder(activeLevel, canClaim, compact, largeText),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: canClaim && !_claiming
                              ? () => _claim(profile)
                              : null,
                          style: FilledButton.styleFrom(
                            foregroundColor: _brown,
                            backgroundColor: const Color(0xFFFFCE31),
                            disabledBackgroundColor: const Color(0xFFFFE9A8),
                            disabledForegroundColor: _brown,
                            side: const BorderSide(
                              color: Color(0xFFFF8A1E),
                              width: 2,
                            ),
                            minimumSize: const Size(0, 54),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  _claiming
                                      ? 'Сохраняем…'
                                      : canClaim
                                      ? 'Забрать $amount'
                                      : 'Награда получена',
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Image.asset(
                                'assets/images/cat_coin.png',
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_message != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Semantics(
                            liveRegion: true,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: _cream,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFFFC857),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                _message!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: _brown,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: _cream,
                          borderRadius: BorderRadius.circular(23),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Text(
                          'Пропустил день? Серия уменьшится на один шаг.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _brown,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
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
      ),
    );
  }

  Widget _topBar(GameProfile profile) => Row(
    children: [
      const Expanded(child: StoryLogo(height: 48)),
      const SizedBox(width: 8),
      Material(
        color: _cream,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            if (profile.plan == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Сначала сохрани план, затем заработай коткоины.',
                  ),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const TasksScreen()),
              );
            }
          },
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                const SizedBox(width: 7),
                Image.asset('assets/images/cat_coin.png', width: 27),
                const SizedBox(width: 4),
                Text(
                  '${profile.balance}',
                  style: const TextStyle(
                    color: _brown,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.add_circle_rounded, color: Color(0xFF19B767)),
                const SizedBox(width: 6),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _titleBar() => Row(
    children: [
      Material(
        color: const Color(0xFF9B35DF),
        borderRadius: BorderRadius.circular(22),
        child: IconButton(
          tooltip: 'Назад',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          iconSize: 28,
        ),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: Container(
          height: 49,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: _cream,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFFFF7C25),
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ежедневная награда',
                    maxLines: 1,
                    style: TextStyle(
                      color: _brown,
                      fontSize: 25,
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
  );

  Widget _hero(GameProfile profile, bool compact, bool largeText) => SizedBox(
    height: largeText ? 225 : (compact ? 157 : 195),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          bottom: -4,
          child:
              profile.coat == PetCoat.ginger &&
                  profile.accessory == PetAccessory.scarf
              ? Image.asset(
                  'assets/images/daily_reward_hero_ginger.png',
                  width: compact ? 170 : 190,
                  height: compact ? 170 : 190,
                  fit: BoxFit.contain,
                  semanticLabel: 'Рыжий котик радуется ежедневной награде',
                )
              : PetPortrait(
                  coat: profile.coat,
                  accessory: profile.accessory,
                  size: compact ? 155 : 185,
                ),
        ),
        Positioned(
          right: 0,
          bottom: -4,
          child: Image.asset(
            'assets/images/daily_reward_chest.png',
            width: compact ? 145 : 177,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          right: compact ? 45 : 75,
          top: 8,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 150),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Text(
              'Как здорово, что ты здесь!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _brown,
                fontSize: 16,
                height: 1.07,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _ladder(int level, bool canClaim, bool compact, bool largeText) {
    final dayWord = level == 1 ? 'день' : (level < 5 ? 'дня' : 'дней');
    final rows = largeText
        ? const [
            [1, 2],
            [3, 4],
            [5, 6],
            [7],
          ]
        : const [
            [1, 2, 3, 4],
            [5, 6, 7],
          ];
    return Container(
      padding: EdgeInsets.fromLTRB(7, compact ? 7 : 10, 7, compact ? 8 : 11),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Column(
        children: [
          Text(
            'Серия: $level $dayWord',
            style: TextStyle(
              color: _brown,
              fontSize: compact ? 23 : 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          for (final row in rows) ...[
            Row(
              children: [
                for (final day in row)
                  Expanded(
                    child: _RewardDayCard(
                      day: day,
                      amount: DailyRewardRules.ladder[day - 1],
                      active: canClaim && day == level,
                      completed: canClaim ? day < level : day <= level,
                      height: largeText ? 110 : (compact ? 82 : 98),
                    ),
                  ),
                if (largeText && row.length == 1)
                  const Expanded(child: SizedBox.shrink()),
              ],
            ),
            if (row != rows.last) const SizedBox(height: 5),
          ],
        ],
      ),
    );
  }
}

class _RewardDayCard extends StatelessWidget {
  const _RewardDayCard({
    required this.day,
    required this.amount,
    required this.active,
    required this.completed,
    required this.height,
  });

  final int day;
  final int amount;
  final bool active;
  final bool completed;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    margin: const EdgeInsets.symmetric(horizontal: 2),
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
    decoration: BoxDecoration(
      color: active
          ? null
          : completed
          ? const Color(0xFFE8FFED)
          : day.isEven
          ? const Color(0xFFE5F5FF)
          : const Color(0xFFFFEEF6),
      gradient: active
          ? const RadialGradient(
              colors: [Color(0xFFFFF9B7), Color(0xFFFFD633)],
              radius: 1.05,
            )
          : null,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: active ? const Color(0xFFFFB800) : Colors.white,
        width: active ? 2.5 : 1.5,
      ),
      boxShadow: active
          ? const [BoxShadow(color: Color(0x88FFDC37), blurRadius: 7)]
          : null,
    ),
    child: Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'День $day',
            maxLines: 1,
            style: const TextStyle(
              color: _brown,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Spacer(),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/cat_coin.png', width: 25),
              const SizedBox(width: 2),
              Text(
                '$amount',
                style: const TextStyle(
                  color: _brown,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        if (completed) ...[
          const Spacer(),
          Semantics(
            label: 'Награда за день $day получена',
            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF04A85A),
              size: 19,
            ),
          ),
        ] else
          const Spacer(),
      ],
    ),
  );
}
