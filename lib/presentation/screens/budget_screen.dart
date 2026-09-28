import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/models/game_transaction.dart';
import '../../domain/rules/game_rules.dart';
import '../../domain/rules/period_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/accessible_motion.dart';
import '../widgets/budget_draft.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/pet_portrait.dart';
import '../widgets/story_logo.dart';
import 'tasks_screen.dart';

/// Черновик редактируется локально, подтверждение сохраняется через репозиторий.
class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  final _needs = TextEditingController(text: '0');
  final _wants = TextEditingController(text: '0');
  final _savings = TextEditingController(text: '0');
  int? _draftPeriod;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(gameControllerProvider).asData?.value;
    if (profile != null && profile.plan == null) _seedDraft(profile);
  }

  void _seedDraft(GameProfile profile) {
    final needs = profile.balance ~/ 2;
    final wants = (profile.balance - needs) ~/ 2;
    _needs.text = '$needs';
    _wants.text = '$wants';
    _savings.text = '${profile.balance - needs - wants}';
    _draftPeriod = profile.period;
  }

  @override
  void dispose() {
    _needs.dispose();
    _wants.dispose();
    _savings.dispose();
    super.dispose();
  }

  int _value(TextEditingController controller) =>
      int.tryParse(controller.text) ?? 0;

  void _adjustAmount(
    TextEditingController controller,
    int change,
    int available,
  ) {
    final current = _value(controller);
    final other = _value(_needs) + _value(_wants) + _value(_savings) - current;
    final maximum = (available - other).clamp(0, 999999);
    final next = (current + change).clamp(0, maximum);
    if (next == current) return;
    controller.text = '$next';
    setState(() => _error = null);
  }

  Future<void> _confirm(GameProfile profile) async {
    final int needs = _value(_needs);
    final int wants = _value(_wants);
    final int savings = _value(_savings);
    try {
      GameRules.confirmBudget(
        profile,
        needs: needs,
        wants: wants,
        savings: savings,
      );
    } on GameRuleException catch (error) {
      setState(() => _error = error.message);
      return;
    }
    final bool? confirmed = await showAccessibleDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text('Сохранить этот план?'),
        content: Text(
          'Нужное: $needs\nРадость: $wants\nКопилка: $savings\n\nКоткоины пока не тратятся. После подтверждения изменить план этого периода нельзя.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Изменить'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(gameControllerProvider.notifier)
          .confirmBudget(needs, wants, savings);
    } on GameRuleException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Не удалось сохранить план. Суммы остались здесь — попробуй ещё раз.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(gameControllerProvider, (_, next) {
      final profile = next.asData?.value;
      if (profile != null &&
          profile.plan == null &&
          _draftPeriod != profile.period) {
        setState(() => _seedDraft(profile));
      }
    });
    final GameProfile? profile = ref
        .watch(gameControllerProvider)
        .asData
        ?.value;
    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Мой бюджет')),
        body: const Center(child: Text('Сначала создай питомца.')),
      );
    }
    final BudgetPlan? plan = profile.plan;
    final int remaining =
        profile.balance - _value(_needs) - _value(_wants) - _value(_savings);
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
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(12, 5, 12, 20),
                    children: [
                      _topBar(profile),
                      const SizedBox(height: 5),
                      _titleBar(),
                      if (plan == null)
                        BudgetDraft(
                          profile: profile,
                          needs: _needs,
                          wants: _wants,
                          savings: _savings,
                          remaining: remaining,
                          saving: _saving,
                          onInputChanged: () => setState(() => _error = null),
                          onAdjust: (controller, change) => _adjustAmount(
                            controller,
                            change,
                            profile.balance,
                          ),
                          onSave: () => _confirm(profile),
                        )
                      else
                        _confirmedPlan(profile, plan),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Semantics(
                            liveRegion: true,
                            child: Text(_error!),
                          ),
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

  Widget _topBar(GameProfile profile) => Row(
    children: [
      Expanded(child: const StoryLogo(height: 48)),
      const SizedBox(width: 8),
      Material(
        color: const Color(0xFFFFF9EA),
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            if (profile.plan == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Сначала сохрани план, затем заработай коткоины в заданиях.',
                  ),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const TasksScreen()),
              );
            }
          },
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                const SizedBox(width: 8),
                Image.asset('assets/images/cat_coin.png', width: 27),
                const SizedBox(width: 5),
                Text(
                  '${profile.balance}',
                  style: const TextStyle(
                    color: Color(0xFF642818),
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.add_circle_rounded, color: Color(0xFF19B767)),
                const SizedBox(width: 7),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _titleBar() => Row(
    children: [
      Material(
        color: const Color(0xFF9B35DF),
        borderRadius: BorderRadius.circular(22),
        child: IconButton(
          tooltip: 'Назад',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          iconSize: 28,
        ),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: Container(
          height: 49,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9EA),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.pie_chart_rounded,
                color: Color(0xFF8830C5),
                size: 28,
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Мой бюджет',
                    style: TextStyle(
                      color: Color(0xFF642818),
                      fontSize: 24,
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
  );

  Widget _confirmedPlan(GameProfile profile, BudgetPlan plan) => Column(
    children: [
      SizedBox(
        height: 158,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child:
                  profile.coat == PetCoat.ginger &&
                      profile.accessory == PetAccessory.scarf
                  ? Image.asset(
                      'assets/images/budget_hero_ginger.png',
                      width: 195,
                      height: 158,
                      fit: BoxFit.contain,
                    )
                  : PetPortrait(
                      coat: profile.coat,
                      accessory: profile.accessory,
                      size: 150,
                    ),
            ),
            Positioned(
              top: 13,
              right: 0,
              child: Container(
                width: 172,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9EA),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Text(
                  'План готов!\nСмотрим,\nкак идут дела.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF642818),
                    fontSize: 18,
                    height: 1.05,
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
          color: const Color(0xFFFFF9EA),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x554B330F),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF1FC566),
                  size: 38,
                ),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'План подтверждён',
                    style: TextStyle(
                      color: Color(0xFF642818),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 45, bottom: 7),
              child: Text(
                'Сравни план с тратами.',
                style: TextStyle(color: Color(0xFF642818), fontSize: 15),
              ),
            ),
            const Row(
              children: [
                Spacer(),
                SizedBox(
                  width: 69,
                  child: Center(
                    child: Text(
                      'План',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 69,
                  child: Center(
                    child: Text(
                      'Факт',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
            _BudgetComparisonRow(
              label: 'Нужно',
              assetPath: 'assets/images/budget_needs.png',
              background: const Color(0xFFFFDFE1),
              accent: const Color(0xFFFF5C71),
              planned: plan.needs,
              actual: profile.actualNeeds,
              available: plan.availableAtConfirmation,
            ),
            const SizedBox(height: 6),
            _BudgetComparisonRow(
              label: 'Хочется',
              assetPath: 'assets/images/budget_joy.png',
              background: const Color(0xFFDAFCE8),
              accent: const Color(0xFF16C869),
              planned: plan.wants,
              actual: profile.actualWants,
              available: plan.availableAtConfirmation,
            ),
            if (plan.gifts > 0) ...[
              const SizedBox(height: 6),
              _BudgetComparisonRow(
                label: 'Подарки',
                assetPath: 'assets/images/budget_joy.png',
                background: const Color(0xFFFFECF6),
                accent: const Color(0xFFE879B3),
                planned: plan.gifts,
                actual: profile.actualGifts,
                available: plan.availableAtConfirmation,
              ),
            ],
            const SizedBox(height: 6),
            _BudgetComparisonRow(
              label: 'На мечту',
              assetPath: 'assets/images/budget_savings.png',
              background: const Color(0xFFDDF3FF),
              accent: const Color(0xFF24A8F1),
              planned: plan.savings,
              actual: profile.netSaved,
              available: plan.availableAtConfirmation,
            ),
            const SizedBox(height: 8),
            _BudgetSummaryLine(
              assetPath: 'assets/images/cat_coin.png',
              background: const Color(0xFFFFF2CF),
              title: 'Не распределено:',
              value: '${plan.remaining}',
            ),
            const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFFF1EDFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.track_changes_rounded,
                    size: 45,
                    color: Color(0xFFEF4B4B),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'На цели:',
                          style: TextStyle(
                            color: Color(0xFF642818),
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '+${profile.totalFor(TransactionKind.deposit)} переведено, '
                          '−${profile.totalFor(TransactionKind.withdrawal)} снято.',
                          style: const TextStyle(
                            color: Color(0xFF642818),
                            fontSize: 14,
                          ),
                        ),
                        const Text(
                          'Факт «На мечту» — переводы минус снятия.',
                          style: TextStyle(
                            color: Color(0xFF805D7E),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 9),
      SizedBox(
        width: double.infinity,
        height: 60,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFFC727),
            foregroundColor: const Color(0xFF642818),
            side: const BorderSide(color: Colors.white, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          onPressed: () => showAccessibleDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (_) => GameActionDialog(
              title: 'Завершить период ${profile.period}?',
              description:
                  '${PeriodRules.summarize(profile).explanation}\n\n'
                  'Итоги сохранятся. В новом периоде получишь 100 монет и составишь новый план. '
                  'Сытость снизится не больше чем на 20: питомец ждёт следующий обед. Рост и накопления сохранятся.',
              confirmLabel: 'Следующий период',
              action: (_) => ref
                  .read(gameControllerProvider.notifier)
                  .finishPeriod(profile.period),
            ),
          ),
          child: const Text(
            'Подвести итоги',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    ],
  );
}

class _BudgetComparisonRow extends StatelessWidget {
  const _BudgetComparisonRow({
    required this.label,
    required this.assetPath,
    required this.background,
    required this.accent,
    required this.planned,
    required this.actual,
    required this.available,
  });
  final String label;
  final String assetPath;
  final Color background;
  final Color accent;
  final int planned;
  final int actual;
  final int available;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: accent.withValues(alpha: 0.45)),
    ),
    child: Row(
      children: [
        Image.asset(assetPath, width: 68, height: 76, fit: BoxFit.contain),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF642818),
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        _BudgetValue(
          value: planned,
          available: available,
          color: accent,
          key: ValueKey('budget-plan-$label'),
        ),
        const SizedBox(width: 5),
        _BudgetValue(
          value: actual,
          available: available,
          color: const Color(0xFF17C868),
          key: ValueKey('budget-actual-$label'),
        ),
      ],
    ),
  );
}

class _BudgetValue extends StatelessWidget {
  const _BudgetValue({
    required this.value,
    required this.available,
    required this.color,
    super.key,
  });
  final int value;
  final int available;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 69,
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9EA),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/cat_coin.png', width: 19),
              const SizedBox(width: 3),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$value',
                    style: const TextStyle(
                      color: Color(0xFF642818),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: available <= 0 ? 0 : (value / available).clamp(0.0, 1.0),
            backgroundColor: const Color(0xFFD9D7D5),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    ),
  );
}

class _BudgetSummaryLine extends StatelessWidget {
  const _BudgetSummaryLine({
    required this.assetPath,
    required this.background,
    required this.title,
    required this.value,
  });
  final String assetPath;
  final Color background;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(19),
    ),
    child: Row(
      children: [
        Image.asset(assetPath, width: 42, height: 42),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF642818),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF642818),
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}
