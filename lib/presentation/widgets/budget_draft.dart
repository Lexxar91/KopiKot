import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/game_profile.dart';
import 'pet_portrait.dart';

const _brown = Color(0xFF642818);
const _cream = Color(0xFFFFF9EA);

/// Черновик бюджета: ввод остаётся локальным до отдельного подтверждения.
class BudgetDraft extends StatelessWidget {
  const BudgetDraft({
    required this.profile,
    required this.needs,
    required this.wants,
    required this.savings,
    required this.kept,
    required this.planningBudget,
    required this.forecastPanel,
    required this.remaining,
    required this.saving,
    required this.onInputChanged,
    required this.onAdjust,
    required this.onSave,
    super.key,
  });

  final GameProfile profile;
  final TextEditingController needs;
  final TextEditingController wants;
  final TextEditingController savings;
  final TextEditingController kept;
  final int planningBudget;
  final Widget forecastPanel;
  final int remaining;
  final bool saving;
  final VoidCallback onInputChanged;
  final void Function(TextEditingController controller, int change) onAdjust;
  final VoidCallback onSave;

  int _value(TextEditingController controller) =>
      int.tryParse(controller.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    final compact =
        MediaQuery.sizeOf(context).height < 700 &&
        MediaQuery.textScalerOf(context).scale(1) < 1.25;
    final needsValue = _value(needs);
    final wantsValue = _value(wants);
    final savingsValue = _value(savings);
    final keptValue = _value(kept);
    final distributed = needsValue + wantsValue + savingsValue + keptValue;
    return Column(
      children: [
        _BudgetHero(profile: profile, compact: compact),
        forecastPanel,
        SizedBox(height: compact ? 5 : 8),
        Container(
          padding: EdgeInsets.fromLTRB(8, compact ? 6 : 10, 8, compact ? 5 : 9),
          decoration: BoxDecoration(
            color: _cream,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x604B330F),
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Можно запланировать:',
                      style: TextStyle(
                        color: _brown,
                        fontSize: compact ? 20 : 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Image.asset('assets/images/cat_coin.png', width: 26),
                  Text(
                    '$planningBudget',
                    style: TextStyle(
                      color: _brown,
                      fontSize: compact ? 22 : 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: compact ? 3 : 7),
              _BudgetAmountRow(
                label: 'Нужное',
                compact: compact,
                assetPath: 'assets/images/budget_needs.png',
                background: const Color(0xFFFFE2E5),
                controller: needs,
                saving: saving,
                canIncrease: remaining > 0,
                onInputChanged: onInputChanged,
                onDecrease: () => onAdjust(needs, -5),
                onIncrease: () => onAdjust(needs, 5),
              ),
              SizedBox(height: compact ? 3 : 5),
              _BudgetAmountRow(
                label: 'Радость',
                compact: compact,
                assetPath: 'assets/images/budget_joy.png',
                background: const Color(0xFFE4FBE8),
                controller: wants,
                saving: saving,
                canIncrease: remaining > 0,
                onInputChanged: onInputChanged,
                onDecrease: () => onAdjust(wants, -5),
                onIncrease: () => onAdjust(wants, 5),
              ),
              SizedBox(height: compact ? 3 : 5),
              _BudgetAmountRow(
                label: 'Копилка',
                compact: compact,
                assetPath: 'assets/images/budget_savings.png',
                background: const Color(0xFFDCF4FF),
                controller: savings,
                saving: saving,
                canIncrease: remaining > 0,
                onInputChanged: onInputChanged,
                onDecrease: () => onAdjust(savings, -5),
                onIncrease: () => onAdjust(savings, 5),
              ),
              SizedBox(height: compact ? 3 : 5),
              _BudgetAmountRow(
                label: 'Оставить в кошельке',
                compact: compact,
                assetPath: 'assets/images/cat_coin.png',
                background: const Color(0xFFFFF1D3),
                controller: kept,
                saving: saving,
                canIncrease: remaining > 0,
                onInputChanged: onInputChanged,
                onDecrease: () => onAdjust(kept, -5),
                onIncrease: () => onAdjust(kept, 5),
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? 5 : 7),
        Container(
          padding: EdgeInsets.fromLTRB(
            10,
            compact ? 5 : 7,
            10,
            compact ? 6 : 9,
          ),
          decoration: BoxDecoration(
            color: _cream,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TotalLabel(
                      label: 'Распределено:',
                      value: distributed,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 35,
                    color: const Color(0xFFD9C7AA),
                  ),
                  Expanded(
                    child: _TotalLabel(label: 'Осталось:', value: remaining),
                  ),
                ],
              ),
              SizedBox(height: compact ? 4 : 7),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 13,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (needsValue > 0)
                        Expanded(
                          flex: needsValue,
                          child: const ColoredBox(color: Color(0xFFFF677A)),
                        ),
                      if (wantsValue > 0)
                        Expanded(
                          flex: wantsValue,
                          child: const ColoredBox(color: Color(0xFF2FCE73)),
                        ),
                      if (savingsValue > 0)
                        Expanded(
                          flex: savingsValue,
                          child: const ColoredBox(color: Color(0xFF36AFF1)),
                        ),
                      if (keptValue > 0)
                        Expanded(
                          flex: keptValue,
                          child: const ColoredBox(color: Color(0xFFFFC342)),
                        ),
                      if (remaining > 0)
                        Expanded(
                          flex: remaining,
                          child: const ColoredBox(color: Color(0xFFE4DDD2)),
                        ),
                      if (distributed == 0 && remaining <= 0)
                        const Expanded(
                          child: ColoredBox(color: Color(0xFFE4DDD2)),
                        ),
                    ],
                  ),
                ),
              ),
              if (remaining < 0)
                Semantics(
                  liveRegion: true,
                  child: Text(
                    'Не хватает: ${-remaining} монет',
                    style: const TextStyle(
                      color: Color(0xFFB32C44),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: compact ? 6 : 9),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: saving || remaining < 0 ? null : onSave,
            style: FilledButton.styleFrom(
              foregroundColor: _brown,
              backgroundColor: const Color(0xFFFFCE31),
              side: const BorderSide(color: Color(0xFFFF8A1E), width: 2),
              minimumSize: const Size(0, 55),
            ),
            icon: const Icon(Icons.pets_rounded),
            label: Text(
              saving ? 'Сохраняем…' : 'Сохранить план',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Планирование не списывает коткоины. Перевод в накопления — отдельное действие.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _brown, fontSize: 12),
        ),
      ],
    );
  }
}

class _BudgetHero extends StatelessWidget {
  const _BudgetHero({required this.profile, required this.compact});
  final GameProfile profile;
  final bool compact;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: compact ? 96 : 118,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 4,
          bottom: compact ? -6 : 0,
          child:
              profile.coat == PetCoat.ginger &&
                  profile.accessory == PetAccessory.scarf
              ? Image.asset(
                  'assets/images/budget_hero_ginger.png',
                  width: compact ? 180 : 205,
                  height: compact ? 120 : 137,
                  fit: BoxFit.contain,
                  semanticLabel: 'Рыжий котик радуется плану',
                )
              : PetPortrait(
                  coat: profile.coat,
                  accessory: profile.accessory,
                  size: compact ? 112 : 120,
                ),
        ),
        Positioned(
          right: 0,
          top: 8,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 185),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              'Давай решим, куда потратить ${profile.balance}!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _brown,
                fontSize: 17,
                height: 1.1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _BudgetAmountRow extends StatelessWidget {
  const _BudgetAmountRow({
    required this.label,
    required this.compact,
    required this.background,
    required this.controller,
    required this.saving,
    required this.canIncrease,
    required this.onInputChanged,
    required this.onDecrease,
    required this.onIncrease,
    required this.assetPath,
  });

  final String label;
  final bool compact;
  final Color background;
  final TextEditingController controller;
  final bool saving;
  final bool canIncrease;
  final VoidCallback onInputChanged;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final scaledText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      constraints: BoxConstraints(
        minHeight: scaledText
            ? 99
            : compact
            ? 69
            : 75,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: scaledText || compact ? 64 : 72,
            child: Image.asset(assetPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: _brown,
                    fontSize: compact ? 17 : 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filled(
                      tooltip: 'Уменьшить: $label',
                      onPressed:
                          saving || (int.tryParse(controller.text) ?? 0) <= 0
                          ? null
                          : onDecrease,
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFFF526F),
                        minimumSize: const Size(45, 45),
                        padding: EdgeInsets.zero,
                      ),
                      icon: const Icon(Icons.remove_rounded),
                    ),
                    Semantics(
                      label: '$label, коткоинов',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/cat_coin.png', width: 22),
                          const SizedBox(width: 2),
                          SizedBox(
                            width: scaledText ? 58 : 62,
                            child: TextField(
                              controller: controller,
                              enabled: !saving,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              onChanged: (_) => onInputChanged(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _brown,
                                fontSize: compact ? 18 : 21,
                                fontWeight: FontWeight.w900,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: _cream,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: compact ? 6 : 9,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filled(
                      tooltip: 'Увеличить: $label',
                      onPressed: saving || !canIncrease ? null : onIncrease,
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF18C872),
                        minimumSize: const Size(45, 45),
                        padding: EdgeInsets.zero,
                      ),
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalLabel extends StatelessWidget {
  const _TotalLabel({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label $value',
    liveRegion: label == 'Осталось:',
    child: Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _brown,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/cat_coin.png', width: 24),
            const SizedBox(width: 3),
            Text(
              '$value',
              key: label == 'Осталось:' ? const Key('budget-remaining') : null,
              style: const TextStyle(
                color: _brown,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
