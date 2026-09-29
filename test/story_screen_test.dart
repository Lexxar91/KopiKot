import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/presentation/screens/story_screen.dart';

void main() {
  testWidgets('История открывается и читается на узком экране', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: StoryScreen()));
    expect(find.textContaining('Кот-Хранитель посадил'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('В городе никогда не бывает скучно.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
