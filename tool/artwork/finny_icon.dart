import 'package:flutter/material.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/presentation/widgets/pet_portrait.dart';

/// Исходник иконки: тот же питомец, что в игре, и собственная игровая монета.
/// PNG для Android и магазина воспроизводятся через export_store_assets.dart.
class FinnyIcon extends StatelessWidget {
  const FinnyIcon({this.adaptiveForeground = false, super.key});
  final bool adaptiveForeground;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: adaptiveForeground ? Colors.transparent : const Color(0xFF356C64),
    child: FractionallySizedBox(
      widthFactor: adaptiveForeground ? 0.59 : 0.86,
      heightFactor: adaptiveForeground ? 0.59 : 0.86,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth;
          return Stack(
            children: [
              PetPortrait(
                coat: PetCoat.ginger,
                accessory: PetAccessory.scarf,
                size: size,
              ),
              Positioned(
                right: adaptiveForeground ? size * 0.10 : 0,
                bottom: adaptiveForeground ? size * 0.10 : 0,
                width: size * 0.30,
                height: size * 0.30,
                child: const CustomPaint(painter: _CoinPainter()),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class _CoinPainter extends CustomPainter {
  const _CoinPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);
    canvas.drawCircle(
      const Offset(50, 50),
      48,
      Paint()..color = const Color(0xFF81551B),
    );
    canvas.drawCircle(
      const Offset(50, 50),
      43,
      Paint()..color = const Color(0xFFFFD479),
    );
    canvas.drawCircle(
      const Offset(50, 50),
      32,
      Paint()
        ..color = const Color(0xFFAF7523)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    final mark = Path()
      ..moveTo(50, 26)
      ..lineTo(69, 50)
      ..lineTo(50, 74)
      ..lineTo(31, 50)
      ..close();
    canvas.drawPath(mark, Paint()..color = const Color(0xFFAF7523));
  }

  @override
  bool shouldRepaint(covariant _CoinPainter oldDelegate) => false;
}
