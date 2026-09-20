import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/data/local/local_game_store.dart';
import 'package:kopikot/data/repositories/local_game_repository.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/models/learning_task.dart';
import 'package:kopikot/main.dart';
import 'package:kopikot/presentation/providers/game_controller.dart';
import 'package:kopikot/presentation/screens/budget_screen.dart';
import 'package:kopikot/presentation/screens/savings_screen.dart';
import 'package:kopikot/presentation/screens/tasks_screen.dart';

import '../test/support/native_isar.dart';
import 'artwork/finny_icon.dart';

// Для отрисовки используем уже прочитанный снимок настоящей временной Isar.
// Нативное чтение не запускается под виртуальными часами widget-теста.
class _ExportGameController extends GameController {
  _ExportGameController(this.profile);
  final GameProfile profile;
  @override
  Future<GameProfile?> build() async => profile;
}

class _ExportMotionController extends ReduceMotionController {
  @override
  Future<bool> build() async => true;
}

// Явный запуск: flutter test tool/export_store_assets.dart.
// Перезаписывает только перечисленные PNG. Обычный flutter test их не экспортирует.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> capture(
    WidgetTester tester,
    GlobalKey key,
    String path, {
    double ratio = 1,
  }) async {
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: path);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: ratio);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      final output = File(path);
      await output.parent.create(recursive: true);
      await output.writeAsBytes(bytes.buffer.asUint8List());
      image.dispose();
    });
  }

  testWidgets(
    'Экспорт иконок Android и RuStore из исходной векторной графики',
    (tester) async {
      for (final output in {
        'docs/store/icon_512.png': 512,
        'android/app/src/main/res/mipmap-mdpi/ic_launcher.png': 48,
        'android/app/src/main/res/mipmap-hdpi/ic_launcher.png': 72,
        'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png': 96,
        'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png': 144,
        'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png': 192,
        'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png':
            432,
      }.entries) {
        final size = output.value.toDouble();
        tester.view.physicalSize = Size.square(size);
        tester.view.devicePixelRatio = 1;
        final key = GlobalKey();
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: RepaintBoundary(
              key: key,
              child: FinnyIcon(
                adaptiveForeground: output.key.endsWith('foreground.png'),
              ),
            ),
          ),
        );
        await capture(tester, key, output.key);
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    },
  );

  testWidgets('Четыре изображения настоящих экранов на воспроизводимом профиле', (
    tester,
  ) async {
    late Directory temporary;
    late LocalGameStore store;
    late LocalGameRepository repository;
    late GameProfile snapshot;
    await tester.runAsync(() async {
      await initializeTestIsar();
      debugPrint('Export: Isar initialized');
      final flutter = await packageRoot('flutter');
      final fonts = flutter.resolve(
        '../../bin/cache/artifacts/material_fonts/',
      );
      for (final family in {
        'Roboto': 'Roboto-Regular.ttf',
        'MaterialIcons': 'MaterialIcons-Regular.otf',
      }.entries) {
        final bytes = await File.fromUri(
          fonts.resolve(family.value),
        ).readAsBytes();
        await (FontLoader(
          family.key,
        )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
      }
      temporary = await Directory.systemTemp.createTemp('finny_store_export_');
      debugPrint('Export: fonts loaded');
      store = await LocalGameStore.open(
        directory: temporary.path,
        name: 'export',
      );
      repository = LocalGameRepository(
        store,
        parseGameCatalog(
          await File('assets/content/catalog.json').readAsString(),
          taskSource: await File('assets/content/tasks.json').readAsString(),
        ),
      );
      await repository.createProfile(
        petName: 'Финни',
        coat: PetCoat.ginger,
        accessory: PetAccessory.scarf,
      );
      await repository.selectGoal('tent');
      for (var period = 1; period <= 5; period++) {
        await repository.confirmBudget(needs: 25, wants: 0, savings: 20);
        await repository.purchase('porridge', commandId: 'food-$period');
        await repository.transfer(
          'tent',
          20,
          commandId: 'save-$period',
          withdraw: false,
        );
        await repository.finishPeriod(period);
      }
      await repository.confirmBudget(needs: 50, wants: 20, savings: 30);
      await repository.submitTask(
        'budget_lunch',
        const TaskAnswer(needs: 30, savings: 10),
      );
      await repository.purchase('porridge', commandId: 'food-6');
      await repository.transfer(
        'tent',
        10,
        commandId: 'save-6',
        withdraw: false,
      );
      await repository.selectGoal('tent');
      await repository.saveReduceMotion(true);
      snapshot = (await repository.loadProfile())!;
      debugPrint('Export: fixture saved');
    });
    final shadowsWereDisabled = debugDisableShadows;
    try {
      debugDisableShadows = false;
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameRepositoryProvider.overrideWith((ref) async => repository),
            gameCatalogProvider.overrideWith((ref) async => repository.catalog),
            gameControllerProvider.overrideWith(
              () => _ExportGameController(snapshot),
            ),
            reduceMotionProvider.overrideWith(_ExportMotionController.new),
          ],
          child: RepaintBoundary(key: key, child: const KopiKotApp()),
        ),
      );
      // Снимки уже в памяти; завершаем микрозадачи Riverpod виртуальным кадром.
      await tester.pumpAndSettle();
      expect(find.text('Баланс: 350'), findsOneWidget);
      expect(find.text('Накопления: 110'), findsOneWidget);
      expect(find.text('Период 6 · Опытный друг'), findsOneWidget);
      await capture(tester, key, 'docs/store/screenshots/01_pet.png', ratio: 3);
      for (final screen in <String, Widget>{
        '02_budget': const BudgetScreen(),
        '03_savings': const SavingsScreen(),
        '04_task': TaskScreen(
          task: repository.catalog.task('basket_food'),
          catalog: repository.catalog,
        ),
      }.entries) {
        final navigator = tester.state<NavigatorState>(find.byType(Navigator));
        navigator.push(MaterialPageRoute<void>(builder: (_) => screen.value));
        await tester.pumpAndSettle();
        if (screen.key == '04_task') {
          await tester.tap(find.text('Каша с тыквой'));
          await tester.tap(find.text('Свежая вода'));
          await tester.pumpAndSettle();
          expect(find.text('Корзина: 35 из 40'), findsOneWidget);
        }
        await capture(
          tester,
          key,
          'docs/store/screenshots/${screen.key}.png',
          ratio: 3,
        );
        navigator.pop();
        await tester.pumpAndSettle();
      }
      await tester.pumpWidget(const SizedBox());
    } finally {
      debugDisableShadows = shadowsWereDisabled;
      debugDefaultTargetPlatformOverride = null;
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await tester.runAsync(() async {
        await store.close();
        await temporary.delete(recursive: true);
      });
    }
  });
}
