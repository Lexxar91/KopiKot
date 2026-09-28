import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_profile.dart';
import '../../domain/models/day_financial_report.dart';
import '../../domain/models/game_transaction.dart';
import '../../domain/rules/game_rules.dart';
import '../../domain/rules/period_rules.dart';
import '../../domain/rules/budget_income_rules.dart';
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
  final _kept = TextEditingController(text: '0');
  final _sourceIds = <String>{};
  int _draftGifts = 0;
  int? _draftPeriod;
  bool _editing = false;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(gameControllerProvider).asData?.value;
    if (profile != null && profile.plan == null) _seedDraft(profile);
  }

  void _seedDraft(GameProfile profile) {
    final openingBalance = GameRules.openingBalance(profile);
    final needs = openingBalance ~/ 2;
    final wants = (openingBalance - needs) ~/ 2;
    _needs.text = '$needs';
    _wants.text = '$wants';
    _savings.text = '${openingBalance - needs - wants}';
    _kept.text = '0';
    _draftGifts = 0;
    _sourceIds.clear();
    _draftPeriod = profile.period;
  }

  void _startRevision(BudgetPlan plan, List<BudgetIncomeOption> options) {
    setState(() {
      _needs.text = '${plan.needs}';
      _wants.text = '${plan.wants}';
      _savings.text = '${plan.savings}';
      _kept.text = '${plan.kept}';
      _draftGifts = plan.gifts;
      _sourceIds
        ..clear()
        ..addAll(
          plan.sourceIds.where(
            (id) => options.any((option) => option.id == id),
          ),
        );
      _editing = true;
      _error = null;
    });
  }

  Widget _forecastPanel(
    GameProfile profile,
    int openingBalance,
    List<BudgetIncomeOption> options,
    int expectedIncome,
  ) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF9EA),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white, width: 3),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Кошелёк в начале: $openingBalance · Сейчас: ${profile.balance}',
          style: const TextStyle(
            color: Color(0xFF642818),
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          'Накопления отдельно: ${profile.savings} · Ожидаемый доход: $expectedIncome',
          style: const TextStyle(color: Color(0xFF642818)),
        ),
        Material(
          type: MaterialType.transparency,
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: const Text(
              'Выбрать источники дохода',
              style: TextStyle(
                color: Color(0xFF642818),
                fontWeight: FontWeight.w900,
              ),
            ),
            children: [
              for (final option in options)
                CheckboxListTile(
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(option.title),
                  subtitle: Text(
                    'Базовая: ${option.base} · ${option.received ? 'получено' : 'ожидается'}: ${option.expected}',
                  ),
                  value: _sourceIds.contains(option.id),
                  onChanged: (value) => setState(() {
                    if (value == true) {
                      _sourceIds.add(option.id);
                    } else {
                      _sourceIds.remove(option.id);
                    }
                    _error = null;
                  }),
                ),
            ],
          ),
        ),
        const Text(
          'Планируемый доход — прогноз. Потратить его можно только после получения.',
          style: TextStyle(color: Color(0xFF654938), fontSize: 12),
        ),
      ],
    ),
  );

  @override
  void dispose() {
    _needs.dispose();
    _wants.dispose();
    _savings.dispose();
    _kept.dispose();
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
    final other =
        _value(_needs) +
        _value(_wants) +
        _value(_savings) +
        _value(_kept) +
        _draftGifts -
        current;
    final maximum = (available - other).clamp(0, 999999);
    final next = (current + change).clamp(0, maximum);
    if (next == current) return;
    controller.text = '$next';
    setState(() => _error = null);
  }

  Future<void> _confirm(GameProfile profile, int expectedIncome) async {
    final int needs = _value(_needs);
    final int wants = _value(_wants);
    final int savings = _value(_savings);
    final int kept = _value(_kept);
    final sourceIds = _sourceIds.toList()..sort();
    try {
      if (_editing) {
        GameRules.reviseBudget(
          profile,
          needs: needs,
          wants: wants,
          savings: savings,
          gifts: _draftGifts,
          kept: kept,
          expectedIncome: expectedIncome,
          sourceIds: sourceIds,
        );
      } else {
        GameRules.confirmBudget(
          profile,
          needs: needs,
          wants: wants,
          savings: savings,
          gifts: _draftGifts,
          kept: kept,
          expectedIncome: expectedIncome,
          sourceIds: sourceIds,
        );
      }
    } on GameRuleException catch (error) {
      setState(() => _error = error.message);
      return;
    }
    final bool? confirmed = await showAccessibleDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(_editing ? 'Обновить план?' : 'Сохранить этот план?'),
        content: Text(
          'Нужное: $needs\nРадость: $wants\nКопилка: $savings\n'
          'Оставить в кошельке: $kept\nОжидаемый доход: $expectedIncome\n\n'
          'План не списывает коткоины. Будущий доход можно потратить только после получения. План можно пересчитать.',
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
      if (_editing) {
        await ref
            .read(gameControllerProvider.notifier)
            .reviseBudget(
              needs,
              wants,
              savings,
              gifts: _draftGifts,
              kept: kept,
              expectedIncome: expectedIncome,
              sourceIds: sourceIds,
            );
      } else {
        await ref
            .read(gameControllerProvider.notifier)
            .confirmBudget(
              needs,
              wants,
              savings,
              gifts: _draftGifts,
              kept: kept,
              expectedIncome: expectedIncome,
              sourceIds: sourceIds,
            );
      }
      if (mounted) setState(() => _editing = false);
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
    final catalog = ref.watch(gameCatalogProvider).asData?.value;
    final options = catalog == null
        ? <BudgetIncomeOption>[]
        : BudgetIncomeRules.options(profile, catalog);
    final expectedIncome = options
        .where((option) => _sourceIds.contains(option.id))
        .fold<int>(0, (sum, option) => sum + option.expected);
    final openingBalance =
        plan?.openingBalance ?? GameRules.openingBalance(profile);
    final planningBudget = openingBalance + expectedIncome;
    final int remaining =
        planningBudget -
        _value(_needs) -
        _value(_wants) -
        _value(_savings) -
        _value(_kept) -
        _draftGifts;
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
                      if (plan == null &&
                          profile.periodSummaries.isNotEmpty &&
                          profile.periodSummaries.last.period ==
                              profile.period - 1)
                        _lastDayCard(profile),
                      if (plan == null || _editing)
                        BudgetDraft(
                          profile: profile,
                          needs: _needs,
                          wants: _wants,
                          savings: _savings,
                          kept: _kept,
                          planningBudget: planningBudget,
                          forecastPanel: _forecastPanel(
                            profile,
                            openingBalance,
                            options,
                            expectedIncome,
                          ),
                          remaining: remaining,
                          saving: _saving,
                          onInputChanged: () => setState(() => _error = null),
                          onAdjust: (controller, change) =>
                              _adjustAmount(controller, change, planningBudget),
                          onSave: () => _confirm(profile, expectedIncome),
                        )
                      else
                        _confirmedPlan(profile, plan, options),
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

  Widget _lastDayCard(GameProfile profile) {
    final summary = profile.periodSummaries.last;
    final report = DayFinancialReport.fromProfile(profile, summary.period);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Итоги прошлого дня',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF642818),
            ),
          ),
          Text(
            'Кошелёк в начале: ${report.openingWallet} · Накопления: ${report.openingSavings}',
          ),
          Text(
            'Доходы: план ${summary.plannedIncome ?? '—'} / факт ${report.income}',
          ),
          for (final source in report.incomeBySource.entries)
            Text('• ${source.key}: +${source.value}'),
          Text(
            'Покупки: нужное ${report.needs}, радость ${report.wants}, '
            'подарки ${report.gifts}, Котодерево ${report.saplings}',
          ),
          Text(
            'Накопления: +${report.deposits} переведено · −${report.withdrawals} снято',
          ),
          Text(
            'В конце: кошелёк ${report.closingWallet} · накопления ${report.closingSavings}',
          ),
          Text(
            'План / факт: нужное ${summary.plannedNeeds}/${report.needs}, '
            'радость ${summary.plannedWants}/${summary.actualWants}, '
            'накопления ${summary.plannedSavings}/${report.netSaved}',
          ),
          if (summary.missedDays > 0)
            Text('Был перерыв: ${summary.missedDays} дн. Коткоины не списаны.'),
        ],
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

  Widget _confirmedPlan(
    GameProfile profile,
    BudgetPlan plan,
    List<BudgetIncomeOption> options,
  ) => Column(
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
            Text(
              'Кошелёк в начале: ${plan.openingBalance} · Ожидаемый доход: ${plan.expectedIncome}',
              style: const TextStyle(color: Color(0xFF642818), fontSize: 13),
            ),
            Text(
              'Получено за период: ${profile.totalFor(TransactionKind.income)} · Сейчас в кошельке: ${profile.balance}',
              style: const TextStyle(color: Color(0xFF642818), fontSize: 13),
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
            _BudgetSummaryLine(
              assetPath: 'assets/images/cat_coin.png',
              background: const Color(0xFFFFF2CF),
              title: 'Оставить в кошельке:',
              value: '${plan.kept}',
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
      if (profile.isTest) ...[
        const SizedBox(height: 9),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _startRevision(plan, options),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Пересчитать план'),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF9EA),
              foregroundColor: const Color(0xFF642818),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
        if (profile.budgetRevisions.any(
          (entry) => entry.period == profile.period,
        ))
          ExpansionTile(
            title: const Text(
              'Предыдущие варианты плана',
              style: TextStyle(
                color: Color(0xFF642818),
                fontWeight: FontWeight.w800,
              ),
            ),
            children: [
              for (final revision in profile.budgetRevisions.where(
                (entry) => entry.period == profile.period,
              ))
                ListTile(
                  tileColor: const Color(0xFFFFF9EA),
                  title: Text(
                    'Нужно ${revision.plan.needs} · Радость ${revision.plan.wants} · Копилка ${revision.plan.savings}',
                  ),
                  subtitle: Text(
                    'Доход ${revision.plan.expectedIncome} · В кошельке ${revision.plan.kept}',
                  ),
                ),
            ],
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
                title: 'Завершить день ${profile.period}?',
                description:
                    '${PeriodRules.summarize(profile).explanation}\n\n'
                    'В деморежиме сразу откроется следующий игровой день. '
                    'Награда дня начислится один раз, затем можно составить новый план.',
                confirmLabel: 'Следующий день',
                action: (_) => ref
                    .read(gameControllerProvider.notifier)
                    .finishPeriod(profile.period),
              ),
            ),
            child: const Text(
              'Завершить день',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
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
