// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLicenseRecordCollection on Isar {
  IsarCollection<LicenseRecord> get licenseRecords => this.collection();
}

const LicenseRecordSchema = CollectionSchema(
  name: r'LicenseRecord',
  id: -8859542880264892391,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'currency': PropertySchema(
      id: 1,
      name: r'currency',
      type: IsarType.string,
    ),
    r'devicePrefix': PropertySchema(
      id: 2,
      name: r'devicePrefix',
      type: IsarType.string,
    ),
    r'expiresAt': PropertySchema(
      id: 3,
      name: r'expiresAt',
      type: IsarType.dateTime,
    ),
    r'holderEmail': PropertySchema(
      id: 4,
      name: r'holderEmail',
      type: IsarType.string,
    ),
    r'holderName': PropertySchema(
      id: 5,
      name: r'holderName',
      type: IsarType.string,
    ),
    r'holderPhone': PropertySchema(
      id: 6,
      name: r'holderPhone',
      type: IsarType.string,
    ),
    r'issuedAt': PropertySchema(
      id: 7,
      name: r'issuedAt',
      type: IsarType.dateTime,
    ),
    r'licenseCode': PropertySchema(
      id: 8,
      name: r'licenseCode',
      type: IsarType.string,
    ),
    r'licenseId': PropertySchema(
      id: 9,
      name: r'licenseId',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 10,
      name: r'notes',
      type: IsarType.string,
    ),
    r'revoked': PropertySchema(
      id: 11,
      name: r'revoked',
      type: IsarType.bool,
    ),
    r'shared': PropertySchema(
      id: 12,
      name: r'shared',
      type: IsarType.bool,
    ),
    r'type': PropertySchema(
      id: 13,
      name: r'type',
      type: IsarType.byte,
      enumMap: _LicenseRecordtypeEnumValueMap,
    )
  },
  estimateSize: _licenseRecordEstimateSize,
  serialize: _licenseRecordSerialize,
  deserialize: _licenseRecordDeserialize,
  deserializeProp: _licenseRecordDeserializeProp,
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
  getId: _licenseRecordGetId,
  getLinks: _licenseRecordGetLinks,
  attach: _licenseRecordAttach,
  version: '3.1.0+1',
);

int _licenseRecordEstimateSize(
  LicenseRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currency.length * 3;
  {
    final value = object.devicePrefix;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.holderEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.holderName.length * 3;
  {
    final value = object.holderPhone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.licenseCode.length * 3;
  bytesCount += 3 + object.licenseId.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _licenseRecordSerialize(
  LicenseRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeString(offsets[1], object.currency);
  writer.writeString(offsets[2], object.devicePrefix);
  writer.writeDateTime(offsets[3], object.expiresAt);
  writer.writeString(offsets[4], object.holderEmail);
  writer.writeString(offsets[5], object.holderName);
  writer.writeString(offsets[6], object.holderPhone);
  writer.writeDateTime(offsets[7], object.issuedAt);
  writer.writeString(offsets[8], object.licenseCode);
  writer.writeString(offsets[9], object.licenseId);
  writer.writeString(offsets[10], object.notes);
  writer.writeBool(offsets[11], object.revoked);
  writer.writeBool(offsets[12], object.shared);
  writer.writeByte(offsets[13], object.type.index);
}

LicenseRecord _licenseRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LicenseRecord();
  object.amount = reader.readDoubleOrNull(offsets[0]);
  object.currency = reader.readString(offsets[1]);
  object.devicePrefix = reader.readStringOrNull(offsets[2]);
  object.expiresAt = reader.readDateTimeOrNull(offsets[3]);
  object.holderEmail = reader.readStringOrNull(offsets[4]);
  object.holderName = reader.readString(offsets[5]);
  object.holderPhone = reader.readStringOrNull(offsets[6]);
  object.id = id;
  object.issuedAt = reader.readDateTime(offsets[7]);
  object.licenseCode = reader.readString(offsets[8]);
  object.licenseId = reader.readString(offsets[9]);
  object.notes = reader.readStringOrNull(offsets[10]);
  object.revoked = reader.readBool(offsets[11]);
  object.shared = reader.readBool(offsets[12]);
  object.type =
      _LicenseRecordtypeValueEnumMap[reader.readByteOrNull(offsets[13])] ??
          LicenseType.demo;
  return object;
}

P _licenseRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (_LicenseRecordtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          LicenseType.demo) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LicenseRecordtypeEnumValueMap = {
  'demo': 0,
  'monthly': 1,
  'annual': 2,
  'lifetime': 3,
};
const _LicenseRecordtypeValueEnumMap = {
  0: LicenseType.demo,
  1: LicenseType.monthly,
  2: LicenseType.annual,
  3: LicenseType.lifetime,
};

Id _licenseRecordGetId(LicenseRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _licenseRecordGetLinks(LicenseRecord object) {
  return [];
}

void _licenseRecordAttach(
    IsarCollection<dynamic> col, Id id, LicenseRecord object) {
  object.id = id;
}

extension LicenseRecordByIndex on IsarCollection<LicenseRecord> {
  Future<LicenseRecord?> getByLicenseId(String licenseId) {
    return getByIndex(r'licenseId', [licenseId]);
  }

  LicenseRecord? getByLicenseIdSync(String licenseId) {
    return getByIndexSync(r'licenseId', [licenseId]);
  }

  Future<bool> deleteByLicenseId(String licenseId) {
    return deleteByIndex(r'licenseId', [licenseId]);
  }

  bool deleteByLicenseIdSync(String licenseId) {
    return deleteByIndexSync(r'licenseId', [licenseId]);
  }

  Future<List<LicenseRecord?>> getAllByLicenseId(List<String> licenseIdValues) {
    final values = licenseIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'licenseId', values);
  }

  List<LicenseRecord?> getAllByLicenseIdSync(List<String> licenseIdValues) {
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

  Future<Id> putByLicenseId(LicenseRecord object) {
    return putByIndex(r'licenseId', object);
  }

  Id putByLicenseIdSync(LicenseRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'licenseId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLicenseId(List<LicenseRecord> objects) {
    return putAllByIndex(r'licenseId', objects);
  }

  List<Id> putAllByLicenseIdSync(List<LicenseRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'licenseId', objects, saveLinks: saveLinks);
  }
}

extension LicenseRecordQueryWhereSort
    on QueryBuilder<LicenseRecord, LicenseRecord, QWhere> {
  QueryBuilder<LicenseRecord, LicenseRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LicenseRecordQueryWhere
    on QueryBuilder<LicenseRecord, LicenseRecord, QWhereClause> {
  QueryBuilder<LicenseRecord, LicenseRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterWhereClause>
      licenseIdEqualTo(String licenseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'licenseId',
        value: [licenseId],
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterWhereClause>
      licenseIdNotEqualTo(String licenseId) {
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

extension LicenseRecordQueryFilter
    on QueryBuilder<LicenseRecord, LicenseRecord, QFilterCondition> {
  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      amountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      amountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      amountEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      amountGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      amountLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      amountBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      currencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      currencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      currencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      currencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'devicePrefix',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'devicePrefix',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'devicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'devicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'devicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'devicePrefix',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'devicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'devicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'devicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'devicePrefix',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'devicePrefix',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      devicePrefixIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'devicePrefix',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      expiresAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      expiresAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      expiresAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      expiresAtLessThan(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      expiresAtBetween(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'holderEmail',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'holderEmail',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderEmailEqualTo(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderEmailLessThan(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderEmailBetween(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderEmailEndsWith(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'holderEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'holderEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'holderEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'holderEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderNameEqualTo(
    String value, {
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderNameGreaterThan(
    String value, {
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderNameLessThan(
    String value, {
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderNameBetween(
    String lower,
    String upper, {
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderNameEndsWith(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'holderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'holderName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'holderName',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'holderName',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'holderPhone',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'holderPhone',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'holderPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'holderPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'holderPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'holderPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'holderPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'holderPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'holderPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'holderPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'holderPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      holderPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'holderPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      issuedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'issuedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      issuedAtGreaterThan(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      issuedAtLessThan(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      issuedAtBetween(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licenseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'licenseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'licenseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'licenseCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'licenseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'licenseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'licenseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'licenseCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licenseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'licenseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseIdEqualTo(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseIdLessThan(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseIdBetween(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseIdStartsWith(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseIdEndsWith(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'licenseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'licenseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licenseId',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      licenseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'licenseId',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      revokedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revoked',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      sharedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shared',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition> typeEqualTo(
      LicenseType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      typeGreaterThan(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition>
      typeLessThan(
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

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterFilterCondition> typeBetween(
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

extension LicenseRecordQueryObject
    on QueryBuilder<LicenseRecord, LicenseRecord, QFilterCondition> {}

extension LicenseRecordQueryLinks
    on QueryBuilder<LicenseRecord, LicenseRecord, QFilterCondition> {}

extension LicenseRecordQuerySortBy
    on QueryBuilder<LicenseRecord, LicenseRecord, QSortBy> {
  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      sortByDevicePrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devicePrefix', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      sortByDevicePrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devicePrefix', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByHolderEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderEmail', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      sortByHolderEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderEmail', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByHolderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderName', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      sortByHolderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderName', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByHolderPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderPhone', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      sortByHolderPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderPhone', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByIssuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      sortByIssuedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByLicenseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseCode', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      sortByLicenseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseCode', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByLicenseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseId', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      sortByLicenseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseId', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByRevoked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revoked', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByRevokedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revoked', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByShared() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shared', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortBySharedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shared', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension LicenseRecordQuerySortThenBy
    on QueryBuilder<LicenseRecord, LicenseRecord, QSortThenBy> {
  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      thenByDevicePrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devicePrefix', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      thenByDevicePrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'devicePrefix', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByHolderEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderEmail', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      thenByHolderEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderEmail', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByHolderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderName', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      thenByHolderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderName', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByHolderPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderPhone', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      thenByHolderPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holderPhone', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByIssuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      thenByIssuedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issuedAt', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByLicenseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseCode', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      thenByLicenseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseCode', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByLicenseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseId', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy>
      thenByLicenseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseId', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByRevoked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revoked', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByRevokedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revoked', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByShared() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shared', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenBySharedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shared', Sort.desc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension LicenseRecordQueryWhereDistinct
    on QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> {
  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByCurrency(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByDevicePrefix(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'devicePrefix', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByHolderEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'holderEmail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByHolderName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'holderName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByHolderPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'holderPhone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByIssuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'issuedAt');
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByLicenseCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'licenseCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByLicenseId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'licenseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByRevoked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'revoked');
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByShared() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shared');
    });
  }

  QueryBuilder<LicenseRecord, LicenseRecord, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension LicenseRecordQueryProperty
    on QueryBuilder<LicenseRecord, LicenseRecord, QQueryProperty> {
  QueryBuilder<LicenseRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LicenseRecord, double?, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<LicenseRecord, String, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<LicenseRecord, String?, QQueryOperations>
      devicePrefixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'devicePrefix');
    });
  }

  QueryBuilder<LicenseRecord, DateTime?, QQueryOperations> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<LicenseRecord, String?, QQueryOperations> holderEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'holderEmail');
    });
  }

  QueryBuilder<LicenseRecord, String, QQueryOperations> holderNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'holderName');
    });
  }

  QueryBuilder<LicenseRecord, String?, QQueryOperations> holderPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'holderPhone');
    });
  }

  QueryBuilder<LicenseRecord, DateTime, QQueryOperations> issuedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'issuedAt');
    });
  }

  QueryBuilder<LicenseRecord, String, QQueryOperations> licenseCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'licenseCode');
    });
  }

  QueryBuilder<LicenseRecord, String, QQueryOperations> licenseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'licenseId');
    });
  }

  QueryBuilder<LicenseRecord, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<LicenseRecord, bool, QQueryOperations> revokedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'revoked');
    });
  }

  QueryBuilder<LicenseRecord, bool, QQueryOperations> sharedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shared');
    });
  }

  QueryBuilder<LicenseRecord, LicenseType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
