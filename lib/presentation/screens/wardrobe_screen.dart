import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';

/// Гардероб отделяет покупку вещи от бесплатного выбора внешнего вида.
class WardrobeScreen extends ConsumerWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameProfile? profile = ref
        .watch(gameControllerProvider)
        .asData
        ?.value;
    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('Сначала создай питомца.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Гардероб')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE6B7), Color(0xFFFFD6E4)],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  PetPortrait(
                    coat: profile.coat,
                    accessory: profile.accessory,
                    emotion: profile.emotion,
                    stage: profile.growthStage,
                    size: 190,
                  ),
                  Text(
                    profile.accessory == null
                        ? '${profile.petName} сейчас без аксессуара'
                        : '${accessoryLabels[profile.accessory]} сейчас надет',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (profile.accessory != null) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => ref
                          .read(gameControllerProvider.notifier)
                          .equipAccessory(null),
                      icon: const Icon(Icons.checkroom_outlined),
                      label: const Text('Снять аксессуар'),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Мои вещи', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            const Text(
              'Купленная вещь остаётся навсегда. Надевать и снимать её можно бесплатно.',
            ),
            const SizedBox(height: 12),
            for (final accessory in PetAccessory.values)
              _AccessoryCard(profile: profile, accessory: accessory),
          ],
        ),
      ),
    );
  }
}

class _AccessoryCard extends ConsumerWidget {
  const _AccessoryCard({required this.profile, required this.accessory});

  final GameProfile profile;
  final PetAccessory accessory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool owned = profile.ownsAccessory(accessory);
    final bool equipped = profile.accessory == accessory;
    final IconData icon = switch (accessory) {
      PetAccessory.scarf => Icons.airline_seat_flat_angled_outlined,
      PetAccessory.bow => Icons.auto_awesome_outlined,
      PetAccessory.cap => Icons.explore_outlined,
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        minVerticalPadding: 14,
        leading: CircleAvatar(
          backgroundColor: owned
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(owned ? icon : Icons.lock_outline),
        ),
        title: Text(accessoryLabels[accessory]!),
        subtitle: Text(
          owned
              ? (equipped ? 'Сейчас на питомце' : 'Готов к примерке')
              : 'Можно купить в Котомаркете',
        ),
        trailing: FilledButton.tonal(
          onPressed: !owned || equipped
              ? null
              : () => ref
                    .read(gameControllerProvider.notifier)
                    .equipAccessory(accessory),
          child: Text(equipped ? 'Надет' : 'Надеть'),
        ),
      ),
    );
  }
}
