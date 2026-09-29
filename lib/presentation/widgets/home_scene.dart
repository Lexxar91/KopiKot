import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/game_profile.dart';
import 'goal_medal.dart';
import 'home_section_navigation.dart';
import 'pet_portrait.dart';
import 'story_logo.dart';

bool _useCompactHomeLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).height < 700 &&
    MediaQuery.textScalerOf(context).scale(1) < 1.25;

/// Игровая сцена главного экрана. Данные и действия приходят из HomeScreen.
class HomeScene extends StatefulWidget {
  const HomeScene({
    required this.profile,
    required this.sections,
    required this.goalTitle,
    required this.goalSaved,
    required this.goalPrice,
    required this.needsVetVisit,
    required this.onGarden,
    required this.onShop,
    required this.onVet,
    required this.onTasks,
    required this.onDemo,
    required this.onWalk,
    required this.onBadges,
    required this.onDailyTip,
    required this.onStory,
    required this.onSavings,
    required this.onReward,
    super.key,
  });

  final GameProfile profile;
  final List<HomeSection> sections;
  final String goalTitle;
  final int goalSaved;
  final int goalPrice;
  final bool needsVetVisit;
  final VoidCallback onGarden;
  final VoidCallback onShop;
  final VoidCallback onVet;
  final VoidCallback onTasks;
  final VoidCallback onDemo;
  final VoidCallback onWalk;
  final VoidCallback onBadges;
  final VoidCallback onDailyTip;
  final VoidCallback onStory;
  final VoidCallback onSavings;
  final VoidCallback onReward;

  @override
  State<HomeScene> createState() => _HomeSceneState();
}

class _HomeSceneState extends State<HomeScene> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _goHome() {
    if (!_scroll.hasClients) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _scroll.jumpTo(0);
    } else {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    }
  }

  void _showFeedback() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Как дела у ${widget.profile.petName}?'),
      content: SingleChildScrollView(child: Text(widget.profile.feedback)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Понятно'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
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
                child: Column(
                  children: [
                    _SceneHeader(
                      balance: widget.profile.balance,
                      onEarn: widget.onTasks,
                    ),
                    HomeSectionNavigation(
                      sections: widget.sections,
                      compact: _useCompactHomeLayout(context),
                    ),
                    Expanded(
                      child: ListView(
                        controller: _scroll,
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        children: [
                          if (widget.profile.isTest)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'Тестовый профиль · отдельное сохранение',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          _PetScene(
                            profile: widget.profile,
                            onGarden: widget.onGarden,
                            onFeedback: _showFeedback,
                          ),
                          const SizedBox(height: 5),
                          _WellbeingPanel(profile: widget.profile),
                          SizedBox(
                            height: _useCompactHomeLayout(context) ? 5 : 9,
                          ),
                          _CareActions(
                            onBadges: widget.onBadges,
                            onDemo: widget.onDemo,
                            onDailyTip: widget.onDailyTip,
                            onStory: widget.onStory,
                          ),
                          SizedBox(
                            height: _useCompactHomeLayout(context) ? 5 : 9,
                          ),
                          _GoalPanel(
                            goalId: widget.profile.selectedGoalId ?? 'tent',
                            title: widget.goalTitle,
                            saved: widget.goalSaved,
                            price: widget.goalPrice,
                            onTap: widget.onSavings,
                          ),
                          if (widget.needsVetVisit)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Card(
                                color: const Color(0xFFFDF3DC),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.medical_services_rounded,
                                  ),
                                  title: const Text('Пора к ветеринару'),
                                  subtitle: const Text(
                                    'Котику пригодится совет ветеринара. Давай запланируем визит?',
                                  ),
                                  onTap: widget.onVet,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    _BottomBar(
                      onHome: _goHome,
                      onShop: widget.onShop,
                      onReward: widget.onReward,
                    ),
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

class _SceneHeader extends StatelessWidget {
  const _SceneHeader({required this.balance, required this.onEarn});
  final int balance;
  final VoidCallback onEarn;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
    child: SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(child: const StoryLogo()),
          const SizedBox(width: 8),
          Semantics(
            label: 'Баланс: $balance коткоинов. Заработать ещё',
            button: true,
            child: Material(
              color: const Color(0xFFFFF6DC),
              borderRadius: BorderRadius.circular(25),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: onEarn,
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 9),
                      Image.asset('assets/images/cat_coin.png', width: 27),
                      const SizedBox(width: 4),
                      Text(
                        '$balance',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF6B2916),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.add_circle_rounded,
                        color: Color(0xFF20B765),
                        size: 27,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _PetScene extends StatelessWidget {
  const _PetScene({
    required this.profile,
    required this.onGarden,
    required this.onFeedback,
  });
  final GameProfile profile;
  final VoidCallback onGarden;
  final VoidCallback onFeedback;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 190,
    child: Stack(
      children: [
        Positioned(
          left: 0,
          bottom: 0,
          width: 125,
          height: 188,
          child: Tooltip(
            message: 'Котодерево',
            child: Semantics(
              button: true,
              label: 'Котодерево',
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onGarden,
                  child: Image.asset(
                    'assets/images/home_coin_tree.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomLeft,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: PetPortrait(
            coat: profile.coat,
            accessory: profile.accessory,
            emotion: profile.emotion,
            stage: profile.growthStage,
            size: 190,
          ),
        ),
        Positioned(
          right: 0,
          top: 29,
          child: Material(
            color: const Color(0xFFFFFDF3),
            borderRadius: BorderRadius.circular(22),
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: onFeedback,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 135, minWidth: 105),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Привет!\nЯ ${profile.petName} 🐾',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF643119),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _WellbeingPanel extends StatelessWidget {
  const _WellbeingPanel({required this.profile});
  final GameProfile profile;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(
      10,
      _useCompactHomeLayout(context) ? 4 : 7,
      10,
      _useCompactHomeLayout(context) ? 5 : 9,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF7DF).withValues(alpha: 0.97),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: const Color(0xFFFFD26C), width: 2),
      boxShadow: const [
        BoxShadow(
          color: Color(0x450C320C),
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 2),
          child: Text(
            'Как я себя чувствую',
            style: TextStyle(
              color: Color(0xFF643119),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _Meter(
          label: 'Сытость',
          value: profile.satiety,
          icon: Icons.restaurant_rounded,
          color: const Color(0xFFFF666E),
        ),
        SizedBox(height: _useCompactHomeLayout(context) ? 2 : 4),
        _Meter(
          label: 'Энергия',
          value: profile.energy,
          icon: Icons.bolt_rounded,
          color: const Color(0xFFFFB319),
        ),
        SizedBox(height: _useCompactHomeLayout(context) ? 2 : 4),
        _Meter(
          label: 'Радость',
          value: profile.mood,
          icon: Icons.sentiment_very_satisfied_rounded,
          color: const Color(0xFF21C867),
        ),
      ],
    ),
  );
}

class _Meter extends StatelessWidget {
  const _Meter({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final largeText = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final compact = _useCompactHomeLayout(context);
    return Semantics(
      label: '$label: $value из 100',
      child: Container(
        constraints: BoxConstraints(minHeight: compact ? 26 : 31),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: compact ? 1 : 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: compact ? 19 : 23, color: color),
            const SizedBox(width: 5),
            SizedBox(
              width: largeText ? 83 : 70,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF643119),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: LinearProgressIndicator(
                value: value.clamp(0, 100) / 100,
                minHeight: 9,
                borderRadius: BorderRadius.circular(9),
                color: color,
                backgroundColor: const Color(0xFFE8E1D7),
              ),
            ),
            const SizedBox(width: 7),
            SizedBox(
              width: largeText ? 43 : 27,
              child: Text(
                '$value',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF643119),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareActions extends StatelessWidget {
  const _CareActions({
    required this.onBadges,
    required this.onDemo,
    required this.onDailyTip,
    required this.onStory,
  });
  final VoidCallback onBadges;
  final VoidCallback onDemo;
  final VoidCallback onDailyTip;
  final VoidCallback onStory;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _CareTile(
        label: 'Значки',
        icon: const GoalMedal(size: 43, accent: Color(0xFFFF9E07)),
        onTap: onBadges,
      ),
      const SizedBox(width: 5),
      _DemoTile(onTap: onDemo),
      const SizedBox(width: 5),
      _PreviewActionTile(
        label: 'Совет дня',
        isAdvice: true,
        colors: const [Color(0xFF49E996), Color(0xFF00A977)],
        onTap: onDailyTip,
      ),
      const SizedBox(width: 5),
      _PreviewActionTile(
        label: 'История',
        isAdvice: false,
        colors: const [Color(0xFF61C4FF), Color(0xFF0879DC)],
        onTap: onStory,
      ),
    ],
  );
}

/// Кнопка входа в деморежим повторяет фиолетовую плитку с иконкой Play.
class _DemoTile extends StatelessWidget {
  const _DemoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(21),
      elevation: 4,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC456F9), Color(0xFF7C1BDD)],
          ),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: InkWell(
          key: const Key('demo-button'),
          borderRadius: BorderRadius.circular(21),
          onTap: onTap,
          child: SizedBox(
            height: _useCompactHomeLayout(context)
                ? 58
                : 67 +
                      (MediaQuery.textScalerOf(context).scale(1) - 1).clamp(
                            0,
                            2,
                          ) *
                          20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: _useCompactHomeLayout(context) ? 34 : 40,
                  height: _useCompactHomeLayout(context) ? 34 : 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      Icon(Icons.circle, color: Color(0xFF7E25CD), size: 39),
                      Icon(
                        Icons.circle_outlined,
                        color: Color(0xFFF4EAFF),
                        size: 39,
                      ),
                      Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 29,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Демо',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
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
  );
}

/// Яркая плитка действия на главном экране.
class _PreviewActionTile extends StatelessWidget {
  const _PreviewActionTile({
    required this.label,
    required this.isAdvice,
    required this.colors,
    this.onTap,
  });

  final String label;
  final bool isAdvice;
  final List<Color> colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final compact = _useCompactHomeLayout(context);
    final iconSize = compact ? 30.0 : 38.0;
    final height = compact
        ? 58.0
        : 67.0 +
              (MediaQuery.textScalerOf(context).scale(1) - 1).clamp(0, 2) * 20;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x663D3519),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: iconSize + 8,
                height: iconSize + 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: isAdvice
                      ? [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: 15,
                              color: const Color(0xFFFFF381),
                            ),
                          ),
                          Icon(
                            Icons.lightbulb_rounded,
                            size: iconSize,
                            color: const Color(0xFFFFC526),
                            shadows: const [
                              Shadow(color: Color(0xFFB96108), blurRadius: 3),
                            ],
                          ),
                          Positioned(
                            top: iconSize * 0.25,
                            child: Icon(
                              Icons.pets_rounded,
                              size: iconSize * 0.30,
                              color: const Color(0xFFCA5B10),
                            ),
                          ),
                        ]
                      : [
                          Icon(
                            Icons.menu_book_rounded,
                            size: iconSize + 2,
                            color: const Color(0xFF344795),
                          ),
                          Icon(
                            Icons.menu_book_rounded,
                            size: iconSize - 2,
                            color: const Color(0xFFFFF0D2),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: 15,
                              color: const Color(0xFFFFDE52),
                            ),
                          ),
                        ],
                ),
              ),
              const SizedBox(height: 1),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    shadows: [Shadow(color: Color(0x774B2D25), blurRadius: 2)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CareTile extends StatelessWidget {
  const _CareTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(21),
      elevation: 4,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8488), Color(0xFFE92E44)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(21),
          onTap: onTap,
          child: SizedBox(
            height: _useCompactHomeLayout(context)
                ? 58
                : 67 +
                      (MediaQuery.textScalerOf(context).scale(1) - 1).clamp(
                            0,
                            2,
                          ) *
                          20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: _useCompactHomeLayout(context) ? 32 : 42,
                  height: _useCompactHomeLayout(context) ? 32 : 42,
                  child: FittedBox(child: icon),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
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
        ),
      ),
    ),
  );
}

class _GoalPanel extends StatelessWidget {
  const _GoalPanel({
    required this.goalId,
    required this.title,
    required this.saved,
    required this.price,
    required this.onTap,
  });
  final String goalId;
  final String title;
  final int saved;
  final int price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    key: const Key('home-goal-panel'),
    color: const Color(0xFFFFF7E0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(23),
      side: const BorderSide(color: Color(0xFFFFD279), width: 2),
    ),
    elevation: 4,
    child: InkWell(
      borderRadius: BorderRadius.circular(23),
      onTap: onTap,
      child: SizedBox(
        height: _useCompactHomeLayout(context)
            ? 65
            : 69 +
                  (MediaQuery.textScalerOf(context).scale(1) - 1).clamp(0, 2) *
                      30,
        child: Row(
          children: [
            const SizedBox(width: 10),
            Image.asset(
              switch (goalId) {
                'tent' => 'assets/images/savings_treadmill.png',
                'telescope' => 'assets/images/savings_bed.png',
                'garden' => 'assets/images/savings_rare_sapling.png',
                _ => 'assets/images/home_coin_tree.png',
              },
              width: 52,
              height: 58,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Моя цель',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF643119),
                    ),
                  ),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF226744),
                    ),
                  ),
                  const SizedBox(height: 3),
                  LinearProgressIndicator(
                    value: price == 0 ? 0 : (saved / price).clamp(0, 1),
                    minHeight: 7,
                    borderRadius: BorderRadius.circular(9),
                    color: const Color(0xFF32C645),
                    backgroundColor: const Color(0xFFE9E2D7),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$saved/$price',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xFF643119),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFB58455)),
            const SizedBox(width: 3),
          ],
        ),
      ),
    ),
  );
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.onHome,
    required this.onShop,
    required this.onReward,
  });
  final VoidCallback onHome;
  final VoidCallback onShop;
  final VoidCallback onReward;

  @override
  Widget build(BuildContext context) => Container(
    key: const Key('home-bottom-bar'),
    height: _useCompactHomeLayout(context)
        ? 55
        : 65 + (MediaQuery.textScalerOf(context).scale(1) - 1).clamp(0, 2) * 45,
    margin: const EdgeInsets.fromLTRB(8, 2, 8, 4),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFDF4),
      borderRadius: BorderRadius.circular(31),
      border: Border.all(color: const Color(0xFFFFDB8A), width: 2),
      boxShadow: const [
        BoxShadow(
          color: Color(0x660C320C),
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        _BottomItem(
          label: 'Главная',
          icon: Icons.home_rounded,
          selected: true,
          onTap: onHome,
        ),
        _BottomItem(
          label: 'Магазин',
          icon: Icons.storefront_rounded,
          onTap: onShop,
        ),
        _BottomItem(
          label: 'Награда',
          icon: Icons.card_giftcard_rounded,
          onTap: onReward,
        ),
      ],
    ),
  );
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Material(
      color: selected ? const Color(0xFFFFE1A1) : Colors.transparent,
      borderRadius: BorderRadius.circular(29),
      child: InkWell(
        borderRadius: BorderRadius.circular(29),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: selected
                  ? const Color(0xFFE8661A)
                  : const Color(0xFFB86B44),
            ),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: selected
                    ? const Color(0xFF962F13)
                    : const Color(0xFF6B5C59),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
