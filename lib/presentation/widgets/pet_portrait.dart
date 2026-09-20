import 'package:flutter/material.dart';

import '../../domain/models/game_profile.dart';

const Map<PetCoat, String> coatLabels = {
  PetCoat.ginger: 'Рыжий',
  PetCoat.grey: 'Серый',
  PetCoat.cream: 'Кремовый',
};
const Map<PetAccessory, String> accessoryLabels = {
  PetAccessory.scarf: 'Шарф',
  PetAccessory.bow: 'Бантик',
  PetAccessory.cap: 'Шапочка',
};

/// Собственная векторная иллюстрация: 3 окраса × 3 аксессуара без сетевых файлов.
class PetPortrait extends StatelessWidget {
  const PetPortrait({
    required this.coat,
    required this.accessory,
    this.size = 180,
    this.stage = 1,
    super.key,
  });
  final PetCoat coat;
  final PetAccessory accessory;
  final double size;
  final int stage;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: '${coatLabels[coat]} кот, ${accessoryLabels[accessory]}',
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _CatPainter(coat, accessory, stage)),
    ),
  );
}

class _CatPainter extends CustomPainter {
  const _CatPainter(this.coat, this.accessory, this.stage);
  final PetCoat coat;
  final PetAccessory accessory;
  final int stage;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 200, size.height / 200);
    final Color fur = switch (coat) {
      PetCoat.ginger => const Color(0xFFEBA559),
      PetCoat.grey => const Color(0xFF9CAEBB),
      PetCoat.cream => const Color(0xFFF0D5A7),
    };
    final Paint fill = Paint()..color = fur;
    final Paint ink = Paint()
      ..color = const Color(0xFF40342F)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      const Offset(100, 100),
      94,
      Paint()..color = const Color(0xFFE9F1E9),
    );
    canvas.drawOval(
      const Rect.fromLTWH(41, 177, 119, 12),
      Paint()..color = const Color(0xFFD2DECF),
    );
    final Path tail = Path()
      ..moveTo(141, 164)
      ..quadraticBezierTo(191, 171, 171, 131);
    canvas.drawPath(
      tail,
      Paint()
        ..color = fur
        ..style = PaintingStyle.stroke
        ..strokeWidth = 17
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawOval(const Rect.fromLTWH(56, 99, 94, 86), fill);
    canvas.drawOval(
      const Rect.fromLTWH(79, 126, 45, 49),
      Paint()..color = const Color(0xFFFFF0D8),
    );
    final Path ears = Path()
      ..moveTo(44, 74)
      ..lineTo(41, 26)
      ..quadraticBezierTo(43, 20, 49, 25)
      ..lineTo(79, 51)
      ..moveTo(121, 51)
      ..lineTo(152, 25)
      ..quadraticBezierTo(158, 20, 160, 27)
      ..lineTo(156, 78);
    canvas.drawPath(ears, fill);
    final Path innerEars = Path()
      ..moveTo(50, 59)
      ..lineTo(48, 35)
      ..lineTo(68, 53)
      ..close()
      ..moveTo(132, 53)
      ..lineTo(151, 35)
      ..lineTo(151, 61)
      ..close();
    canvas.drawPath(innerEars, Paint()..color = const Color(0xFFE1A496));
    canvas.drawOval(const Rect.fromLTWH(39, 44, 122, 92), fill);
    canvas.drawOval(
      const Rect.fromLTWH(56, 86, 89, 43),
      Paint()..color = const Color(0xFFFFF0D8),
    );
    canvas.drawLine(const Offset(91, 48), const Offset(94, 60), ink);
    canvas.drawLine(const Offset(108, 48), const Offset(106, 60), ink);
    canvas.drawOval(
      const Rect.fromLTWH(68, 78, 8, 13),
      Paint()..color = ink.color,
    );
    canvas.drawOval(
      const Rect.fromLTWH(124, 78, 8, 13),
      Paint()..color = ink.color,
    );
    canvas.drawOval(
      const Rect.fromLTWH(94, 94, 13, 8),
      Paint()..color = const Color(0xFFAD6B64),
    );
    final Path smile = Path()
      ..moveTo(100, 103)
      ..quadraticBezierTo(92, 114, 84, 106)
      ..moveTo(100, 103)
      ..quadraticBezierTo(108, 114, 116, 106);
    canvas.drawPath(smile, ink);
    for (final double y in [97, 105]) {
      canvas.drawLine(Offset(43, y), Offset(61, y + 2), ink);
      canvas.drawLine(Offset(139, y + 2), Offset(158, y), ink);
    }
    canvas.drawOval(const Rect.fromLTWH(58, 167, 35, 18), fill);
    canvas.drawOval(const Rect.fromLTWH(112, 167, 35, 18), fill);
    final Paint accent = Paint()..color = const Color(0xFF356C64);
    switch (accessory) {
      case PetAccessory.scarf:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(64, 124, 76, 13),
            const Radius.circular(6),
          ),
          accent,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(112, 130, 17, 29),
            const Radius.circular(4),
          ),
          accent,
        );
      case PetAccessory.bow:
        final Path bow = Path()
          ..moveTo(125, 57)
          ..lineTo(105, 43)
          ..lineTo(106, 70)
          ..close()
          ..moveTo(125, 57)
          ..lineTo(144, 43)
          ..lineTo(144, 70)
          ..close();
        canvas.drawPath(bow, Paint()..color = const Color(0xFFA54F64));
        canvas.drawCircle(
          const Offset(125, 57),
          6,
          Paint()..color = const Color(0xFF773D50),
        );
      case PetAccessory.cap:
        final Path cap = Path()
          ..moveTo(70, 49)
          ..quadraticBezierTo(100, 2, 130, 49)
          ..close();
        canvas.drawPath(cap, accent);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(65, 43, 70, 12),
            const Radius.circular(5),
          ),
          accent,
        );
        canvas.drawCircle(
          const Offset(100, 19),
          7,
          Paint()..color = const Color(0xFFE6B953),
        );
    }
    if (stage >= 2) {
      final badgePaint = Paint()..color = const Color(0xFFB97818);
      for (int index = 0; index < (stage >= 3 ? 3 : 1); index++) {
        final double x = 25 + index * 75;
        final double y = index == 1 ? 14 : 153;
        final star = Path()
          ..moveTo(x, y - 10)
          ..lineTo(x + 4, y - 3)
          ..lineTo(x + 12, y)
          ..lineTo(x + 4, y + 3)
          ..lineTo(x, y + 10)
          ..lineTo(x - 4, y + 3)
          ..lineTo(x - 12, y)
          ..lineTo(x - 4, y - 3)
          ..close();
        canvas.drawPath(star, badgePaint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CatPainter oldDelegate) =>
      coat != oldDelegate.coat ||
      accessory != oldDelegate.accessory ||
      stage != oldDelegate.stage;
}
