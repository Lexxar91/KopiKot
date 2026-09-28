import '../../domain/models/game_profile.dart';
import '../../domain/models/game_catalog.dart';
import '../../domain/models/game_transaction.dart';
import '../../domain/models/learning_task.dart';
import '../../domain/models/period_summary.dart';
import '../../domain/rules/learning_rules.dart';
import '../../domain/rules/learning_difficulty_rules.dart';
import '../../domain/rules/mini_game_rules.dart';
import '../../domain/rules/daily_reward_rules.dart';
import '../../domain/rules/period_rules.dart';
import '../../domain/rules/activity_rules.dart';
import '../../domain/rules/activity_reward_rules.dart';
import '../../domain/rules/accountant_rules.dart';
import '../../domain/rules/market_game_rules.dart';
import '../../domain/rules/sapling_rules.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/rules/game_rules.dart';
import '../../domain/rules/budget_income_rules.dart';
import '../../domain/rules/economy_rules.dart';
import '../../domain/rules/growth_rules.dart';
import '../local/local_game_store.dart';
import '../local/accountant_session_codec.dart';
import '../local/market_session_codec.dart';
import '../local/profile_record.dart';

/// Начальный доход и профиль записываются вместе, без повторного начисления.
class LocalGameRepository implements GameRepository {
  const LocalGameRepository(
    this._store,
    this.catalog, {
    this.clock = DateTime.now,
  });
  final LocalGameStore _store;
  final GameCatalog catalog;
  final DateTime Function() clock;

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
    return record == null ? null : loadProfile();
  }

  @override
  Future<GameProfile> resetTestProfile() async {
    await _store.resetTestProfile(_initialTestProfile());
    return (await loadProfile())!;
  }

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
      ..selectedGoalId = 'tent'
      ..goalChoicesUnlocked = false,
  );

  @override
  Future<GameProfile?> loadProfile() async {
    final record = await _store.readProfile();
    return record == null ? null : _change((profile) => profile);
  }

  @override
  Future<GameProfile> createProfile({
    required String petName,
    required PetCoat coat,
    required PetAccessory accessory,
  }) async {
    final String name = GameRules.validatePetName(petName);
    await _store.updateProfile((current) {
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
          ..incomeSource = 'Подарок на знакомство'
          ..selectedGoalId = 'tent'
          ..goalChoicesUnlocked = false,
      );
    });
    return (await loadProfile())!;
  }

  @override
  Future<GameProfile> confirmBudget({
    required int needs,
    required int wants,
    required int savings,
    int gifts = 0,
    int kept = 0,
    int expectedIncome = 0,
    List<String> sourceIds = const [],
  }) async {
    await loadProfile();
    final ProfileRecord record = await _store.updateProfile((current) {
      if (current == null) {
        throw const GameRuleException('Сначала создай питомца.');
      }
      _migrate(current);
      final profile = _toDomain(current);
      if (expectedIncome !=
          BudgetIncomeRules.totalFor(profile, catalog, sourceIds)) {
        throw const GameRuleException(
          'Ожидаемый доход изменился. Проверь план ещё раз.',
        );
      }
      final BudgetPlan plan = GameRules.confirmBudget(
        profile,
        needs: needs,
        wants: wants,
        savings: savings,
        gifts: gifts,
        kept: kept,
        expectedIncome: expectedIncome,
        sourceIds: sourceIds,
      );
      return current
        ..budgetConfirmed = true
        ..plannedBalance = plan.availableAtConfirmation
        ..budgetOpeningBalance = plan.openingBalance
        ..budgetExpectedIncome = plan.expectedIncome
        ..budgetKept = plan.kept
        ..budgetSourceIds = plan.sourceIds
        ..plannedNeeds = plan.needs
        ..plannedWants = plan.wants
        ..plannedGifts = plan.gifts
        ..plannedSavings = plan.savings;
    });
    return _toDomain(record);
  }

  @override
  Future<GameProfile> reviseBudget({
    required int needs,
    required int wants,
    required int savings,
    int gifts = 0,
    int kept = 0,
    int expectedIncome = 0,
    List<String> sourceIds = const [],
  }) => _change((profile) {
    if (expectedIncome !=
        BudgetIncomeRules.totalFor(profile, catalog, sourceIds)) {
      throw const GameRuleException(
        'Ожидаемый доход изменился. Проверь план ещё раз.',
      );
    }
    return GameRules.reviseBudget(
      profile,
      needs: needs,
      wants: wants,
      savings: savings,
      gifts: gifts,
      kept: kept,
      expectedIncome: expectedIncome,
      sourceIds: sourceIds,
    );
  });

  GameProfile _toDomain(ProfileRecord record) {
    if (record.schemaVersion != 8) {
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
      dayKey: record.dayKey,
      accountantSessions: decodeAccountantSessions(
        record.accountantSessionsJson,
      ),
      marketSessions: decodeMarketSessions(record.marketSessionsJson),
      bestDayIncome: record.bestDayIncome,
      bestDayKey: record.bestDayKey,
      unlockedGrowthStage: record.unlockedGrowthStage,
      growthIncomeThresholds: List.unmodifiable(
        record.growthIncomeThresholds ?? const [30, 55, 80],
      ),
      growthSavingsThresholds: List.unmodifiable(
        record.growthSavingsThresholds ?? const [30, 100, 200],
      ),
      growthMilestones: List.unmodifiable(
        (record.growthMilestones ?? <GrowthMilestoneRecord>[]).map(
          (entry) => GrowthMilestone(
            stage: entry.stage,
            incomeThreshold: entry.incomeThreshold,
            savingsThreshold: entry.savingsThreshold,
            bestDayIncome: entry.bestDayIncome,
            savingsAtUnlock: entry.savingsAtUnlock,
            dayKey: entry.dayKey,
          ),
        ),
      ),
      incomeSource: record.incomeSource,
      incomeAmount: record.incomeAmount,
      taskProgress: List.unmodifiable(
        (record.taskProgress ?? <TaskProgressRecord>[]).map(
          (entry) => TaskProgress(
            taskId: entry.taskId,
            attempts: entry.attempts,
            completed: entry.completed,
            feedback: entry.feedback,
            hintUsed: entry.hintUsed,
            solutionShown: entry.solutionShown,
            reviewed: entry.reviewed,
            practiceAttempts: entry.practiceAttempts,
          ),
        ),
      ),
      learningTopics: List.unmodifiable(
        (record.learningTopics ?? <LearningTopicRecord>[]).map(
          (entry) => LearningTopicProgress(
            topic: entry.topic,
            difficulty: LearningDifficulty.values.byName(entry.difficulty),
            cleanStreak: entry.cleanStreak,
            helpStreak: entry.helpStreak,
            downgradeOffered: entry.downgradeOffered,
            downgradePending: entry.downgradePending,
          ),
        ),
      ),
      periodSummaries: List.unmodifiable(
        (record.periodSummaries ?? <PeriodSummaryRecord>[]).map(
          (entry) => PeriodSummary(
            period: entry.period,
            dayKey: entry.dayKey,
            missedDays: entry.missedDays,
            plannedIncome: entry.plannedIncome,
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
      goalChoicesUnlocked: record.goalChoicesUnlocked ?? true,
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
            plantedDayKey: entry.plantedDayKey,
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
            startSatiety: entry.startSatiety,
            startEnergy: entry.startEnergy,
            startMood: entry.startMood,
            baseReward: entry.baseReward,
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
              openingBalance:
                  record.budgetOpeningBalance == 0 &&
                      record.budgetExpectedIncome == 0
                  ? record.plannedBalance
                  : record.budgetOpeningBalance,
              expectedIncome: record.budgetExpectedIncome,
              kept: record.budgetKept,
              sourceIds: List.unmodifiable(record.budgetSourceIds ?? const []),
              needs: record.plannedNeeds,
              wants: record.plannedWants,
              gifts: record.plannedGifts,
              savings: record.plannedSavings,
            )
          : null,
      budgetRevisions: List.unmodifiable(
        (record.budgetRevisions ?? const <BudgetRevisionRecord>[]).map(
          (entry) => BudgetRevision(
            period: entry.period,
            plan: BudgetPlan(
              availableAtConfirmation: entry.available,
              openingBalance: entry.openingBalance,
              expectedIncome: entry.expectedIncome,
              needs: entry.needs,
              wants: entry.wants,
              savings: entry.savings,
              gifts: entry.gifts,
              kept: entry.kept,
              sourceIds: List.unmodifiable(entry.sourceIds ?? const []),
            ),
          ),
        ),
      ),
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
  Future<GameProfile> purchaseGoal(String goalId, String commandId) => _change(
    (profile) =>
        EconomyRules.purchaseGoal(profile, catalog.goal(goalId), commandId),
  );

  @override
  Future<GameProfile> transferReserve(
    int amount, {
    required String commandId,
    required bool withdraw,
  }) => _change(
    (profile) => EconomyRules.transferReserve(
      profile,
      amount,
      commandId: commandId,
      withdraw: withdraw,
    ),
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
      final profile = GrowthRules.refresh(
        action(PeriodRules.openToday(_toDomain(current), clock())),
      );
      return current
        ..period = profile.period
        ..dayKey = profile.dayKey
        ..accountantSessionsJson = encodeAccountantSessions(
          profile.accountantSessions,
        )
        ..marketSessionsJson = encodeMarketSessions(profile.marketSessions)
        ..bestDayIncome = profile.bestDayIncome
        ..bestDayKey = profile.bestDayKey
        ..unlockedGrowthStage = profile.unlockedGrowthStage
        ..growthIncomeThresholds = profile.growthIncomeThresholds
        ..growthSavingsThresholds = profile.growthSavingsThresholds
        ..growthMilestones = [
          for (final entry in profile.growthMilestones)
            GrowthMilestoneRecord()
              ..stage = entry.stage
              ..incomeThreshold = entry.incomeThreshold
              ..savingsThreshold = entry.savingsThreshold
              ..bestDayIncome = entry.bestDayIncome
              ..savingsAtUnlock = entry.savingsAtUnlock
              ..dayKey = entry.dayKey,
        ]
        ..budgetConfirmed = profile.plan != null
        ..plannedBalance = profile.plan?.availableAtConfirmation ?? 0
        ..budgetOpeningBalance = profile.plan?.openingBalance ?? 0
        ..budgetExpectedIncome = profile.plan?.expectedIncome ?? 0
        ..budgetKept = profile.plan?.kept ?? 0
        ..budgetSourceIds = profile.plan?.sourceIds
        ..plannedNeeds = profile.plan?.needs ?? 0
        ..plannedWants = profile.plan?.wants ?? 0
        ..plannedGifts = profile.plan?.gifts ?? 0
        ..plannedSavings = profile.plan?.savings ?? 0
        ..budgetRevisions = [
          for (final revision in profile.budgetRevisions)
            BudgetRevisionRecord()
              ..period = revision.period
              ..available = revision.plan.availableAtConfirmation
              ..openingBalance = revision.plan.openingBalance
              ..expectedIncome = revision.plan.expectedIncome
              ..needs = revision.plan.needs
              ..wants = revision.plan.wants
              ..savings = revision.plan.savings
              ..gifts = revision.plan.gifts
              ..kept = revision.plan.kept
              ..sourceIds = revision.plan.sourceIds,
        ]
        ..taskProgress = [
          for (final entry in profile.taskProgress)
            TaskProgressRecord()
              ..taskId = entry.taskId
              ..attempts = entry.attempts
              ..completed = entry.completed
              ..hintUsed = entry.hintUsed
              ..solutionShown = entry.solutionShown
              ..reviewed = entry.reviewed
              ..practiceAttempts = entry.practiceAttempts
              ..feedback = entry.feedback,
        ]
        ..learningTopics = [
          for (final entry in profile.learningTopics)
            LearningTopicRecord()
              ..topic = entry.topic
              ..difficulty = entry.difficulty.name
              ..cleanStreak = entry.cleanStreak
              ..helpStreak = entry.helpStreak
              ..downgradeOffered = entry.downgradeOffered
              ..downgradePending = entry.downgradePending,
        ]
        ..periodSummaries = [
          for (final entry in profile.periodSummaries)
            PeriodSummaryRecord()
              ..period = entry.period
              ..dayKey = entry.dayKey
              ..missedDays = entry.missedDays
              ..plannedIncome = entry.plannedIncome
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
        ..goalChoicesUnlocked = profile.goalChoicesUnlocked
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
              ..plantedPeriod = sapling.plantedPeriod
              ..plantedDayKey = sapling.plantedDayKey,
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
              ..startSatiety = entry.startSatiety
              ..startEnergy = entry.startEnergy
              ..startMood = entry.startMood
              ..baseReward = entry.baseReward
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
    if (record.schemaVersion == 5) {
      record
        ..bestDayIncome = 0
        ..bestDayKey = null
        ..unlockedGrowthStage = 1
        ..growthIncomeThresholds = const [30, 55, 80]
        ..growthSavingsThresholds = const [30, 100, 200]
        ..growthMilestones = <GrowthMilestoneRecord>[];
      record.schemaVersion = 6;
    }
    if (record.schemaVersion == 6) {
      record.accountantSessionsJson = '[]';
      record.schemaVersion = 7;
    }
    if (record.schemaVersion == 7) {
      record.marketSessionsJson = '[]';
      record.schemaVersion = 8;
    }
    if (record.schemaVersion != 8) {
      throw StateError('Unsupported profile schema: ${record.schemaVersion}');
    }
    return record;
  }

  @override
  Future<GameProfile> submitTask(
    String taskId,
    TaskAnswer answer, {
    ActivityRewardSnapshot? snapshot,
  }) => _change(
    (profile) => LearningRules.submit(
      profile,
      catalog,
      catalog.task(taskId),
      answer,
      snapshot: snapshot,
    ),
  );

  @override
  Future<GameProfile> acknowledgeTask(
    String taskId, {
    ActivityRewardSnapshot? snapshot,
  }) => _change(
    (profile) => LearningRules.acknowledge(
      profile,
      catalog.task(taskId),
      snapshot: snapshot,
    ),
  );

  @override
  Future<GameProfile> chooseLearningDifficulty(
    String topic,
    LearningDifficulty difficulty,
  ) => _change(
    (profile) => LearningDifficultyRules.choose(profile, topic, difficulty),
  );

  @override
  Future<GameProfile> dismissLearningDowngrade(String topic) => _change(
    (profile) => LearningDifficultyRules.dismissDowngrade(profile, topic),
  );

  @override
  Future<GameProfile> claimMiniGame(
    MiniGameKind kind,
    String commandId, {
    ActivityRewardSnapshot? snapshot,
  }) => _change(
    (profile) =>
        MiniGameRules.claim(profile, kind, commandId, snapshot: snapshot),
  );

  @override
  Future<GameProfile> accountantAction(
    String sessionId,
    AccountantAction action, {
    int? answer,
  }) => _change(
    (profile) =>
        AccountantRules.apply(profile, sessionId, action, answer: answer),
  );

  @override
  Future<GameProfile> marketAction(
    String sessionId,
    MarketAction action, {
    String? itemId,
  }) => _change(
    (profile) =>
        MarketGameRules.apply(profile, sessionId, action, itemId: itemId),
  );

  @override
  Future<GameProfile> claimDailyReward() =>
      _change((profile) => DailyRewardRules.claim(profile, now: clock()));

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
