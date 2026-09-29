import 'package:flutter/material.dart';

/// Медаль с лапкой для значков целей и кнопки на главном экране.
class GoalMedal extends StatelessWidget {
  const GoalMedal({required this.size, required this.accent, super.key});

  final double size;
  final Color accent;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          left: size * 0.18,
          bottom: size * 0.02,
          child: Transform.rotate(angle: 0.18, child: _ribbon()),
        ),
        Positioned(
          right: size * 0.18,
          bottom: size * 0.02,
          child: Transform.rotate(angle: -0.18, child: _ribbon()),
        ),
        Container(
          width: size * 0.78,
          height: size * 0.78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF99B), Color(0xFFFFC323), Color(0xFFD6810B)],
            ),
            border: Border.all(color: Colors.white, width: size * 0.035),
            boxShadow: [
              BoxShadow(
                color: const Color(0x88572D08),
                blurRadius: size * 0.05,
                offset: Offset(0, size * 0.035),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.085),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent,
                border: Border.all(
                  color: const Color(0xFFFFF5A8),
                  width: size * 0.025,
                ),
              ),
              child: Icon(
                Icons.pets_rounded,
                color: const Color(0xFFFFE564),
                size: size * 0.38,
                shadows: const [
                  Shadow(color: Color(0xFF934313), blurRadius: 3),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _ribbon() => Container(
    width: size * 0.22,
    height: size * 0.43,
    decoration: BoxDecoration(
      color: accent,
      border: Border.all(color: const Color(0xFFFFD759), width: size * 0.015),
      borderRadius: BorderRadius.circular(size * 0.025),
    ),
  );
}
