// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsRecordCollection on Isar {
  IsarCollection<AppSettingsRecord> get appSettingsRecords => this.collection();
}

const AppSettingsRecordSchema = CollectionSchema(
  name: r'AppSettingsRecord',
  id: -5800169138830006153,
  properties: {
    r'reduceMotion': PropertySchema(
      id: 0,
      name: r'reduceMotion',
      type: IsarType.bool,
    ),
    r'testProfile': PropertySchema(
      id: 1,
      name: r'testProfile',
      type: IsarType.bool,
    ),
  },

  estimateSize: _appSettingsRecordEstimateSize,
  serialize: _appSettingsRecordSerialize,
  deserialize: _appSettingsRecordDeserialize,
  deserializeProp: _appSettingsRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _appSettingsRecordGetId,
  getLinks: _appSettingsRecordGetLinks,
  attach: _appSettingsRecordAttach,
  version: '3.3.2',
);

int _appSettingsRecordEstimateSize(
  AppSettingsRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _appSettingsRecordSerialize(
  AppSettingsRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.reduceMotion);
  writer.writeBool(offsets[1], object.testProfile);
}

AppSettingsRecord _appSettingsRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettingsRecord();
  object.id = id;
  object.reduceMotion = reader.readBool(offsets[0]);
  object.testProfile = reader.readBool(offsets[1]);
  return object;
}

P _appSettingsRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingsRecordGetId(AppSettingsRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsRecordGetLinks(
  AppSettingsRecord object,
) {
  return [];
}

void _appSettingsRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  AppSettingsRecord object,
) {
  object.id = id;
}

extension AppSettingsRecordQueryWhereSort
    on QueryBuilder<AppSettingsRecord, AppSettingsRecord, QWhere> {
  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsRecordQueryWhere
    on QueryBuilder<AppSettingsRecord, AppSettingsRecord, QWhereClause> {
  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterWhereClause>
  idBetween(
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

extension AppSettingsRecordQueryFilter
    on QueryBuilder<AppSettingsRecord, AppSettingsRecord, QFilterCondition> {
  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterFilterCondition>
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

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterFilterCondition>
  reduceMotionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reduceMotion', value: value),
      );
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterFilterCondition>
  testProfileEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'testProfile', value: value),
      );
    });
  }
}

extension AppSettingsRecordQueryObject
    on QueryBuilder<AppSettingsRecord, AppSettingsRecord, QFilterCondition> {}

extension AppSettingsRecordQueryLinks
    on QueryBuilder<AppSettingsRecord, AppSettingsRecord, QFilterCondition> {}

extension AppSettingsRecordQuerySortBy
    on QueryBuilder<AppSettingsRecord, AppSettingsRecord, QSortBy> {
  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterSortBy>
  sortByReduceMotion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reduceMotion', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterSortBy>
  sortByReduceMotionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reduceMotion', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterSortBy>
  sortByTestProfile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testProfile', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterSortBy>
  sortByTestProfileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testProfile', Sort.desc);
    });
  }
}

extension AppSettingsRecordQuerySortThenBy
    on QueryBuilder<AppSettingsRecord, AppSettingsRecord, QSortThenBy> {
  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterSortBy>
  thenByReduceMotion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reduceMotion', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterSortBy>
  thenByReduceMotionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reduceMotion', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterSortBy>
  thenByTestProfile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testProfile', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QAfterSortBy>
  thenByTestProfileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testProfile', Sort.desc);
    });
  }
}

extension AppSettingsRecordQueryWhereDistinct
    on QueryBuilder<AppSettingsRecord, AppSettingsRecord, QDistinct> {
  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QDistinct>
  distinctByReduceMotion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reduceMotion');
    });
  }

  QueryBuilder<AppSettingsRecord, AppSettingsRecord, QDistinct>
  distinctByTestProfile() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'testProfile');
    });
  }
}

extension AppSettingsRecordQueryProperty
    on QueryBuilder<AppSettingsRecord, AppSettingsRecord, QQueryProperty> {
  QueryBuilder<AppSettingsRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettingsRecord, bool, QQueryOperations>
  reduceMotionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reduceMotion');
    });
  }

  QueryBuilder<AppSettingsRecord, bool, QQueryOperations>
  testProfileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'testProfile');
    });
  }
}
