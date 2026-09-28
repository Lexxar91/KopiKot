import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../../domain/rules/economy_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';

const _ink = Color(0xFF642818);
const _cream = Color(0xFFFFF9E9);

/// Накопления каждой цели отделены от доступного баланса и от других целей.
class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});
  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen> {
  final _amount = TextEditingController(text: '20');
  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _transfer(
    GameProfile profile,
    GoalDefinition goal,
    bool withdraw,
  ) async {
    final int? amount = int.tryParse(_amount.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Укажи хотя бы одну монету.')),
      );
      return;
    }
    final int saved = profile.savedFor(goal.id);
    final String impact;
    if (withdraw) {
      final int perPeriod = profile.plan?.savings ?? 0;
      final int? beforePeriods = EconomyRules.periodsToGoal(
        price: goal.price,
        saved: saved,
        perPeriod: perPeriod,
      );
      final int? afterPeriods = EconomyRules.periodsToGoal(
        price: goal.price,
        saved: saved - amount,
        perPeriod: perPeriod,
      );
      final String timeline = beforePeriods == null || afterPeriods == null
          ? 'В бюджете пока не запланированы накопления, поэтому срок достижения цели оценить нельзя.'
          : 'Примерное число игровых периодов до цели: $beforePeriods → $afterPeriods, если откладывать по $perPeriod монет каждый период.';
      impact = amount <= saved
          ? 'На цели останется ${saved - amount} из ${goal.price}. До мечты будет не хватать ${goal.price - saved + amount} монет. Баланс станет ${profile.balance + amount}. $timeline'
          : 'На этой цели только $saved монет. Такую сумму снять нельзя.';
    } else {
      impact =
          'Сейчас на цели $saved из ${goal.price}, на балансе ${profile.balance}. '
          '${amount <= profile.balance && saved + amount <= goal.price ? 'После перевода на цели будет ${saved + amount}, на балансе ${profile.balance - amount}.' : 'Сумма должна помещаться в баланс и не превышать остаток до цели.'}';
    }
    if (!mounted) return;
    await showAccessibleDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameActionDialog(
        title: withdraw
            ? 'Взять $amount монет с цели?'
            : 'Отложить $amount монет?',
        description:
            '${goal.title}\n\n$impact\n\nСытость и радость не изменятся.',
        confirmLabel: withdraw ? 'Снять монеты' : 'Отложить',
        action: (id) => ref
            .read(gameControllerProvider.notifier)
            .transfer(goal.id, amount, id, withdraw: withdraw),
      ),
    );
  }

  Future<void> _selectGoal(GoalDefinition goal) async {
    await showAccessibleDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameActionDialog(
        title: 'Выбрать эту мечту?',
        description:
            '${goal.title} — ${goal.price} монет. Смена цели не переводит и не тратит накопления.',
        confirmLabel: 'Выбрать цель',
        action: (_) =>
            ref.read(gameControllerProvider.notifier).selectGoal(goal.id),
      ),
    );
  }

  static String _goalImage(String id) => switch (id) {
    'tent' => 'assets/images/savings_treadmill.png',
    'telescope' => 'assets/images/savings_bed.png',
    'garden' => 'assets/images/savings_rare_sapling.png',
    _ => 'assets/images/home_coin_tree.png',
  };

  Widget _panel({required Widget child, EdgeInsets? padding}) => Container(
    padding: padding ?? const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: _cream,
      borderRadius: BorderRadius.circular(27),
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: const [
        BoxShadow(
          color: Color(0x663D3519),
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: child,
  );

  Widget _goalCard(GoalDefinition goal, bool compact) => Expanded(
    child: InkWell(
      onTap: () => _selectGoal(goal),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: compact ? 82 : 104,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: goal.id == 'telescope'
              ? const Color(0xFFFFDFDE)
              : const Color(0xFFDEFFF0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(_goalImage(goal.id), fit: BoxFit.contain),
            ),
            const SizedBox(width: 2),
            Expanded(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  goal.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFB76A43)),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    final compact = MediaQuery.sizeOf(context).height < 760;
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
                child: ref
                    .watch(gameCatalogProvider)
                    .when(
                      loading: () => const Center(child: LoadingStatus()),
                      error: (_, _) => Center(
                        child: TextButton(
                          onPressed: () => ref.invalidate(gameCatalogProvider),
                          child: const Text('Повторить загрузку целей'),
                        ),
                      ),
                      data: (catalog) {
                        final goals = catalog.goals
                            .where((goal) => goal.id != 'tree_bank')
                            .toList();
                        final goal = catalog.goals.firstWhere(
                          (item) => item.id == profile?.selectedGoalId,
                          orElse: () => goals.first,
                        );
                        final others = goals
                            .where((item) => item.id != goal.id)
                            .toList();
                        final saved = profile?.savedFor(goal.id) ?? 0;
                        final amount = int.tryParse(_amount.text) ?? 0;
                        final remaining = (goal.price - saved).clamp(
                          0,
                          goal.price,
                        );
                        return ListView(
                          padding: const EdgeInsets.fromLTRB(11, 5, 11, 20),
                          children: [
                            Row(
                              children: [
                                const Expanded(child: StoryLogo(height: 48)),
                                const SizedBox(width: 7),
                                _panel(
                                  padding: const EdgeInsets.fromLTRB(
                                    5,
                                    3,
                                    8,
                                    3,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/cat_coin.png',
                                        width: 38,
                                        height: 38,
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
                                        backgroundColor: Color(0xFF05AF77),
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
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                IconButton.filled(
                                  tooltip: 'Назад',
                                  onPressed: () =>
                                      Navigator.of(context).maybePop(),
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xFFA227EA),
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(49, 49),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: _panel(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/budget_savings.png',
                                          width: 39,
                                          height: 39,
                                        ),
                                        const SizedBox(width: 4),
                                        const Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'Накопления',
                                              style: TextStyle(
                                                color: _ink,
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
                            SizedBox(
                              height: compact ? 174 : 225,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: -9,
                                    bottom: -9,
                                    child: PetPortrait(
                                      coat: profile?.coat ?? PetCoat.ginger,
                                      accessory:
                                          profile?.accessory ??
                                          PetAccessory.scarf,
                                      size: compact ? 183 : 230,
                                      emotion: PetEmotion.happy,
                                    ),
                                  ),
                                  Positioned(
                                    right: goal.id == 'telescope' ? -20 : -8,
                                    bottom: goal.id == 'telescope' ? -13 : -5,
                                    child: Image.asset(
                                      _goalImage(goal.id),
                                      width: compact ? 193 : 241,
                                      height: compact ? 138 : 189,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Positioned(
                                    right: compact ? 45 : 90,
                                    top: 1,
                                    child: _panel(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 6,
                                      ),
                                      child: Text(
                                        'Я коплю\nна мечту!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _ink,
                                          fontSize: compact ? 15 : 19,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _panel(
                              child: Row(
                                children: [
                                  Image.asset(
                                    _goalImage(goal.id),
                                    width: compact ? 63 : 85,
                                    height: compact ? 83 : 105,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'Моя цель: ${goal.title.toLowerCase()}',
                                            style: const TextStyle(
                                              color: _ink,
                                              fontSize: 21,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: (saved / goal.price).clamp(
                                              0.0,
                                              1.0,
                                            ),
                                            minHeight: 13,
                                            backgroundColor: const Color(
                                              0xFFEBD8BE,
                                            ),
                                            color: const Color(0xFF08BEBC),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '$saved / ${goal.price}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: _ink,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          'Осталось накопить: $remaining',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: _ink,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 7),
                            _panel(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/cat_coin.png',
                                        width: 34,
                                        height: 34,
                                      ),
                                      const SizedBox(width: 5),
                                      const Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'Отложить коткоины',
                                            style: TextStyle(
                                              color: _ink,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      for (final choice in [10, 20, 50]) ...[
                                        if (choice != 10)
                                          const SizedBox(width: 4),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => setState(
                                              () => _amount.text = '$choice',
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Container(
                                              height: compact ? 42 : 55,
                                              decoration: BoxDecoration(
                                                color: amount == choice
                                                    ? const Color(0xFF007D70)
                                                    : const Color(0xFFFFF4DA),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: amount == choice
                                                      ? const Color(0xFFFFD936)
                                                      : const Color(0xFFFFDBAF),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Center(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/cat_coin.png',
                                                        width: compact
                                                            ? 23
                                                            : 29,
                                                        height: compact
                                                            ? 23
                                                            : 29,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                        '$choice',
                                                        style: TextStyle(
                                                          color:
                                                              amount == choice
                                                              ? Colors.white
                                                              : _ink,
                                                          fontSize: compact
                                                              ? 19
                                                              : 24,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'После пополнения: ${saved + amount} / ${goal.price}',
                                    style: const TextStyle(
                                      color: _ink,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 7),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFF35C),
                                    Color(0xFFFFAE18),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(27),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: FilledButton.icon(
                                onPressed: profile == null
                                    ? null
                                    : profile.selectedGoalId != goal.id
                                    ? () => _selectGoal(goal)
                                    : profile.plan == null
                                    ? null
                                    : () => _transfer(profile, goal, false),
                                icon: Image.asset(
                                  'assets/images/cat_coin.png',
                                  width: 34,
                                  height: 34,
                                ),
                                label: Text(
                                  profile?.selectedGoalId == goal.id
                                      ? 'Отложить ${_amount.text}'
                                      : 'Выбрать цель',
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: _ink,
                                  shadowColor: Colors.transparent,
                                  minimumSize: Size.fromHeight(
                                    compact ? 49 : 61,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            if (profile?.plan == null)
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Для перевода сначала подтверди бюджет.',
                                  style: TextStyle(color: _ink),
                                ),
                              ),
                            const SizedBox(height: 7),
                            _panel(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Другие цели',
                                    style: TextStyle(
                                      color: _ink,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      for (
                                        var index = 0;
                                        index < others.length;
                                        index++
                                      ) ...[
                                        if (index > 0) const SizedBox(width: 5),
                                        _goalCard(others[index], compact),
                                      ],
                                    ],
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
}
