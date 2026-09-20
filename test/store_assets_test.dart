import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

Future<ui.Image> readPng(String path) async {
  final codec = await ui.instantiateImageCodec(await File(path).readAsBytes());
  final image = (await codec.getNextFrame()).image;
  codec.dispose();
  return image;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Иконки имеют нужные размеры и непрозрачный фон по краям', () async {
    for (final entry in {
      'docs/store/icon_512.png': 512,
      'android/app/src/main/res/mipmap-mdpi/ic_launcher.png': 48,
      'android/app/src/main/res/mipmap-hdpi/ic_launcher.png': 72,
      'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png': 96,
      'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png': 144,
      'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png': 192,
    }.entries) {
      final image = await readPng(entry.key);
      try {
        expect(image.width, entry.value);
        expect(image.height, entry.value);
        expect(await File(entry.key).length(), lessThan(1000000));
        final bytes = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        final size = entry.value;
        for (var i = 0; i < size; i++) {
          for (final pixel in [
            i,
            (size - 1) * size + i,
            i * size,
            i * size + size - 1,
          ]) {
            expect(
              bytes.getUint8(pixel * 4 + 3),
              255,
              reason: '${entry.key}: edge',
            );
          }
        }
      } finally {
        image.dispose();
      }
    }
  });

  test(
    'Четыре вертикальных кадра имеют размер 1080×1920 и весят менее 3 МБ',
    () async {
      for (final name in ['01_pet', '02_budget', '03_savings', '04_task']) {
        final path = 'docs/store/screenshots/$name.png';
        final image = await readPng(path);
        expect(image.width, 1080);
        expect(image.height, 1920);
        expect(await File(path).length(), lessThan(3000000));
        image.dispose();
      }
    },
  );

  test('Адаптивный передний план помещается в безопасный круг 66 dp', () async {
    const path =
        'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png';
    final image = await readPng(path);
    expect(image.width, 432);
    expect(image.height, 432);
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    var visiblePixels = 0;
    var maximumRadiusSquared = 0.0;
    for (var y = 0; y < 432; y++) {
      for (var x = 0; x < 432; x++) {
        if (bytes.getUint8((y * 432 + x) * 4 + 3) == 0) continue;
        visiblePixels++;
        final dx = x + 0.5 - 216;
        final dy = y + 0.5 - 216;
        // 432 px / 108 dp = 4; радиус 33 dp = 132 px плюс 1 px сглаживания.
        final radiusSquared = dx * dx + dy * dy;
        if (radiusSquared > maximumRadiusSquared) {
          maximumRadiusSquared = radiusSquared;
        }
      }
    }
    expect(visiblePixels, greaterThan(10000));
    expect(maximumRadiusSquared, lessThanOrEqualTo(133 * 133));
    image.dispose();
  });
}
