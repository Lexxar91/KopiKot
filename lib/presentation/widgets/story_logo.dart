import 'package:flutter/material.dart';

/// Общая деревянная плашка: надпись остаётся доступным масштабируемым текстом.
class StoryLogo extends StatelessWidget {
  const StoryLogo({this.height = 50, super.key});

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: LayoutBuilder(
      builder: (context, constraints) => Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/logo_wood.png',
            fit: BoxFit.fill,
            filterQuality: FilterQuality.medium,
            cacheWidth: constraints.maxWidth.isFinite
                ? (constraints.maxWidth *
                          MediaQuery.devicePixelRatioOf(context))
                      .ceil()
                : null,
            excludeFromSemantics: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'КопиКот',
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xFFFFD34A),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  shadows: [
                    Shadow(
                      color: Color(0xFF5A210B),
                      offset: Offset(1.5, 2.5),
                      blurRadius: 1.5,
                    ),
                    Shadow(
                      color: Color(0xFFFB8D0A),
                      offset: Offset(-1, -1),
                      blurRadius: 1,
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
