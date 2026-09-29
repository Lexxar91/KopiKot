import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/presentation/providers/game_controller.dart';
import 'package:kopikot/presentation/screens/savings_screen.dart';

import 'game_rules_test.dart' show initialProfile;

class _ReadyController extends GameController {
  _ReadyController(this.profile);
  final GameProfile profile;

  @override
  Future<GameProfile?> build() async => profile;
}

void main() {
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
    taskSource: File('assets/content/tasks.json').readAsStringSync(),
  );

  for (final textScale in [1.0, 2.0]) {
    testWidgets('Накопления 360 dp: цели и текст ×$textScale', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final profile = initialProfile.copyWith(selectedGoalId: 'tent');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameControllerProvider.overrideWith(
              () => _ReadyController(profile),
            ),
            gameCatalogProvider.overrideWith((ref) async => catalog),
          ],
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: const Size(360, 640),
                textScaler: TextScaler.linear(textScale),
              ),
              child: const SavingsScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Моя цель: беговая дорожка'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Другие цели'),
        240,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byIcon(Icons.lock_rounded), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  }
}
