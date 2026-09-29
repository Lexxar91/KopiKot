import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/rules/period_rules.dart';

const _artwork = 'assets/images/daily_tip_reference.png';
const _brown = Color(0xFF55200F);

/// Короткий совет и его акцентная первая фраза.
class DailyTip {
  const DailyTip(this.title, this.body);

  final String title;
  final String body;

  String get fullText => '$title $body';
}

const dailyTips = [
  DailyTip(
    'Перед покупкой подумай:',
    'тебе это нужно сейчас или просто очень хочется?',
  ),
  DailyTip(
    'Получил монетки?',
    'Часть можно оставить на нужные покупки, а часть — копить на мечту.',
  ),
  DailyTip('Посчитай заранее:', 'сколько монет останется после покупки?'),
];

/// В течение игрового дня совет неизменен; на следующий день берётся следующий.
DailyTip dailyTipForDay(String dayKey) {
  final days = PeriodRules.daysBetween('2020-01-01', dayKey);
  return dailyTips[((days % dailyTips.length) + dailyTips.length) %
      dailyTips.length];
}

/// Иллюстрированный экран совета с оформлением из макета.
class DailyTipScreen extends StatelessWidget {
  const DailyTipScreen({this.dayKey, super.key});

  final String? dayKey;

  @override
  Widget build(BuildContext context) {
    final tip = dailyTipForDay(dayKey ?? PeriodRules.dayKey(DateTime.now()));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFF88C9F6),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: ListView(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final scale = width / 941;
                      return SizedBox(
                        height: 1672 * scale,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(_artwork, fit: BoxFit.fill),
                            ),
                            Positioned(
                              left: 22 * scale,
                              top: 63 * scale,
                              width: 152 * scale,
                              height: 145 * scale,
                              child: Semantics(
                                button: true,
                                label: 'Назад',
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.of(context).maybePop(),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 32 * scale,
                              top: 1057 * scale,
                              width: 877 * scale,
                              height: 437 * scale,
                              child: _TipCard(tip: tip, scale: scale),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip, required this.scale});

  final DailyTip tip;
  final double scale;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFFFF8E5),
      borderRadius: BorderRadius.circular(43 * scale),
      border: Border.all(color: const Color(0xFFFFC54B), width: 5 * scale),
      boxShadow: const [BoxShadow(color: Color(0x8052230D), blurRadius: 8)],
    ),
    child: Stack(
      children: [
        Positioned(
          left: 18 * scale,
          top: 12 * scale,
          child: Icon(
            Icons.eco_rounded,
            color: const Color(0xFF3B9C25),
            size: 62 * scale,
          ),
        ),
        Positioned(
          right: 18 * scale,
          top: 12 * scale,
          child: Icon(
            Icons.eco_rounded,
            color: const Color(0xFF3B9C25),
            size: 62 * scale,
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              45 * scale,
              43 * scale,
              45 * scale,
              26 * scale,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 785 * scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tip.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _brown,
                        fontSize: 72 * scale,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 24 * scale),
                    Text(
                      tip.body,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _brown,
                        fontSize: 52 * scale,
                        height: 1.27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
