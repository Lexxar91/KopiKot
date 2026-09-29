import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/presentation/widgets/home_section_navigation.dart';

void main() {
  testWidgets('Выпадающее меню закрывается перед переходом', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: HomeSectionNavigation(
              sections: [
                HomeSection(
                  title: 'Учимся',
                  shortTitle: 'Учимся',
                  icon: Icons.school_rounded,
                  color: Colors.blue,
                  destinations: [
                    HomeDestination(
                      title: 'Задания',
                      icon: Icons.auto_stories_rounded,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const Scaffold(body: Text('Экран')),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Учимся'));
    await tester.pumpAndSettle();
    expect(find.text('Задания'), findsOneWidget);
    await tester.tap(find.text('Задания'));
    await tester.pumpAndSettle();
    expect(find.text('Экран'), findsOneWidget);
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(find.text('Задания'), findsNothing);
  });
}
