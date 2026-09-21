import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/game_action_dialog.dart';

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
      appBar: AppBar(title: const Text('Котодерево')),
      body: ref
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
                for (final sapling in catalog.saplings) sapling.id: sapling,
              };
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE2F5D9), Color(0xFFFFE9C7)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          child: Icon(Icons.park_outlined),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'На балансе: ${profile?.balance ?? 0} монет',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Text(
                                'Посади саженец — монеты подрастут. '
                                'Ждать дольше — получишь больше.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (profile != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(profile.feedback),
                      ),
                    ),
                  if (profile != null && profile.saplings.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'В саду пока пусто. Посади саженец ниже — '
                          'и через несколько периодов он подарит монеты.',
                        ),
                      ),
                    ),
                  for (final sapling in profile?.saplings ?? const <SaplingState>[])
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
                    _SaplingOfferCard(definition: definition, profile: profile),
                ],
              );
            },
          ),
    );
  }
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
    final int elapsed = (profile?.period ?? sapling.plantedPeriod) -
        sapling.plantedPeriod;
    final bool ripe = elapsed >= definition.term;
    final int payout = ripe
        ? definition.reward
        : definition.earlyReward(elapsed);
    final double progress = (elapsed / definition.term).clamp(0.0, 1.0);
    return Card(
      color: const Color(0xFFEFF7E4),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFD8EDC4),
                  child: Icon(
                    ripe ? Icons.spa_rounded : Icons.grass_outlined,
                    color: ripe ? const Color(0xFF3E7B27) : Colors.brown,
                  ),
                ),
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
                        ripe
                            ? 'Созрело! Можно собрать ${definition.reward} монет'
                            : 'Растёт: $elapsed из ${definition.term} дней',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF6BA84F),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: profile == null
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
                                    'Подождать ещё ${definition.term - elapsed} дней: +${definition.reward} монет.\n\n'
                                    'Оба варианта — не ошибка. Решай сам!',
                          confirmLabel: 'Собрать сейчас',
                          action: (id) => ref
                              .read(gameControllerProvider.notifier)
                              .harvestSapling(sapling.id, id),
                        ),
                      ),
                child: Text('Собрать: +$payout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
                child: Text('Сначала подтверди бюджет — саженец это накопление.'),
              ),
          ],
        ),
      ),
    );
  }
}
