import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/models/game_transaction.dart';
import '../providers/game_controller.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

/// История покупок с фильтрами по периоду и типу расхода.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  int? _selectedPeriod;
  TransactionKind? _selectedKind;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    final purchases =
        profile?.transactions
            .where(
              (entry) => const {
                TransactionKind.needPurchase,
                TransactionKind.wantPurchase,
                TransactionKind.giftPurchase,
              }.contains(entry.kind),
            )
            .toList()
            .reversed
            .toList() ??
        <GameTransaction>[];
    final periods = purchases.map((entry) => entry.period).toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    final period = periods.contains(_selectedPeriod)
        ? _selectedPeriod
        : (periods.isEmpty ? profile?.period : periods.first);
    final visible = purchases
        .where(
          (entry) =>
              entry.period == period &&
              (_selectedKind == null || entry.kind == _selectedKind),
        )
        .toList();

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
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                    children: [
                      _header(context, profile),
                      const SizedBox(height: 10),
                      _filters(periods, period),
                      const SizedBox(height: 12),
                      if (visible.isEmpty)
                        _emptyState(purchases.isEmpty)
                      else
                        for (final entry in visible) ...[
                          _HistoryCard(entry: entry),
                          const SizedBox(height: 10),
                        ],
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

  Widget _header(BuildContext context, GameProfile? profile) => SizedBox(
    height: 150,
    child: Stack(
      children: [
        const Positioned(
          top: 0,
          left: 62,
          right: 35,
          child: StoryLogo(height: 64),
        ),
        if (profile != null)
          Positioned(
            top: 5,
            right: 0,
            child: PetPortrait(
              coat: profile.coat,
              accessory: profile.accessory,
              size: 94,
            ),
          ),
        Positioned(
          top: 59,
          left: 0,
          child: Material(
            color: const Color(0xFF9632DB),
            borderRadius: BorderRadius.circular(29),
            child: IconButton(
              tooltip: 'Назад',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              iconSize: 30,
            ),
          ),
        ),
        Positioned(
          top: 70,
          left: 68,
          right: 0,
          child: Container(
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(33),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.pie_chart_rounded,
                  color: Color(0xFF8D24DB),
                  size: 37,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'История покупок',
                      style: TextStyle(
                        color: _brown,
                        fontSize: 27,
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
  );

  Widget _filters(List<int> periods, int? period) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
    decoration: BoxDecoration(
      color: _cream,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white, width: 3),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFECD9FF),
              borderRadius: BorderRadius.circular(22),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: periods.isEmpty ? null : period,
                hint: Text('Период ${period ?? 1}'),
                borderRadius: BorderRadius.circular(18),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: [
                  for (final item in periods)
                    DropdownMenuItem(value: item, child: Text('Период $item')),
                ],
                onChanged: periods.isEmpty
                    ? null
                    : (value) => setState(() => _selectedPeriod = value),
              ),
            ),
          ),
          const SizedBox(width: 7),
          _filterChip('Все', null, Icons.apps_rounded, const Color(0xFF8D24DB)),
          _filterChip(
            'Нужно',
            TransactionKind.needPurchase,
            Icons.favorite_rounded,
            const Color(0xFFE95474),
          ),
          _filterChip(
            'Хочется',
            TransactionKind.wantPurchase,
            Icons.celebration_rounded,
            const Color(0xFF2BBF63),
          ),
          _filterChip(
            'Подарки',
            TransactionKind.giftPurchase,
            Icons.card_giftcard_rounded,
            const Color(0xFF8D24DB),
          ),
        ],
      ),
    ),
  );

  Widget _filterChip(
    String label,
    TransactionKind? kind,
    IconData icon,
    Color color,
  ) {
    final selected = _selectedKind == kind;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        color: selected ? color : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => setState(() => _selectedKind = kind),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                if (kind != null) ...[
                  Icon(icon, size: 19, color: selected ? Colors.white : color),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : _brown,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(bool noPurchases) => Container(
    padding: const EdgeInsets.all(26),
    decoration: BoxDecoration(
      color: _cream,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      children: [
        const Icon(
          Icons.receipt_long_rounded,
          size: 54,
          color: Color(0xFF8D24DB),
        ),
        const SizedBox(height: 8),
        Text(
          noPurchases ? 'Покупок пока нет' : 'За этот период покупок нет',
          style: const TextStyle(
            color: _brown,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (noPurchases)
          const Text(
            'После выбора в Котомаркете здесь появятся цена и результат.',
            textAlign: TextAlign.center,
          ),
      ],
    ),
  );
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.entry});

  final GameTransaction entry;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (entry.kind) {
      TransactionKind.needPurchase => (
        'Нужно',
        Icons.favorite_rounded,
        const Color(0xFFE95474),
      ),
      TransactionKind.wantPurchase => (
        'Хочется',
        Icons.celebration_rounded,
        const Color(0xFF1CBF65),
      ),
      TransactionKind.giftPurchase => (
        'Подарки',
        Icons.card_giftcard_rounded,
        const Color(0xFF8D24DB),
      ),
      _ => ('Покупка', Icons.shopping_bag_rounded, const Color(0xFF8D24DB)),
    };
    final image = switch (entry.referenceId) {
      'vet_checkup' => 'assets/images/vet_rabbit.png',
      'shop_brush' => 'assets/images/shop_brush.png',
      'shop_food' => 'assets/images/quest_cat_food.png',
      'shop_bow' => 'assets/images/wardrobe_bow.png',
      _ => switch (entry.label) {
        'Плановый осмотр у ветеринара' => 'assets/images/vet_rabbit.png',
        'Ягодный бантик' => 'assets/images/wardrobe_bow.png',
        'Щётка' => 'assets/images/shop_brush.png',
        'Корм' => 'assets/images/quest_cat_food.png',
        _ =>
          entry.kind == TransactionKind.giftPurchase
              ? 'assets/images/garden_coin_sapling.png'
              : 'assets/images/market_basket.png',
      },
    };
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x7756320F),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 82,
            height: 96,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(23),
            ),
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _brown,
                    fontSize: 17,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 5,
                  runSpacing: 3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 15, color: color),
                          const SizedBox(width: 3),
                          Text(
                            label,
                            style: const TextStyle(
                              color: _brown,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'период ${entry.period}',
                      style: const TextStyle(color: _brown, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'После покупки: осталось ${entry.balanceAfter} монет',
                  style: const TextStyle(color: _brown, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 3),
          Column(
            children: [
              Image.asset('assets/images/cat_coin.png', width: 28),
              Text(
                '−${entry.amount}',
                style: const TextStyle(
                  color: _brown,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
