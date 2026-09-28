import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

/// Котодерево-копилка: саженец растёт по игровым периодам и приносит монеты.
///
/// Перед каждым решением ребёнок видит оба варианта: собрать сейчас
/// с меньшей наградой или подождать и получить больше.
class GardenScreen extends ConsumerWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameProfile? profile = ref
        .watch(gameControllerProvider)
        .asData
        ?.value;
    return Scaffold(
      backgroundColor: const Color(0xFF88C9F6),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/garden_background.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          SafeArea(
            child: ref
                .watch(gameCatalogProvider)
                .when(
                  loading: () => const Center(child: LoadingStatus()),
                  error: (_, _) => Center(
                    child: TextButton(
                      onPressed: () => ref.invalidate(gameCatalogProvider),
                      child: const Text('Повторить загрузку сада'),
                    ),
                  ),
                  data: (catalog) {
                    final treeDefinition = catalog.sapling('sapling_5');
                    final definitions = {
                      for (final sapling in catalog.saplings)
                        sapling.id: sapling,
                    };
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(12, 5, 12, 24),
                          children: [
                            Row(
                              children: [
                                const Expanded(child: StoryLogo(height: 48)),
                                const SizedBox(width: 8),
                                Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _cream,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/cat_coin.png',
                                        width: 27,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${profile?.balance ?? 0}',
                                        style: const TextStyle(
                                          color: _brown,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Color(0xFF00AE79),
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
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Material(
                                  color: const Color(0xFF9B35DF),
                                  borderRadius: BorderRadius.circular(22),
                                  child: IconButton(
                                    tooltip: 'Назад',
                                    onPressed: () =>
                                        Navigator.of(context).maybePop(),
                                    icon: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Container(
                                    height: 49,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _cream,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 19,
                                          backgroundColor: Color(0xFF168EF2),
                                          child: Icon(
                                            Icons.eco_rounded,
                                            color: Colors.lightGreenAccent,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Котодерево',
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
                            ),
                            _gardenHero(profile),
                            if (profile != null && profile.saplings.isEmpty)
                              _PlantTreeCard(
                                definition: treeDefinition,
                                profile: profile,
                              ),
                            for (final sapling
                                in profile?.saplings ?? const <SaplingState>[])
                              _GrowingSaplingCard(
                                sapling: sapling,
                                definition: definitions[sapling.definitionId]!,
                                profile: profile,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _gardenHero(GameProfile? profile) => SizedBox(
    height: 235,
    child: Stack(
      children: [
        if (profile != null)
          Positioned(
            left: 0,
            bottom: 0,
            child: PetPortrait(
              coat: profile.coat,
              accessory: profile.accessory,
              emotion: profile.emotion,
              stage: profile.growthStage,
              size: 205,
            ),
          ),
        Positioned(
          right: 38,
          bottom: 0,
          child: Image.asset(
            profile?.saplings.isNotEmpty == true
                ? 'assets/images/garden_coin_sapling.png'
                : 'assets/images/home_goal_sapling.png',
            width: 145,
            height: 155,
            fit: BoxFit.contain,
            semanticLabel: 'Саженец-копилка',
          ),
        ),
        Positioned(
          right: 0,
          top: 6,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 175),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              'Подождём — вырастет больше!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _brown,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _GrowingSaplingCard extends ConsumerWidget {
  const _GrowingSaplingCard({
    required this.sapling,
    required this.definition,
    required this.profile,
  });

  final SaplingState sapling;
  final SaplingDefinition definition;
  final GameProfile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int elapsed =
        (profile?.period ?? sapling.plantedPeriod) - sapling.plantedPeriod;
    final bool ripe = elapsed >= definition.term;
    final int payout = ripe
        ? definition.reward
        : definition.earlyReward(elapsed);
    final remaining = (definition.term - elapsed).clamp(0, definition.term);
    final currentStage = ripe
        ? 5
        : ((elapsed * 5) ~/ definition.term).clamp(0, 4) + 1;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _cream,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco_rounded, color: Color(0xFF21B75B)),
                  SizedBox(width: 8),
                  Text(
                    'Моё деревце',
                    style: TextStyle(
                      color: _brown,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 39,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 32,
                      right: 32,
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7D0AC),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 39,
                            decoration: BoxDecoration(
                              color: index + 1 == currentStage
                                  ? const Color(0xFF21C765)
                                  : const Color(0xFFFFF0D6),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: index + 1 == currentStage
                                    ? const Color(0xFFFFD73D)
                                    : Colors.white,
                                width: 3,
                              ),
                              boxShadow: index + 1 == currentStage
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x99FFE129),
                                        blurRadius: 12,
                                        spreadRadius: 3,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: index + 1 == currentStage
                                      ? Colors.white
                                      : _brown,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1DCB7)),
                ),
                child: Text(
                  ripe ? 'Урожай созрел!' : 'До урожая: $remaining дней',
                  style: const TextStyle(
                    color: _brown,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _HarvestChoice(
                label: 'Собрать сейчас',
                amount: payout,
                color: const Color(0xFFFFAAA3),
                onTap: profile == null
                    ? null
                    : () => showAccessibleDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => GameActionDialog(
                          title: ripe
                              ? 'Собрать ${definition.reward} монет?'
                              : 'Собрать сейчас или подождать?',
                          description: ripe
                              ? 'Деревце созрело!\n\n'
                                    'Собрать сейчас: +${definition.reward} монет.'
                              : 'Деревце растёт $elapsed из ${definition.term} дней.\n\n'
                                    'Собрать сейчас: +$payout монет.\n'
                                    'Подождать ещё $remaining дней: +${definition.reward} монет.\n\n'
                                    'Оба варианта — не ошибка. Решай сам!',
                          confirmLabel: 'Собрать сейчас',
                          action: (id) => ref
                              .read(gameControllerProvider.notifier)
                              .harvestSapling(sapling.id, id),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _HarvestChoice(
                label: ripe ? 'Урожай готов' : 'Подождать $remaining дней',
                amount: definition.reward,
                color: const Color(0xFF91F4A8),
                onTap: ripe
                    ? null
                    : () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Подождём — вырастет больше!'),
                        ),
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: _cream,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_rounded, color: Color(0xFFAB7836)),
              SizedBox(width: 8),
              Text(
                'Оба выбора доступны',
                style: TextStyle(color: _brown, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HarvestChoice extends StatelessWidget {
  const _HarvestChoice({
    required this.label,
    required this.amount,
    required this.color,
    required this.onTap,
  });

  final String label;
  final int amount;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(28),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(7, 10, 7, 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.lerp(color, Colors.white, 0.35)!, color],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 105,
              height: 45,
              child: Stack(
                children: [
                  Positioned(
                    left: 8,
                    top: 9,
                    child: Image.asset('assets/images/cat_coin.png', width: 36),
                  ),
                  Positioned(
                    right: 8,
                    top: 9,
                    child: Image.asset('assets/images/cat_coin.png', width: 36),
                  ),
                  Positioned(
                    left: 34,
                    top: 0,
                    child: Image.asset('assets/images/cat_coin.png', width: 39),
                  ),
                ],
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  color: _brown,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: _cream,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/cat_coin.png', width: 27),
                  const SizedBox(width: 4),
                  Text(
                    '$amount',
                    style: const TextStyle(
                      color: _brown,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PlantTreeCard extends ConsumerWidget {
  const _PlantTreeCard({required this.definition, required this.profile});

  final SaplingDefinition definition;
  final GameProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Column(
        children: [
          const Text(
            'Моё деревце',
            style: TextStyle(
              color: _brown,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Посади деревце. До урожая: ${definition.term} дней',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _brown, fontSize: 17),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: profile.plan == null
                  ? null
                  : () => showAccessibleDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => GameActionDialog(
                        title: 'Посадить деревце?',
                        description:
                            'Стоимость: ${definition.price} коткоинов. '
                            'После посадки останется ${profile.balance - definition.price}.\n\n'
                            'Собрать сейчас: ${definition.earlyReward(0)} коткоинов. '
                            'Подождать ${definition.term} дней: ${definition.reward} коткоинов.',
                        confirmLabel: 'Посадить',
                        action: (id) => ref
                            .read(gameControllerProvider.notifier)
                            .plantSapling(definition.id, id),
                      ),
                    ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFD23F),
                foregroundColor: _brown,
                minimumSize: const Size(0, 54),
              ),
              icon: const Icon(Icons.eco_rounded),
              label: const Text('Посадить деревце'),
            ),
          ),
          if (profile.plan == null) const Text('Сначала сохрани бюджет.'),
        ],
      ),
    );
  }
}
