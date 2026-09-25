import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

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
    final compact = MediaQuery.sizeOf(context).height < 700;
    final accessories = <PetAccessory>[
      PetAccessory.scarf,
      PetAccessory.bow,
      PetAccessory.headband,
      PetAccessory.wristbands,
      if (profile.ownsAccessory(PetAccessory.cap)) PetAccessory.cap,
    ];
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
                  padding: const EdgeInsets.fromLTRB(12, 5, 12, 18),
                  children: [
                    Row(
                      children: [
                        const Expanded(child: StoryLogo(height: 48)),
                        const SizedBox(width: 8),
                        Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 9),
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
                                '${profile.balance}',
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
                            onPressed: () => Navigator.of(context).maybePop(),
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
                            padding: const EdgeInsets.symmetric(horizontal: 9),
                            decoration: BoxDecoration(
                              color: _cream,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.checkroom_rounded,
                                  color: Color(0xFFFF821F),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Гардероб',
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
                    SizedBox(
                      height: compact ? 215 : 270,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 3,
                            bottom: 0,
                            child: PetPortrait(
                              coat: profile.coat,
                              accessory: profile.accessory,
                              emotion: profile.emotion,
                              stage: profile.growthStage,
                              size: compact ? 210 : 265,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 15,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: compact ? 135 : 175,
                              ),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _cream,
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Text(
                                'Выбирай мой образ! 🐾',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _brown,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _cream,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Мои аксессуары',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _brown,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: accessories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent:
                                      MediaQuery.textScalerOf(
                                            context,
                                          ).scale(1) >=
                                          1.5
                                      ? 220
                                      : 145,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                            itemBuilder: (context, index) => _AccessoryCard(
                              profile: profile,
                              accessory: accessories[index],
                            ),
                          ),
                          if (profile.accessory != null) ...[
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: () => ref
                                  .read(gameControllerProvider.notifier)
                                  .equipAccessory(null),
                              icon: const Icon(Icons.checkroom_outlined),
                              label: const Text('Снять — бесплатно'),
                            ),
                          ],
                        ],
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
}

class _AccessoryCard extends ConsumerWidget {
  const _AccessoryCard({required this.profile, required this.accessory});

  final GameProfile profile;
  final PetAccessory accessory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool owned = profile.ownsAccessory(accessory);
    final bool equipped = profile.accessory == accessory;
    final String? artwork = switch (accessory) {
      PetAccessory.scarf => 'assets/images/wardrobe_scarf.png',
      PetAccessory.bow => 'assets/images/wardrobe_bow.png',
      PetAccessory.cap => null,
      PetAccessory.headband => 'assets/images/wardrobe_headband.png',
      PetAccessory.wristbands => 'assets/images/wardrobe_wristbands.png',
    };
    return Container(
      key: Key('wardrobe-${accessory.name}'),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: switch (accessory) {
          PetAccessory.scarf => const Color(0xFFE7FFEF),
          PetAccessory.bow => const Color(0xFFFFE7EC),
          PetAccessory.cap => const Color(0xFFFFF3CF),
          PetAccessory.headband => const Color(0xFFFFF3CF),
          PetAccessory.wristbands => const Color(0xFFE2F4FF),
        },
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: equipped ? const Color(0xFF28C444) : Colors.white,
          width: equipped ? 3 : 2,
        ),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              accessoryLabels[accessory]!,
              style: const TextStyle(
                color: _brown,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: owned ? 1 : 0.55,
                    child: artwork == null
                        ? const Icon(
                            Icons.sports_baseball_rounded,
                            color: Color(0xFF168F9A),
                            size: 48,
                          )
                        : Image.asset(
                            artwork,
                            fit: BoxFit.contain,
                            semanticLabel: accessoryLabels[accessory],
                          ),
                  ),
                ),
                if (!owned)
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.lock_outline, color: _brown, size: 20),
                  ),
              ],
            ),
          ),
          if (!owned)
            const Text(
              'Купить в магазине',
              maxLines: 1,
              style: TextStyle(color: _brown, fontSize: 11),
            ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: !owned || equipped
                  ? null
                  : () => ref
                        .read(gameControllerProvider.notifier)
                        .equipAccessory(accessory),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                equipped
                    ? 'Надет'
                    : owned
                    ? 'Надеть'
                    : 'Не куплен',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
