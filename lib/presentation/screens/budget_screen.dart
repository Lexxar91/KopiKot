import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/models/game_transaction.dart';
import '../../domain/rules/game_rules.dart';
import '../../domain/rules/period_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/accessible_motion.dart';

/// Черновик редактируется локально, подтверждение сохраняется через репозиторий.
class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  final _needs = TextEditingController(text: '0');
  final _wants = TextEditingController(text: '0');
  final _gifts = TextEditingController(text: '0');
  final _savings = TextEditingController(text: '0');
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _needs.dispose();
    _wants.dispose();
    _gifts.dispose();
    _savings.dispose();
    super.dispose();
  }

  int _value(TextEditingController controller) =>
      int.tryParse(controller.text) ?? 0;

  Future<void> _confirm(GameProfile profile) async {
    final int needs = _value(_needs);
    final int wants = _value(_wants);
    final int gifts = _value(_gifts);
    final int savings = _value(_savings);
    try {
      GameRules.confirmBudget(
        profile,
        needs: needs,
        wants: wants,
        gifts: gifts,
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
          'Нужно: $needs\nРадость: $wants\nПодарки: $gifts\nНа мечту: $savings\n\nМонеты пока не тратятся. После подтверждения изменить план этого периода нельзя.',
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
          .confirmBudget(needs, wants, savings, gifts: gifts);
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

  Widget _amount(String label, String hint, TextEditingController controller) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextField(
          controller: controller,
          enabled: !_saving,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onChanged: (_) => setState(() => _error = null),
          decoration: InputDecoration(
            labelText: label,
            helperText: hint,
            suffixText: 'монет',
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
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
        profile.balance -
        _value(_needs) -
        _value(_wants) -
        _value(_gifts) -
        _value(_savings);
    return Scaffold(
      appBar: AppBar(title: const Text('Мой бюджет')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Период ${profile.period}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (plan == null) ...[
                Text(
                  'Распредели ${profile.balance} монет. Можно оставить часть на потом.',
                ),
                const SizedBox(height: 24),
                _amount('Нужно', 'Еда и уход для питомца', _needs),
                _amount('Хочется', 'Игрушки и украшения — по желанию', _wants),
                _amount(
                  'На мечту',
                  'Монеты, которые хочешь отложить',
                  _savings,
                ),
                _amount('Подарки', 'Добрые сюрпризы друзьям питомца', _gifts),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    remaining >= 0
                        ? 'Осталось распределить: $remaining'
                        : 'Не хватает: ${-remaining} монет',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Планирование не списывает монеты. Перевод в накопления — отдельное действие.',
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _saving || remaining < 0
                      ? null
                      : () => _confirm(profile),
                  child: Text(_saving ? 'Сохраняем…' : 'Подтвердить план'),
                ),
              ] else ...[
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
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Semantics(liveRegion: true, child: Text(_error!)),
                ),
            ],
          ),
        ),
      ),
    );
  }
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
