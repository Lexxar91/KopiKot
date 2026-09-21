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
    r'balance': PropertySchema(id: 1, name: r'balance', type: IsarType.long),
    r'budgetConfirmed': PropertySchema(
      id: 2,
      name: r'budgetConfirmed',
      type: IsarType.bool,
    ),
    r'coat': PropertySchema(id: 3, name: r'coat', type: IsarType.string),
    r'energy': PropertySchema(id: 4, name: r'energy', type: IsarType.long),
    r'feedback': PropertySchema(
      id: 5,
      name: r'feedback',
      type: IsarType.string,
    ),
    r'goalBalances': PropertySchema(
      id: 6,
      name: r'goalBalances',
      type: IsarType.objectList,

      target: r'GoalBalanceRecord',
    ),
    r'incomeAmount': PropertySchema(
      id: 7,
      name: r'incomeAmount',
      type: IsarType.long,
    ),
    r'incomeSource': PropertySchema(
      id: 8,
      name: r'incomeSource',
      type: IsarType.string,
    ),
    r'lastRewardAt': PropertySchema(
      id: 9,
      name: r'lastRewardAt',
      type: IsarType.dateTime,
    ),
    r'mood': PropertySchema(id: 10, name: r'mood', type: IsarType.long),
    r'ownedAccessories': PropertySchema(
      id: 11,
      name: r'ownedAccessories',
      type: IsarType.stringList,
    ),
    r'period': PropertySchema(id: 12, name: r'period', type: IsarType.long),
    r'periodSummaries': PropertySchema(
      id: 13,
      name: r'periodSummaries',
      type: IsarType.objectList,

      target: r'PeriodSummaryRecord',
    ),
    r'petName': PropertySchema(id: 14, name: r'petName', type: IsarType.string),
    r'plannedBalance': PropertySchema(
      id: 15,
      name: r'plannedBalance',
      type: IsarType.long,
    ),
    r'plannedGifts': PropertySchema(
      id: 16,
      name: r'plannedGifts',
      type: IsarType.long,
    ),
    r'plannedNeeds': PropertySchema(
      id: 17,
      name: r'plannedNeeds',
      type: IsarType.long,
    ),
    r'plannedSavings': PropertySchema(
      id: 18,
      name: r'plannedSavings',
      type: IsarType.long,
    ),
    r'plannedWants': PropertySchema(
      id: 19,
      name: r'plannedWants',
      type: IsarType.long,
    ),
    r'saplings': PropertySchema(
      id: 20,
      name: r'saplings',
      type: IsarType.objectList,

      target: r'SaplingRecord',
    ),
    r'satiety': PropertySchema(id: 21, name: r'satiety', type: IsarType.long),
    r'savings': PropertySchema(id: 22, name: r'savings', type: IsarType.long),
    r'schemaVersion': PropertySchema(
      id: 23,
      name: r'schemaVersion',
      type: IsarType.long,
    ),
    r'selectedGoalId': PropertySchema(
      id: 24,
      name: r'selectedGoalId',
      type: IsarType.string,
    ),
    r'streak': PropertySchema(id: 25, name: r'streak', type: IsarType.long),
    r'taskProgress': PropertySchema(
      id: 26,
      name: r'taskProgress',
      type: IsarType.objectList,

      target: r'TaskProgressRecord',
    ),
    r'transactions': PropertySchema(
      id: 27,
      name: r'transactions',
      type: IsarType.objectList,

      target: r'TransactionRecord',
    ),
    r'walkPeriod': PropertySchema(
      id: 28,
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
    r'GoalBalanceRecord': GoalBalanceRecordSchema,
    r'TransactionRecord': TransactionRecordSchema,
    r'TaskProgressRecord': TaskProgressRecordSchema,
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
  bytesCount += 3 + object.coat.length * 3;
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
  bytesCount += 3 + object.incomeSource.length * 3;
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
  writer.writeLong(offsets[1], object.balance);
  writer.writeBool(offsets[2], object.budgetConfirmed);
  writer.writeString(offsets[3], object.coat);
  writer.writeLong(offsets[4], object.energy);
  writer.writeString(offsets[5], object.feedback);
  writer.writeObjectList<GoalBalanceRecord>(
    offsets[6],
    allOffsets,
    GoalBalanceRecordSchema.serialize,
    object.goalBalances,
  );
  writer.writeLong(offsets[7], object.incomeAmount);
  writer.writeString(offsets[8], object.incomeSource);
  writer.writeDateTime(offsets[9], object.lastRewardAt);
  writer.writeLong(offsets[10], object.mood);
  writer.writeStringList(offsets[11], object.ownedAccessories);
  writer.writeLong(offsets[12], object.period);
  writer.writeObjectList<PeriodSummaryRecord>(
    offsets[13],
    allOffsets,
    PeriodSummaryRecordSchema.serialize,
    object.periodSummaries,
  );
  writer.writeString(offsets[14], object.petName);
  writer.writeLong(offsets[15], object.plannedBalance);
  writer.writeLong(offsets[16], object.plannedGifts);
  writer.writeLong(offsets[17], object.plannedNeeds);
  writer.writeLong(offsets[18], object.plannedSavings);
  writer.writeLong(offsets[19], object.plannedWants);
  writer.writeObjectList<SaplingRecord>(
    offsets[20],
    allOffsets,
    SaplingRecordSchema.serialize,
    object.saplings,
  );
  writer.writeLong(offsets[21], object.satiety);
  writer.writeLong(offsets[22], object.savings);
  writer.writeLong(offsets[23], object.schemaVersion);
  writer.writeString(offsets[24], object.selectedGoalId);
  writer.writeLong(offsets[25], object.streak);
  writer.writeObjectList<TaskProgressRecord>(
    offsets[26],
    allOffsets,
    TaskProgressRecordSchema.serialize,
    object.taskProgress,
  );
  writer.writeObjectList<TransactionRecord>(
    offsets[27],
    allOffsets,
    TransactionRecordSchema.serialize,
    object.transactions,
  );
  writer.writeLong(offsets[28], object.walkPeriod);
}

ProfileRecord _profileRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProfileRecord();
  object.accessory = reader.readString(offsets[0]);
  object.balance = reader.readLong(offsets[1]);
  object.budgetConfirmed = reader.readBool(offsets[2]);
  object.coat = reader.readString(offsets[3]);
  object.energy = reader.readLong(offsets[4]);
  object.feedback = reader.readStringOrNull(offsets[5]);
  object.goalBalances = reader.readObjectList<GoalBalanceRecord>(
    offsets[6],
    GoalBalanceRecordSchema.deserialize,
    allOffsets,
    GoalBalanceRecord(),
  );
  object.id = id;
  object.incomeAmount = reader.readLong(offsets[7]);
  object.incomeSource = reader.readString(offsets[8]);
  object.lastRewardAt = reader.readDateTimeOrNull(offsets[9]);
  object.mood = reader.readLong(offsets[10]);
  object.ownedAccessories = reader.readStringList(offsets[11]);
  object.period = reader.readLong(offsets[12]);
  object.periodSummaries = reader.readObjectList<PeriodSummaryRecord>(
    offsets[13],
    PeriodSummaryRecordSchema.deserialize,
    allOffsets,
    PeriodSummaryRecord(),
  );
  object.petName = reader.readString(offsets[14]);
  object.plannedBalance = reader.readLong(offsets[15]);
  object.plannedGifts = reader.readLong(offsets[16]);
  object.plannedNeeds = reader.readLong(offsets[17]);
  object.plannedSavings = reader.readLong(offsets[18]);
  object.plannedWants = reader.readLong(offsets[19]);
  object.saplings = reader.readObjectList<SaplingRecord>(
    offsets[20],
    SaplingRecordSchema.deserialize,
    allOffsets,
    SaplingRecord(),
  );
  object.satiety = reader.readLong(offsets[21]);
  object.savings = reader.readLong(offsets[22]);
  object.schemaVersion = reader.readLong(offsets[23]);
  object.selectedGoalId = reader.readStringOrNull(offsets[24]);
  object.streak = reader.readLong(offsets[25]);
  object.taskProgress = reader.readObjectList<TaskProgressRecord>(
    offsets[26],
    TaskProgressRecordSchema.deserialize,
    allOffsets,
    TaskProgressRecord(),
  );
  object.transactions = reader.readObjectList<TransactionRecord>(
    offsets[27],
    TransactionRecordSchema.deserialize,
    allOffsets,
    TransactionRecord(),
  );
  object.walkPeriod = reader.readLong(offsets[28]);
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
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readObjectList<GoalBalanceRecord>(
            offset,
            GoalBalanceRecordSchema.deserialize,
            allOffsets,
            GoalBalanceRecord(),
          ))
          as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readStringList(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readObjectList<PeriodSummaryRecord>(
            offset,
            PeriodSummaryRecordSchema.deserialize,
            allOffsets,
            PeriodSummaryRecord(),
          ))
          as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readObjectList<SaplingRecord>(
            offset,
            SaplingRecordSchema.deserialize,
            allOffsets,
            SaplingRecord(),
          ))
          as P;
    case 21:
      return (reader.readLong(offset)) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    case 23:
      return (reader.readLong(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readLong(offset)) as P;
    case 26:
      return (reader.readObjectList<TaskProgressRecord>(
            offset,
            TaskProgressRecordSchema.deserialize,
            allOffsets,
            TaskProgressRecord(),
          ))
          as P;
    case 27:
      return (reader.readObjectList<TransactionRecord>(
            offset,
            TransactionRecordSchema.deserialize,
            allOffsets,
            TransactionRecord(),
          ))
          as P;
    case 28:
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
  budgetConfirmedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'budgetConfirmed', value: value),
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
  goalBalancesElement(FilterQuery<GoalBalanceRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'goalBalances');
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

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balance');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct>
  distinctByBudgetConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetConfirmed');
    });
  }

  QueryBuilder<ProfileRecord, ProfileRecord, QDistinct> distinctByCoat({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coat', caseSensitive: caseSensitive);
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

  QueryBuilder<ProfileRecord, int, QQueryOperations> balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balance');
    });
  }

  QueryBuilder<ProfileRecord, bool, QQueryOperations>
  budgetConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetConfirmed');
    });
  }

  QueryBuilder<ProfileRecord, String, QQueryOperations> coatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coat');
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
    r'commandId': PropertySchema(
      id: 2,
      name: r'commandId',
      type: IsarType.string,
    ),
    r'kind': PropertySchema(id: 3, name: r'kind', type: IsarType.string),
    r'label': PropertySchema(id: 4, name: r'label', type: IsarType.string),
    r'moodAfter': PropertySchema(
      id: 5,
      name: r'moodAfter',
      type: IsarType.long,
    ),
    r'period': PropertySchema(id: 6, name: r'period', type: IsarType.long),
    r'referenceId': PropertySchema(
      id: 7,
      name: r'referenceId',
      type: IsarType.string,
    ),
    r'satietyAfter': PropertySchema(
      id: 8,
      name: r'satietyAfter',
      type: IsarType.long,
    ),
    r'savingsAfter': PropertySchema(
      id: 9,
      name: r'savingsAfter',
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
  writer.writeString(offsets[2], object.commandId);
  writer.writeString(offsets[3], object.kind);
  writer.writeString(offsets[4], object.label);
  writer.writeLong(offsets[5], object.moodAfter);
  writer.writeLong(offsets[6], object.period);
  writer.writeString(offsets[7], object.referenceId);
  writer.writeLong(offsets[8], object.satietyAfter);
  writer.writeLong(offsets[9], object.savingsAfter);
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
  object.commandId = reader.readString(offsets[2]);
  object.kind = reader.readString(offsets[3]);
  object.label = reader.readString(offsets[4]);
  object.moodAfter = reader.readLong(offsets[5]);
  object.period = reader.readLong(offsets[6]);
  object.referenceId = reader.readStringOrNull(offsets[7]);
  object.satietyAfter = reader.readLong(offsets[8]);
  object.savingsAfter = reader.readLong(offsets[9]);
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
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
    r'taskId': PropertySchema(id: 3, name: r'taskId', type: IsarType.string),
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
  writer.writeString(offsets[3], object.taskId);
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
  object.taskId = reader.readString(offsets[3]);
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

const SaplingRecordSchema = Schema(
  name: r'SaplingRecord',
  id: 4385280109298344912,
  properties: {
    r'definitionId': PropertySchema(
      id: 0,
      name: r'definitionId',
      type: IsarType.string,
    ),
    r'plantedPeriod': PropertySchema(
      id: 1,
      name: r'plantedPeriod',
      type: IsarType.long,
    ),
    r'saplingId': PropertySchema(
      id: 2,
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
  writer.writeLong(offsets[1], object.plantedPeriod);
  writer.writeString(offsets[2], object.saplingId);
}

SaplingRecord _saplingRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SaplingRecord();
  object.definitionId = reader.readString(offsets[0]);
  object.plantedPeriod = reader.readLong(offsets[1]);
  object.saplingId = reader.readString(offsets[2]);
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
      return (reader.readLong(offset)) as P;
    case 2:
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
    r'explanation': PropertySchema(
      id: 3,
      name: r'explanation',
      type: IsarType.string,
    ),
    r'needsMet': PropertySchema(id: 4, name: r'needsMet', type: IsarType.bool),
    r'netSaved': PropertySchema(id: 5, name: r'netSaved', type: IsarType.long),
    r'period': PropertySchema(id: 6, name: r'period', type: IsarType.long),
    r'plannedGifts': PropertySchema(
      id: 7,
      name: r'plannedGifts',
      type: IsarType.long,
    ),
    r'plannedNeeds': PropertySchema(
      id: 8,
      name: r'plannedNeeds',
      type: IsarType.long,
    ),
    r'plannedSavings': PropertySchema(
      id: 9,
      name: r'plannedSavings',
      type: IsarType.long,
    ),
    r'plannedWants': PropertySchema(
      id: 10,
      name: r'plannedWants',
      type: IsarType.long,
    ),
    r'savedRegularly': PropertySchema(
      id: 11,
      name: r'savedRegularly',
      type: IsarType.bool,
    ),
    r'withinPlan': PropertySchema(
      id: 12,
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
  writer.writeString(offsets[3], object.explanation);
  writer.writeBool(offsets[4], object.needsMet);
  writer.writeLong(offsets[5], object.netSaved);
  writer.writeLong(offsets[6], object.period);
  writer.writeLong(offsets[7], object.plannedGifts);
  writer.writeLong(offsets[8], object.plannedNeeds);
  writer.writeLong(offsets[9], object.plannedSavings);
  writer.writeLong(offsets[10], object.plannedWants);
  writer.writeBool(offsets[11], object.savedRegularly);
  writer.writeBool(offsets[12], object.withinPlan);
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
  object.explanation = reader.readString(offsets[3]);
  object.needsMet = reader.readBool(offsets[4]);
  object.netSaved = reader.readLong(offsets[5]);
  object.period = reader.readLong(offsets[6]);
  object.plannedGifts = reader.readLong(offsets[7]);
  object.plannedNeeds = reader.readLong(offsets[8]);
  object.plannedSavings = reader.readLong(offsets[9]);
  object.plannedWants = reader.readLong(offsets[10]);
  object.savedRegularly = reader.readBool(offsets[11]);
  object.withinPlan = reader.readBool(offsets[12]);
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
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
