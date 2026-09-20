import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/providers/game_controller.dart';
import 'presentation/screens/create_pet_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/widgets/accessible_motion.dart';

void main() {
  runApp(const ProviderScope(child: KopiKotApp()));
}

/// Корень приложения и общая конфигурация Material UI.
class KopiKotApp extends ConsumerWidget {
  const KopiKotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduceMotion = ref.watch(reduceMotionProvider).asData?.value ?? true;
    return MaterialApp(
      title: 'Питомец Финни',
      debugShowCheckedModeBanner: false,
      themeAnimationStyle: AnimationStyle.noAnimation,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations:
              reduceMotion || MediaQuery.disableAnimationsOf(context),
        ),
        child: child!,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF356C64)),
        scaffoldBackgroundColor: const Color(0xFFFAF8F1),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (final platform in TargetPlatform.values)
              platform: const AccessiblePageTransitions(),
          },
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
          bodyLarge: TextStyle(fontSize: 16),
          labelLarge: TextStyle(fontSize: 16),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          helperMaxLines: 3,
          errorMaxLines: 3,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(minimumSize: const Size(48, 52)),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
      ),
      home: const _ProfileGate(),
    );
  }
}

class _ProfileGate extends ConsumerWidget {
  const _ProfileGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(gameControllerProvider)
      .when(
        loading: () => const Scaffold(
          body: Center(child: LoadingStatus(label: 'Открываем дом питомца')),
        ),
        error: (error, stack) => Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Не удалось открыть сохранение. Данные не удалены. Попробуй ещё раз.',
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        ref.invalidate(gameRepositoryProvider);
                        ref.invalidate(gameControllerProvider);
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        data: (profile) => profile == null
            ? const CreatePetScreen()
            : HomeScreen(profile: profile),
      );
}
