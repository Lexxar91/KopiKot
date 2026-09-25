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
        child: Material(
          color: section.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
            side: BorderSide(color: Colors.white, width: isSelected ? 3 : 2),
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
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _destinationPanel(HomeSection section) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
    child: Material(
      color: const Color(0xFFFFF8E8).withValues(alpha: 0.97),
      borderRadius: BorderRadius.circular(20),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Закрыть раздел',
                  onPressed: () => setState(() => _selectedIndex = null),
                  icon: const Icon(Icons.close_rounded),
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
                        child: FilledButton.tonalIcon(
                          onPressed: destination.onTap,
                          icon: Icon(destination.icon),
                          label: Text(
                            destination.title,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(48, 58),
                            backgroundColor: section.color,
                            foregroundColor: const Color(0xFF4A321F),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
