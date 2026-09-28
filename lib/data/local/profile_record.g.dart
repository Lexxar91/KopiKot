// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProfileRecordCollection on Isar {
  IsarCollection<ProfileRecord> get profileRecords => this.collection();
}

const ProfileRecordSchema = CollectionSchema(
  name: r'ProfileRecord',
  id: 4570135406082580845,
  properties: {
    r'accessory': PropertySchema(
      id: 0,
      name: r'accessory',
      type: IsarType.string,
    ),
    r'accountantSessionsJson': PropertySchema(
      id: 1,
      name: r'accountantSessionsJson',
      type: IsarType.string,
    ),
    r'balance': PropertySchema(id: 2, name: r'balance', type: IsarType.long),
    r'bestDayIncome': PropertySchema(
      id: 3,
      name: r'bestDayIncome',
      type: IsarType.long,
    ),
    r'bestDayKey': PropertySchema(
      id: 4,
      name: r'bestDayKey',
      type: IsarType.string,
    ),
    r'budgetConfirmed': PropertySchema(
      id: 5,
      name: r'budgetConfirmed',
      type: IsarType.bool,
    ),
    r'budgetExpectedIncome': PropertySchema(
      id: 6,
      name: r'budgetExpectedIncome',
      type: IsarType.long,
    ),
    r'budgetKept': PropertySchema(
      id: 7,
      name: r'budgetKept',
      type: IsarType.long,
    ),
    r'budgetOpeningBalance': PropertySchema(
      id: 8,
      name: r'budgetOpeningBalance',
      type: IsarType.long,
    ),
    r'budgetRevisions': PropertySchema(
      id: 9,
      name: r'budgetRevisions',
      type: IsarType.objectList,

      target: r'BudgetRevisionRecord',
    ),
    r'budgetSourceIds': PropertySchema(
      id: 10,
      name: r'budgetSourceIds',
      type: IsarType.stringList,
    ),
    r'coat': PropertySchema(id: 11, name: r'coat', type: IsarType.string),
    r'dayKey': PropertySchema(id: 12, name: r'dayKey', type: IsarType.string),
    r'energy': PropertySchema(id: 13, name: r'energy', type: IsarType.long),
    r'feedback': PropertySchema(
      id: 14,
      name: r'feedback',
      type: IsarType.string,
    ),
    r'goalBalances': PropertySchema(
      id: 15,
      name: r'goalBalances',
      type: IsarType.objectList,

      target: r'GoalBalanceRecord',
    ),
    r'goalChoicesUnlocked': PropertySchema(
      id: 16,
      name: r'goalChoicesUnlocked',
      type: IsarType.bool,
    ),
    r'growthIncomeThresholds': PropertySchema(
      id: 17,
      name: r'growthIncomeThresholds',
      type: IsarType.longList,
    ),
    r'growthMilestones': PropertySchema(
      id: 18,
      name: r'growthMilestones',
      type: IsarType.objectList,

      target: r'GrowthMilestoneRecord',
    ),
    r'growthSavingsThresholds': PropertySchema(
      id: 19,
      name: r'growthSavingsThresholds',
      type: IsarType.longList,
    ),
    r'incomeAmount': PropertySchema(
      id: 20,
      name: r'incomeAmount',
      type: IsarType.long,
    ),
    r'incomeSource': PropertySchema(
      id: 21,
      name: r'incomeSource',
      type: IsarType.string,
    ),
    r'lastRewardAt': PropertySchema(
      id: 22,
      name: r'lastRewardAt',
      type: IsarType.dateTime,
    ),
    r'learningTopics': PropertySchema(
      id: 23,
      name: r'learningTopics',
      type: IsarType.objectList,

      target: r'LearningTopicRecord',
    ),
    r'marketSessionsJson': PropertySchema(
      id: 24,
      name: r'marketSessionsJson',
      type: IsarType.string,
    ),
    r'mood': PropertySchema(id: 25, name: r'mood', type: IsarType.long),
    r'ownedAccessories': PropertySchema(
      id: 26,
      name: r'ownedAccessories',
      type: IsarType.stringList,
    ),
    r'period': PropertySchema(id: 27, name: r'period', type: IsarType.long),
    r'periodSummaries': PropertySchema(
      id: 28,
      name: r'periodSummaries',
      type: IsarType.objectList,

      target: r'PeriodSummaryRecord',
    ),
    r'petName': PropertySchema(id: 29, name: r'petName', type: IsarType.string),
    r'plannedBalance': PropertySchema(
      id: 30,
      name: r'plannedBalance',
      type: IsarType.long,
    ),
    r'plannedGifts': PropertySchema(
      id: 31,
      name: r'plannedGifts',
      type: IsarType.long,
    ),
    r'plannedNeeds': PropertySchema(
      id: 32,
      name: r'plannedNeeds',
      type: IsarType.long,
    ),
    r'plannedSavings': PropertySchema(
      id: 33,
      name: r'plannedSavings',
      type: IsarType.long,
    ),
    r'plannedWants': PropertySchema(
      id: 34,
      name: r'plannedWants',
      type: IsarType.long,
    ),
    r'saplings': PropertySchema(
      id: 35,
      name: r'saplings',
      type: IsarType.objectList,

      target: r'SaplingRecord',
    ),
    r'satiety': PropertySchema(id: 36, name: r'satiety', type: IsarType.long),
    r'savings': PropertySchema(id: 37, name: r'savings', type: IsarType.long),
    r'schemaVersion': PropertySchema(
      id: 38,
      name: r'schemaVersion',
      type: IsarType.long,
    ),
    r'selectedGoalId': PropertySchema(
      id: 39,
      name: r'selectedGoalId',
      type: IsarType.string,
    ),
    r'streak': PropertySchema(id: 40, name: r'streak', type: IsarType.long),
    r'taskProgress': PropertySchema(
      id: 41,
      name: r'taskProgress',
      type: IsarType.objectList,

      target: r'TaskProgressRecord',
    ),
    r'transactions': PropertySchema(
      id: 42,
      name: r'transactions',
      type: IsarType.objectList,

      target: r'TransactionRecord',
    ),
    r'unlockedGrowthStage': PropertySchema(
      id: 43,
      name: r'unlockedGrowthStage',
      type: IsarType.long,
    ),
    r'walkPeriod': PropertySchema(
      id: 44,
      name: r'walkPeriod',
      type: IsarType.long,
    ),
  },

  estimateSize: _profileRecordEstimateSize,
  serialize: _profileRecordSerialize,
  deserialize: _profileRecordDeserialize,
  deserializeProp: _profileRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'BudgetRevisionRecord': BudgetRevisionRecordSchema,
    r'GoalBalanceRecord': GoalBalanceRecordSchema,
    r'TransactionRecord': TransactionRecordSchema,
    r'TaskProgressRecord': TaskProgressRecordSchema,
    r'LearningTopicRecord': LearningTopicRecordSchema,
    r'GrowthMilestoneRecord': GrowthMilestoneRecordSchema,
    r'PeriodSummaryRecord': PeriodSummaryRecordSchema,
    r'SaplingRecord': SaplingRecordSchema,
  },

  getId: _profileRecordGetId,
  getLinks: _profileRecordGetLinks,
  attach: _profileRecordAttach,
  version: '3.3.2',
);

int _profileRecordEstimateSize(
  ProfileRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accessory.length * 3;
  {
    final value = object.accountantSessionsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.bestDayKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.budgetRevisions;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[BudgetRevisionRecord]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += BudgetRevisionRecordSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.budgetSourceIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.coat.length * 3;
  {
    final value = object.dayKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.feedback;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.goalBalances;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[GoalBalanceRecord]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += GoalBalanceRecordSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.growthIncomeThresholds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final list = object.growthMilestones;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[GrowthMilestoneRecord]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += GrowthMilestoneRecordSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.growthSavingsThresholds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  bytesCount += 3 + object.incomeSource.length * 3;
  {
    final list = object.learningTopics;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[LearningTopicRecord]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += LearningTopicRecordSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.marketSessionsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.ownedAccessories;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.periodSummaries;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PeriodSummaryRecord]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += PeriodSummaryRecordSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  bytesCount += 3 + object.petName.length * 3;
  {
    final list = object.saplings;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[SaplingRecord]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += SaplingRecordSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.selectedGoalId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.taskProgress;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[TaskProgressRecord]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += TaskProgressRecordSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.transactions;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[TransactionRecord]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += TransactionRecordSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  return bytesCount;
}

void _profileRecordSerialize(
  ProfileRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accessory);
  writer.writeString(offsets[1], object.accountantSessionsJson);
  writer.writeLong(offsets[2], object.balance);
  writer.writeLong(offsets[3], object.bestDayIncome);
  writer.writeString(offsets[4], object.bestDayKey);
  writer.writeBool(offsets[5], object.budgetConfirmed);
  writer.writeLong(offsets[6], object.budgetExpectedIncome);
  writer.writeLong(offsets[7], object.budgetKept);
  writer.writeLong(offsets[8], object.budgetOpeningBalance);
  writer.writeObjectList<BudgetRevisionRecord>(
    offsets[9],
    allOffsets,
    BudgetRevisionRecordSchema.serialize,
    object.budgetRevisions,
  );
  writer.writeStringList(offsets[10], object.budgetSourceIds);
  writer.writeString(offsets[11], object.coat);
  writer.writeString(offsets[12], object.dayKey);
  writer.writeLong(offsets[13], object.energy);
  writer.writeString(offsets[14], object.feedback);
  writer.writeObjectList<GoalBalanceRecord>(
    offsets[15],
    allOffsets,
    GoalBalanceRecordSchema.serialize,
    object.goalBalances,
  );
  writer.writeBool(offsets[16], object.goalChoicesUnlocked);
  writer.writeLongList(offsets[17], object.growthIncomeThresholds);
  writer.writeObjectList<GrowthMilestoneRecord>(
    offsets[18],
    allOffsets,
    GrowthMilestoneRecordSchema.serialize,
    object.growthMilestones,
  );
  writer.writeLongList(offsets[19], object.growthSavingsThresholds);
  writer.writeLong(offsets[20], object.incomeAmount);
  writer.writeString(offsets[21], object.incomeSource);
  writer.writeDateTime(offsets[22], object.lastRewardAt);
  writer.writeObjectList<LearningTopicRecord>(
    offsets[23],
    allOffsets,
    LearningTopicRecordSchema.serialize,
    object.learningTopics,
  );
  writer.writeString(offsets[24], object.marketSessionsJson);
  writer.writeLong(offsets[25], object.mood);
  writer.writeStringList(offsets[26], object.ownedAccessories);
  writer.writeLong(offsets[27], object.period);
  writer.writeObjectList<PeriodSummaryRecord>(
    offsets[28],
    allOffsets,
    PeriodSummaryRecordSchema.serialize,
    object.periodSummaries,
  );
  writer.writeString(offsets[29], object.petName);
  writer.writeLong(offsets[30], object.plannedBalance);
  writer.writeLong(offsets[31], object.plannedGifts);
  writer.writeLong(offsets[32], object.plannedNeeds);
  writer.writeLong(offsets[33], object.plannedSavings);
  writer.writeLong(offsets[34], object.plannedWants);
  writer.writeObjectList<SaplingRecord>(
    offsets[35],
    allOffsets,
    SaplingRecordSchema.serialize,
    object.saplings,
  );
  writer.writeLong(offsets[36], object.satiety);
  writer.writeLong(offsets[37], object.savings);
  writer.writeLong(offsets[38], object.schemaVersion);
  writer.writeString(offsets[39], object.selectedGoalId);
  writer.writeLong(offsets[40], object.streak);
  writer.writeObjectList<TaskProgressRecord>(
    offsets[41],
    allOffsets,
    TaskProgressRecordSchema.serialize,
    object.taskProgress,
  );
  writer.writeObjectList<TransactionRecord>(
    offsets[42],
    allOffsets,
    TransactionRecordSchema.serialize,
    object.transactions,
  );
  writer.writeLong(offsets[43], object.unlockedGrowthStage);
  writer.writeLong(offsets[44], object.walkPeriod);
}

ProfileRecord _profileRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProfileRecord();
  object.accessory = reader.readString(offsets[0]);
  object.accountantSessionsJson = reader.readStringOrNull(offsets[1]);
  object.balance = reader.readLong(offsets[2]);
  object.bestDayIncome = reader.readLong(offsets[3]);
  object.bestDayKey = reader.readStringOrNull(offsets[4]);
  object.budgetConfirmed = reader.readBool(offsets[5]);
  object.budgetExpectedIncome = reader.readLong(offsets[6]);
  object.budgetKept = reader.readLong(offsets[7]);
  object.budgetOpeningBalance = reader.readLong(offsets[8]);
  object.budgetRevisions = reader.readObjectList<BudgetRevisionRecord>(
    offsets[9],
    BudgetRevisionRecordSchema.deserialize,
    allOffsets,
    BudgetRevisionRecord(),
  );
  object.budgetSourceIds = reader.readStringList(offsets[10]);
  object.coat = reader.readString(offsets[11]);
  object.dayKey = reader.readStringOrNull(offsets[12]);
  object.energy = reader.readLong(offsets[13]);
  object.feedback = reader.readStringOrNull(offsets[14]);
  object.goalBalances = reader.readObjectList<GoalBalanceRecord>(
    offsets[15],
    GoalBalanceRecordSchema.deserialize,
    allOffsets,
    GoalBalanceRecord(),
  );
  object.goalChoicesUnlocked = reader.readBoolOrNull(offsets[16]);
  object.growthIncomeThresholds = reader.readLongList(offsets[17]);
  object.growthMilestones = reader.readObjectList<GrowthMilestoneRecord>(
    offsets[18],
    GrowthMilestoneRecordSchema.deserialize,
    allOffsets,
    GrowthMilestoneRecord(),
  );
  object.growthSavingsThresholds = reader.readLongList(offsets[19]);
  object.id = id;
  object.incomeAmount = reader.readLong(offsets[20]);
  object.incomeSource = reader.readString(offsets[21]);
  object.lastRewardAt = reader.readDateTimeOrNull(offsets[22]);
  object.learningTopics = reader.readObjectList<LearningTopicRecord>(
    offsets[23],
    LearningTopicRecordSchema.deserialize,
    allOffsets,
    LearningTopicRecord(),
  );
  object.marketSessionsJson = reader.readStringOrNull(offsets[24]);
  object.mood = reader.readLong(offsets[25]);
  object.ownedAccessories = reader.readStringList(offsets[26]);
  object.period = reader.readLong(offsets[27]);
  object.periodSummaries = reader.readObjectList<PeriodSummaryRecord>(
    offsets[28],
    PeriodSummaryRecordSchema.deserialize,
    allOffsets,
    PeriodSummaryRecord(),
  );
  object.petName = reader.readString(offsets[29]);
  object.plannedBalance = reader.readLong(offsets[30]);
  object.plannedGifts = reader.readLong(offsets[31]);
  object.plannedNeeds = reader.readLong(offsets[32]);
  object.plannedSavings = reader.readLong(offsets[33]);
  object.plannedWants = reader.readLong(offsets[34]);
  object.saplings = reader.readObjectList<SaplingRecord>(
    offsets[35],
    SaplingRecordSchema.deserialize,
    allOffsets,
    SaplingRecord(),
  );
  object.satiety = reader.readLong(offsets[36]);
  object.savings = reader.readLong(offsets[37]);
  object.schemaVersion = reader.readLong(offsets[38]);
  object.selectedGoalId = reader.readStringOrNull(offsets[39]);
  object.streak = reader.readLong(offsets[40]);
  object.taskProgress = reader.readObjectList<TaskProgressRecord>(
    offsets[41],
    TaskProgressRecordSchema.deserialize,
    allOffsets,
    TaskProgressRecord(),
  );
  object.transactions = reader.readObjectList<TransactionRecord>(
    offsets[42],
    TransactionRecordSchema.deserialize,
    allOffsets,
    TransactionRecord(),
  );
  object.unlockedGrowthStage = reader.readLong(offsets[43]);
  object.walkPeriod = reader.readLong(offsets[44]);
  return object;
}

P _profileRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readObjectList<BudgetRevisionRecord>(
            offset,
            BudgetRevisionRecordSchema.deserialize,
            allOffsets,
            BudgetRevisionRecord(),
          ))
          as P;
    case 10:
      return (reader.readStringList(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readObjectList<GoalBalanceRecord>(
            offset,
            GoalBalanceRecordSchema.deserialize,
            allOffsets,
            GoalBalanceRecord(),
          ))
          as P;
    case 16:
      return (reader.readBoolOrNull(offset)) as P;
    case 17:
      return (reader.readLongList(offset)) as P;
    case 18:
      return (reader.readObjectList<GrowthMilestoneRecord>(
            offset,
            GrowthMilestoneRecordSchema.deserialize,
            allOffsets,
            GrowthMilestoneRecord(),
          ))
          as P;
    case 19:
      return (reader.readLongList(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 23:
      return (reader.readObjectList<LearningTopicRecord>(
            offset,
            LearningTopicRecordSchema.deserialize,
            allOffsets,
            LearningTopicRecord(),
          ))
          as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readLong(offset)) as P;
    case 26:
      return (reader.readStringList(offset)) as P;
    case 27:
      return (reader.readLong(offset)) as P;
    case 28:
      return (reader.readObjectList<PeriodSummaryRecord>(
            offset,
            PeriodSummaryRecordSchema.deserialize,
            allOffsets,
            PeriodSummaryRecord(),
          ))
          as P;
    case 29:
      return (reader.readString(offset)) as P;
    case 30:
      return (reader.readLong(offset)) as P;
    case 31:
      return (reader.readLong(offset)) as P;
    case 32:
      return (reader.readLong(offset)) as P;
    case 33:
      return (reader.readLong(offset)) as P;
    case 34:
      return (reader.readLong(offset)) as P;
    case 35:
      return (reader.readObjectList<SaplingRecord>(
            offset,
            SaplingRecordSchema.deserialize,
            allOffsets,
            SaplingRecord(),
          ))
          as P;
    case 36:
      return (reader.readLong(offset)) as P;
    case 37:
      return (reader.readLong(offset)) as P;
    case 38:
      return (reader.readLong(offset)) as P;
    case 39:
      return (reader.readStringOrNull(offset)) as P;
    case 40:
      return (reader.readLong(offset)) as P;
    case 41:
      return (reader.readObjectList<TaskProgressRecord>(
            offset,
            TaskProgressRecordSchema.deserialize,
            allOffsets,
            TaskProgressRecord(),
          ))
          as P;
    case 42:
      return (reader.readObjectList<TransactionRecord>(
            offset,
            TransactionRecordSchema.deserialize,
            allOffsets,
            TransactionRecord(),
          ))
          as P;
    case 43:
      return (reader.readLong(offset)) as P;
    case 44:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _profileRecordGetId(ProfileRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _profileRecordGetLinks(ProfileRecord object) {
  return [];
}

void _profileRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  ProfileRecord object,
) {
  object.id = id;
}

extension ProfileRecordQueryWhereSort
    on QueryBuilder<ProfileRecord, ProfileRecord, QWhere> {
  QueryBuilder<ProfileRecord, ProfileRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProfileRecordQueryWhere
    on QueryBuilder<ProfileRecord, ProfileRecord, QWhereClause> {
  QueryBuilder<ProfileRecord, ProfileRecord, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ProfileRecordQueryFilter
    on QueryBuilder<ProfileRecord, ProfileRecord, QFilterCondition> {
  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accessoryEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accessory',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accessoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accessory',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accessoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accessory',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accessoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accessory',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accessoryStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accessory',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accessoryEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accessory',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accessoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accessory',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accessoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accessory',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accessoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accessory', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accessoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accessory', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'accountantSessionsJson'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'accountantSessionsJson'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accountantSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountantSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountantSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountantSessionsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accountantSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accountantSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accountantSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accountantSessionsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountantSessionsJson', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  accountantSessionsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'accountantSessionsJson',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  balanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'balance', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  balanceGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'balance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  balanceLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'balance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  balanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'balance',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayIncomeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bestDayIncome', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayIncomeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bestDayIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayIncomeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bestDayIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayIncomeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bestDayIncome',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'bestDayKey'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'bestDayKey'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bestDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bestDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bestDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bestDayKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bestDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bestDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bestDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bestDayKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bestDayKey', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  bestDayKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bestDayKey', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetConfirmedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'budgetConfirmed', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetExpectedIncomeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'budgetExpectedIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetExpectedIncomeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'budgetExpectedIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetExpectedIncomeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'budgetExpectedIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetExpectedIncomeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'budgetExpectedIncome',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetKeptEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'budgetKept', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetKeptGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'budgetKept',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetKeptLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'budgetKept',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetKeptBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'budgetKept',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetOpeningBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'budgetOpeningBalance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetOpeningBalanceGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'budgetOpeningBalance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetOpeningBalanceLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'budgetOpeningBalance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetOpeningBalanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'budgetOpeningBalance',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetRevisionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'budgetRevisions'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetRevisionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'budgetRevisions'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetRevisionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'budgetRevisions', length, true, length, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetRevisionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'budgetRevisions', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetRevisionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'budgetRevisions', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetRevisionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'budgetRevisions', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetRevisionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'budgetRevisions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetRevisionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'budgetRevisions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'budgetSourceIds'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'budgetSourceIds'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'budgetSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'budgetSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'budgetSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'budgetSourceIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'budgetSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'budgetSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'budgetSourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'budgetSourceIds',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'budgetSourceIds', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'budgetSourceIds', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'budgetSourceIds', length, true, length, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'budgetSourceIds', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'budgetSourceIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'budgetSourceIds', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'budgetSourceIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetSourceIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'budgetSourceIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition> coatEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  coatGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  coatLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition> coatBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coat',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  coatStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  coatEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  coatContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition> coatMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coat',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  coatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coat', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  coatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'coat', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dayKey'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dayKey'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dayKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dayKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dayKey', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  dayKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dayKey', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  energyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'energy', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  energyGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'energy',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  energyLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'energy',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  energyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'energy',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'feedback'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'feedback'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'feedback',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'feedback',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'feedback', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  feedbackIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'feedback', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalBalancesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'goalBalances'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalBalancesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'goalBalances'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalBalancesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'goalBalances', length, true, length, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalBalancesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'goalBalances', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalBalancesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'goalBalances', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalBalancesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'goalBalances', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalBalancesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'goalBalances', length, include, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalBalancesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goalBalances',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalChoicesUnlockedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'goalChoicesUnlocked'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalChoicesUnlockedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'goalChoicesUnlocked'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalChoicesUnlockedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'goalChoicesUnlocked', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'growthIncomeThresholds'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'growthIncomeThresholds'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'growthIncomeThresholds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'growthIncomeThresholds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'growthIncomeThresholds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'growthIncomeThresholds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthIncomeThresholds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'growthIncomeThresholds', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthIncomeThresholds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthIncomeThresholds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthIncomeThresholds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthIncomeThresholdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthIncomeThresholds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthMilestonesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'growthMilestones'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthMilestonesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'growthMilestones'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthMilestonesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'growthMilestones', length, true, length, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthMilestonesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'growthMilestones', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthMilestonesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'growthMilestones', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthMilestonesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'growthMilestones', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthMilestonesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthMilestones',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthMilestonesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthMilestones',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'growthSavingsThresholds'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'growthSavingsThresholds'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'growthSavingsThresholds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'growthSavingsThresholds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'growthSavingsThresholds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'growthSavingsThresholds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthSavingsThresholds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'growthSavingsThresholds', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthSavingsThresholds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthSavingsThresholds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthSavingsThresholds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthSavingsThresholdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'growthSavingsThresholds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeAmountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'incomeAmount', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeAmountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'incomeAmount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeAmountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'incomeAmount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeAmountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'incomeAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeSourceEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'incomeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeSourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'incomeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeSourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'incomeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeSourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'incomeSource',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeSourceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'incomeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeSourceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'incomeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeSourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'incomeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeSourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'incomeSource',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'incomeSource', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  incomeSourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'incomeSource', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  lastRewardAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastRewardAt'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  lastRewardAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastRewardAt'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  lastRewardAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastRewardAt', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  lastRewardAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastRewardAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  lastRewardAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastRewardAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  lastRewardAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastRewardAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  learningTopicsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'learningTopics'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  learningTopicsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'learningTopics'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  learningTopicsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'learningTopics', length, true, length, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  learningTopicsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'learningTopics', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  learningTopicsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'learningTopics', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  learningTopicsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'learningTopics', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  learningTopicsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'learningTopics', length, include, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  learningTopicsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'learningTopics',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'marketSessionsJson'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'marketSessionsJson'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'marketSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'marketSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'marketSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'marketSessionsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'marketSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'marketSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'marketSessionsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'marketSessionsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'marketSessionsJson', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  marketSessionsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'marketSessionsJson', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition> moodEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mood', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  moodGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mood',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  moodLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mood',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition> moodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mood',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'ownedAccessories'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'ownedAccessories'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ownedAccessories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ownedAccessories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ownedAccessories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ownedAccessories',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'ownedAccessories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'ownedAccessories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'ownedAccessories',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'ownedAccessories',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ownedAccessories', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ownedAccessories', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'ownedAccessories', length, true, length, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'ownedAccessories', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'ownedAccessories', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'ownedAccessories', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ownedAccessories',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  ownedAccessoriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'ownedAccessories',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'period', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'period',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'period',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'period',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodSummariesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'periodSummaries'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodSummariesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'periodSummaries'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodSummariesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'periodSummaries', length, true, length, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodSummariesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'periodSummaries', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodSummariesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'periodSummaries', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodSummariesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'periodSummaries', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodSummariesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'periodSummaries',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodSummariesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'periodSummaries',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  petNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'petName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  petNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'petName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  petNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'petName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  petNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'petName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  petNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'petName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  petNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'petName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  petNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'petName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  petNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'petName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  petNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'petName', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  petNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'petName', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedBalance', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedBalanceGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedBalance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedBalanceLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedBalance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedBalanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedBalance',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedGiftsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedGifts', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedGiftsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedGifts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedGiftsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedGifts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedGiftsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedGifts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedNeedsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedNeeds', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedNeedsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedNeeds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedNeedsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedNeeds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedNeedsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedNeeds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedSavingsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedSavings', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedSavingsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedSavings',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedSavingsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedSavings',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedSavingsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedSavings',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedWantsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedWants', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedWantsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedWants',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedWantsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedWants',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  plannedWantsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedWants',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  saplingsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'saplings'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  saplingsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'saplings'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  saplingsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'saplings', length, true, length, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  saplingsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'saplings', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  saplingsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'saplings', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  saplingsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'saplings', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  saplingsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'saplings', length, include, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  saplingsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saplings',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  satietyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'satiety', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  satietyGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'satiety',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  satietyLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'satiety',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  satietyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'satiety',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  savingsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'savings', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  savingsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'savings',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  savingsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'savings',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  savingsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'savings',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  schemaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'schemaVersion', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  schemaVersionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'schemaVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  schemaVersionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'schemaVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  schemaVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'schemaVersion',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'selectedGoalId'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'selectedGoalId'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'selectedGoalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'selectedGoalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'selectedGoalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'selectedGoalId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'selectedGoalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'selectedGoalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'selectedGoalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'selectedGoalId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'selectedGoalId', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  selectedGoalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'selectedGoalId', value: ''),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  streakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'streak', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  streakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'streak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  streakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'streak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  streakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'streak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  taskProgressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'taskProgress'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  taskProgressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'taskProgress'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  taskProgressLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'taskProgress', length, true, length, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  taskProgressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'taskProgress', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  taskProgressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'taskProgress', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  taskProgressLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'taskProgress', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  taskProgressLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'taskProgress', length, include, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  taskProgressLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'taskProgress',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  transactionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'transactions'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  transactionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'transactions'),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  transactionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'transactions', length, true, length, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  transactionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'transactions', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  transactionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'transactions', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  transactionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'transactions', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  transactionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'transactions', length, include, 999999, true);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  transactionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'transactions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  unlockedGrowthStageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unlockedGrowthStage', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  unlockedGrowthStageGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unlockedGrowthStage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  unlockedGrowthStageLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unlockedGrowthStage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  unlockedGrowthStageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unlockedGrowthStage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  walkPeriodEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'walkPeriod', value: value),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  walkPeriodGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'walkPeriod',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  walkPeriodLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'walkPeriod',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  walkPeriodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'walkPeriod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ProfileRecordQueryObject
    on QueryBuilder<ProfileRecord, ProfileRecord, QFilterCondition> {
  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  budgetRevisionsElement(FilterQuery<BudgetRevisionRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'budgetRevisions');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  goalBalancesElement(FilterQuery<GoalBalanceRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'goalBalances');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  growthMilestonesElement(FilterQuery<GrowthMilestoneRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'growthMilestones');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  learningTopicsElement(FilterQuery<LearningTopicRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'learningTopics');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  periodSummariesElement(FilterQuery<PeriodSummaryRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'periodSummaries');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  saplingsElement(FilterQuery<SaplingRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'saplings');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  taskProgressElement(FilterQuery<TaskProgressRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'taskProgress');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterFilterCondition>
  transactionsElement(FilterQuery<TransactionRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'transactions');
    });
  }
}

extension ProfileRecordQueryLinks
    on QueryBuilder<ProfileRecord, ProfileRecord, QFilterCondition> {}

extension ProfileRecordQuerySortBy
    on QueryBuilder<ProfileRecord, ProfileRecord, QSortBy> {
  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByAccessory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessory', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByAccessoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessory', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByAccountantSessionsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountantSessionsJson', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByAccountantSessionsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountantSessionsJson', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByBestDayIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDayIncome', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByBestDayIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDayIncome', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByBestDayKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDayKey', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByBestDayKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDayKey', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByBudgetConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetConfirmed', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByBudgetConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetConfirmed', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByBudgetExpectedIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetExpectedIncome', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByBudgetExpectedIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetExpectedIncome', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByBudgetKept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetKept', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByBudgetKeptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetKept', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByBudgetOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetOpeningBalance', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByBudgetOpeningBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetOpeningBalance', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByCoat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coat', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByCoatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coat', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByDayKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayKey', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByDayKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayKey', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByEnergyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedback', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByFeedbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedback', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByGoalChoicesUnlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalChoicesUnlocked', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByGoalChoicesUnlockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalChoicesUnlocked', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByIncomeAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeAmount', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByIncomeAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeAmount', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByIncomeSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeSource', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByIncomeSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeSource', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByLastRewardAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRewardAt', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByLastRewardAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRewardAt', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByMarketSessionsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketSessionsJson', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByMarketSessionsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketSessionsJson', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByPetName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petName', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByPetNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petName', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByPlannedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedBalance', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByPlannedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedBalance', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByPlannedGifts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedGifts', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByPlannedGiftsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedGifts', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByPlannedNeeds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedNeeds', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByPlannedNeedsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedNeeds', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByPlannedSavings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedSavings', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByPlannedSavingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedSavings', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByPlannedWants() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedWants', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByPlannedWantsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedWants', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortBySatiety() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satiety', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortBySatietyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satiety', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortBySavings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savings', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortBySavingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savings', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortBySelectedGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedGoalId', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortBySelectedGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedGoalId', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByUnlockedGrowthStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedGrowthStage', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByUnlockedGrowthStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedGrowthStage', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> sortByWalkPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkPeriod', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  sortByWalkPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkPeriod', Sort.desc);
    });
  }
}

extension ProfileRecordQuerySortThenBy
    on QueryBuilder<ProfileRecord, ProfileRecord, QSortThenBy> {
  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByAccessory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessory', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByAccessoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessory', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByAccountantSessionsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountantSessionsJson', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByAccountantSessionsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountantSessionsJson', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByBestDayIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDayIncome', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByBestDayIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDayIncome', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByBestDayKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDayKey', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByBestDayKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDayKey', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByBudgetConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetConfirmed', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByBudgetConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetConfirmed', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByBudgetExpectedIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetExpectedIncome', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByBudgetExpectedIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetExpectedIncome', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByBudgetKept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetKept', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByBudgetKeptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetKept', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByBudgetOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetOpeningBalance', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByBudgetOpeningBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetOpeningBalance', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByCoat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coat', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByCoatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coat', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByDayKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayKey', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByDayKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayKey', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByEnergyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedback', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByFeedbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedback', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByGoalChoicesUnlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalChoicesUnlocked', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByGoalChoicesUnlockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalChoicesUnlocked', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByIncomeAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeAmount', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByIncomeAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeAmount', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByIncomeSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeSource', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByIncomeSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeSource', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByLastRewardAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRewardAt', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByLastRewardAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRewardAt', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByMarketSessionsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketSessionsJson', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByMarketSessionsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketSessionsJson', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByPetName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petName', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByPetNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'petName', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByPlannedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedBalance', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByPlannedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedBalance', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByPlannedGifts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedGifts', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByPlannedGiftsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedGifts', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByPlannedNeeds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedNeeds', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByPlannedNeedsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedNeeds', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByPlannedSavings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedSavings', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByPlannedSavingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedSavings', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByPlannedWants() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedWants', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByPlannedWantsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedWants', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenBySatiety() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satiety', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenBySatietyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'satiety', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenBySavings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savings', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenBySavingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savings', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenBySelectedGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedGoalId', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenBySelectedGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedGoalId', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByUnlockedGrowthStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedGrowthStage', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByUnlockedGrowthStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedGrowthStage', Sort.desc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy> thenByWalkPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkPeriod', Sort.asc);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QAfterSortBy>
  thenByWalkPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walkPeriod', Sort.desc);
    });
  }
}

extension ProfileRecordQueryWhereDistinct
    on QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> {
  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByAccessory({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accessory', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByAccountantSessionsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'accountantSessionsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balance');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByBestDayIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestDayIncome');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByBestDayKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestDayKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByBudgetConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetConfirmed');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByBudgetExpectedIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetExpectedIncome');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByBudgetKept() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetKept');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByBudgetOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetOpeningBalance');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByBudgetSourceIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetSourceIds');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByCoat({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByDayKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energy');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByFeedback({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feedback', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByGoalChoicesUnlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalChoicesUnlocked');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByGrowthIncomeThresholds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'growthIncomeThresholds');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByGrowthSavingsThresholds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'growthSavingsThresholds');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByIncomeAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incomeAmount');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByIncomeSource({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incomeSource', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByLastRewardAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastRewardAt');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByMarketSessionsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'marketSessionsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mood');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByOwnedAccessories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownedAccessories');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'period');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByPetName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'petName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByPlannedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedBalance');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByPlannedGifts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedGifts');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByPlannedNeeds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedNeeds');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByPlannedSavings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedSavings');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByPlannedWants() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedWants');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctBySatiety() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'satiety');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctBySavings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savings');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schemaVersion');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctBySelectedGoalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'selectedGoalId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streak');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByUnlockedGrowthStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockedGrowthStage');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByWalkPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walkPeriod');
    });
  }
}

extension ProfileRecordQueryProperty
    on QueryBuilder<ProfileRecord, ProfileRecord, QQueryProperty> {
  QueryBuilder<ProfileRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProfileRecord, String, QQueryOperations> accessoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accessory');
    });
  }

  QueryBuilder<ProfileRecord, String?, QQueryOperations>
  accountantSessionsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountantSessionsJson');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balance');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> bestDayIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestDayIncome');
    });
  }

  QueryBuilder<ProfileRecord, String?, QQueryOperations> bestDayKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestDayKey');
    });
  }

  QueryBuilder<ProfileRecord, bool, QQueryOperations>
  budgetConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetConfirmed');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations>
  budgetExpectedIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetExpectedIncome');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> budgetKeptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetKept');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations>
  budgetOpeningBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetOpeningBalance');
    });
  }

  QueryBuilder<ProfileRecord, List<BudgetRevisionRecord>?, QQueryOperations>
  budgetRevisionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetRevisions');
    });
  }

  QueryBuilder<ProfileRecord, List<String>?, QQueryOperations>
  budgetSourceIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetSourceIds');
    });
  }

  QueryBuilder<ProfileRecord, String, QQueryOperations> coatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coat');
    });
  }

  QueryBuilder<ProfileRecord, String?, QQueryOperations> dayKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayKey');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> energyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energy');
    });
  }

  QueryBuilder<ProfileRecord, String?, QQueryOperations> feedbackProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feedback');
    });
  }

  QueryBuilder<ProfileRecord, List<GoalBalanceRecord>?, QQueryOperations>
  goalBalancesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalBalances');
    });
  }

  QueryBuilder<ProfileRecord, bool?, QQueryOperations>
  goalChoicesUnlockedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalChoicesUnlocked');
    });
  }

  QueryBuilder<ProfileRecord, List<int>?, QQueryOperations>
  growthIncomeThresholdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'growthIncomeThresholds');
    });
  }

  QueryBuilder<ProfileRecord, List<GrowthMilestoneRecord>?, QQueryOperations>
  growthMilestonesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'growthMilestones');
    });
  }

  QueryBuilder<ProfileRecord, List<int>?, QQueryOperations>
  growthSavingsThresholdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'growthSavingsThresholds');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> incomeAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incomeAmount');
    });
  }

  QueryBuilder<ProfileRecord, String, QQueryOperations> incomeSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incomeSource');
    });
  }

  QueryBuilder<ProfileRecord, DateTime?, QQueryOperations>
  lastRewardAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastRewardAt');
    });
  }

  QueryBuilder<ProfileRecord, List<LearningTopicRecord>?, QQueryOperations>
  learningTopicsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'learningTopics');
    });
  }

  QueryBuilder<ProfileRecord, String?, QQueryOperations>
  marketSessionsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'marketSessionsJson');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> moodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mood');
    });
  }

  QueryBuilder<ProfileRecord, List<String>?, QQueryOperations>
  ownedAccessoriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownedAccessories');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> periodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'period');
    });
  }

  QueryBuilder<ProfileRecord, List<PeriodSummaryRecord>?, QQueryOperations>
  periodSummariesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodSummaries');
    });
  }

  QueryBuilder<ProfileRecord, String, QQueryOperations> petNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'petName');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> plannedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedBalance');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> plannedGiftsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedGifts');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> plannedNeedsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedNeeds');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> plannedSavingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedSavings');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> plannedWantsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedWants');
    });
  }

  QueryBuilder<ProfileRecord, List<SaplingRecord>?, QQueryOperations>
  saplingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saplings');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> satietyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'satiety');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> savingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savings');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> schemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schemaVersion');
    });
  }

  QueryBuilder<ProfileRecord, String?, QQueryOperations>
  selectedGoalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedGoalId');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> streakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streak');
    });
  }

  QueryBuilder<ProfileRecord, List<TaskProgressRecord>?, QQueryOperations>
  taskProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskProgress');
    });
  }

  QueryBuilder<ProfileRecord, List<TransactionRecord>?, QQueryOperations>
  transactionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transactions');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations>
  unlockedGrowthStageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedGrowthStage');
    });
  }

  QueryBuilder<ProfileRecord, int, QQueryOperations> walkPeriodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walkPeriod');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const GoalBalanceRecordSchema = Schema(
  name: r'GoalBalanceRecord',
  id: 8865324255492262897,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.long),
    r'goalId': PropertySchema(id: 1, name: r'goalId', type: IsarType.string),
  },

  estimateSize: _goalBalanceRecordEstimateSize,
  serialize: _goalBalanceRecordSerialize,
  deserialize: _goalBalanceRecordDeserialize,
  deserializeProp: _goalBalanceRecordDeserializeProp,
);

int _goalBalanceRecordEstimateSize(
  GoalBalanceRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.goalId.length * 3;
  return bytesCount;
}

void _goalBalanceRecordSerialize(
  GoalBalanceRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeString(offsets[1], object.goalId);
}

GoalBalanceRecord _goalBalanceRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GoalBalanceRecord();
  object.amount = reader.readLong(offsets[0]);
  object.goalId = reader.readString(offsets[1]);
  return object;
}

P _goalBalanceRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension GoalBalanceRecordQueryFilter
    on QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QFilterCondition> {
  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  amountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'amount', value: value),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  amountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  amountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  amountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  goalIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'goalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  goalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'goalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  goalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'goalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  goalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'goalId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  goalIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'goalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  goalIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'goalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  goalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'goalId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  goalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'goalId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  goalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'goalId', value: ''),
      );
    });
  }

  QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QAfterFilterCondition>
  goalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'goalId', value: ''),
      );
    });
  }
}

extension GoalBalanceRecordQueryObject
    on QueryBuilder<GoalBalanceRecord, GoalBalanceRecord, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const BudgetRevisionRecordSchema = Schema(
  name: r'BudgetRevisionRecord',
  id: -6063726691452142431,
  properties: {
    r'available': PropertySchema(
      id: 0,
      name: r'available',
      type: IsarType.long,
    ),
    r'expectedIncome': PropertySchema(
      id: 1,
      name: r'expectedIncome',
      type: IsarType.long,
    ),
    r'gifts': PropertySchema(id: 2, name: r'gifts', type: IsarType.long),
    r'kept': PropertySchema(id: 3, name: r'kept', type: IsarType.long),
    r'needs': PropertySchema(id: 4, name: r'needs', type: IsarType.long),
    r'openingBalance': PropertySchema(
      id: 5,
      name: r'openingBalance',
      type: IsarType.long,
    ),
    r'period': PropertySchema(id: 6, name: r'period', type: IsarType.long),
    r'savings': PropertySchema(id: 7, name: r'savings', type: IsarType.long),
    r'sourceIds': PropertySchema(
      id: 8,
      name: r'sourceIds',
      type: IsarType.stringList,
    ),
    r'wants': PropertySchema(id: 9, name: r'wants', type: IsarType.long),
  },

  estimateSize: _budgetRevisionRecordEstimateSize,
  serialize: _budgetRevisionRecordSerialize,
  deserialize: _budgetRevisionRecordDeserialize,
  deserializeProp: _budgetRevisionRecordDeserializeProp,
);

int _budgetRevisionRecordEstimateSize(
  BudgetRevisionRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.sourceIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _budgetRevisionRecordSerialize(
  BudgetRevisionRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.available);
  writer.writeLong(offsets[1], object.expectedIncome);
  writer.writeLong(offsets[2], object.gifts);
  writer.writeLong(offsets[3], object.kept);
  writer.writeLong(offsets[4], object.needs);
  writer.writeLong(offsets[5], object.openingBalance);
  writer.writeLong(offsets[6], object.period);
  writer.writeLong(offsets[7], object.savings);
  writer.writeStringList(offsets[8], object.sourceIds);
  writer.writeLong(offsets[9], object.wants);
}

BudgetRevisionRecord _budgetRevisionRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetRevisionRecord();
  object.available = reader.readLong(offsets[0]);
  object.expectedIncome = reader.readLong(offsets[1]);
  object.gifts = reader.readLong(offsets[2]);
  object.kept = reader.readLong(offsets[3]);
  object.needs = reader.readLong(offsets[4]);
  object.openingBalance = reader.readLong(offsets[5]);
  object.period = reader.readLong(offsets[6]);
  object.savings = reader.readLong(offsets[7]);
  object.sourceIds = reader.readStringList(offsets[8]);
  object.wants = reader.readLong(offsets[9]);
  return object;
}

P _budgetRevisionRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readStringList(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension BudgetRevisionRecordQueryFilter
    on
        QueryBuilder<
          BudgetRevisionRecord,
          BudgetRevisionRecord,
          QFilterCondition
        > {
  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  availableEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'available', value: value),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  availableGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'available',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  availableLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'available',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  availableBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'available',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  expectedIncomeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'expectedIncome', value: value),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  expectedIncomeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'expectedIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  expectedIncomeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'expectedIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  expectedIncomeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'expectedIncome',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  giftsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gifts', value: value),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  giftsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gifts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  giftsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gifts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  giftsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gifts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  keptEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'kept', value: value),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  keptGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'kept',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  keptLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'kept',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  keptBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kept',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  needsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'needs', value: value),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  needsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'needs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  needsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'needs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  needsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'needs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  openingBalanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'openingBalance', value: value),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  openingBalanceGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'openingBalance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  openingBalanceLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'openingBalance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  openingBalanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'openingBalance',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  periodEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'period', value: value),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  periodGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'period',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  periodLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'period',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  periodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'period',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  savingsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'savings', value: value),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  savingsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'savings',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  savingsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'savings',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  savingsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'savings',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sourceIds'),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sourceIds'),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sourceIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sourceIds',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceIds', value: ''),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceIds', value: ''),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceIds', length, true, length, true);
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceIds', 0, true, 0, true);
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceIds', 0, true, length, include);
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceIds', length, include, 999999, true);
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  sourceIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourceIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  wantsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wants', value: value),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  wantsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'wants',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  wantsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'wants',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BudgetRevisionRecord,
    BudgetRevisionRecord,
    QAfterFilterCondition
  >
  wantsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'wants',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension BudgetRevisionRecordQueryObject
    on
        QueryBuilder<
          BudgetRevisionRecord,
          BudgetRevisionRecord,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TransactionRecordSchema = Schema(
  name: r'TransactionRecord',
  id: 5251947889243599499,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.long),
    r'balanceAfter': PropertySchema(
      id: 1,
      name: r'balanceAfter',
      type: IsarType.long,
    ),
    r'baseReward': PropertySchema(
      id: 2,
      name: r'baseReward',
      type: IsarType.long,
    ),
    r'commandId': PropertySchema(
      id: 3,
      name: r'commandId',
      type: IsarType.string,
    ),
    r'kind': PropertySchema(id: 4, name: r'kind', type: IsarType.string),
    r'label': PropertySchema(id: 5, name: r'label', type: IsarType.string),
    r'moodAfter': PropertySchema(
      id: 6,
      name: r'moodAfter',
      type: IsarType.long,
    ),
    r'period': PropertySchema(id: 7, name: r'period', type: IsarType.long),
    r'referenceId': PropertySchema(
      id: 8,
      name: r'referenceId',
      type: IsarType.string,
    ),
    r'satietyAfter': PropertySchema(
      id: 9,
      name: r'satietyAfter',
      type: IsarType.long,
    ),
    r'savingsAfter': PropertySchema(
      id: 10,
      name: r'savingsAfter',
      type: IsarType.long,
    ),
    r'startEnergy': PropertySchema(
      id: 11,
      name: r'startEnergy',
      type: IsarType.long,
    ),
    r'startMood': PropertySchema(
      id: 12,
      name: r'startMood',
      type: IsarType.long,
    ),
    r'startSatiety': PropertySchema(
      id: 13,
      name: r'startSatiety',
      type: IsarType.long,
    ),
  },

  estimateSize: _transactionRecordEstimateSize,
  serialize: _transactionRecordSerialize,
  deserialize: _transactionRecordDeserialize,
  deserializeProp: _transactionRecordDeserializeProp,
);

int _transactionRecordEstimateSize(
  TransactionRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.commandId.length * 3;
  bytesCount += 3 + object.kind.length * 3;
  bytesCount += 3 + object.label.length * 3;
  {
    final value = object.referenceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _transactionRecordSerialize(
  TransactionRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amount);
  writer.writeLong(offsets[1], object.balanceAfter);
  writer.writeLong(offsets[2], object.baseReward);
  writer.writeString(offsets[3], object.commandId);
  writer.writeString(offsets[4], object.kind);
  writer.writeString(offsets[5], object.label);
  writer.writeLong(offsets[6], object.moodAfter);
  writer.writeLong(offsets[7], object.period);
  writer.writeString(offsets[8], object.referenceId);
  writer.writeLong(offsets[9], object.satietyAfter);
  writer.writeLong(offsets[10], object.savingsAfter);
  writer.writeLong(offsets[11], object.startEnergy);
  writer.writeLong(offsets[12], object.startMood);
  writer.writeLong(offsets[13], object.startSatiety);
}

TransactionRecord _transactionRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransactionRecord();
  object.amount = reader.readLong(offsets[0]);
  object.balanceAfter = reader.readLong(offsets[1]);
  object.baseReward = reader.readLongOrNull(offsets[2]);
  object.commandId = reader.readString(offsets[3]);
  object.kind = reader.readString(offsets[4]);
  object.label = reader.readString(offsets[5]);
  object.moodAfter = reader.readLong(offsets[6]);
  object.period = reader.readLong(offsets[7]);
  object.referenceId = reader.readStringOrNull(offsets[8]);
  object.satietyAfter = reader.readLong(offsets[9]);
  object.savingsAfter = reader.readLong(offsets[10]);
  object.startEnergy = reader.readLongOrNull(offsets[11]);
  object.startMood = reader.readLongOrNull(offsets[12]);
  object.startSatiety = reader.readLongOrNull(offsets[13]);
  return object;
}

P _transactionRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TransactionRecordQueryFilter
    on QueryBuilder<TransactionRecord, TransactionRecord, QFilterCondition> {
  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  amountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'amount', value: value),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  amountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  amountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  amountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  balanceAfterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'balanceAfter', value: value),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  balanceAfterGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'balanceAfter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  balanceAfterLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'balanceAfter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  balanceAfterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'balanceAfter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  baseRewardIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'baseReward'),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  baseRewardIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'baseReward'),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  baseRewardEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'baseReward', value: value),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  baseRewardGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'baseReward',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  baseRewardLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'baseReward',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  baseRewardBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'baseReward',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  commandIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  commandIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  commandIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  commandIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'commandId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  commandIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  commandIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  commandIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'commandId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  commandIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'commandId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  commandIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'commandId', value: ''),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  commandIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'commandId', value: ''),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  kindEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'kind',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  kindGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'kind',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  kindLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'kind',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  kindBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kind',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  kindStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'kind',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  kindEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'kind',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  kindContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'kind',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  kindMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'kind',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  kindIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'kind', value: ''),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  kindIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'kind', value: ''),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  labelEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'label',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  labelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  labelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  labelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  labelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'label',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'label', value: ''),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'label', value: ''),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  moodAfterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'moodAfter', value: value),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  moodAfterGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'moodAfter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  moodAfterLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'moodAfter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  moodAfterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'moodAfter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  periodEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'period', value: value),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  periodGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'period',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  periodLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'period',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  periodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'period',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'referenceId'),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'referenceId'),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'referenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'referenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'referenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'referenceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'referenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'referenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'referenceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'referenceId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'referenceId', value: ''),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  referenceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'referenceId', value: ''),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  satietyAfterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'satietyAfter', value: value),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  satietyAfterGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'satietyAfter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  satietyAfterLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'satietyAfter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  satietyAfterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'satietyAfter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  savingsAfterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'savingsAfter', value: value),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  savingsAfterGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'savingsAfter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  savingsAfterLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'savingsAfter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  savingsAfterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'savingsAfter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startEnergyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startEnergy'),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startEnergyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startEnergy'),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startEnergyEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startEnergy', value: value),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startEnergyGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startEnergy',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startEnergyLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startEnergy',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startEnergyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startEnergy',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startMoodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startMood'),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startMoodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startMood'),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startMoodEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startMood', value: value),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startMoodGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startMood',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startMoodLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startMood',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startMoodBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startMood',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startSatietyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startSatiety'),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startSatietyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startSatiety'),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startSatietyEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startSatiety', value: value),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startSatietyGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startSatiety',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startSatietyLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startSatiety',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionRecord, TransactionRecord, QAfterFilterCondition>
  startSatietyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startSatiety',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TransactionRecordQueryObject
    on QueryBuilder<TransactionRecord, TransactionRecord, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TaskProgressRecordSchema = Schema(
  name: r'TaskProgressRecord',
  id: -1994117272746731422,
  properties: {
    r'attempts': PropertySchema(id: 0, name: r'attempts', type: IsarType.long),
    r'completed': PropertySchema(
      id: 1,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'feedback': PropertySchema(
      id: 2,
      name: r'feedback',
      type: IsarType.string,
    ),
    r'hintUsed': PropertySchema(id: 3, name: r'hintUsed', type: IsarType.bool),
    r'practiceAttempts': PropertySchema(
      id: 4,
      name: r'practiceAttempts',
      type: IsarType.long,
    ),
    r'reviewed': PropertySchema(id: 5, name: r'reviewed', type: IsarType.bool),
    r'solutionShown': PropertySchema(
      id: 6,
      name: r'solutionShown',
      type: IsarType.bool,
    ),
    r'taskId': PropertySchema(id: 7, name: r'taskId', type: IsarType.string),
  },

  estimateSize: _taskProgressRecordEstimateSize,
  serialize: _taskProgressRecordSerialize,
  deserialize: _taskProgressRecordDeserialize,
  deserializeProp: _taskProgressRecordDeserializeProp,
);

int _taskProgressRecordEstimateSize(
  TaskProgressRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.feedback.length * 3;
  bytesCount += 3 + object.taskId.length * 3;
  return bytesCount;
}

void _taskProgressRecordSerialize(
  TaskProgressRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attempts);
  writer.writeBool(offsets[1], object.completed);
  writer.writeString(offsets[2], object.feedback);
  writer.writeBool(offsets[3], object.hintUsed);
  writer.writeLong(offsets[4], object.practiceAttempts);
  writer.writeBool(offsets[5], object.reviewed);
  writer.writeBool(offsets[6], object.solutionShown);
  writer.writeString(offsets[7], object.taskId);
}

TaskProgressRecord _taskProgressRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskProgressRecord();
  object.attempts = reader.readLong(offsets[0]);
  object.completed = reader.readBool(offsets[1]);
  object.feedback = reader.readString(offsets[2]);
  object.hintUsed = reader.readBool(offsets[3]);
  object.practiceAttempts = reader.readLong(offsets[4]);
  object.reviewed = reader.readBool(offsets[5]);
  object.solutionShown = reader.readBool(offsets[6]);
  object.taskId = reader.readString(offsets[7]);
  return object;
}

P _taskProgressRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TaskProgressRecordQueryFilter
    on QueryBuilder<TaskProgressRecord, TaskProgressRecord, QFilterCondition> {
  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  attemptsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'attempts', value: value),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  attemptsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'attempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  attemptsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'attempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  attemptsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'attempts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  completedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completed', value: value),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  feedbackEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  feedbackGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  feedbackLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  feedbackBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'feedback',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  feedbackStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  feedbackEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  feedbackContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'feedback',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  feedbackMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'feedback',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  feedbackIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'feedback', value: ''),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  feedbackIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'feedback', value: ''),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  hintUsedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hintUsed', value: value),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  practiceAttemptsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'practiceAttempts', value: value),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  practiceAttemptsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'practiceAttempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  practiceAttemptsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'practiceAttempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  practiceAttemptsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'practiceAttempts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  reviewedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reviewed', value: value),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  solutionShownEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'solutionShown', value: value),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  taskIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'taskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  taskIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'taskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  taskIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'taskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  taskIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'taskId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  taskIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'taskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  taskIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'taskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  taskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'taskId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  taskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'taskId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  taskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taskId', value: ''),
      );
    });
  }

  QueryBuilder<TaskProgressRecord, TaskProgressRecord, QAfterFilterCondition>
  taskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'taskId', value: ''),
      );
    });
  }
}

extension TaskProgressRecordQueryObject
    on QueryBuilder<TaskProgressRecord, TaskProgressRecord, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LearningTopicRecordSchema = Schema(
  name: r'LearningTopicRecord',
  id: -3700948664942419368,
  properties: {
    r'cleanStreak': PropertySchema(
      id: 0,
      name: r'cleanStreak',
      type: IsarType.long,
    ),
    r'difficulty': PropertySchema(
      id: 1,
      name: r'difficulty',
      type: IsarType.string,
    ),
    r'downgradeOffered': PropertySchema(
      id: 2,
      name: r'downgradeOffered',
      type: IsarType.bool,
    ),
    r'downgradePending': PropertySchema(
      id: 3,
      name: r'downgradePending',
      type: IsarType.bool,
    ),
    r'helpStreak': PropertySchema(
      id: 4,
      name: r'helpStreak',
      type: IsarType.long,
    ),
    r'topic': PropertySchema(id: 5, name: r'topic', type: IsarType.string),
  },

  estimateSize: _learningTopicRecordEstimateSize,
  serialize: _learningTopicRecordSerialize,
  deserialize: _learningTopicRecordDeserialize,
  deserializeProp: _learningTopicRecordDeserializeProp,
);

int _learningTopicRecordEstimateSize(
  LearningTopicRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.difficulty.length * 3;
  bytesCount += 3 + object.topic.length * 3;
  return bytesCount;
}

void _learningTopicRecordSerialize(
  LearningTopicRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cleanStreak);
  writer.writeString(offsets[1], object.difficulty);
  writer.writeBool(offsets[2], object.downgradeOffered);
  writer.writeBool(offsets[3], object.downgradePending);
  writer.writeLong(offsets[4], object.helpStreak);
  writer.writeString(offsets[5], object.topic);
}

LearningTopicRecord _learningTopicRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LearningTopicRecord();
  object.cleanStreak = reader.readLong(offsets[0]);
  object.difficulty = reader.readString(offsets[1]);
  object.downgradeOffered = reader.readBool(offsets[2]);
  object.downgradePending = reader.readBool(offsets[3]);
  object.helpStreak = reader.readLong(offsets[4]);
  object.topic = reader.readString(offsets[5]);
  return object;
}

P _learningTopicRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LearningTopicRecordQueryFilter
    on
        QueryBuilder<
          LearningTopicRecord,
          LearningTopicRecord,
          QFilterCondition
        > {
  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  cleanStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cleanStreak', value: value),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  cleanStreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cleanStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  cleanStreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cleanStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  cleanStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cleanStreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  difficultyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'difficulty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  difficultyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'difficulty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  difficultyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'difficulty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  difficultyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'difficulty',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  difficultyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'difficulty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  difficultyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'difficulty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  difficultyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'difficulty',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  difficultyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'difficulty',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  difficultyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'difficulty', value: ''),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  difficultyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'difficulty', value: ''),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  downgradeOfferedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downgradeOffered', value: value),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  downgradePendingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downgradePending', value: value),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  helpStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'helpStreak', value: value),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  helpStreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'helpStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  helpStreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'helpStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  helpStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'helpStreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  topicEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'topic',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  topicGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'topic',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  topicLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'topic',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  topicBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'topic',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  topicStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'topic',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  topicEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'topic',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  topicContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'topic',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  topicMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'topic',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  topicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'topic', value: ''),
      );
    });
  }

  QueryBuilder<LearningTopicRecord, LearningTopicRecord, QAfterFilterCondition>
  topicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'topic', value: ''),
      );
    });
  }
}

extension LearningTopicRecordQueryObject
    on
        QueryBuilder<
          LearningTopicRecord,
          LearningTopicRecord,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const GrowthMilestoneRecordSchema = Schema(
  name: r'GrowthMilestoneRecord',
  id: -5482434417089184682,
  properties: {
    r'bestDayIncome': PropertySchema(
      id: 0,
      name: r'bestDayIncome',
      type: IsarType.long,
    ),
    r'dayKey': PropertySchema(id: 1, name: r'dayKey', type: IsarType.string),
    r'incomeThreshold': PropertySchema(
      id: 2,
      name: r'incomeThreshold',
      type: IsarType.long,
    ),
    r'savingsAtUnlock': PropertySchema(
      id: 3,
      name: r'savingsAtUnlock',
      type: IsarType.long,
    ),
    r'savingsThreshold': PropertySchema(
      id: 4,
      name: r'savingsThreshold',
      type: IsarType.long,
    ),
    r'stage': PropertySchema(id: 5, name: r'stage', type: IsarType.long),
  },

  estimateSize: _growthMilestoneRecordEstimateSize,
  serialize: _growthMilestoneRecordSerialize,
  deserialize: _growthMilestoneRecordDeserialize,
  deserializeProp: _growthMilestoneRecordDeserializeProp,
);

int _growthMilestoneRecordEstimateSize(
  GrowthMilestoneRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dayKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _growthMilestoneRecordSerialize(
  GrowthMilestoneRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bestDayIncome);
  writer.writeString(offsets[1], object.dayKey);
  writer.writeLong(offsets[2], object.incomeThreshold);
  writer.writeLong(offsets[3], object.savingsAtUnlock);
  writer.writeLong(offsets[4], object.savingsThreshold);
  writer.writeLong(offsets[5], object.stage);
}

GrowthMilestoneRecord _growthMilestoneRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GrowthMilestoneRecord();
  object.bestDayIncome = reader.readLong(offsets[0]);
  object.dayKey = reader.readStringOrNull(offsets[1]);
  object.incomeThreshold = reader.readLong(offsets[2]);
  object.savingsAtUnlock = reader.readLong(offsets[3]);
  object.savingsThreshold = reader.readLong(offsets[4]);
  object.stage = reader.readLong(offsets[5]);
  return object;
}

P _growthMilestoneRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension GrowthMilestoneRecordQueryFilter
    on
        QueryBuilder<
          GrowthMilestoneRecord,
          GrowthMilestoneRecord,
          QFilterCondition
        > {
  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  bestDayIncomeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bestDayIncome', value: value),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  bestDayIncomeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bestDayIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  bestDayIncomeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bestDayIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  bestDayIncomeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bestDayIncome',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dayKey'),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dayKey'),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dayKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dayKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dayKey', value: ''),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  dayKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dayKey', value: ''),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  incomeThresholdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'incomeThreshold', value: value),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  incomeThresholdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'incomeThreshold',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  incomeThresholdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'incomeThreshold',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  incomeThresholdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'incomeThreshold',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  savingsAtUnlockEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'savingsAtUnlock', value: value),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  savingsAtUnlockGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'savingsAtUnlock',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  savingsAtUnlockLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'savingsAtUnlock',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  savingsAtUnlockBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'savingsAtUnlock',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  savingsThresholdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'savingsThreshold', value: value),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  savingsThresholdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'savingsThreshold',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  savingsThresholdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'savingsThreshold',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  savingsThresholdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'savingsThreshold',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  stageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stage', value: value),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  stageGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  stageLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    GrowthMilestoneRecord,
    GrowthMilestoneRecord,
    QAfterFilterCondition
  >
  stageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GrowthMilestoneRecordQueryObject
    on
        QueryBuilder<
          GrowthMilestoneRecord,
          GrowthMilestoneRecord,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SaplingRecordSchema = Schema(
  name: r'SaplingRecord',
  id: 4385280109298344912,
  properties: {
    r'definitionId': PropertySchema(
      id: 0,
      name: r'definitionId',
      type: IsarType.string,
    ),
    r'plantedDayKey': PropertySchema(
      id: 1,
      name: r'plantedDayKey',
      type: IsarType.string,
    ),
    r'plantedPeriod': PropertySchema(
      id: 2,
      name: r'plantedPeriod',
      type: IsarType.long,
    ),
    r'saplingId': PropertySchema(
      id: 3,
      name: r'saplingId',
      type: IsarType.string,
    ),
  },

  estimateSize: _saplingRecordEstimateSize,
  serialize: _saplingRecordSerialize,
  deserialize: _saplingRecordDeserialize,
  deserializeProp: _saplingRecordDeserializeProp,
);

int _saplingRecordEstimateSize(
  SaplingRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.definitionId.length * 3;
  {
    final value = object.plantedDayKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.saplingId.length * 3;
  return bytesCount;
}

void _saplingRecordSerialize(
  SaplingRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.definitionId);
  writer.writeString(offsets[1], object.plantedDayKey);
  writer.writeLong(offsets[2], object.plantedPeriod);
  writer.writeString(offsets[3], object.saplingId);
}

SaplingRecord _saplingRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SaplingRecord();
  object.definitionId = reader.readString(offsets[0]);
  object.plantedDayKey = reader.readStringOrNull(offsets[1]);
  object.plantedPeriod = reader.readLong(offsets[2]);
  object.saplingId = reader.readString(offsets[3]);
  return object;
}

P _saplingRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SaplingRecordQueryFilter
    on QueryBuilder<SaplingRecord, SaplingRecord, QFilterCondition> {
  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  definitionIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'definitionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  definitionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'definitionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  definitionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'definitionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  definitionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'definitionId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  definitionIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'definitionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  definitionIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'definitionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  definitionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'definitionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  definitionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'definitionId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  definitionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'definitionId', value: ''),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  definitionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'definitionId', value: ''),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'plantedDayKey'),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'plantedDayKey'),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'plantedDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plantedDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plantedDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plantedDayKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'plantedDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'plantedDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'plantedDayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'plantedDayKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plantedDayKey', value: ''),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedDayKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'plantedDayKey', value: ''),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedPeriodEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plantedPeriod', value: value),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedPeriodGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plantedPeriod',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedPeriodLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plantedPeriod',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  plantedPeriodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plantedPeriod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  saplingIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'saplingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  saplingIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'saplingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  saplingIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'saplingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  saplingIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'saplingId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  saplingIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'saplingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  saplingIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'saplingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  saplingIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'saplingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  saplingIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'saplingId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  saplingIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'saplingId', value: ''),
      );
    });
  }

  QueryBuilder<SaplingRecord, SaplingRecord, QAfterFilterCondition>
  saplingIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'saplingId', value: ''),
      );
    });
  }
}

extension SaplingRecordQueryObject
    on QueryBuilder<SaplingRecord, SaplingRecord, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PeriodSummaryRecordSchema = Schema(
  name: r'PeriodSummaryRecord',
  id: -459405569969481046,
  properties: {
    r'actualGifts': PropertySchema(
      id: 0,
      name: r'actualGifts',
      type: IsarType.long,
    ),
    r'actualNeeds': PropertySchema(
      id: 1,
      name: r'actualNeeds',
      type: IsarType.long,
    ),
    r'actualWants': PropertySchema(
      id: 2,
      name: r'actualWants',
      type: IsarType.long,
    ),
    r'dayKey': PropertySchema(id: 3, name: r'dayKey', type: IsarType.string),
    r'explanation': PropertySchema(
      id: 4,
      name: r'explanation',
      type: IsarType.string,
    ),
    r'missedDays': PropertySchema(
      id: 5,
      name: r'missedDays',
      type: IsarType.long,
    ),
    r'needsMet': PropertySchema(id: 6, name: r'needsMet', type: IsarType.bool),
    r'netSaved': PropertySchema(id: 7, name: r'netSaved', type: IsarType.long),
    r'period': PropertySchema(id: 8, name: r'period', type: IsarType.long),
    r'plannedGifts': PropertySchema(
      id: 9,
      name: r'plannedGifts',
      type: IsarType.long,
    ),
    r'plannedIncome': PropertySchema(
      id: 10,
      name: r'plannedIncome',
      type: IsarType.long,
    ),
    r'plannedNeeds': PropertySchema(
      id: 11,
      name: r'plannedNeeds',
      type: IsarType.long,
    ),
    r'plannedSavings': PropertySchema(
      id: 12,
      name: r'plannedSavings',
      type: IsarType.long,
    ),
    r'plannedWants': PropertySchema(
      id: 13,
      name: r'plannedWants',
      type: IsarType.long,
    ),
    r'savedRegularly': PropertySchema(
      id: 14,
      name: r'savedRegularly',
      type: IsarType.bool,
    ),
    r'withinPlan': PropertySchema(
      id: 15,
      name: r'withinPlan',
      type: IsarType.bool,
    ),
  },

  estimateSize: _periodSummaryRecordEstimateSize,
  serialize: _periodSummaryRecordSerialize,
  deserialize: _periodSummaryRecordDeserialize,
  deserializeProp: _periodSummaryRecordDeserializeProp,
);

int _periodSummaryRecordEstimateSize(
  PeriodSummaryRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dayKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.explanation.length * 3;
  return bytesCount;
}

void _periodSummaryRecordSerialize(
  PeriodSummaryRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.actualGifts);
  writer.writeLong(offsets[1], object.actualNeeds);
  writer.writeLong(offsets[2], object.actualWants);
  writer.writeString(offsets[3], object.dayKey);
  writer.writeString(offsets[4], object.explanation);
  writer.writeLong(offsets[5], object.missedDays);
  writer.writeBool(offsets[6], object.needsMet);
  writer.writeLong(offsets[7], object.netSaved);
  writer.writeLong(offsets[8], object.period);
  writer.writeLong(offsets[9], object.plannedGifts);
  writer.writeLong(offsets[10], object.plannedIncome);
  writer.writeLong(offsets[11], object.plannedNeeds);
  writer.writeLong(offsets[12], object.plannedSavings);
  writer.writeLong(offsets[13], object.plannedWants);
  writer.writeBool(offsets[14], object.savedRegularly);
  writer.writeBool(offsets[15], object.withinPlan);
}

PeriodSummaryRecord _periodSummaryRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PeriodSummaryRecord();
  object.actualGifts = reader.readLong(offsets[0]);
  object.actualNeeds = reader.readLong(offsets[1]);
  object.actualWants = reader.readLong(offsets[2]);
  object.dayKey = reader.readStringOrNull(offsets[3]);
  object.explanation = reader.readString(offsets[4]);
  object.missedDays = reader.readLong(offsets[5]);
  object.needsMet = reader.readBool(offsets[6]);
  object.netSaved = reader.readLong(offsets[7]);
  object.period = reader.readLong(offsets[8]);
  object.plannedGifts = reader.readLong(offsets[9]);
  object.plannedIncome = reader.readLongOrNull(offsets[10]);
  object.plannedNeeds = reader.readLong(offsets[11]);
  object.plannedSavings = reader.readLong(offsets[12]);
  object.plannedWants = reader.readLong(offsets[13]);
  object.savedRegularly = reader.readBool(offsets[14]);
  object.withinPlan = reader.readBool(offsets[15]);
  return object;
}

P _periodSummaryRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PeriodSummaryRecordQueryFilter
    on
        QueryBuilder<
          PeriodSummaryRecord,
          PeriodSummaryRecord,
          QFilterCondition
        > {
  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualGiftsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'actualGifts', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualGiftsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'actualGifts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualGiftsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'actualGifts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualGiftsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'actualGifts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualNeedsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'actualNeeds', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualNeedsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'actualNeeds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualNeedsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'actualNeeds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualNeedsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'actualNeeds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualWantsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'actualWants', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualWantsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'actualWants',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualWantsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'actualWants',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  actualWantsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'actualWants',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dayKey'),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dayKey'),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dayKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dayKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dayKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dayKey', value: ''),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  dayKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dayKey', value: ''),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  explanationEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'explanation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  explanationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'explanation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  explanationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'explanation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  explanationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'explanation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  explanationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'explanation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  explanationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'explanation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  explanationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'explanation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  explanationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'explanation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  explanationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'explanation', value: ''),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  explanationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'explanation', value: ''),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  missedDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'missedDays', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  missedDaysGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'missedDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  missedDaysLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'missedDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  missedDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'missedDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  needsMetEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'needsMet', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  netSavedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'netSaved', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  netSavedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'netSaved',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  netSavedLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'netSaved',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  netSavedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'netSaved',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  periodEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'period', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  periodGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'period',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  periodLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'period',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  periodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'period',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedGiftsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedGifts', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedGiftsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedGifts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedGiftsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedGifts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedGiftsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedGifts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedIncomeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'plannedIncome'),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedIncomeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'plannedIncome'),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedIncomeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedIncome', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedIncomeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedIncomeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedIncome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedIncomeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedIncome',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedNeedsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedNeeds', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedNeedsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedNeeds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedNeedsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedNeeds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedNeedsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedNeeds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedSavingsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedSavings', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedSavingsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedSavings',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedSavingsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedSavings',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedSavingsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedSavings',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedWantsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedWants', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedWantsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedWants',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedWantsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedWants',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  plannedWantsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedWants',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  savedRegularlyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'savedRegularly', value: value),
      );
    });
  }

  QueryBuilder<PeriodSummaryRecord, PeriodSummaryRecord, QAfterFilterCondition>
  withinPlanEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'withinPlan', value: value),
      );
    });
  }
}

extension PeriodSummaryRecordQueryObject
    on
        QueryBuilder<
          PeriodSummaryRecord,
          PeriodSummaryRecord,
          QFilterCondition
        > {}
