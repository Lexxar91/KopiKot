import 'package:flutter/material.dart';

/// Действие в раскрывающейся группе разделов главного экрана.
class HomeDestination {
  const HomeDestination({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
}

class HomeSection {
  const HomeSection({
    required this.title,
    required this.shortTitle,
    required this.icon,
    required this.color,
    required this.destinations,
  });

  final String title;
  final String shortTitle;
  final IconData icon;
  final Color color;
  final List<HomeDestination> destinations;
}

/// Закреплённые группы навигации: открытая группа не прокручивается с лентой.
class HomeSectionNavigation extends StatefulWidget {
  const HomeSectionNavigation({
    required this.sections,
    this.compact = false,
    super.key,
  });

  final List<HomeSection> sections;
  final bool compact;

  @override
  State<HomeSectionNavigation> createState() => _HomeSectionNavigationState();
}

class _HomeSectionNavigationState extends State<HomeSectionNavigation> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final selected = _selectedIndex;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            8,
            widget.compact ? 3 : 6,
            8,
            widget.compact ? 3 : 4,
          ),
          child: Row(
            children: [
              for (var index = 0; index < widget.sections.length; index++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _sectionButton(index),
                  ),
                ),
            ],
          ),
        ),
        if (selected != null && selected < widget.sections.length)
          _destinationPanel(widget.sections[selected]),
      ],
    );
  }

  Widget _sectionButton(int index) {
    final section = widget.sections[index];
    final isSelected = _selectedIndex == index;
    return Semantics(
      button: true,
      label: section.title,
      expanded: isSelected,
      child: Tooltip(
        message: section.title,
        child: Container(
          padding: EdgeInsets.all(isSelected ? 3 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            color: isSelected ? const Color(0xFFFFD52E) : Colors.transparent,
            boxShadow: isSelected
                ? const [BoxShadow(color: Color(0xCCFFDA31), blurRadius: 11)]
                : null,
          ),
          child: Material(
            color: isSelected ? const Color(0xFF1478DF) : section.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            elevation: isSelected ? 7 : 4,
            child: InkWell(
              borderRadius: BorderRadius.circular(17),
              onTap: () =>
                  setState(() => _selectedIndex = isSelected ? null : index),
              child: SizedBox(
                height: widget.compact ? 54 : 64,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(section.icon, size: 25, color: Colors.white),
                    const SizedBox(height: 2),
                    Text(
                      section.shortTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
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

  Widget _destinationPanel(HomeSection section) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7DF).withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x775B350C),
            blurRadius: 11,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.eco_rounded, color: Color(0xFF3AA52C), size: 22),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  section.shortTitle,
                  style: const TextStyle(
                    color: Color(0xFF642818),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Закрыть раздел',
                onPressed: () => setState(() => _selectedIndex = null),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFFF27622),
                  size: 30,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final destination in section.destinations)
                    SizedBox(
                      width: tileWidth,
                      child: _destinationTile(section, destination),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );

  Widget _destinationTile(HomeSection section, HomeDestination destination) {
    final image = switch (destination.title) {
      'Бухгалтер' => 'assets/images/quest_budget.png',
      'Котомаркет' => 'assets/images/market_basket.png',
      'Задания' => 'assets/images/quest_purchases.png',
      'Прогресс' => 'assets/images/quest_badge_plan.png',
      'Ветеринар' => 'assets/images/vet_rabbit.png',
      'Еда и уход' => 'assets/images/action_feed.png',
      'Гардероб' => 'assets/images/wardrobe_scarf.png',
      'Котодерево' => 'assets/images/garden_coin_sapling.png',
      'Бюджет' => 'assets/images/quest_budget.png',
      'Накопления' => 'assets/images/budget_savings.png',
      'Итог дня' => 'assets/images/daily_reward_chest.png',
      'История' => 'assets/images/quest_purchases.png',
      'Как играть' => 'assets/images/quest_savings.png',
      'Для взрослых' => 'assets/images/quest_badge_plan.png',
      _ => null,
    };
    return Material(
      color: const Color(0xFFFFFDF5),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: destination.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              height: widget.compact ? 63 : 76,
              width: double.infinity,
              decoration: BoxDecoration(
                color: section.color.withValues(alpha: 0.13),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: image == null
                  ? Icon(destination.icon, size: 47, color: section.color)
                  : Image.asset(image, fit: BoxFit.contain),
            ),
            Container(
              height: 43,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    section.color.withValues(alpha: 0.85),
                    section.color,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(destination.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      destination.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
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
}
