import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/presentation/screens/daily_tip_screen.dart';

void main() {
  test('Три совета меняются каждый игровой день и затем повторяются', () {
    final shown = [
      dailyTipForDay('2020-01-01').fullText,
      dailyTipForDay('2020-01-02').fullText,
      dailyTipForDay('2020-01-03').fullText,
    ];
    expect(shown.toSet(), hasLength(3));
    expect(dailyTipForDay('2020-01-04').fullText, shown.first);
    expect(shown, [
      'Перед покупкой подумай: тебе это нужно сейчас или просто очень хочется?',
      'Получил монетки? Часть можно оставить на нужные покупки, а часть — копить на мечту.',
      'Посчитай заранее: сколько монет останется после покупки?',
    ]);
  });

  testWidgets('Совет виден на телефоне без переполнения', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: DailyTipScreen(dayKey: '2020-01-02')),
    );
    expect(find.text('Получил монетки?'), findsOneWidget);
    expect(find.textContaining('копить на мечту.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
