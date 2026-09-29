import 'package:flutter/material.dart';

/// Исходник иконки из изображения пользователя для Android и магазина.
class FinnyIcon extends StatelessWidget {
  const FinnyIcon({this.adaptiveForeground = false, super.key});

  final bool adaptiveForeground;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: adaptiveForeground ? Colors.transparent : const Color(0xFFF8FFF6),
    child: Center(
      child: FractionallySizedBox(
        widthFactor: adaptiveForeground ? 0.67 : 1,
        heightFactor: adaptiveForeground ? 0.67 : 1,
        child: adaptiveForeground
            ? ClipOval(
                child: Image.asset(
                  'assets/images/app_icon_source.jpg',
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                'assets/images/app_icon_source.jpg',
                fit: BoxFit.cover,
              ),
      ),
    ),
  );
}
