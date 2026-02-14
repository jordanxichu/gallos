// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_db.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLicenseDbCollection on Isar {
  IsarCollection<LicenseDb> get licenseDbs => this.collection();
}

const LicenseDbSchema = CollectionSchema(
  name: r'LicenseDb',
  id: -9173507772629353157,
  properties: {
    r'activatedAt': PropertySchema(
      id: 0,
      name: r'activatedAt',
      type: IsarType.dateTime,
    ),
    r'deviceFingerprint': PropertySchema(
      id: 1,
      name: r'deviceFingerprint',
      type: IsarType.string,
    ),
    r'expiresAt': PropertySchema(
      id: 2,
      name: r'expiresAt',
      type: IsarType.dateTime,
    ),
    r'holderEmail': PropertySchema(
      id: 3,
      name: r'holderEmail',
      type: IsarType.string,
    ),
    r'holderName': PropertySchema(
      id: 4,
      name: r'holderName',
      type: IsarType.string,
    ),
    r'issuedAt': PropertySchema(
      id: 5,
      name: r'issuedAt',
      type: IsarType.dateTime,
    ),
    r'licenseId': PropertySchema(
      id: 6,
      name: r'licenseId',
      type: IsarType.string,
    ),
    r'licensePayload': PropertySchema(
      id: 7,
      name: r'licensePayload',
      type: IsarType.string,
    ),
    r'maxReactivations': PropertySchema(
      id: 8,
      name: r'maxReactivations',
      type: IsarType.long,
    ),
    r'reactivationCount': PropertySchema(
      id: 9,
      name: r'reactivationCount',
      type: IsarType.long,
    ),
    r'revoked': PropertySchema(
      id: 10,
      name: r'revoked',
      type: IsarType.bool,
    ),
    r'signature': PropertySchema(
      id: 11,
      name: r'signature',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 12,
      name: r'type',
      type: IsarType.byte,
      enumMap: _LicenseDbtypeEnumValueMap,
    )
  },
  estimateSize: _licenseDbEstimateSize,
  serialize: _licenseDbSerialize,
  deserialize: _licenseDbDeserialize,
  deserializeProp: _licenseDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'licenseId': IndexSchema(
      id: 2024518247436909527,
      name: r'licenseId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'licenseId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _licenseDbGetId,
  getLinks: _licenseDbGetLinks,
  attach: _licenseDbAttach,
  version: '3.1.0+1',
);

int _licenseDbEstimateSize(
  LicenseDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.deviceFingerprint.length * 3;
  {
    final value = object.holderEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.holderName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.licenseId.length * 3;
  bytesCount += 3 + object.licensePayload.length * 3;
  bytesCount += 3 + object.signature.length * 3;
  return bytesCount;
}

void _licenseDbSerialize(
  LicenseDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.activatedAt);
  writer.writeString(offsets[1], object.deviceFingerprint);
  writer.writeDateTime(offsets[2], object.expiresAt);
  writer.writeString(offsets[3], object.holderEmail);
  writer.writeString(offsets[4], object.holderName);
  writer.writeDateTime(offsets[5], object.issuedAt);
  writer.writeString(offsets[6], object.licenseId);
  writer.writeString(offsets[7], object.licensePayload);
  writer.writeLong(offsets[8], object.maxReactivations);
  writer.writeLong(offsets[9], object.reactivationCount);
  writer.writeBool(offsets[10], object.revoked);
  writer.writeString(offsets[11], object.signature);
  writer.writeByte(offsets[12], object.type.index);
}

LicenseDb _licenseDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LicenseDb();
  object.activatedAt = reader.readDateTime(offsets[0]);
  object.deviceFingerprint = reader.readString(offsets[1]);
  object.expiresAt = reader.readDateTimeOrNull(offsets[2]);
  object.holderEmail = reader.readStringOrNull(offsets[3]);
  object.holderName = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.issuedAt = reader.readDateTime(offsets[5]);
  object.licenseId = reader.readString(offsets[6]);
  object.licensePayload = reader.readString(offsets[7]);
  object.maxReactivations = reader.readLong(offsets[8]);
  object.reactivationCount = reader.readLong(offsets[9]);
  object.revoked = reader.readBool(offsets[10]);
  object.signature = reader.readString(offsets[11]);
  object.type =
      _LicenseDbtypeValueEnumMap[reader.readByteOrNull(offsets[12])] ??
          LicenseType.demo;
  return object;
}

P _licenseDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (_LicenseDbtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          LicenseType.demo) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LicenseDbtypeEnumValueMap = {
  'demo': 0,
  'monthly': 1,
  'annual': 2,
  'lifetime': 3,
};
const _LicenseDbtypeValueEnumMap = {
  0: LicenseType.demo,
  1: LicenseType.monthly,
  2: LicenseType.annual,
  3: LicenseType.lifetime,
};

Id _licenseDbGetId(LicenseDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _licenseDbGetLinks(LicenseDb object) {
  return [];
}

void _licenseDbAttach(IsarCollection<dynamic> col, Id id, LicenseDb object) {
  object.id = id;
}

extension LicenseDbByIndex on IsarCollection<LicenseDb> {
  Future<LicenseDb?> getByLicenseId(String licenseId) {
    return getByIndex(r'licenseId', [licenseId]);
  }

  LicenseDb? getByLicenseIdSync(String licenseId) {
    return getByIndexSync(r'licenseId', [licenseId]);
  }

  Future<bool> deleteByLicenseId(String licenseId) {
    return deleteByIndex(r'licenseId', [licenseId]);
  }

  bool deleteByLicenseIdSync(String licenseId) {
    return deleteByIndexSync(r'licenseId', [licenseId]);
  }

  Future<List<LicenseDb?>> getAllByLicenseId(List<String> licenseIdValues) {
    final values = licenseIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'licenseId', values);
  }

  List<LicenseDb?> getAllByLicenseIdSync(List<String> licenseIdValues) {
    final values = licenseIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'licenseId', values);
  }

  Future<int> deleteAllByLicenseId(List<String> licenseIdValues) {
    final values = licenseIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'licenseId', values);
  }

  int deleteAllByLicenseIdSync(List<String> licenseIdValues) {
    final values = licenseIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'licenseId', values);
  }

  Future<Id> putByLicenseId(LicenseDb object) {
    return putByIndex(r'licenseId', object);
  }

  Id putByLicenseIdSync(LicenseDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'licenseId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLicenseId(List<LicenseDb> objects) {
    return putAllByIndex(r'licenseId', objects);
  }

  List<Id> putAllByLicenseIdSync(List<LicenseDb> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'licenseId', objects, saveLinks: saveLinks);
  }
}

extension LicenseDbQueryWhereSort
    on QueryBuilder<LicenseDb, LicenseDb, QWhere> {
  QueryBuilder<LicenseDb, LicenseDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LicenseDbQueryWhere
    on QueryBuilder<LicenseDb, LicenseDb, QWhereClause> {
  QueryBuilder<LicenseDb, LicenseDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<LicenseDb, LicenseDb, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterWhereClause> licenseIdEqualTo(
      String licenseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'licenseId',
        value: [licenseId],
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterWhereClause> licenseIdNotEqualTo(
      String licenseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'licenseId',
              lower: [],
              upper: [licenseId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'licenseId',
              lower: [licenseId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'licenseId',
              lower: [licenseId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'licenseId',
              lower: [],
              upper: [licenseId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LicenseDbQueryFilter
    on QueryBuilder<LicenseDb, LicenseDb, QFilterCondition> {
  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> activatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      activatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> activatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> activatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      deviceFingerprintEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceFingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      deviceFingerprintGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceFingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      deviceFingerprintLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceFingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      deviceFingerprintBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceFingerprint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      deviceFingerprintStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceFingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      deviceFingerprintEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceFingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      deviceFingerprintContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceFingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      deviceFingerprintMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceFingerprint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      deviceFingerprintIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceFingerprint',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      deviceFingerprintIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceFingerprint',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> expiresAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      expiresAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> expiresAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      expiresAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> expiresAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> expiresAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'holderEmail',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'holderEmail',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderEmailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'holderEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'holderEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'holderEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'holderEmail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'holderEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'holderEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderEmailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'holderEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderEmailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'holderEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'holderEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'holderEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'holderName',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'holderName',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'holderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'holderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'holderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'holderName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'holderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'holderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'holderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> holderNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'holderName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'holderName',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      holderNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'holderName',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> issuedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'issuedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> issuedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'issuedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> issuedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'issuedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> issuedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'issuedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> licenseIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licenseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licenseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'licenseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> licenseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'licenseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> licenseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'licenseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> licenseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'licenseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> licenseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'licenseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> licenseIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'licenseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> licenseIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'licenseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> licenseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licenseId',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licenseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'licenseId',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licensePayloadEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licensePayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licensePayloadGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'licensePayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licensePayloadLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'licensePayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licensePayloadBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'licensePayload',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licensePayloadStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'licensePayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licensePayloadEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'licensePayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licensePayloadContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'licensePayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licensePayloadMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'licensePayload',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licensePayloadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licensePayload',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      licensePayloadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'licensePayload',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      maxReactivationsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxReactivations',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      maxReactivationsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxReactivations',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      maxReactivationsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxReactivations',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      maxReactivationsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxReactivations',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      reactivationCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactivationCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      reactivationCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reactivationCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      reactivationCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reactivationCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      reactivationCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reactivationCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> revokedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revoked',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> signatureEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      signatureGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> signatureLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> signatureBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> signatureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> signatureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> signatureContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> signatureMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signature',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> signatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signature',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition>
      signatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signature',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> typeEqualTo(
      LicenseType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> typeGreaterThan(
    LicenseType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> typeLessThan(
    LicenseType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterFilterCondition> typeBetween(
    LicenseType lower,
    LicenseType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LicenseDbQueryObject
    on QueryBuilder<LicenseDb, LicenseDb, QFilterCondition> {}

extension LicenseDbQueryLinks
    on QueryBuilder<LicenseDb, LicenseDb, QFilterCondition> {}

extension LicenseDbQuerySortBy on QueryBuilder<LicenseDb, LicenseDb, QSortBy> {
  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByActivatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activatedAt', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByActivatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activatedAt', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByDeviceFingerprint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceFingerprint', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy>
      sortByDeviceFingerprintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceFingerprint', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByHolderEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderEmail', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByHolderEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderEmail', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByHolderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderName', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByHolderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderName', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByIssuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByIssuedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByLicenseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseId', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByLicenseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseId', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByLicensePayload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licensePayload', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByLicensePayloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licensePayload', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByMaxReactivations() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxReactivations', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy>
      sortByMaxReactivationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxReactivations', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByReactivationCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactivationCount', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy>
      sortByReactivationCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactivationCount', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByRevoked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revoked', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByRevokedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revoked', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortBySignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortBySignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension LicenseDbQuerySortThenBy
    on QueryBuilder<LicenseDb, LicenseDb, QSortThenBy> {
  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByActivatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activatedAt', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByActivatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activatedAt', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByDeviceFingerprint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceFingerprint', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy>
      thenByDeviceFingerprintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceFingerprint', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByHolderEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderEmail', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByHolderEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderEmail', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByHolderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderName', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByHolderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderName', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByIssuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByIssuedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByLicenseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseId', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByLicenseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseId', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByLicensePayload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licensePayload', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByLicensePayloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licensePayload', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByMaxReactivations() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxReactivations', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy>
      thenByMaxReactivationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxReactivations', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByReactivationCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactivationCount', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy>
      thenByReactivationCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactivationCount', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByRevoked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revoked', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByRevokedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revoked', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenBySignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenBySignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.desc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension LicenseDbQueryWhereDistinct
    on QueryBuilder<LicenseDb, LicenseDb, QDistinct> {
  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByActivatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activatedAt');
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByDeviceFingerprint(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceFingerprint',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByHolderEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'holderEmail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByHolderName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'holderName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByIssuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'issuedAt');
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByLicenseId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'licenseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByLicensePayload(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'licensePayload',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByMaxReactivations() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxReactivations');
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByReactivationCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reactivationCount');
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByRevoked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'revoked');
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctBySignature(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signature', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseDb, LicenseDb, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension LicenseDbQueryProperty
    on QueryBuilder<LicenseDb, LicenseDb, QQueryProperty> {
  QueryBuilder<LicenseDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LicenseDb, DateTime, QQueryOperations> activatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activatedAt');
    });
  }

  QueryBuilder<LicenseDb, String, QQueryOperations>
      deviceFingerprintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceFingerprint');
    });
  }

  QueryBuilder<LicenseDb, DateTime?, QQueryOperations> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<LicenseDb, String?, QQueryOperations> holderEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'holderEmail');
    });
  }

  QueryBuilder<LicenseDb, String?, QQueryOperations> holderNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'holderName');
    });
  }

  QueryBuilder<LicenseDb, DateTime, QQueryOperations> issuedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'issuedAt');
    });
  }

  QueryBuilder<LicenseDb, String, QQueryOperations> licenseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'licenseId');
    });
  }

  QueryBuilder<LicenseDb, String, QQueryOperations> licensePayloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'licensePayload');
    });
  }

  QueryBuilder<LicenseDb, int, QQueryOperations> maxReactivationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxReactivations');
    });
  }

  QueryBuilder<LicenseDb, int, QQueryOperations> reactivationCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reactivationCount');
    });
  }

  QueryBuilder<LicenseDb, bool, QQueryOperations> revokedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'revoked');
    });
  }

  QueryBuilder<LicenseDb, String, QQueryOperations> signatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signature');
    });
  }

  QueryBuilder<LicenseDb, LicenseType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
