// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'derby_db.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDerbyDbCollection on Isar {
  IsarCollection<DerbyDb> get derbyDbs => this.collection();
}

const DerbyDbSchema = CollectionSchema(
  name: r'DerbyDb',
  id: 8831643225791775165,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'estado': PropertySchema(
      id: 1,
      name: r'estado',
      type: IsarType.string,
    ),
    r'fechaFin': PropertySchema(
      id: 2,
      name: r'fechaFin',
      type: IsarType.dateTime,
    ),
    r'fechaSorteo': PropertySchema(
      id: 3,
      name: r'fechaSorteo',
      type: IsarType.dateTime,
    ),
    r'lugar': PropertySchema(
      id: 4,
      name: r'lugar',
      type: IsarType.string,
    ),
    r'nombre': PropertySchema(
      id: 5,
      name: r'nombre',
      type: IsarType.string,
    ),
    r'numeroRondas': PropertySchema(
      id: 6,
      name: r'numeroRondas',
      type: IsarType.long,
    ),
    r'puntosDerrota': PropertySchema(
      id: 7,
      name: r'puntosDerrota',
      type: IsarType.long,
    ),
    r'puntosEmpate': PropertySchema(
      id: 8,
      name: r'puntosEmpate',
      type: IsarType.long,
    ),
    r'puntosVictoria': PropertySchema(
      id: 9,
      name: r'puntosVictoria',
      type: IsarType.long,
    ),
    r'toleranciaPeso': PropertySchema(
      id: 10,
      name: r'toleranciaPeso',
      type: IsarType.double,
    ),
    r'uid': PropertySchema(
      id: 11,
      name: r'uid',
      type: IsarType.string,
    )
  },
  estimateSize: _derbyDbEstimateSize,
  serialize: _derbyDbSerialize,
  deserialize: _derbyDbDeserialize,
  deserializeProp: _derbyDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _derbyDbGetId,
  getLinks: _derbyDbGetLinks,
  attach: _derbyDbAttach,
  version: '3.1.0+1',
);

int _derbyDbEstimateSize(
  DerbyDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.estado.length * 3;
  {
    final value = object.lugar;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.nombre.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _derbyDbSerialize(
  DerbyDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.estado);
  writer.writeDateTime(offsets[2], object.fechaFin);
  writer.writeDateTime(offsets[3], object.fechaSorteo);
  writer.writeString(offsets[4], object.lugar);
  writer.writeString(offsets[5], object.nombre);
  writer.writeLong(offsets[6], object.numeroRondas);
  writer.writeLong(offsets[7], object.puntosDerrota);
  writer.writeLong(offsets[8], object.puntosEmpate);
  writer.writeLong(offsets[9], object.puntosVictoria);
  writer.writeDouble(offsets[10], object.toleranciaPeso);
  writer.writeString(offsets[11], object.uid);
}

DerbyDb _derbyDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DerbyDb();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.estado = reader.readString(offsets[1]);
  object.fechaFin = reader.readDateTimeOrNull(offsets[2]);
  object.fechaSorteo = reader.readDateTimeOrNull(offsets[3]);
  object.id = id;
  object.lugar = reader.readStringOrNull(offsets[4]);
  object.nombre = reader.readString(offsets[5]);
  object.numeroRondas = reader.readLong(offsets[6]);
  object.puntosDerrota = reader.readLong(offsets[7]);
  object.puntosEmpate = reader.readLong(offsets[8]);
  object.puntosVictoria = reader.readLong(offsets[9]);
  object.toleranciaPeso = reader.readDouble(offsets[10]);
  object.uid = reader.readString(offsets[11]);
  return object;
}

P _derbyDbDeserializeProp<P>(
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
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _derbyDbGetId(DerbyDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _derbyDbGetLinks(DerbyDb object) {
  return [];
}

void _derbyDbAttach(IsarCollection<dynamic> col, Id id, DerbyDb object) {
  object.id = id;
}

extension DerbyDbByIndex on IsarCollection<DerbyDb> {
  Future<DerbyDb?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  DerbyDb? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<DerbyDb?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<DerbyDb?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(DerbyDb object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(DerbyDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<DerbyDb> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<DerbyDb> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension DerbyDbQueryWhereSort on QueryBuilder<DerbyDb, DerbyDb, QWhere> {
  QueryBuilder<DerbyDb, DerbyDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DerbyDbQueryWhere on QueryBuilder<DerbyDb, DerbyDb, QWhereClause> {
  QueryBuilder<DerbyDb, DerbyDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DerbyDb, DerbyDb, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterWhereClause> idBetween(
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

  QueryBuilder<DerbyDb, DerbyDb, QAfterWhereClause> uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterWhereClause> uidNotEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DerbyDbQueryFilter
    on QueryBuilder<DerbyDb, DerbyDb, QFilterCondition> {
  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> estadoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> estadoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> estadoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> estadoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> estadoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> estadoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> estadoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> estadoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'estado',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> estadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: '',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> estadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'estado',
        value: '',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaFinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fechaFin',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaFinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fechaFin',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaFinEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fechaFin',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaFinGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fechaFin',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaFinLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fechaFin',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaFinBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fechaFin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaSorteoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fechaSorteo',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaSorteoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fechaSorteo',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaSorteoEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fechaSorteo',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaSorteoGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fechaSorteo',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaSorteoLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fechaSorteo',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> fechaSorteoBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fechaSorteo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lugar',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lugar',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lugar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lugar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lugar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lugar',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lugar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lugar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lugar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lugar',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lugar',
        value: '',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> lugarIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lugar',
        value: '',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> nombreEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> nombreGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> nombreLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> nombreBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nombre',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> nombreStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> nombreEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> nombreContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> nombreMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nombre',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> nombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> nombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> numeroRondasEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numeroRondas',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> numeroRondasGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numeroRondas',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> numeroRondasLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numeroRondas',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> numeroRondasBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numeroRondas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> puntosDerrotaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puntosDerrota',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition>
      puntosDerrotaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'puntosDerrota',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> puntosDerrotaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'puntosDerrota',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> puntosDerrotaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'puntosDerrota',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> puntosEmpateEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puntosEmpate',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> puntosEmpateGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'puntosEmpate',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> puntosEmpateLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'puntosEmpate',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> puntosEmpateBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'puntosEmpate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> puntosVictoriaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puntosVictoria',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition>
      puntosVictoriaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'puntosVictoria',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> puntosVictoriaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'puntosVictoria',
        value: value,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> puntosVictoriaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'puntosVictoria',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> toleranciaPesoEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toleranciaPeso',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition>
      toleranciaPesoGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toleranciaPeso',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> toleranciaPesoLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toleranciaPeso',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> toleranciaPesoBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toleranciaPeso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> uidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> uidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterFilterCondition> uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }
}

extension DerbyDbQueryObject
    on QueryBuilder<DerbyDb, DerbyDb, QFilterCondition> {}

extension DerbyDbQueryLinks
    on QueryBuilder<DerbyDb, DerbyDb, QFilterCondition> {}

extension DerbyDbQuerySortBy on QueryBuilder<DerbyDb, DerbyDb, QSortBy> {
  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByFechaFin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaFin', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByFechaFinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaFin', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByFechaSorteo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaSorteo', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByFechaSorteoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaSorteo', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByLugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lugar', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByLugarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lugar', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByNumeroRondas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroRondas', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByNumeroRondasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroRondas', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByPuntosDerrota() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosDerrota', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByPuntosDerrotaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosDerrota', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByPuntosEmpate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosEmpate', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByPuntosEmpateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosEmpate', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByPuntosVictoria() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosVictoria', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByPuntosVictoriaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosVictoria', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByToleranciaPeso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toleranciaPeso', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByToleranciaPesoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toleranciaPeso', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension DerbyDbQuerySortThenBy
    on QueryBuilder<DerbyDb, DerbyDb, QSortThenBy> {
  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByFechaFin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaFin', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByFechaFinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaFin', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByFechaSorteo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaSorteo', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByFechaSorteoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaSorteo', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByLugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lugar', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByLugarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lugar', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByNumeroRondas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroRondas', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByNumeroRondasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroRondas', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByPuntosDerrota() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosDerrota', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByPuntosDerrotaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosDerrota', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByPuntosEmpate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosEmpate', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByPuntosEmpateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosEmpate', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByPuntosVictoria() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosVictoria', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByPuntosVictoriaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosVictoria', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByToleranciaPeso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toleranciaPeso', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByToleranciaPesoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toleranciaPeso', Sort.desc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension DerbyDbQueryWhereDistinct
    on QueryBuilder<DerbyDb, DerbyDb, QDistinct> {
  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByEstado(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estado', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByFechaFin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fechaFin');
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByFechaSorteo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fechaSorteo');
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByLugar(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lugar', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByNombre(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nombre', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByNumeroRondas() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numeroRondas');
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByPuntosDerrota() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'puntosDerrota');
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByPuntosEmpate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'puntosEmpate');
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByPuntosVictoria() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'puntosVictoria');
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByToleranciaPeso() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toleranciaPeso');
    });
  }

  QueryBuilder<DerbyDb, DerbyDb, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension DerbyDbQueryProperty
    on QueryBuilder<DerbyDb, DerbyDb, QQueryProperty> {
  QueryBuilder<DerbyDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DerbyDb, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DerbyDb, String, QQueryOperations> estadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estado');
    });
  }

  QueryBuilder<DerbyDb, DateTime?, QQueryOperations> fechaFinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fechaFin');
    });
  }

  QueryBuilder<DerbyDb, DateTime?, QQueryOperations> fechaSorteoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fechaSorteo');
    });
  }

  QueryBuilder<DerbyDb, String?, QQueryOperations> lugarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lugar');
    });
  }

  QueryBuilder<DerbyDb, String, QQueryOperations> nombreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nombre');
    });
  }

  QueryBuilder<DerbyDb, int, QQueryOperations> numeroRondasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numeroRondas');
    });
  }

  QueryBuilder<DerbyDb, int, QQueryOperations> puntosDerrotaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'puntosDerrota');
    });
  }

  QueryBuilder<DerbyDb, int, QQueryOperations> puntosEmpateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'puntosEmpate');
    });
  }

  QueryBuilder<DerbyDb, int, QQueryOperations> puntosVictoriaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'puntosVictoria');
    });
  }

  QueryBuilder<DerbyDb, double, QQueryOperations> toleranciaPesoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toleranciaPeso');
    });
  }

  QueryBuilder<DerbyDb, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRondaDbCollection on Isar {
  IsarCollection<RondaDb> get rondaDbs => this.collection();
}

const RondaDbSchema = CollectionSchema(
  name: r'RondaDb',
  id: 1617189654214308231,
  properties: {
    r'bloqueada': PropertySchema(
      id: 0,
      name: r'bloqueada',
      type: IsarType.bool,
    ),
    r'derbyId': PropertySchema(
      id: 1,
      name: r'derbyId',
      type: IsarType.string,
    ),
    r'estado': PropertySchema(
      id: 2,
      name: r'estado',
      type: IsarType.string,
    ),
    r'fechaGeneracion': PropertySchema(
      id: 3,
      name: r'fechaGeneracion',
      type: IsarType.dateTime,
    ),
    r'numero': PropertySchema(
      id: 4,
      name: r'numero',
      type: IsarType.long,
    ),
    r'uid': PropertySchema(
      id: 5,
      name: r'uid',
      type: IsarType.string,
    )
  },
  estimateSize: _rondaDbEstimateSize,
  serialize: _rondaDbSerialize,
  deserialize: _rondaDbDeserialize,
  deserializeProp: _rondaDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'derbyId': IndexSchema(
      id: -5896148082954423910,
      name: r'derbyId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'derbyId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _rondaDbGetId,
  getLinks: _rondaDbGetLinks,
  attach: _rondaDbAttach,
  version: '3.1.0+1',
);

int _rondaDbEstimateSize(
  RondaDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.derbyId.length * 3;
  bytesCount += 3 + object.estado.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _rondaDbSerialize(
  RondaDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.bloqueada);
  writer.writeString(offsets[1], object.derbyId);
  writer.writeString(offsets[2], object.estado);
  writer.writeDateTime(offsets[3], object.fechaGeneracion);
  writer.writeLong(offsets[4], object.numero);
  writer.writeString(offsets[5], object.uid);
}

RondaDb _rondaDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RondaDb();
  object.bloqueada = reader.readBool(offsets[0]);
  object.derbyId = reader.readString(offsets[1]);
  object.estado = reader.readString(offsets[2]);
  object.fechaGeneracion = reader.readDateTimeOrNull(offsets[3]);
  object.id = id;
  object.numero = reader.readLong(offsets[4]);
  object.uid = reader.readString(offsets[5]);
  return object;
}

P _rondaDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _rondaDbGetId(RondaDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _rondaDbGetLinks(RondaDb object) {
  return [];
}

void _rondaDbAttach(IsarCollection<dynamic> col, Id id, RondaDb object) {
  object.id = id;
}

extension RondaDbByIndex on IsarCollection<RondaDb> {
  Future<RondaDb?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  RondaDb? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<RondaDb?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<RondaDb?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(RondaDb object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(RondaDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<RondaDb> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<RondaDb> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension RondaDbQueryWhereSort on QueryBuilder<RondaDb, RondaDb, QWhere> {
  QueryBuilder<RondaDb, RondaDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RondaDbQueryWhere on QueryBuilder<RondaDb, RondaDb, QWhereClause> {
  QueryBuilder<RondaDb, RondaDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<RondaDb, RondaDb, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterWhereClause> idBetween(
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

  QueryBuilder<RondaDb, RondaDb, QAfterWhereClause> uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterWhereClause> uidNotEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterWhereClause> derbyIdEqualTo(
      String derbyId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'derbyId',
        value: [derbyId],
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterWhereClause> derbyIdNotEqualTo(
      String derbyId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'derbyId',
              lower: [],
              upper: [derbyId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'derbyId',
              lower: [derbyId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'derbyId',
              lower: [derbyId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'derbyId',
              lower: [],
              upper: [derbyId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RondaDbQueryFilter
    on QueryBuilder<RondaDb, RondaDb, QFilterCondition> {
  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> bloqueadaEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bloqueada',
        value: value,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> derbyIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derbyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> derbyIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'derbyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> derbyIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'derbyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> derbyIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'derbyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> derbyIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'derbyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> derbyIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'derbyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> derbyIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'derbyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> derbyIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'derbyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> derbyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derbyId',
        value: '',
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> derbyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'derbyId',
        value: '',
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> estadoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> estadoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> estadoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> estadoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> estadoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> estadoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> estadoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> estadoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'estado',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> estadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: '',
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> estadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'estado',
        value: '',
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition>
      fechaGeneracionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fechaGeneracion',
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition>
      fechaGeneracionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fechaGeneracion',
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> fechaGeneracionEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fechaGeneracion',
        value: value,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition>
      fechaGeneracionGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fechaGeneracion',
        value: value,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> fechaGeneracionLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fechaGeneracion',
        value: value,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> fechaGeneracionBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fechaGeneracion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> numeroEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numero',
        value: value,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> numeroGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numero',
        value: value,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> numeroLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numero',
        value: value,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> numeroBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numero',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> uidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> uidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterFilterCondition> uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }
}

extension RondaDbQueryObject
    on QueryBuilder<RondaDb, RondaDb, QFilterCondition> {}

extension RondaDbQueryLinks
    on QueryBuilder<RondaDb, RondaDb, QFilterCondition> {}

extension RondaDbQuerySortBy on QueryBuilder<RondaDb, RondaDb, QSortBy> {
  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByBloqueada() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bloqueada', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByBloqueadaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bloqueada', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByDerbyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derbyId', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByDerbyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derbyId', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByFechaGeneracion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaGeneracion', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByFechaGeneracionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaGeneracion', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByNumero() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByNumeroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension RondaDbQuerySortThenBy
    on QueryBuilder<RondaDb, RondaDb, QSortThenBy> {
  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByBloqueada() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bloqueada', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByBloqueadaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bloqueada', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByDerbyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derbyId', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByDerbyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derbyId', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByFechaGeneracion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaGeneracion', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByFechaGeneracionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaGeneracion', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByNumero() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByNumeroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.desc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension RondaDbQueryWhereDistinct
    on QueryBuilder<RondaDb, RondaDb, QDistinct> {
  QueryBuilder<RondaDb, RondaDb, QDistinct> distinctByBloqueada() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bloqueada');
    });
  }

  QueryBuilder<RondaDb, RondaDb, QDistinct> distinctByDerbyId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'derbyId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QDistinct> distinctByEstado(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estado', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RondaDb, RondaDb, QDistinct> distinctByFechaGeneracion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fechaGeneracion');
    });
  }

  QueryBuilder<RondaDb, RondaDb, QDistinct> distinctByNumero() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numero');
    });
  }

  QueryBuilder<RondaDb, RondaDb, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension RondaDbQueryProperty
    on QueryBuilder<RondaDb, RondaDb, QQueryProperty> {
  QueryBuilder<RondaDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RondaDb, bool, QQueryOperations> bloqueadaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bloqueada');
    });
  }

  QueryBuilder<RondaDb, String, QQueryOperations> derbyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'derbyId');
    });
  }

  QueryBuilder<RondaDb, String, QQueryOperations> estadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estado');
    });
  }

  QueryBuilder<RondaDb, DateTime?, QQueryOperations> fechaGeneracionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fechaGeneracion');
    });
  }

  QueryBuilder<RondaDb, int, QQueryOperations> numeroProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numero');
    });
  }

  QueryBuilder<RondaDb, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPeleaDbCollection on Isar {
  IsarCollection<PeleaDb> get peleaDbs => this.collection();
}

const PeleaDbSchema = CollectionSchema(
  name: r'PeleaDb',
  id: 6911306891685574419,
  properties: {
    r'duracionSegundos': PropertySchema(
      id: 0,
      name: r'duracionSegundos',
      type: IsarType.long,
    ),
    r'empate': PropertySchema(
      id: 1,
      name: r'empate',
      type: IsarType.bool,
    ),
    r'estado': PropertySchema(
      id: 2,
      name: r'estado',
      type: IsarType.string,
    ),
    r'galloRojoId': PropertySchema(
      id: 3,
      name: r'galloRojoId',
      type: IsarType.string,
    ),
    r'galloVerdeId': PropertySchema(
      id: 4,
      name: r'galloVerdeId',
      type: IsarType.string,
    ),
    r'ganadorId': PropertySchema(
      id: 5,
      name: r'ganadorId',
      type: IsarType.string,
    ),
    r'notas': PropertySchema(
      id: 6,
      name: r'notas',
      type: IsarType.string,
    ),
    r'numero': PropertySchema(
      id: 7,
      name: r'numero',
      type: IsarType.long,
    ),
    r'rondaId': PropertySchema(
      id: 8,
      name: r'rondaId',
      type: IsarType.string,
    ),
    r'uid': PropertySchema(
      id: 9,
      name: r'uid',
      type: IsarType.string,
    )
  },
  estimateSize: _peleaDbEstimateSize,
  serialize: _peleaDbSerialize,
  deserialize: _peleaDbDeserialize,
  deserializeProp: _peleaDbDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'rondaId': IndexSchema(
      id: 579998671803408765,
      name: r'rondaId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'rondaId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _peleaDbGetId,
  getLinks: _peleaDbGetLinks,
  attach: _peleaDbAttach,
  version: '3.1.0+1',
);

int _peleaDbEstimateSize(
  PeleaDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.estado.length * 3;
  bytesCount += 3 + object.galloRojoId.length * 3;
  bytesCount += 3 + object.galloVerdeId.length * 3;
  {
    final value = object.ganadorId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notas;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.rondaId.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _peleaDbSerialize(
  PeleaDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.duracionSegundos);
  writer.writeBool(offsets[1], object.empate);
  writer.writeString(offsets[2], object.estado);
  writer.writeString(offsets[3], object.galloRojoId);
  writer.writeString(offsets[4], object.galloVerdeId);
  writer.writeString(offsets[5], object.ganadorId);
  writer.writeString(offsets[6], object.notas);
  writer.writeLong(offsets[7], object.numero);
  writer.writeString(offsets[8], object.rondaId);
  writer.writeString(offsets[9], object.uid);
}

PeleaDb _peleaDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PeleaDb();
  object.duracionSegundos = reader.readLongOrNull(offsets[0]);
  object.empate = reader.readBool(offsets[1]);
  object.estado = reader.readString(offsets[2]);
  object.galloRojoId = reader.readString(offsets[3]);
  object.galloVerdeId = reader.readString(offsets[4]);
  object.ganadorId = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.notas = reader.readStringOrNull(offsets[6]);
  object.numero = reader.readLong(offsets[7]);
  object.rondaId = reader.readString(offsets[8]);
  object.uid = reader.readString(offsets[9]);
  return object;
}

P _peleaDbDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _peleaDbGetId(PeleaDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _peleaDbGetLinks(PeleaDb object) {
  return [];
}

void _peleaDbAttach(IsarCollection<dynamic> col, Id id, PeleaDb object) {
  object.id = id;
}

extension PeleaDbByIndex on IsarCollection<PeleaDb> {
  Future<PeleaDb?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  PeleaDb? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<PeleaDb?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<PeleaDb?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(PeleaDb object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(PeleaDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<PeleaDb> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<PeleaDb> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension PeleaDbQueryWhereSort on QueryBuilder<PeleaDb, PeleaDb, QWhere> {
  QueryBuilder<PeleaDb, PeleaDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PeleaDbQueryWhere on QueryBuilder<PeleaDb, PeleaDb, QWhereClause> {
  QueryBuilder<PeleaDb, PeleaDb, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PeleaDb, PeleaDb, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterWhereClause> idBetween(
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

  QueryBuilder<PeleaDb, PeleaDb, QAfterWhereClause> uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterWhereClause> uidNotEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterWhereClause> rondaIdEqualTo(
      String rondaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'rondaId',
        value: [rondaId],
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterWhereClause> rondaIdNotEqualTo(
      String rondaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rondaId',
              lower: [],
              upper: [rondaId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rondaId',
              lower: [rondaId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rondaId',
              lower: [rondaId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rondaId',
              lower: [],
              upper: [rondaId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PeleaDbQueryFilter
    on QueryBuilder<PeleaDb, PeleaDb, QFilterCondition> {
  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition>
      duracionSegundosIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'duracionSegundos',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition>
      duracionSegundosIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'duracionSegundos',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> duracionSegundosEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duracionSegundos',
        value: value,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition>
      duracionSegundosGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duracionSegundos',
        value: value,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition>
      duracionSegundosLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duracionSegundos',
        value: value,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> duracionSegundosBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duracionSegundos',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> empateEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'empate',
        value: value,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> estadoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> estadoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> estadoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> estadoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> estadoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> estadoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> estadoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> estadoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'estado',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> estadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> estadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'estado',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloRojoIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'galloRojoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloRojoIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'galloRojoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloRojoIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'galloRojoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloRojoIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'galloRojoId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloRojoIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'galloRojoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloRojoIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'galloRojoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloRojoIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'galloRojoId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloRojoIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'galloRojoId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloRojoIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'galloRojoId',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition>
      galloRojoIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'galloRojoId',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloVerdeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'galloVerdeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloVerdeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'galloVerdeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloVerdeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'galloVerdeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloVerdeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'galloVerdeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloVerdeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'galloVerdeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloVerdeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'galloVerdeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloVerdeIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'galloVerdeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloVerdeIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'galloVerdeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> galloVerdeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'galloVerdeId',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition>
      galloVerdeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'galloVerdeId',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ganadorId',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ganadorId',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ganadorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ganadorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ganadorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ganadorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ganadorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ganadorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ganadorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ganadorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ganadorId',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> ganadorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ganadorId',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notas',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notas',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notas',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notas',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> notasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notas',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> numeroEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numero',
        value: value,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> numeroGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numero',
        value: value,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> numeroLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numero',
        value: value,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> numeroBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numero',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> rondaIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rondaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> rondaIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rondaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> rondaIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rondaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> rondaIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rondaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> rondaIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rondaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> rondaIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rondaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> rondaIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rondaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> rondaIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rondaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> rondaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rondaId',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> rondaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rondaId',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> uidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> uidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterFilterCondition> uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }
}

extension PeleaDbQueryObject
    on QueryBuilder<PeleaDb, PeleaDb, QFilterCondition> {}

extension PeleaDbQueryLinks
    on QueryBuilder<PeleaDb, PeleaDb, QFilterCondition> {}

extension PeleaDbQuerySortBy on QueryBuilder<PeleaDb, PeleaDb, QSortBy> {
  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByDuracionSegundos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duracionSegundos', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByDuracionSegundosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duracionSegundos', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByEmpate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empate', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByEmpateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empate', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByGalloRojoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'galloRojoId', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByGalloRojoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'galloRojoId', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByGalloVerdeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'galloVerdeId', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByGalloVerdeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'galloVerdeId', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByGanadorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ganadorId', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByGanadorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ganadorId', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByNotas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notas', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByNotasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notas', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByNumero() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByNumeroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByRondaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rondaId', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByRondaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rondaId', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension PeleaDbQuerySortThenBy
    on QueryBuilder<PeleaDb, PeleaDb, QSortThenBy> {
  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByDuracionSegundos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duracionSegundos', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByDuracionSegundosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duracionSegundos', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByEmpate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empate', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByEmpateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empate', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByGalloRojoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'galloRojoId', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByGalloRojoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'galloRojoId', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByGalloVerdeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'galloVerdeId', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByGalloVerdeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'galloVerdeId', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByGanadorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ganadorId', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByGanadorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ganadorId', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByNotas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notas', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByNotasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notas', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByNumero() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByNumeroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numero', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByRondaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rondaId', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByRondaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rondaId', Sort.desc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension PeleaDbQueryWhereDistinct
    on QueryBuilder<PeleaDb, PeleaDb, QDistinct> {
  QueryBuilder<PeleaDb, PeleaDb, QDistinct> distinctByDuracionSegundos() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duracionSegundos');
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QDistinct> distinctByEmpate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'empate');
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QDistinct> distinctByEstado(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estado', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QDistinct> distinctByGalloRojoId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'galloRojoId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QDistinct> distinctByGalloVerdeId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'galloVerdeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QDistinct> distinctByGanadorId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ganadorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QDistinct> distinctByNotas(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notas', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QDistinct> distinctByNumero() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numero');
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QDistinct> distinctByRondaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rondaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PeleaDb, PeleaDb, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension PeleaDbQueryProperty
    on QueryBuilder<PeleaDb, PeleaDb, QQueryProperty> {
  QueryBuilder<PeleaDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PeleaDb, int?, QQueryOperations> duracionSegundosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duracionSegundos');
    });
  }

  QueryBuilder<PeleaDb, bool, QQueryOperations> empateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'empate');
    });
  }

  QueryBuilder<PeleaDb, String, QQueryOperations> estadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estado');
    });
  }

  QueryBuilder<PeleaDb, String, QQueryOperations> galloRojoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'galloRojoId');
    });
  }

  QueryBuilder<PeleaDb, String, QQueryOperations> galloVerdeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'galloVerdeId');
    });
  }

  QueryBuilder<PeleaDb, String?, QQueryOperations> ganadorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ganadorId');
    });
  }

  QueryBuilder<PeleaDb, String?, QQueryOperations> notasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notas');
    });
  }

  QueryBuilder<PeleaDb, int, QQueryOperations> numeroProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numero');
    });
  }

  QueryBuilder<PeleaDb, String, QQueryOperations> rondaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rondaId');
    });
  }

  QueryBuilder<PeleaDb, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}
