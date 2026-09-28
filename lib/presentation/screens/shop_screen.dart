import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';
import 'wardrobe_screen.dart';

const _ink = Color(0xFF472016);
const _cream = Color(0xFFFFFAEB);

/// Витрина показывает цену и эффект до подтверждения покупки.
class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  int category = 0;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/quest_market_background.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: ref
                    .watch(gameCatalogProvider)
                    .when(
                      loading: () => const Center(child: LoadingStatus()),
                      error: (_, _) => Center(
                        child: TextButton(
                          onPressed: () => ref.invalidate(gameCatalogProvider),
                          child: const Text('Повторить загрузку каталога'),
                        ),
                      ),
                      data: (catalog) {
                        final ids = switch (category) {
                          0 => [
                            'shop_food',
                            'shop_shampoo',
                            'shop_milk',
                            'shop_brush',
                          ],
                          1 => ['vet_checkup', 'owl_seedlings'],
                          _ => [
                            'berry_bow',
                            'star_scarf',
                            'sport_headband',
                            'blue_wristbands',
                          ],
                        };
                        return ListView(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
                          children: [
                            Row(
                              children: [
                                const Expanded(child: StoryLogo(height: 50)),
                                const SizedBox(width: 8),
                                _panel(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/images/cat_coin.png',
                                        width: 38,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${profile?.balance ?? 0}',
                                        style: const TextStyle(
                                          color: _ink,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const CircleAvatar(
                                        radius: 17,
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
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton.filled(
                                  tooltip: 'Назад',
                                  onPressed: () =>
                                      Navigator.of(context).maybePop(),
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xFFA52BE5),
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(53, 53),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _panel(
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.storefront_rounded,
                                          color: Color(0xFFE96C1A),
                                          size: 32,
                                        ),
                                        SizedBox(width: 7),
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'Котомаркет',
                                              style: TextStyle(
                                                color: _ink,
                                                fontSize: 31,
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
                              height: 220,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 2,
                                    bottom: 0,
                                    child: PetPortrait(
                                      coat: profile?.coat ?? PetCoat.ginger,
                                      accessory:
                                          profile?.accessory ??
                                          PetAccessory.scarf,
                                      size: 195,
                                      emotion: PetEmotion.happy,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 12,
                                    child: Container(
                                      width: 175,
                                      padding: const EdgeInsets.all(13),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(29),
                                        border: Border.all(
                                          color: const Color(0xFFFFE2AA),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Text(
                                        'Сначала\nнужное,\nпотом радость!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _ink,
                                          fontSize: 20,
                                          height: 1.1,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _panel(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  _tab(0, 'Нужное', Icons.pets_rounded),
                                  _tab(1, 'Полезное', Icons.eco_rounded),
                                  _tab(2, 'Радость', Icons.favorite_rounded),
                                ],
                              ),
                            ),
                            const SizedBox(height: 9),
                            _panel(
                              padding: const EdgeInsets.fromLTRB(9, 10, 9, 12),
                              child: Column(
                                children: [
                                  Text(
                                    switch (category) {
                                      0 => 'Для заботы о котике',
                                      1 => 'Полезное для котика',
                                      _ => 'Для радости котика',
                                    },
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: _ink,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final width =
                                          (constraints.maxWidth - 8) / 2;
                                      return Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          for (var i = 0; i < ids.length; i++)
                                            SizedBox(
                                              width: width,
                                              child: _ProductCard(
                                                product: catalog.product(
                                                  ids[i],
                                                ),
                                                profile: profile,
                                                tint: const [
                                                  Color(0xFFE8FFE6),
                                                  Color(0xFFE3F7FF),
                                                  Color(0xFFFFF3DB),
                                                  Color(0xFFFFE9EE),
                                                ][i % 4],
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 9),
                            _panel(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/cat_coin.png',
                                    width: 35,
                                  ),
                                  const SizedBox(width: 7),
                                  const Flexible(
                                    child: Text(
                                      'Проверь, хватит ли коткоинов',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _ink,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 9),
                            _panel(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  _nav(
                                    Icons.home_rounded,
                                    'Главная',
                                    () => Navigator.of(context).maybePop(),
                                  ),
                                  _nav(
                                    Icons.storefront_rounded,
                                    'Котомаркет',
                                    null,
                                    selected: true,
                                  ),
                                  _nav(
                                    Icons.pets_rounded,
                                    'Котик',
                                    () => Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const WardrobeScreen(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(int index, String title, IconData icon) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: category == index ? const Color(0xFF00746E) : _cream,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 50,
          child: InkWell(
            onTap: () => setState(() => category = index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: category == index
                        ? Colors.white
                        : const Color(0xFFE86B21),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: category == index ? Colors.white : _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _nav(
    IconData icon,
    String title,
    VoidCallback? onTap, {
    bool selected = false,
  }) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: selected ? const Color(0xFF00746E) : _cream,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 50,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: selected ? Colors.white : const Color(0xFFAC5D2D),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected ? Colors.white : _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _panel({
  required Widget child,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
    horizontal: 11,
    vertical: 7,
  ),
}) => Container(
  padding: padding,
  decoration: BoxDecoration(
    color: _cream,
    borderRadius: BorderRadius.circular(26),
    border: Border.all(color: Colors.white, width: 2),
    boxShadow: const [
      BoxShadow(color: Color(0x553E1D0A), blurRadius: 8, offset: Offset(0, 3)),
    ],
  ),
  child: child,
);

String _productImage(String id) => switch (id) {
  'shop_food' => 'assets/images/quest_cat_food.png',
  'shop_shampoo' => 'assets/images/market_shampoo.png',
  'shop_milk' => 'assets/images/shop_milk.png',
  'shop_brush' => 'assets/images/shop_brush.png',
  'berry_bow' => 'assets/images/wardrobe_bow.png',
  'star_scarf' => 'assets/images/wardrobe_scarf.png',
  'sport_headband' => 'assets/images/wardrobe_headband.png',
  'blue_wristbands' => 'assets/images/wardrobe_wristbands.png',
  'vet_checkup' => 'assets/images/vet_rabbit.png',
  _ => 'assets/images/garden_coin_sapling.png',
};

class _ProductCard extends ConsumerWidget {
  const _ProductCard({
    required this.product,
    required this.profile,
    required this.tint,
  });

  final ShopProduct product;
  final GameProfile? profile;
  final Color tint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owned =
        product.accessory != null &&
        profile?.ownsAccessory(product.accessory!) == true;
    final category = switch (product.category) {
      ExpenseCategory.needs => 'Нужное',
      ExpenseCategory.wants => 'Радость',
      ExpenseCategory.gifts => 'Полезное',
    };
    return Container(
      height: 217,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(_productImage(product.id), fit: BoxFit.contain),
          ),
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/cat_coin.png', width: 27),
              const SizedBox(width: 3),
              Text(
                '${product.price}',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              key: Key('shop-buy-${product.id}'),
              onPressed: profile?.plan == null || owned
                  ? null
                  : () => showAccessibleDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => GameActionDialog(
                        title: 'Купить ${product.title.toLowerCase()}?',
                        description:
                            '$category · ${product.price} монет.\n${product.description}\n\n'
                            'Сейчас на балансе ${profile!.balance} монет. '
                            '${profile!.balance >= product.price ? 'После покупки останется ${profile!.balance - product.price}.' : 'Не хватает ${product.price - profile!.balance} монет. Выбери покупку дешевле или отложи её.'}',
                        confirmLabel: 'Купить',
                        action: (id) => ref
                            .read(gameControllerProvider.notifier)
                            .purchase(product.id, id),
                      ),
                    ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF007861),
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                owned ? 'Куплено' : 'Купить',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
