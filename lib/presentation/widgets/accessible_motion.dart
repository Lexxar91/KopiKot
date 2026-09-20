import 'package:flutter/material.dart';

/// Статус остаётся видимым и без непрерывного вращения индикатора.
class LoadingStatus extends StatelessWidget {
  const LoadingStatus({this.label = 'Загружаем…', super.key});
  final String label;
  @override
  Widget build(BuildContext context) => MediaQuery.disableAnimationsOf(context)
      ? Text(label)
      : CircularProgressIndicator(semanticsLabel: label);
}

/// Переход остаётся навигацией, но без визуального движения при отключении.
class AccessiblePageTransitions extends PageTransitionsBuilder {
  const AccessiblePageTransitions();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => MediaQuery.disableAnimationsOf(context)
      ? child
      : const FadeUpwardsPageTransitionsBuilder().buildTransitions(
          route,
          context,
          animation,
          secondaryAnimation,
          child,
        );
}

/// Единое правило диалогов: предпочтение приложения уже объединено с системным.
Future<T?> showAccessibleDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) => showDialog<T>(
  context: context,
  builder: builder,
  barrierDismissible: barrierDismissible,
  animationStyle: MediaQuery.disableAnimationsOf(context)
      ? AnimationStyle.noAnimation
      : null,
);
