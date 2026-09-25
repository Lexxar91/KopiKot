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
              'assets/images/fairytale_background.png',
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
                                        Icon(
                                          Icons.eco_rounded,
                                          color: Color(0xFF30B6F3),
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
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _cream,
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const Text(
                                  'В саду пока пусто. Посади саженец ниже — '
                                  'и через несколько периодов он подарит монеты.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _brown,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            for (final sapling
                                in profile?.saplings ?? const <SaplingState>[])
                              _GrowingSaplingCard(
                                sapling: sapling,
                                definition: definitions[sapling.definitionId]!,
                                profile: profile,
                              ),
                            const SizedBox(height: 18),
                            Text(
                              'Посадить новый',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Все саженцы стоят одинаково: разница только в терпении.',
                            ),
                            const SizedBox(height: 12),
                            for (final definition in catalog.saplings)
                              _SaplingOfferCard(
                                definition: definition,
                                profile: profile,
                              ),
                            if (profile != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                child: Semantics(
                                  liveRegion: true,
                                  child: Text(profile.feedback),
                                ),
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
    height: 220,
    child: Stack(
      children: [
        Positioned(
          right: 0,
          bottom: 0,
          child: Image.asset(
            'assets/images/home_coin_tree.png',
            width: 150,
            height: 175,
            fit: BoxFit.contain,
            semanticLabel: 'Дерево с коткоинами',
          ),
        ),
        if (profile != null)
          Positioned(
            left: 0,
            bottom: 0,
            child: PetPortrait(
              coat: profile.coat,
              accessory: profile.accessory,
              emotion: profile.emotion,
              stage: profile.growthStage,
              size: 165,
            ),
          ),
        Positioned(
          left: 120,
          bottom: 0,
          child: Image.asset(
            profile?.saplings.isNotEmpty == true
                ? 'assets/images/garden_coin_sapling.png'
                : 'assets/images/home_goal_sapling.png',
            width: 135,
            height: 145,
            fit: BoxFit.contain,
            semanticLabel: 'Саженец-копилка',
          ),
        ),
        Positioned(
          left: 120,
          top: 10,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 175),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              profile?.saplings.isNotEmpty == true
                  ? 'Подождём — вырастет больше!'
                  : 'Посадим саженец и подождём!',
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Column(
        children: [
          const Text(
            'Моё деревце',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _brown,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
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
                          border: Border.all(color: Colors.white, width: 2),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _HarvestChoice(
                  label: 'Собрать сейчас',
                  amount: payout,
                  color: const Color(0xFFFFC5C1),
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
                                ? '${definition.title} созрело!\n\n'
                                      'Собрать сейчас: +${definition.reward} монет.'
                                : '${definition.title} растёт $elapsed из ${definition.term} дней.\n\n'
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
                  color: const Color(0xFFC2F6CA),
                  onTap: ripe
                      ? null
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Отлично! Саженец продолжит расти в следующих игровых днях.',
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Оба выбора доступны',
            style: TextStyle(color: _brown, fontWeight: FontWeight.w800),
          ),
        ],
      ),
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
    color: color,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  color: _brown,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/cat_coin.png', width: 25),
                const SizedBox(width: 4),
                Text(
                  '$amount',
                  style: const TextStyle(
                    color: _brown,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _SaplingOfferCard extends ConsumerWidget {
  const _SaplingOfferCard({required this.definition, required this.profile});

  final SaplingDefinition definition;
  final GameProfile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool canPlant = profile != null && profile!.plan != null;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.eco_outlined)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        definition.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Цена ${definition.price} · награда ${definition.reward} монет',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(definition.description),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: !canPlant
                    ? null
                    : () => showAccessibleDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => GameActionDialog(
                          title: 'Посадить ${definition.title.toLowerCase()}?',
                          description:
                              'Накопление · ${definition.price} монет.\n'
                              '${definition.description}\n\n'
                              'Сейчас на балансе ${profile!.balance} монет. '
                              '${profile!.balance >= definition.price ? 'После посадки останется ${profile!.balance - definition.price}.' : 'Не хватает ${definition.price - profile!.balance}. Заработай монеты в заданиях или выбери покупку позже.'}',
                          confirmLabel: 'Посадить',
                          action: (id) => ref
                              .read(gameControllerProvider.notifier)
                              .plantSapling(definition.id, id),
                        ),
                      ),
                child: const Text('Посадить'),
              ),
            ),
            if (!canPlant)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Сначала подтверди бюджет — саженец это накопление.',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
