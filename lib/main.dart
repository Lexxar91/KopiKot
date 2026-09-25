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
      title: 'КопиКот',
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
        useMaterial3: true,
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          primary: const Color(0xFF6252D8),
          secondary: const Color(0xFFE76F8A),
          surface: const Color(0xFFFFFBF7),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFBF7),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (final platform in TargetPlatform.values)
              platform: const AccessiblePageTransitions(),
          },
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
          titleLarge: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          bodyMedium: TextStyle(fontSize: 15.5, height: 1.35),
          bodyLarge: TextStyle(fontSize: 16, height: 1.4),
          labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Color(0xFFFFFBF7),
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Color(0xFF272236),
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFE5DFEC)),
          ),
          helperMaxLines: 3,
          errorMaxLines: 3,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(48, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(48, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
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
