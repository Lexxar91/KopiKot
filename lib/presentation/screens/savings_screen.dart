import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_profile.dart';
import '../../domain/rules/economy_rules.dart';
import '../providers/game_controller.dart';
import '../widgets/game_action_dialog.dart';
import '../widgets/accessible_motion.dart';

/// Накопления каждой цели отделены от доступного баланса и от других целей.
class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});
  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen> {
  final _amount = TextEditingController(text: '10');
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
            '${goal.title}\n\n$impact\n\nСытость и настроение не изменятся.',
        confirmLabel: withdraw ? 'Снять монеты' : 'Отложить',
        action: (id) => ref
            .read(gameControllerProvider.notifier)
            .transfer(goal.id, amount, id, withdraw: withdraw),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gameControllerProvider).asData?.value;
    return Scaffold(
      appBar: AppBar(title: const Text('На мечту')),
      body: ref
          .watch(gameCatalogProvider)
          .when(
            loading: () => const Center(child: LoadingStatus()),
            error: (_, _) => Center(
              child: TextButton(
                onPressed: () => ref.invalidate(gameCatalogProvider),
                child: const Text('Повторить загрузку целей'),
              ),
            ),
            data: (catalog) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Баланс: ${profile?.balance ?? 0} · Все накопления: ${profile?.savings ?? 0}',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Выбери мечту. При смене цели уже отложенные монеты остаются на своих целях.',
                ),
                if (profile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(profile.feedback),
                    ),
                  ),
                for (final goal in catalog.goals)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(goal.description),
                          const SizedBox(height: 8),
                          Text(
                            '${profile?.savedFor(goal.id) ?? 0} из ${goal.price} монет',
                          ),
                          Text(
                            'Осталось: ${goal.price - (profile?.savedFor(goal.id) ?? 0)}',
                          ),
                          if (profile?.savedFor(goal.id) == goal.price)
                            const Text('Цель достигнута!'),
                          if (profile?.selectedGoalId == goal.id) ...[
                            const SizedBox(height: 12),
                            const Text('Выбранная цель'),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _amount,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Сумма перевода',
                                suffixText: 'монет',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                FilledButton(
                                  onPressed: profile?.plan == null
                                      ? null
                                      : () => _transfer(profile!, goal, false),
                                  child: const Text('Пополнить'),
                                ),
                                OutlinedButton(
                                  onPressed: profile?.plan == null
                                      ? null
                                      : () => _transfer(profile!, goal, true),
                                  child: const Text('Взять с цели'),
                                ),
                              ],
                            ),
                            if (profile?.plan == null)
                              const Text(
                                'Для перевода сначала подтверди бюджет.',
                              ),
                          ] else
                            TextButton(
                              onPressed: profile == null
                                  ? null
                                  : () => showAccessibleDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => GameActionDialog(
                                        title: 'Выбрать эту мечту?',
                                        description:
                                            '${goal.title} — ${goal.price} монет. Смена цели не переводит и не тратит накопления.',
                                        confirmLabel: 'Выбрать цель',
                                        action: (_) => ref
                                            .read(
                                              gameControllerProvider.notifier,
                                            )
                                            .selectGoal(goal.id),
                                      ),
                                    ),
                              child: const Text('Выбрать цель'),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}
