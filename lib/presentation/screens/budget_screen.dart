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

  Widget _confirmedPlan(GameProfile profile, BudgetPlan plan) => Container(
    margin: const EdgeInsets.only(top: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF9EA),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('План подтверждён. Сравни его с тратами.'),
        const SizedBox(height: 16),
        _PlanLine(
          label: 'Нужно',
          amount: plan.needs,
          actual: profile.actualNeeds,
        ),
        _PlanLine(
          label: 'Хочется',
          amount: plan.wants,
          actual: profile.actualWants,
        ),
        if (plan.gifts > 0)
          _PlanLine(
            label: 'Подарки',
            amount: plan.gifts,
            actual: profile.actualGifts,
          ),
        _PlanLine(
          label: 'На мечту',
          amount: plan.savings,
          actual: profile.netSaved,
        ),
        _PlanLine(label: 'Не распределено', amount: plan.remaining),
        const SizedBox(height: 20),
        Text(
          'Переведено на цели: ${profile.totalFor(TransactionKind.deposit)}. '
          'Снято с целей: ${profile.totalFor(TransactionKind.withdrawal)}.',
        ),
        const SizedBox(height: 12),
        const Text(
          'Факт «На мечту» — переводы минус снятия за период. '
          'Если он отрицательный, ты взял из накоплений больше, чем отложил. '
          'Не потратить на желаемое — допустимый выбор.',
        ),
        const SizedBox(height: 20),
        FilledButton(
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
          child: const Text('Подвести итоги'),
        ),
      ],
    ),
  );
}

class _PlanLine extends StatelessWidget {
  const _PlanLine({required this.label, required this.amount, this.actual});
  final String label;
  final int amount;
  final int? actual;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      actual == null
          ? '$label: $amount монет'
          : '$label — план: $amount · факт: $actual',
    ),
  );
}
