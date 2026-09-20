import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopikot/domain/models/game_profile.dart';
import 'package:kopikot/data/content/catalog_loader.dart';
import 'package:kopikot/domain/rules/economy_rules.dart';
import 'package:kopikot/domain/rules/learning_rules.dart';
import 'package:kopikot/domain/rules/period_rules.dart';
import 'package:kopikot/domain/models/learning_task.dart';
import 'package:kopikot/domain/repositories/game_repository.dart';
import 'package:kopikot/domain/rules/game_rules.dart';
import 'package:kopikot/main.dart';
import 'package:kopikot/presentation/providers/game_controller.dart';
import 'package:kopikot/presentation/widgets/pet_portrait.dart';
import 'package:kopikot/presentation/screens/tasks_screen.dart';
import 'package:kopikot/presentation/screens/budget_screen.dart';
import 'package:kopikot/presentation/screens/shop_screen.dart';
import 'package:kopikot/presentation/screens/savings_screen.dart';
import 'package:kopikot/presentation/screens/history_screen.dart';
import 'package:kopikot/presentation/screens/progress_screen.dart';
import 'package:kopikot/presentation/screens/adult_screen.dart';
import 'package:kopikot/presentation/widgets/accessible_motion.dart';

import 'game_rules_test.dart' show initialProfile;

class _MemoryRepository implements GameRepository {
  final catalog = parseGameCatalog(
    File('assets/content/catalog.json').readAsStringSync(),
    taskSource: File('assets/content/tasks.json').readAsStringSync(),
  );
  final profiles = <bool, GameProfile>{};
  bool testProfile = false;
  GameProfile? get profile => profiles[testProfile];
  set profile(GameProfile? value) {
    if (value == null) {
      profiles.remove(testProfile);
    } else {
      profiles[testProfile] = value;
    }
  }

  bool failCreate = false;
  bool failProfileAction = false;
  bool reduceMotion = false;
  @override
  Future<bool> loadReduceMotion() async => reduceMotion;
  @override
  Future<void> saveReduceMotion(bool value) async {
    if (failProfileAction) throw StateError('Simulated disk failure');
    reduceMotion = value;
  }

  GameProfile _demo() => const GameProfile(
    petName: 'Финни Тест',
    coat: PetCoat.ginger,
    accessory: PetAccessory.scarf,
    balance: 100,
    savings: 0,
    period: 1,
    satiety: 70,
    mood: 70,
    incomeSource: 'Подарок на знакомство',
    incomeAmount: 100,
    isTest: true,
    selectedGoalId: 'tent',
  );

  @override
  Future<GameProfile?> switchProfile({required bool testProfile}) async {
    if (failProfileAction) throw StateError('Simulated disk failure');
    this.testProfile = testProfile;
    if (testProfile) profiles.putIfAbsent(true, _demo);
    return profile;
  }

  @override
  Future<GameProfile> resetTestProfile() async {
    if (failProfileAction) throw StateError('Simulated disk failure');
    if (!testProfile) throw StateError('Test profile required');
    return profile = _demo();
  }

  @override
  Future<void> deleteRegularProfile() async {
    if (failProfileAction) throw StateError('Simulated disk failure');
    if (testProfile) throw StateError('Regular profile required');
    profile = null;
  }

  @override
  Future<GameProfile> submitTask(String taskId, TaskAnswer answer) async =>
      profile = LearningRules.submit(
        profile!,
        catalog,
        catalog.task(taskId),
        answer,
      );
  @override
  Future<GameProfile> finishPeriod(int expectedPeriod) async =>
      profile = PeriodRules.finish(profile!, expectedPeriod);

  @override
  Future<GameProfile> purchase(
    String productId, {
    required String commandId,
  }) async => profile = EconomyRules.purchase(
    profile!,
    catalog.product(productId),
    commandId,
  );
  @override
  Future<GameProfile> selectGoal(String goalId) async =>
      profile = EconomyRules.selectGoal(profile!, catalog.goal(goalId));
  @override
  Future<GameProfile> transfer(
    String goalId,
    int amount, {
    required String commandId,
    required bool withdraw,
  }) async => profile = EconomyRules.transfer(
    profile!,
    catalog.goal(goalId),
    amount,
    commandId: commandId,
    withdraw: withdraw,
  );

  @override
  Future<GameProfile?> loadProfile() async => profile;

  @override
  Future<GameProfile> createProfile({
    required String petName,
    required PetCoat coat,
    required PetAccessory accessory,
  }) async {
    if (failCreate) throw StateError('Simulated disk failure');
    return profile = GameProfile(
      petName: GameRules.validatePetName(petName),
      coat: coat,
      accessory: accessory,
      balance: 100,
      savings: 0,
      period: 1,
      satiety: 70,
      mood: 70,
      incomeSource: 'Подарок на знакомство',
      incomeAmount: 100,
    );
  }

  @override
  Future<GameProfile> confirmBudget({
    required int needs,
    required int wants,
    required int savings,
  }) async => profile = profile!.withPlan(
    GameRules.confirmBudget(
      profile!,
      needs: needs,
      wants: wants,
      savings: savings,
    ),
  );
}

void main() {
  Future<void> launch(
    WidgetTester tester,
    _MemoryRepository repository, {
    double scale = 1,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWith((ref) async => repository),
        ],
        child: const KopiKotApp(),
      ),
    );
    // В приложении репозиторий ожидает каталог при запуске. Тестовый репозиторий
    // не имеет этой зависимости, поэтому ждём реальный asset явно.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    await tester.runAsync(() => container.read(gameCatalogProvider.future));
    await tester.pumpAndSettle();
  }

  Future<void> openAdult(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Для взрослого'));
    await tester.pumpAndSettle();
    final question = tester
        .widget<Text>(find.byKey(const Key('adult-challenge')))
        .data!;
    final numbers = RegExp(
      r'\d+',
    ).allMatches(question).map((match) => int.parse(match[0]!));
    await tester.enterText(
      find.byKey(const Key('adult-answer')),
      '${numbers.reduce((a, b) => a + b)}',
    );
    await tester.tap(find.text('Открыть раздел'));
    await tester.pumpAndSettle();
  }

  Future<void> adultAction(WidgetTester tester, String label) async {
    await tester.scrollUntilVisible(
      find.text(label),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).first);
    await tester.pumpAndSettle();
  }

  testWidgets('Барьер взрослого и вход в демо без обычного профиля на 360 dp', (
    tester,
  ) async {
    final repository = _MemoryRepository();
    await launch(tester, repository, scale: 2);
    await tester.tap(find.byTooltip('Для взрослого'));
    await tester.pumpAndSettle();
    expect(find.text('Сбросить тестовый профиль'), findsNothing);
    await tester.enterText(find.byKey(const Key('adult-answer')), '0');
    await tester.tap(find.text('Открыть раздел'));
    await tester.pumpAndSettle();
    expect(find.text('Проверьте ответ и попробуйте ещё раз.'), findsOneWidget);
    expect(find.text('Учимся через заботу'), findsNothing);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    await openAdult(tester);
    expect(find.text('Учимся через заботу'), findsOneWidget);
    await adultAction(tester, 'Открыть тестовый профиль');
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(repository.testProfile, isFalse);
    await adultAction(tester, 'Открыть тестовый профиль');
    await tester.tap(find.text('Подтвердить'));
    await tester.pumpAndSettle();
    expect(repository.profile!.isTest, isTrue);
    expect(
      find.text('Тестовый профиль · отдельное сохранение'),
      findsOneWidget,
    );
    await openAdult(tester);
    await adultAction(tester, 'Вернуться в обычный профиль');
    await tester.tap(find.text('Подтвердить'));
    await tester.pumpAndSettle();
    expect(repository.profile, isNull);
    expect(find.text('Давай дружить!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Сброс демо: отмена, ошибка записи, повтор и защита обычного профиля',
    (tester) async {
      final repository = _MemoryRepository()
        ..profile = initialProfile.copyWith(balance: 74);
      repository.profiles[true] = LearningRules.submit(
        repository._demo().copyWith(
          plan: const BudgetPlan(
            availableAtConfirmation: 100,
            needs: 50,
            wants: 20,
            savings: 30,
          ),
        ),
        repository.catalog,
        repository.catalog.task('saving_start'),
        const TaskAnswer(savings: 10),
      );
      await launch(tester, repository);
      await openAdult(tester);
      await adultAction(tester, 'Открыть тестовый профиль');
      await tester.tap(find.text('Подтвердить'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 110);
      await openAdult(tester);
      await adultAction(tester, 'Сбросить тестовый профиль');
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 110);
      await adultAction(tester, 'Сбросить тестовый профиль');
      repository.failProfileAction = true;
      await tester.tap(
        find.widgetWithText(FilledButton, 'Сбросить тестовый профиль'),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Не удалось сохранить действие. Попробуй ещё раз.'),
        findsOneWidget,
      );
      expect(repository.profile!.balance, 110);
      expect(repository.profiles[false]!.balance, 74);
      repository.failProfileAction = false;
      await tester.tap(
        find.widgetWithText(FilledButton, 'Сбросить тестовый профиль'),
      );
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 100);
      expect(repository.profile!.taskProgress, isEmpty);
      expect(find.text('Финни Тест'), findsOneWidget);
      await openAdult(tester);
      await adultAction(tester, 'Вернуться в обычный профиль');
      await tester.tap(find.text('Подтвердить'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 74);
      expect(find.text('Финни'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Удаление обычного профиля требует подтверждения и допускает повтор ошибки',
    (tester) async {
      final repository = _MemoryRepository()..profile = initialProfile;
      repository.profiles[true] = repository._demo().copyWith(balance: 87);
      await launch(tester, repository);
      await openAdult(tester);
      await adultAction(tester, 'Удалить обычный профиль');
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(repository.profile, isNotNull);
      await adultAction(tester, 'Удалить обычный профиль');
      repository.failProfileAction = true;
      await tester.tap(find.text('Удалить профиль'));
      await tester.pumpAndSettle();
      expect(repository.profile, isNotNull);
      expect(
        find.text('Не удалось сохранить действие. Попробуй ещё раз.'),
        findsOneWidget,
      );
      repository.failProfileAction = false;
      await tester.tap(find.text('Удалить профиль'));
      await tester.pumpAndSettle();
      expect(repository.profile, isNull);
      expect(repository.profiles[true]!.balance, 87);
      expect(find.text('Давай дружить!'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'Компоновка и доступность игровых разделов на 360 dp с текстом ×$scale',
      (tester) async {
        final repository = _MemoryRepository()
          ..profile = initialProfile.copyWith(
            selectedGoalId: 'tent',
            plan: const BudgetPlan(
              availableAtConfirmation: 100,
              needs: 50,
              wants: 20,
              savings: 30,
            ),
          );
        await launch(tester, repository, scale: scale);
        final semantics = tester.ensureSemantics();
        try {
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          final screens = <Widget>[
            const BudgetScreen(),
            const ShopScreen(),
            const SavingsScreen(),
            const HistoryScreen(),
            const ProgressScreen(),
            const AdultScreen(),
            const TasksScreen(),
            for (final id in ['budget_lunch', 'basket_food', 'saving_start'])
              TaskScreen(
                task: repository.catalog.task(id),
                catalog: repository.catalog,
              ),
          ];
          for (final screen in screens) {
            final navigator = tester.state<NavigatorState>(
              find.byType(Navigator),
            );
            navigator.push(MaterialPageRoute<void>(builder: (_) => screen));
            await tester.pumpAndSettle();
            expect(
              tester.takeException(),
              isNull,
              reason: '${screen.runtimeType}: top',
            );
            await expectLater(
              tester,
              meetsGuideline(androidTapTargetGuideline),
              reason: '${screen.runtimeType}: touch',
            );
            await expectLater(
              tester,
              meetsGuideline(textContrastGuideline),
              reason: '${screen.runtimeType}: contrast',
            );
            final scrollable = find.byType(Scrollable).first;
            for (var step = 0; step < 80; step++) {
              final position = tester
                  .state<ScrollableState>(scrollable)
                  .position;
              if (position.pixels >= position.maxScrollExtent) break;
              await tester.drag(scrollable, const Offset(0, -450));
              await tester.pumpAndSettle();
              expect(
                tester.takeException(),
                isNull,
                reason: '${screen.runtimeType}: step $step',
              );
            }
            navigator.pop();
            await tester.pumpAndSettle();
          }
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  testWidgets(
    'Уменьшение движения: ошибка записи, повтор и диалог без анимации',
    (tester) async {
      final repository = _MemoryRepository()..profile = initialProfile;
      await launch(tester, repository);
      await openAdult(tester);
      final setting = find.text('Отключить анимации переходов');
      await tester.scrollUntilVisible(
        setting,
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      repository.failProfileAction = true;
      await tester.tap(setting);
      await tester.pumpAndSettle();
      expect(repository.reduceMotion, isFalse);
      expect(
        find.text('Не удалось сохранить настройку. Попробуйте ещё раз.'),
        findsOneWidget,
      );
      repository.failProfileAction = false;
      await tester.tap(setting);
      await tester.pumpAndSettle();
      expect(repository.reduceMotion, isTrue);
      expect(MediaQuery.disableAnimationsOf(tester.element(setting)), isTrue);
      Navigator.of(tester.element(setting)).pop();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Для взрослого'));
      await tester.pumpAndSettle();
      final gateContext = tester.element(
        find.byKey(const Key('adult-challenge')),
      );
      expect(ModalRoute.of(gateContext)!.transitionDuration, Duration.zero);
      const marker = SizedBox(key: Key('motion-marker'));
      expect(
        identical(
          const AccessiblePageTransitions().buildTransitions(
            MaterialPageRoute<void>(builder: (_) => marker),
            gateContext,
            kAlwaysCompleteAnimation,
            kAlwaysDismissedAnimation,
            marker,
          ),
          marker,
        ),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Системное уменьшение движения действует независимо от настройки приложения',
    (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final repository = _MemoryRepository()..profile = initialProfile;
      await launch(tester, repository);
      expect(repository.reduceMotion, isFalse);
      expect(
        MediaQuery.disableAnimationsOf(tester.element(find.text('Финни'))),
        isTrue,
      );
      await tester.tap(find.byTooltip('Для взрослого'));
      await tester.pumpAndSettle();
      expect(
        ModalRoute.of(
          tester.element(find.byKey(const Key('adult-challenge'))),
        )!.transitionDuration,
        Duration.zero,
      );
    },
  );

  testWidgets('Создание питомца, отмена и подтверждение бюджета на 360 dp', (
    tester,
  ) async {
    final repository = _MemoryRepository();
    await launch(tester, repository);
    await tester.enterText(find.byType(TextFormField), 'Луна');
    await tester.tap(find.text('Серый'));
    await tester.ensureVisible(find.text('Бантик'));
    await tester.tap(find.text('Бантик'));
    await tester.scrollUntilVisible(
      find.text('Начать дружбу'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Начать дружбу'));
    await tester.pumpAndSettle();
    expect(find.text('Луна'), findsOneWidget);
    expect(repository.profile!.coat, PetCoat.grey);
    expect(repository.profile!.accessory, PetAccessory.bow);
    await tester.scrollUntilVisible(
      find.text('Составить бюджет'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Составить бюджет'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '60');
    await tester.enterText(find.byType(TextField).at(1), '20');
    await tester.enterText(find.byType(TextField).at(2), '30');
    await tester.pump();
    expect(find.text('Не хватает: 10 монет'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(2), '20');
    await tester.pump();
    await tester.ensureVisible(find.text('Подтвердить план'));
    await tester.tap(find.text('Подтвердить план'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Изменить'));
    await tester.pumpAndSettle();
    expect(repository.profile!.plan, isNull);
    await tester.tap(find.text('Подтвердить план'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Подтвердить'));
    await tester.pumpAndSettle();
    expect(
      find.text('План подтверждён. Сравни его с тратами.'),
      findsOneWidget,
    );
    expect(repository.profile!.balance, 100);
    expect(repository.profile!.plan!.savings, 20);
    expect(tester.takeException(), isNull);
  });

  for (final taskId in ['basket_food', 'saving_start']) {
    testWidgets('$taskId: ответ через форму сохраняет награду', (tester) async {
      final repository = _MemoryRepository()
        ..profile = initialProfile.withPlan(
          GameRules.confirmBudget(
            initialProfile,
            needs: 50,
            wants: 20,
            savings: 30,
          ),
        );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameRepositoryProvider.overrideWith((ref) async => repository),
          ],
          child: MaterialApp(
            home: TaskScreen(
              task: repository.catalog.task(taskId),
              catalog: repository.catalog,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (taskId == 'basket_food') {
        await tester.tap(find.text('Каша с тыквой'));
        await tester.tap(find.text('Свежая вода'));
      } else {
        await tester.enterText(find.byType(TextField), '10');
      }
      await tester.scrollUntilVisible(
        find.text('Проверить решение'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Проверить решение'));
      await tester.pumpAndSettle();
      expect(repository.profile!.completedTask(taskId), isTrue);
      expect(repository.profile!.balance, 110);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'Учебный бюджет даёт награду, завершение периода открывает новый план',
    (tester) async {
      final repository = _MemoryRepository()
        ..profile = initialProfile.withPlan(
          GameRules.confirmBudget(
            initialProfile,
            needs: 50,
            wants: 20,
            savings: 30,
          ),
        );
      await launch(tester, repository);
      await tester.scrollUntilVisible(
        find.text('Задания'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Задания'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Обед и мечта'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Проверить решение'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Проверить решение'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 100);
      expect(repository.profile!.taskProgress.single.completed, isFalse);
      await tester.scrollUntilVisible(
        find.widgetWithText(TextField, 'Нужно'),
        -150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.widgetWithText(TextField, 'Нужно'), '30');
      await tester.enterText(find.widgetWithText(TextField, 'На мечту'), '10');
      await tester.scrollUntilVisible(
        find.text('Проверить решение'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Проверить решение'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 110);
      expect(find.text('Задание выполнено'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Посмотреть бюджет'),
        -200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Посмотреть бюджет'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Подвести итоги'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Подвести итоги'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(repository.profile!.period, 1);
      await tester.tap(find.text('Подвести итоги'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Следующий период'));
      await tester.pumpAndSettle();
      expect(repository.profile!.period, 2);
      expect(repository.profile!.balance, 210);
      expect(repository.profile!.plan, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Покупка, пополнение и отменённое/подтверждённое снятие на 360 dp',
    (tester) async {
      final repository = _MemoryRepository()
        ..profile = initialProfile.withPlan(
          GameRules.confirmBudget(
            initialProfile,
            needs: 50,
            wants: 20,
            savings: 30,
          ),
        );
      await launch(tester, repository);
      await tester.scrollUntilVisible(
        find.text('Покупки'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Покупки'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Выбрать за 25'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Выбрать за 25'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 100);
      await tester.tap(find.text('Выбрать за 25'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Купить'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 75);
      expect(repository.profile!.satiety, 90);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('На мечту'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('На мечту'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Выбрать цель').first,
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Выбрать цель').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Выбрать цель'));
      await tester.pumpAndSettle();
      expect(repository.profile!.selectedGoalId, 'tent');
      await tester.scrollUntilVisible(
        find.byType(TextField),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.byType(TextField), '30');
      await tester.scrollUntilVisible(
        find.text('Пополнить'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Пополнить'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отложить'));
      await tester.pumpAndSettle();
      expect(repository.profile!.balance, 45);
      expect(repository.profile!.savings, 30);
      await tester.enterText(find.byType(TextField), '10');
      await tester.ensureVisible(find.text('Взять с цели'));
      await tester.tap(find.text('Взять с цели'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('На цели останется 20 из 120'),
        findsOneWidget,
      );
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(repository.profile!.savings, 30);
      await tester.tap(find.text('Взять с цели'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Снять монеты'));
      await tester.pumpAndSettle();
      expect(repository.profile!.savings, 20);
      expect(repository.profile!.balance, 55);
      expect(repository.profile!.netSaved, 20);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Посмотреть бюджет'),
        -150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Посмотреть бюджет'));
      await tester.pumpAndSettle();
      expect(find.text('Нужно — план: 50 · факт: 25'), findsOneWidget);
      expect(find.text('Хочется — план: 20 · факт: 0'), findsOneWidget);
      expect(find.text('На мечту — план: 30 · факт: 20'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Попытка покупки при нехватке показывает выход и не списывает монеты',
    (tester) async {
      final repository = _MemoryRepository()
        ..profile = initialProfile
            .withPlan(
              GameRules.confirmBudget(
                initialProfile,
                needs: 50,
                wants: 20,
                savings: 30,
              ),
            )
            .copyWith(balance: 20);
      await launch(tester, repository);
      await tester.scrollUntilVisible(
        find.text('Покупки'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Покупки'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Выбрать за 25'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Выбрать за 25'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Купить'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Не хватает 5 монет.'), findsOneWidget);
      expect(repository.profile!.balance, 20);
      expect(repository.profile!.transactions, isEmpty);
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Ошибка сохранения оставляет введённое имя для повторной попытки',
    (tester) async {
      final repository = _MemoryRepository()..failCreate = true;
      await launch(tester, repository);
      await tester.enterText(find.byType(TextFormField), 'Финни');
      await tester.scrollUntilVisible(
        find.text('Начать дружбу'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Начать дружбу'));
      await tester.pumpAndSettle();
      expect(
        find.text('Не удалось сохранить питомца. Попробуй ещё раз.'),
        findsOneWidget,
      );
      expect(find.text('Финни'), findsOneWidget);
      expect(repository.profile, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Существующий профиль открывается сразу; справка доступна офлайн',
    (tester) async {
      final repository = _MemoryRepository()..profile = initialProfile;
      await launch(tester, repository, scale: 2);
      expect(find.text('Финни'), findsOneWidget);
      expect(find.text('Баланс: 100'), findsOneWidget);
      await tester.tap(find.byTooltip('Как играть'));
      await tester.pumpAndSettle();
      expect(find.text('Твой маленький друг'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Девять вариантов питомца различимы на каждой из трёх стадий', (
    tester,
  ) async {
    final key = GlobalKey();
    final Set<int> fingerprints = {};
    for (final coat in PetCoat.values) {
      for (final accessory in PetAccessory.values) {
        for (var stage = 1; stage <= 3; stage++) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: RepaintBoundary(
                    key: key,
                    child: PetPortrait(
                      coat: coat,
                      accessory: accessory,
                      stage: stage,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            find.bySemanticsLabel(
              '${coatLabels[coat]} кот, ${accessoryLabels[accessory]}',
            ),
            findsOneWidget,
          );
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final ui.Image image = await boundary.toImage();
            final bytes = (await image.toByteData(
              format: ui.ImageByteFormat.png,
            ))!;
            fingerprints.add(Object.hashAll(bytes.buffer.asUint8List()));
            if (coat == PetCoat.ginger && accessory == PetAccessory.scarf) {
              await File(
                '/tmp/finny_pet_stage_$stage.png',
              ).writeAsBytes(bytes.buffer.asUint8List());
            }
            image.dispose();
          });
        }
      }
    }
    expect(fingerprints.length, 27);
  });
}
