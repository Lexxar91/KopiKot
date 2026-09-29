import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/domain/rules/economy_rules.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/presentation/providers/game_controller.dart';
import 'package:kopikot/presentation/screens/badges_screen.dart';
import 'package:kopikot/presentation/widgets/pet_portrait.dart';

class _BadgeProfileController extends GameController {
  _BadgeProfileController(this.profile);

  final GameProfile profile;

  @override
  Future<GameProfile?> build() async => profile;
}

void main() {
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
  );

  test(
    'Целевые значки сохраняются, повторная покупка запрещена в обоих режимах',
    () {
      for (final isDemo in [false, true]) {
        for (final goal in catalog.goals) {
          var profile = GameProfile(
            petName: 'Финни',
            coat: PetCoat.grey,
            accessory: PetAccessory.scarf,
            balance: 10000,
            savings: 0,
            period: 1,
            satiety: 70,
            mood: 70,
            incomeSource: 'Подарок',
            incomeAmount: 10000,
            isTest: isDemo,
            selectedGoalId: goal.id,
            goalChoicesUnlocked: true,
            plan: const BudgetPlan(
              availableAtConfirmation: 10000,
              needs: 0,
              wants: 0,
              savings: 0,
            ),
          );
          expect(profile.reachedGoal(goal.id, goal.price), isFalse);
          profile = EconomyRules.transfer(
            profile,
            goal,
            goal.price,
            commandId: 'save-${goal.id}',
            withdraw: false,
          );
          expect(profile.reachedGoal(goal.id, goal.price), isTrue);
          profile = EconomyRules.transfer(
            profile,
            goal,
            goal.price,
            commandId: 'withdraw-${goal.id}',
            withdraw: true,
          );
          expect(profile.reachedGoal(goal.id, goal.price), isTrue);
          profile = EconomyRules.transfer(
            profile,
            goal,
            goal.price,
            commandId: 'save-again-${goal.id}',
            withdraw: false,
          );
          profile = EconomyRules.purchaseGoal(
            profile,
            goal,
            'purchase-${goal.id}',
          );
          expect(profile.purchasedGoal(goal.id), isTrue);
          expect(profile.reachedGoal(goal.id, goal.price), isTrue);
          expect(
            EconomyRules.purchaseGoal(profile, goal, 'purchase-${goal.id}'),
            same(profile),
          );
          expect(
            () => EconomyRules.purchaseGoal(profile, goal, 'second-${goal.id}'),
            throwsA(isA<GameRuleException>()),
          );
          expect(
            () => EconomyRules.transfer(
              profile,
              goal,
              10,
              commandId: 'extra-${goal.id}',
              withdraw: false,
            ),
            throwsA(isA<GameRuleException>()),
          );
        }
      }
    },
  );

  testWidgets('В значках показан выбранный окрас котика', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    const profile = GameProfile(
      petName: 'Дымок',
      coat: PetCoat.grey,
      accessory: PetAccessory.scarf,
      balance: 100,
      savings: 0,
      period: 1,
      satiety: 70,
      mood: 70,
      incomeSource: 'Подарок',
      incomeAmount: 100,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameControllerProvider.overrideWith(
            () => _BadgeProfileController(profile),
          ),
          gameCatalogProvider.overrideWith((ref) async => catalog),
        ],
        child: const MaterialApp(home: BadgesScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Награды за достигнутые цели'), findsOneWidget);
    expect(
      tester.widget<PetPortrait>(find.byType(PetPortrait)).coat,
      PetCoat.grey,
    );
    expect(find.text('Беговая дорожка'), findsOneWidget);
    expect(find.text('Редкий саженец'), findsOneWidget);
    expect(find.text('Лежанка'), findsOneWidget);
  });
}
