import '../../domain/models/game_profile.dart';
import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_transaction.dart';
import '../../domain/models/learning_task.dart';
import '../../domain/models/period_summary.dart';
import '../../domain/rules/learning_rules.dart';
import '../../domain/rules/mini_game_rules.dart';
import '../../domain/rules/daily_reward_rules.dart';
import '../../domain/rules/period_rules.dart';
import '../../domain/rules/activity_rules.dart';
import '../../domain/rules/sapling_rules.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/rules/game_rules.dart';
import '../../domain/rules/economy_rules.dart';
import '../local/local_game_store.dart';
import '../local/profile_record.dart';

/// Начальный доход и профиль записываются вместе, без повторного начисления.
class LocalGameRepository implements GameRepository {
  const LocalGameRepository(this._store, this.catalog);
  final LocalGameStore _store;
  final GameCatalog catalog;

  @override
  Future<bool> loadReduceMotion() => _store.readReduceMotion();
  @override
  Future<void> saveReduceMotion(bool value) => _store.saveReduceMotion(value);

  @override
  Future<GameProfile?> switchProfile({required bool testProfile}) async {
    final record = await _store.switchProfile(
      testProfile: testProfile,
      prepare: (current) {
        final next = current ?? (testProfile ? _initialTestProfile() : null);
        if (next != null) {
          _migrate(next);
          _toDomain(
            next,
          ); // Проверить до фиксации выбора, не теряя старый режим.
        }
        return next;
      },
    );
    return record == null ? null : _toDomain(record);
  }

  @override
  Future<GameProfile> resetTestProfile() async =>
      _toDomain(await _store.resetTestProfile(_initialTestProfile()));

  @override
  Future<void> deleteRegularProfile() => _store.deleteRegularProfile();

  ProfileRecord _initialTestProfile() => _withInitialHistory(
    ProfileRecord()
      ..id = 2
      ..petName = 'Финни Тест'
      ..coat = PetCoat.ginger.name
      ..accessory = PetAccessory.scarf.name
      ..ownedAccessories = [PetAccessory.scarf.name]
      ..balance = GameRules.startingBalance
      ..incomeAmount = GameRules.startingBalance
      ..incomeSource = 'Подарок на знакомство'
      ..selectedGoalId = 'tent',
  );

  @override
  Future<GameProfile?> loadProfile() async {
    ProfileRecord? record = await _store.readProfile();
    if (record != null && record.schemaVersion < 5) {
      record = await _store.updateProfile((current) => _migrate(current!));
    }
    return record == null ? null : _toDomain(record);
  }

  @override
  Future<GameProfile> createProfile({
    required String petName,
    required PetCoat coat,
    required PetAccessory accessory,
  }) async {
    final String name = GameRules.validatePetName(petName);
    final ProfileRecord record = await _store.updateProfile((current) {
      if (current != null) {
        throw const GameRuleException(
          'Питомец уже создан. Вернись на главный экран.',
        );
      }
      return _withInitialHistory(
        ProfileRecord()
          ..petName = name
          ..coat = coat.name
          ..accessory = accessory.name
          ..ownedAccessories = [accessory.name]
          ..balance = GameRules.startingBalance
          ..incomeAmount = GameRules.startingBalance
          ..incomeSource = 'Подарок на знакомство',
      );
    });
    return _toDomain(record);
  }

  @override
  Future<GameProfile> confirmBudget({
    required int needs,
    required int wants,
    required int savings,
    int gifts = 0,
  }) async {
    final ProfileRecord record = await _store.updateProfile((current) {
      if (current == null) {
        throw const GameRuleException('Сначала создай питомца.');
      }
      _migrate(current);
      final BudgetPlan plan = GameRules.confirmBudget(
        _toDomain(current),
        needs: needs,
        wants: wants,
        savings: savings,
        gifts: gifts,
      );
      return current
        ..budgetConfirmed = true
        ..plannedBalance = plan.availableAtConfirmation
        ..plannedNeeds = plan.needs
        ..plannedWants = plan.wants
        ..plannedGifts = plan.gifts
        ..plannedSavings = plan.savings;
    });
    return _toDomain(record);
  }

  GameProfile _toDomain(ProfileRecord record) {
    if (record.schemaVersion != 5) {
      throw StateError('Unsupported profile schema: ${record.schemaVersion}');
    }
    final balances = record.goalBalances ?? <GoalBalanceRecord>[];
    if (record.balance < 0 ||
        record.savings < 0 ||
        balances.any((goal) => goal.amount < 0) ||
        balances.map((goal) => goal.goalId).toSet().length != balances.length ||
        balances.fold<int>(0, (sum, goal) => sum + goal.amount) !=
            record.savings) {
      throw StateError('Inconsistent saved balances');
    }
    return GameProfile(
      petName: record.petName,
      isTest: record.id == 2,
      coat: PetCoat.values.byName(record.coat),
      accessory: record.accessory.isEmpty
          ? null
          : PetAccessory.values.byName(record.accessory),
      ownedAccessories: List.unmodifiable(
        (record.ownedAccessories ?? const <String>[])
            .map(PetAccessory.values.byName)
            .toSet(),
      ),
      balance: record.balance,
      savings: record.savings,
      period: record.period,
      satiety: record.satiety,
      mood: record.mood,
      energy: record.energy,
      streak: record.streak,
      walkPeriod: record.walkPeriod,
      lastRewardAt: record.lastRewardAt,
      incomeSource: record.incomeSource,
      incomeAmount: record.incomeAmount,
      taskProgress: List.unmodifiable(
        (record.taskProgress ?? <TaskProgressRecord>[]).map(
          (entry) => TaskProgress(
            taskId: entry.taskId,
            attempts: entry.attempts,
            completed: entry.completed,
            feedback: entry.feedback,
          ),
        ),
      ),
      periodSummaries: List.unmodifiable(
        (record.periodSummaries ?? <PeriodSummaryRecord>[]).map(
          (entry) => PeriodSummary(
            period: entry.period,
            plannedNeeds: entry.plannedNeeds,
            plannedWants: entry.plannedWants,
            plannedSavings: entry.plannedSavings,
            plannedGifts: entry.plannedGifts,
            actualNeeds: entry.actualNeeds,
            actualWants: entry.actualWants,
            actualGifts: entry.actualGifts,
            netSaved: entry.netSaved,
            needsMet: entry.needsMet,
            withinPlan: entry.withinPlan,
            savedRegularly: entry.savedRegularly,
            explanation: entry.explanation,
          ),
        ),
      ),
      selectedGoalId: record.selectedGoalId,
      goalSavings: Map.unmodifiable({
        for (final goal in record.goalBalances ?? <GoalBalanceRecord>[])
          goal.goalId: goal.amount,
      }),
      saplings: List.unmodifiable(
        (record.saplings ?? <SaplingRecord>[]).map(
          (entry) => SaplingState(
            id: entry.saplingId,
            definitionId: entry.definitionId,
            plantedPeriod: entry.plantedPeriod,
          ),
        ),
      ),
      transactions: List.unmodifiable(
        (record.transactions ?? <TransactionRecord>[]).map(
          (entry) => GameTransaction(
            id: entry.commandId,
            period: entry.period,
            kind: TransactionKind.values.byName(entry.kind),
            amount: entry.amount,
            label: entry.label,
            referenceId: entry.referenceId,
            balanceAfter: entry.balanceAfter,
            savingsAfter: entry.savingsAfter,
            satietyAfter: entry.satietyAfter,
            moodAfter: entry.moodAfter,
          ),
        ),
      ),
      feedback:
          record.feedback ??
          'Питомец рад знакомству. Давай подумаем, на что хватит монет.',
      plan: record.budgetConfirmed
          ? BudgetPlan(
              availableAtConfirmation: record.plannedBalance,
              needs: record.plannedNeeds,
              wants: record.plannedWants,
              gifts: record.plannedGifts,
              savings: record.plannedSavings,
            )
          : null,
    );
  }

  @override
  Future<GameProfile> purchase(String productId, {required String commandId}) =>
      _change(
        (profile) => EconomyRules.purchase(
          profile,
          catalog.product(productId),
          commandId,
        ),
      );

  @override
  Future<GameProfile> equipAccessory(PetAccessory? accessory) =>
      _change((profile) => EconomyRules.equipAccessory(profile, accessory));

  @override
  Future<GameProfile> walk() => _change(ActivityRules.walk);

  @override
  Future<GameProfile> plantSapling(String definitionId, String commandId) =>
      _change(
        (profile) => SaplingRules.plant(
          profile,
          catalog.sapling(definitionId),
          commandId,
        ),
      );

  @override
  Future<GameProfile> harvestSapling(String saplingId, String commandId) =>
      _change((profile) {
        final SaplingState state = profile.saplings.firstWhere(
          (sapling) => sapling.id == saplingId,
        );
        return SaplingRules.harvest(
          profile,
          state,
          catalog.sapling(state.definitionId),
          commandId,
        );
      });

  @override
  Future<GameProfile> selectGoal(String goalId) => _change(
    (profile) => EconomyRules.selectGoal(profile, catalog.goal(goalId)),
  );

  @override
  Future<GameProfile> transfer(
    String goalId,
    int amount, {
    required String commandId,
    required bool withdraw,
  }) => _change(
    (profile) => EconomyRules.transfer(
      profile,
      catalog.goal(goalId),
      amount,
      commandId: commandId,
      withdraw: withdraw,
    ),
  );

  Future<GameProfile> _change(GameProfile Function(GameProfile) action) async {
    final record = await _store.updateProfile((current) {
      if (current == null) {
        throw const GameRuleException('Сначала создай питомца.');
      }
      _migrate(current);
      final profile = action(_toDomain(current));
      return current
        ..period = profile.period
        ..budgetConfirmed = profile.plan != null
        ..plannedBalance = profile.plan?.availableAtConfirmation ?? 0
        ..plannedNeeds = profile.plan?.needs ?? 0
        ..plannedWants = profile.plan?.wants ?? 0
        ..plannedGifts = profile.plan?.gifts ?? 0
        ..plannedSavings = profile.plan?.savings ?? 0
        ..taskProgress = [
          for (final entry in profile.taskProgress)
            TaskProgressRecord()
              ..taskId = entry.taskId
              ..attempts = entry.attempts
              ..completed = entry.completed
              ..feedback = entry.feedback,
        ]
        ..periodSummaries = [
          for (final entry in profile.periodSummaries)
            PeriodSummaryRecord()
              ..period = entry.period
              ..plannedNeeds = entry.plannedNeeds
              ..plannedWants = entry.plannedWants
              ..plannedSavings = entry.plannedSavings
              ..plannedGifts = entry.plannedGifts
              ..actualNeeds = entry.actualNeeds
              ..actualWants = entry.actualWants
              ..actualGifts = entry.actualGifts
              ..netSaved = entry.netSaved
              ..needsMet = entry.needsMet
              ..withinPlan = entry.withinPlan
              ..savedRegularly = entry.savedRegularly
              ..explanation = entry.explanation,
        ]
        ..balance = profile.balance
        ..savings = profile.savings
        ..satiety = profile.satiety
        ..mood = profile.mood
        ..energy = profile.energy
        ..streak = profile.streak
        ..walkPeriod = profile.walkPeriod
        ..lastRewardAt = profile.lastRewardAt
        ..accessory = profile.accessory?.name ?? ''
        ..ownedAccessories = [
          for (final accessory in profile.ownedAccessories) accessory.name,
        ]
        ..selectedGoalId = profile.selectedGoalId
        ..feedback = profile.feedback
        ..goalBalances = [
          for (final entry in profile.goalSavings.entries)
            GoalBalanceRecord()
              ..goalId = entry.key
              ..amount = entry.value,
        ]
        ..saplings = [
          for (final sapling in profile.saplings)
            SaplingRecord()
              ..saplingId = sapling.id
              ..definitionId = sapling.definitionId
              ..plantedPeriod = sapling.plantedPeriod,
        ]
        ..transactions = [
          for (final entry in profile.transactions)
            TransactionRecord()
              ..commandId = entry.id
              ..period = entry.period
              ..kind = entry.kind.name
              ..amount = entry.amount
              ..label = entry.label
              ..referenceId = entry.referenceId
              ..balanceAfter = entry.balanceAfter
              ..savingsAfter = entry.savingsAfter
              ..satietyAfter = entry.satietyAfter
              ..moodAfter = entry.moodAfter,
        ];
    });
    return _toDomain(record);
  }

  ProfileRecord _migrate(ProfileRecord record) {
    if (record.schemaVersion == 1) {
      // В схеме 1 доступны только начальный доход и план, других операций не было.
      _withInitialHistory(record);
      record.schemaVersion = 2;
    }
    if (record.schemaVersion == 2) record.schemaVersion = 3;
    if (record.schemaVersion == 3) {
      record.ownedAccessories = record.accessory.isEmpty
          ? <String>[]
          : <String>[record.accessory];
      record.schemaVersion = 4;
    }
    if (record.schemaVersion == 4) {
      // Схема 5 добавляет энергию, серию, прогулку и саженцы: значения по умолчанию.
      record
        ..energy = 70
        ..streak = 1
        ..walkPeriod = 0
        ..saplings = <SaplingRecord>[];
      record.schemaVersion = 5;
    }
    if (record.schemaVersion != 5) {
      throw StateError('Unsupported profile schema: ${record.schemaVersion}');
    }
    return record;
  }

  @override
  Future<GameProfile> submitTask(String taskId, TaskAnswer answer) => _change(
    (profile) =>
        LearningRules.submit(profile, catalog, catalog.task(taskId), answer),
  );

  @override
  Future<GameProfile> claimMiniGame(MiniGameKind kind, String commandId) =>
      _change((profile) => MiniGameRules.claim(profile, kind, commandId));

  @override
  Future<GameProfile> claimDailyReward() => _change(DailyRewardRules.claim);

  @override
  Future<GameProfile> finishPeriod(int expectedPeriod) =>
      _change((profile) => PeriodRules.finish(profile, expectedPeriod));

  ProfileRecord _withInitialHistory(ProfileRecord record) =>
      record
        ..transactions = [
          TransactionRecord()
            ..commandId = 'initial-income'
            ..period = 1
            ..kind = TransactionKind.income.name
            ..amount = record.incomeAmount
            ..label = record.incomeSource
            ..balanceAfter = record.balance
            ..savingsAfter = record.savings
            ..satietyAfter = record.satiety
            ..moodAfter = record.mood,
        ];
}
