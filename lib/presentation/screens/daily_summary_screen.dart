import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/daily_summary.dart';
import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';
import 'tasks_screen.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

/// Показывает реальные операции текущего игрового периода как добрый итог дня.
class DailySummaryScreen extends ConsumerWidget {
  const DailySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('Сначала создай питомца.')),
      );
    }
    final summary = DailySummary.fromProfile(profile);
    final compact =
        MediaQuery.sizeOf(context).height < 700 &&
        MediaQuery.textScalerOf(context).scale(1) < 1.25;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBody: true,
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
                    padding: const EdgeInsets.fromLTRB(12, 5, 12, 88),
                    children: [
                      _topBar(context, profile),
                      const SizedBox(height: 5),
                      _titleBar(context),
                      _hero(profile, summary, compact, largeText),
                      _summaryPanel(summary, compact),
                      const SizedBox(height: 8),
                      _feedbackCard(profile, summary, compact),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                foregroundColor: _brown,
                backgroundColor: const Color(0xFFFFCE31),
                side: const BorderSide(color: Color(0xFFFF8A1E), width: 2),
                minimumSize: const Size(0, 54),
              ),
              icon: const Icon(Icons.pets_rounded),
              label: const Text(
                'Продолжить',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, GameProfile profile) => Row(
    children: [
      Expanded(child: const StoryLogo(height: 48)),
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

  Widget _titleBar(BuildContext context) => Row(
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
              const Icon(Icons.wb_sunny_rounded, color: Color(0xFFFFA52D)),
              const SizedBox(width: 8),
              const Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Итог дня',
                    style: TextStyle(
                      color: _brown,
                      fontSize: 26,
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

  Widget _hero(
    GameProfile profile,
    DailySummary summary,
    bool compact,
    bool largeText,
  ) => SizedBox(
    height: largeText ? 235 : (compact ? 135 : 165),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 5,
          bottom: -5,
          child:
              profile.coat == PetCoat.ginger &&
                  profile.accessory == PetAccessory.scarf
              ? Image.asset(
                  'assets/images/daily_reward_hero_ginger.png',
                  width: compact ? 145 : 175,
                  height: compact ? 145 : 175,
                  semanticLabel: 'Рыжий котик радуется итогу дня',
                )
              : PetPortrait(
                  coat: profile.coat,
                  accessory: profile.accessory,
                  size: compact ? 145 : 175,
                ),
        ),
        Positioned(
          right: 0,
          top: 8,
          child: Container(
            constraints: BoxConstraints(maxWidth: compact ? 175 : 205),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              summary.spent > 0 && summary.saved > 0
                  ? 'Сегодня у нас получилось и позаботиться, и накопить!'
                  : 'Сегодня мы сделали ещё один шаг к мечте!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _brown,
                fontSize: 16,
                height: 1.08,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _summaryPanel(DailySummary summary, bool compact) => Container(
    padding: EdgeInsets.fromLTRB(8, compact ? 8 : 12, 8, compact ? 9 : 12),
    decoration: BoxDecoration(
      color: _cream,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: const [
        BoxShadow(
          color: Color(0x604B330F),
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          'Твои коткоины сегодня',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _brown,
            fontSize: compact ? 21 : 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: compact ? 6 : 10),
        Row(
          children: [
            _MetricTile('Заработано', summary.earned, const Color(0xFFE5F9E9)),
            _MetricTile('Потрачено', summary.spent, const Color(0xFFFFE5E9)),
            _MetricTile('Отложено', summary.saved, const Color(0xFFE2F4FF)),
            _MetricTile('Осталось', summary.remaining, const Color(0xFFFFF4B9)),
          ],
        ),
        SizedBox(height: compact ? 7 : 10),
        _SummaryBar(summary: summary),
        SizedBox(height: compact ? 7 : 11),
        Text(
          'На что потрачено и отложено',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _brown,
            fontSize: compact ? 16 : 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            _BreakdownTile(
              'Корм',
              summary.food,
              'assets/images/action_feed.png',
              const Color(0xFFFFE4E8),
            ),
            _BreakdownTile(
              'Уход',
              summary.care,
              'assets/images/action_care.png',
              const Color(0xFFFFE4E8),
            ),
            _BreakdownTile(
              'На цель',
              summary.saved,
              'assets/images/budget_savings.png',
              const Color(0xFFE3F5FF),
            ),
          ],
        ),
        if (summary.other > 0) ...[
          const SizedBox(height: 4),
          Text(
            'Другие покупки: ${summary.other} коткоинов',
            style: const TextStyle(color: _brown, fontSize: 12),
          ),
        ],
      ],
    ),
  );

  Widget _feedbackCard(
    GameProfile profile,
    DailySummary summary,
    bool compact,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: _cream,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: Colors.white, width: 3),
    ),
    child: Row(
      children: [
        profile.coat == PetCoat.ginger &&
                profile.accessory == PetAccessory.scarf
            ? Image.asset(
                'assets/images/daily_reward_hero_ginger.png',
                width: compact ? 62 : 78,
                height: compact ? 62 : 78,
                semanticLabel: 'Котик радуется',
              )
            : PetPortrait(
                coat: profile.coat,
                accessory: profile.accessory,
                size: compact ? 62 : 78,
              ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            summary.food + summary.care > 0 && summary.saved > 0
                ? 'На нужное хватило, и цель стала ближе'
                : 'Каждый добрый выбор помогает котику и приближает мечту.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _brown,
              fontSize: compact ? 14 : 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 5),
        const Icon(Icons.favorite_rounded, color: Color(0xFFFF6686), size: 22),
      ],
    ),
  );
}

class _MetricTile extends StatelessWidget {
  const _MetricTile(this.label, this.value, this.background);
  final String label;
  final int value;
  final Color background;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                color: _brown,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/cat_coin.png', width: 21),
                const SizedBox(width: 2),
                Text(
                  '$value',
                  style: const TextStyle(
                    color: _brown,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
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

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.summary});
  final DailySummary summary;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        'Всего заработано: ${summary.earned}',
        style: const TextStyle(
          color: _brown,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 3),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 24,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (summary.spent > 0)
                Expanded(
                  flex: summary.spent,
                  child: _segment(summary.spent, const Color(0xFFFF667B)),
                ),
              if (summary.saved > 0)
                Expanded(
                  flex: summary.saved,
                  child: _segment(summary.saved, const Color(0xFF36AFF1)),
                ),
              if (summary.remaining > 0)
                Expanded(
                  flex: summary.remaining,
                  child: _segment(summary.remaining, const Color(0xFFFFCF35)),
                ),
              if (summary.spent + summary.saved + summary.remaining == 0)
                const Expanded(child: ColoredBox(color: Color(0xFFE4DDD2))),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _segment(int amount, Color color) => ColoredBox(
    color: color,
    child: Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '$amount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    ),
  );
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile(this.label, this.value, this.assetPath, this.background);
  final String label;
  final int value;
  final String assetPath;
  final Color background;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              color: _brown,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          Image.asset(assetPath, height: 43, fit: BoxFit.contain),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/cat_coin.png', width: 19),
              const SizedBox(width: 2),
              Text(
                '$value',
                style: const TextStyle(
                  color: _brown,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
