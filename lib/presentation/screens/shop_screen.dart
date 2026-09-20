import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../providers/game_controller.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/accessible_motion.dart';

/// Цены, категории и эффект видны до отдельного подтверждения покупки.
class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Покупки')),
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
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'На балансе: ${profile?.balance ?? 0} монет',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (profile?.plan == null)
                  const Text(
                    'Перед покупками подтверди бюджет на главном экране.',
                  ),
                if (profile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(profile.feedback),
                    ),
                  ),
                for (final product in catalog.products)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '${product.category == ExpenseCategory.needs ? 'Нужно' : 'Хочется'} · ${product.price} монет',
                          ),
                          const SizedBox(height: 8),
                          Text(product.description),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: profile?.plan == null
                                ? null
                                : () async {
                                    await showAccessibleDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => GameActionDialog(
                                        title:
                                            'Купить ${product.title.toLowerCase()}?',
                                        description:
                                            '${product.category == ExpenseCategory.needs ? 'Обязательная' : 'Необязательная'} покупка. '
                                            'Цена: ${product.price} монет.\n${product.description}\n\n'
                                            'Сейчас на балансе ${profile!.balance} монет. '
                                            '${profile.balance >= product.price ? 'После покупки останется ${profile.balance - product.price}.' : 'Не хватает ${product.price - profile.balance}. Выбери покупку дешевле или отложи её.'}',
                                        confirmLabel: 'Купить',
                                        action: (id) => ref
                                            .read(
                                              gameControllerProvider.notifier,
                                            )
                                            .purchase(product.id, id),
                                      ),
                                    );
                                  },
                            child: Text('Выбрать за ${product.price}'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}
