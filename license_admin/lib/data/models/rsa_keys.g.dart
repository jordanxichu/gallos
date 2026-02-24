// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rsa_keys.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRsaKeysCollection on Isar {
  IsarCollection<RsaKeys> get rsaKeys => this.collection();
}

const RsaKeysSchema = CollectionSchema(
  name: r'RsaKeys',
  id: -200461174965063455,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'label': PropertySchema(
      id: 1,
      name: r'label',
      type: IsarType.string,
    ),
    r'privateKeyPem': PropertySchema(
      id: 2,
      name: r'privateKeyPem',
      type: IsarType.string,
    ),
    r'publicKeyPem': PropertySchema(
      id: 3,
      name: r'publicKeyPem',
      type: IsarType.string,
    )
  },
  estimateSize: _rsaKeysEstimateSize,
  serialize: _rsaKeysSerialize,
  deserialize: _rsaKeysDeserialize,
  deserializeProp: _rsaKeysDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _rsaKeysGetId,
  getLinks: _rsaKeysGetLinks,
  attach: _rsaKeysAttach,
  version: '3.1.0+1',
);

int _rsaKeysEstimateSize(
  RsaKeys object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.label;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.privateKeyPem.length * 3;
  bytesCount += 3 + object.publicKeyPem.length * 3;
  return bytesCount;
}

void _rsaKeysSerialize(
  RsaKeys object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.label);
  writer.writeString(offsets[2], object.privateKeyPem);
  writer.writeString(offsets[3], object.publicKeyPem);
}

RsaKeys _rsaKeysDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RsaKeys();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.label = reader.readStringOrNull(offsets[1]);
  object.privateKeyPem = reader.readString(offsets[2]);
  object.publicKeyPem = reader.readString(offsets[3]);
  return object;
}

P _rsaKeysDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _rsaKeysGetId(RsaKeys object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _rsaKeysGetLinks(RsaKeys object) {
  return [];
}

void _rsaKeysAttach(IsarCollection<dynamic> col, Id id, RsaKeys object) {
  object.id = id;
}

extension RsaKeysQueryWhereSort on QueryBuilder<RsaKeys, RsaKeys, QWhere> {
  QueryBuilder<RsaKeys, RsaKeys, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RsaKeysQueryWhere on QueryBuilder<RsaKeys, RsaKeys, QWhereClause> {
  QueryBuilder<RsaKeys, RsaKeys, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<RsaKeys, RsaKeys, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterWhereClause> idBetween(
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
}

extension RsaKeysQueryFilter
    on QueryBuilder<RsaKeys, RsaKeys, QFilterCondition> {
  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'label',
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'label',
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> privateKeyPemEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privateKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition>
      privateKeyPemGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'privateKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> privateKeyPemLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'privateKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> privateKeyPemBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'privateKeyPem',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> privateKeyPemStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'privateKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> privateKeyPemEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'privateKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> privateKeyPemContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'privateKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> privateKeyPemMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'privateKeyPem',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> privateKeyPemIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'privateKeyPem',
        value: '',
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition>
      privateKeyPemIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'privateKeyPem',
        value: '',
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> publicKeyPemEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publicKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> publicKeyPemGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'publicKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> publicKeyPemLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'publicKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> publicKeyPemBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'publicKeyPem',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> publicKeyPemStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'publicKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> publicKeyPemEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'publicKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> publicKeyPemContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'publicKeyPem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> publicKeyPemMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'publicKeyPem',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition> publicKeyPemIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publicKeyPem',
        value: '',
      ));
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterFilterCondition>
      publicKeyPemIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'publicKeyPem',
        value: '',
      ));
    });
  }
}

extension RsaKeysQueryObject
    on QueryBuilder<RsaKeys, RsaKeys, QFilterCondition> {}

extension RsaKeysQueryLinks
    on QueryBuilder<RsaKeys, RsaKeys, QFilterCondition> {}

extension RsaKeysQuerySortBy on QueryBuilder<RsaKeys, RsaKeys, QSortBy> {
  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> sortByPrivateKeyPem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privateKeyPem', Sort.asc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> sortByPrivateKeyPemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privateKeyPem', Sort.desc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> sortByPublicKeyPem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicKeyPem', Sort.asc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> sortByPublicKeyPemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicKeyPem', Sort.desc);
    });
  }
}

extension RsaKeysQuerySortThenBy
    on QueryBuilder<RsaKeys, RsaKeys, QSortThenBy> {
  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> thenByPrivateKeyPem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privateKeyPem', Sort.asc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> thenByPrivateKeyPemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'privateKeyPem', Sort.desc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> thenByPublicKeyPem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicKeyPem', Sort.asc);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QAfterSortBy> thenByPublicKeyPemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicKeyPem', Sort.desc);
    });
  }
}

extension RsaKeysQueryWhereDistinct
    on QueryBuilder<RsaKeys, RsaKeys, QDistinct> {
  QueryBuilder<RsaKeys, RsaKeys, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QDistinct> distinctByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QDistinct> distinctByPrivateKeyPem(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'privateKeyPem',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RsaKeys, RsaKeys, QDistinct> distinctByPublicKeyPem(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'publicKeyPem', caseSensitive: caseSensitive);
    });
  }
}

extension RsaKeysQueryProperty
    on QueryBuilder<RsaKeys, RsaKeys, QQueryProperty> {
  QueryBuilder<RsaKeys, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RsaKeys, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<RsaKeys, String?, QQueryOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<RsaKeys, String, QQueryOperations> privateKeyPemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'privateKeyPem');
    });
  }

  QueryBuilder<RsaKeys, String, QQueryOperations> publicKeyPemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publicKeyPem');
    });
  }
}
