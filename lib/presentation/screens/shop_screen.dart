import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/game_action_dialog.dart';
import 'wardrobe_screen.dart';

/// Котомаркет показывает цену, категорию и эффект до подтверждения покупки.
class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameProfile? profile = ref
        .watch(gameControllerProvider)
        .asData
        ?.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Котомаркет'),
        actions: [
          IconButton(
            tooltip: 'Гардероб',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const WardrobeScreen()),
            ),
            icon: const Icon(Icons.checkroom_outlined),
          ),
        ],
      ),
      body: ref
          .watch(gameCatalogProvider)
          .when(
            loading: () => const Center(child: LoadingStatus()),
            error: (_, _) => Center(
              child: TextButton(
                onPressed: () => ref.invalidate(gameCatalogProvider),
                child: const Text('Повторить загрузку каталога'),
              ),
            ),
            data: (catalog) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDFF7F2), Color(0xFFE9E4FF)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        child: Icon(Icons.storefront_outlined),
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
                            Text(
                              profile?.plan == null
                                  ? 'Сначала подтверди бюджет.'
                                  : 'Выбирай для питомца и его друзей.',
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
                for (final product in catalog.products)
                  _ProductCard(product: product, profile: profile),
              ],
            ),
          ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product, required this.profile});

  final ShopProduct product;
  final GameProfile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool owned =
        product.accessory != null &&
        profile != null &&
        profile!.ownsAccessory(product.accessory!);
    final (String, IconData, Color) category = switch (product.category) {
      ExpenseCategory.needs => (
        'Нужно',
        Icons.favorite_outline,
        const Color(0xFFFFE0D6),
      ),
      ExpenseCategory.wants => (
        'Хочется',
        Icons.celebration_outlined,
        const Color(0xFFE8E1FF),
      ),
      ExpenseCategory.gifts => (
        'Подарки',
        Icons.redeem_outlined,
        const Color(0xFFDDF6E9),
      ),
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: category.$3,
                  child: Icon(category.$2),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('${category.$1} · ${product.price} монет'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(product.description),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: profile?.plan == null || owned
                    ? null
                    : () => showAccessibleDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => GameActionDialog(
                          title: 'Купить ${product.title.toLowerCase()}?',
                          description:
                              '${category.$1} · ${product.price} монет.\n${product.description}\n\n'
                              'Сейчас на балансе ${profile!.balance} монет. '
                              '${profile!.balance >= product.price ? 'После покупки останется ${profile!.balance - product.price}.' : 'Не хватает ${product.price - profile!.balance}. Выбери покупку дешевле или отложи её.'}',
                          confirmLabel: 'Купить',
                          action: (id) => ref
                              .read(gameControllerProvider.notifier)
                              .purchase(product.id, id),
                        ),
                      ),
                child: Text(
                  owned ? 'Уже в гардеробе' : 'Выбрать за ${product.price}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
