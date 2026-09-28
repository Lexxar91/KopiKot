import 'package:flutter/material.dart';

import '../../domain/models/game_profile.dart';

const Map<PetCoat, String> coatLabels = {
  PetCoat.ginger: 'Рыжик',
  PetCoat.grey: 'Дымок',
  PetCoat.cream: 'Кремок',
  PetCoat.dark: 'Темныш',
  PetCoat.white: 'Облачко',
};
const Map<PetAccessory, String> accessoryLabels = {
  PetAccessory.scarf: 'Платок',
  PetAccessory.bow: 'Бантик',
  PetAccessory.cap: 'Шапочка',
  PetAccessory.headband: 'Повязка',
  PetAccessory.wristbands: 'Напульсники',
};
const Map<PetEmotion, String> emotionLabels = {
  PetEmotion.calm: 'спокоен',
  PetEmotion.happy: 'доволен',
  PetEmotion.excited: 'в восторге',
  PetEmotion.hungry: 'ждёт заботы',
  PetEmotion.thoughtful: 'задумался',
  PetEmotion.proud: 'гордится планом',
};

/// Питомец сохраняет разные окрасы, аксессуары и эмоции без сети.
class PetPortrait extends StatelessWidget {
  const PetPortrait({
    required this.coat,
    required this.accessory,
    this.size = 180,
    this.stage = 1,
    this.emotion = PetEmotion.calm,
    super.key,
  });
  final PetCoat coat;
  final PetAccessory? accessory;
  final double size;
  final int stage;
  final PetEmotion emotion;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label:
        '${coatLabels[coat]} кот, ${accessory == null ? 'без аксессуара' : accessoryLabels[accessory]}',
    child: SizedBox.square(dimension: size, child: _storybookPortrait()),
  );

  Widget _storybookPortrait() {
    final path = switch ((coat, accessory == PetAccessory.scarf)) {
      (PetCoat.ginger, true) => 'assets/images/orange_kitten.png',
      (PetCoat.grey, true) => 'assets/images/grey_kitten.png',
      (PetCoat.cream, true) => 'assets/images/cream_kitten.png',
      (PetCoat.dark, true) => 'assets/images/dark_kitten.png',
      (PetCoat.white, true) => 'assets/images/white_kitten.png',
      (PetCoat.ginger, false) => 'assets/images/orange_kitten_no_scarf.png',
      (PetCoat.grey, false) => 'assets/images/grey_kitten_no_scarf.png',
      (PetCoat.cream, false) => 'assets/images/cream_kitten_no_scarf.png',
      (PetCoat.dark, false) => 'assets/images/dark_kitten_no_scarf.png',
      (PetCoat.white, false) => 'assets/images/white_kitten_no_scarf.png',
    };
    final emotionIcon = switch (emotion) {
      PetEmotion.calm => null,
      PetEmotion.happy => Icons.favorite_rounded,
      PetEmotion.excited => Icons.celebration_rounded,
      PetEmotion.hungry => Icons.restaurant_rounded,
      PetEmotion.thoughtful => Icons.lightbulb_rounded,
      PetEmotion.proud => Icons.star_rounded,
    };
    final emotionColor = switch (emotion) {
      PetEmotion.calm => Colors.transparent,
      PetEmotion.happy => const Color(0xFFFF6985),
      PetEmotion.excited => const Color(0xFFAF65EC),
      PetEmotion.hungry => const Color(0xFFFF9F4A),
      PetEmotion.thoughtful => const Color(0xFF58BEE6),
      PetEmotion.proud => const Color(0xFFFFC342),
    };
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          path,
          key: ValueKey(path),
          fit: BoxFit.contain,
          width: size,
          height: size,
          errorBuilder: (_, _, _) => CustomPaint(
            size: Size.square(size),
            painter: _CatPainter(coat, accessory, stage, emotion),
          ),
        ),
        if (accessory == PetAccessory.bow)
          Positioned(
            left: size * 0.64,
            top: size * 0.02,
            child: Image.asset(
              'assets/images/wardrobe_bow.png',
              width: size * 0.2,
            ),
          ),
        if (accessory == PetAccessory.headband)
          Positioned(
            left: size * 0.29,
            top: size * 0.12,
            child: Image.asset(
              'assets/images/wardrobe_headband.png',
              width: size * 0.43,
            ),
          ),
        if (accessory == PetAccessory.wristbands)
          Positioned(
            left: size * 0.3,
            top: size * 0.5,
            child: Image.asset(
              'assets/images/wardrobe_wristbands.png',
              width: size * 0.42,
            ),
          ),
        if (accessory == PetAccessory.cap)
          Positioned(
            left: size * 0.39,
            top: size * 0.07,
            child: Icon(
              Icons.emoji_objects_rounded,
              size: size * 0.22,
              color: const Color(0xFFFFC342),
            ),
          ),
        if (stage > 1)
          Positioned(
            left: size * 0.12,
            top: size * 0.1,
            child: CircleAvatar(
              radius: size * 0.085,
              backgroundColor: stage >= 4
                  ? const Color(0xFF9747D9)
                  : stage == 2
                  ? const Color(0xFF40BDE0)
                  : const Color(0xFFFFC342),
              child: Icon(
                stage >= 4
                    ? Icons.diamond_rounded
                    : stage == 2
                    ? Icons.auto_awesome_rounded
                    : Icons.workspace_premium_rounded,
                size: size * 0.1,
                color: Colors.white,
              ),
            ),
          ),
        if (emotionIcon != null)
          Positioned(
            right: size * 0.1,
            bottom: size * 0.1,
            child: CircleAvatar(
              radius: size * 0.08,
              backgroundColor: emotionColor,
              child: Icon(emotionIcon, size: size * 0.09, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class _CatPainter extends CustomPainter {
  const _CatPainter(this.coat, this.accessory, this.stage, this.emotion);
  final PetCoat coat;
  final PetAccessory? accessory;
  final int stage;
  final PetEmotion emotion;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 200, size.height / 200);
    final Color fur = switch (coat) {
      PetCoat.ginger => const Color(0xFFEBA559),
      PetCoat.grey => const Color(0xFF9CAEBB),
      PetCoat.cream => const Color(0xFFF0D5A7),
      PetCoat.dark => const Color(0xFF48434B),
      PetCoat.white => const Color(0xFFF5F5F1),
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
    _drawFace(canvas, ink);
    for (final double y in [97, 105]) {
      canvas.drawLine(Offset(43, y), Offset(61, y + 2), ink);
      canvas.drawLine(Offset(139, y + 2), Offset(158, y), ink);
    }
    canvas.drawOval(const Rect.fromLTWH(58, 167, 35, 18), fill);
    canvas.drawOval(const Rect.fromLTWH(112, 167, 35, 18), fill);
    final Paint accent = Paint()..color = const Color(0xFF356C64);
    switch (accessory) {
      case null:
        break;
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
      case PetAccessory.headband:
        final band = Path()
          ..moveTo(59, 55)
          ..quadraticBezierTo(100, 32, 141, 55);
        canvas.drawPath(
          band,
          Paint()
            ..color = const Color(0xFFFFBE23)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 12,
        );
        canvas.drawCircle(
          const Offset(100, 41),
          7,
          Paint()..color = Colors.white,
        );
      case PetAccessory.wristbands:
        final wristband = Paint()..color = const Color(0xFF1D74D8);
        for (final x in [66.0, 116.0]) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, 153, 25, 14),
              const Radius.circular(4),
            ),
            wristband,
          );
          canvas.drawCircle(
            Offset(x + 12, 160),
            3,
            Paint()..color = Colors.white,
          );
        }
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

  void _drawFace(Canvas canvas, Paint ink) {
    final Paint solidInk = Paint()..color = ink.color;
    if (emotion == PetEmotion.proud) {
      canvas.drawArc(
        const Rect.fromLTWH(65, 76, 14, 12),
        0.15,
        2.8,
        false,
        ink,
      );
      canvas.drawArc(
        const Rect.fromLTWH(121, 76, 14, 12),
        0.15,
        2.8,
        false,
        ink,
      );
    } else {
      final double height = emotion == PetEmotion.excited ? 17 : 13;
      canvas.drawOval(Rect.fromLTWH(68, 78, 8, height), solidInk);
      canvas.drawOval(Rect.fromLTWH(124, 78, 8, height), solidInk);
      if (emotion == PetEmotion.happy || emotion == PetEmotion.excited) {
        canvas.drawCircle(
          const Offset(71, 81),
          1.7,
          Paint()..color = Colors.white,
        );
        canvas.drawCircle(
          const Offset(127, 81),
          1.7,
          Paint()..color = Colors.white,
        );
      }
    }
    if (emotion == PetEmotion.thoughtful) {
      canvas.drawLine(const Offset(66, 72), const Offset(77, 75), ink);
      canvas.drawLine(const Offset(123, 75), const Offset(134, 72), ink);
    }
    canvas.drawOval(
      const Rect.fromLTWH(94, 94, 13, 8),
      Paint()..color = const Color(0xFFAD6B64),
    );
    final Path mouth = Path()..moveTo(100, 103);
    switch (emotion) {
      case PetEmotion.hungry:
        canvas.drawOval(const Rect.fromLTWH(92, 104, 16, 13), ink);
      case PetEmotion.thoughtful:
        mouth.quadraticBezierTo(100, 102, 88, 111);
        canvas.drawPath(mouth, ink);
      case PetEmotion.excited:
        canvas.drawOval(
          const Rect.fromLTWH(90, 103, 20, 20),
          Paint()..color = const Color(0xFFE9858B),
        );
        canvas.drawOval(const Rect.fromLTWH(90, 103, 20, 20), ink);
      case PetEmotion.calm || PetEmotion.happy || PetEmotion.proud:
        mouth
          ..quadraticBezierTo(92, 114, 84, 106)
          ..moveTo(100, 103)
          ..quadraticBezierTo(108, 114, 116, 106);
        canvas.drawPath(mouth, ink);
    }
    if (emotion == PetEmotion.happy || emotion == PetEmotion.excited) {
      final blush = Paint()..color = const Color(0x55ED7D8D);
      canvas.drawOval(const Rect.fromLTWH(55, 94, 15, 8), blush);
      canvas.drawOval(const Rect.fromLTWH(130, 94, 15, 8), blush);
    }
  }

  @override
  bool shouldRepaint(covariant _CatPainter oldDelegate) =>
      coat != oldDelegate.coat ||
      accessory != oldDelegate.accessory ||
      stage != oldDelegate.stage ||
      emotion != oldDelegate.emotion;
}
