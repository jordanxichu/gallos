// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participante_db.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetParticipanteDbCollection on Isar {
  IsarCollection<ParticipanteDb> get participanteDbs => this.collection();
}

const ParticipanteDbSchema = CollectionSchema(
  name: r'ParticipanteDb',
  id: 8446553726317401070,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'equipo': PropertySchema(
      id: 1,
      name: r'equipo',
      type: IsarType.string,
    ),
    r'nombre': PropertySchema(
      id: 2,
      name: r'nombre',
      type: IsarType.string,
    ),
    r'peleasEmpatadas': PropertySchema(
      id: 3,
      name: r'peleasEmpatadas',
      type: IsarType.long,
    ),
    r'peleasGanadas': PropertySchema(
      id: 4,
      name: r'peleasGanadas',
      type: IsarType.long,
    ),
    r'peleasPerdidas': PropertySchema(
      id: 5,
      name: r'peleasPerdidas',
      type: IsarType.long,
    ),
    r'puntosTotales': PropertySchema(
      id: 6,
      name: r'puntosTotales',
      type: IsarType.long,
    ),
    r'telefono': PropertySchema(
      id: 7,
      name: r'telefono',
      type: IsarType.string,
    ),
    r'uid': PropertySchema(
      id: 8,
      name: r'uid',
      type: IsarType.string,
    )
  },
  estimateSize: _participanteDbEstimateSize,
  serialize: _participanteDbSerialize,
  deserialize: _participanteDbDeserialize,
  deserializeProp: _participanteDbDeserializeProp,
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
  getId: _participanteDbGetId,
  getLinks: _participanteDbGetLinks,
  attach: _participanteDbAttach,
  version: '3.1.0+1',
);

int _participanteDbEstimateSize(
  ParticipanteDb object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.equipo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.nombre.length * 3;
  {
    final value = object.telefono;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _participanteDbSerialize(
  ParticipanteDb object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.equipo);
  writer.writeString(offsets[2], object.nombre);
  writer.writeLong(offsets[3], object.peleasEmpatadas);
  writer.writeLong(offsets[4], object.peleasGanadas);
  writer.writeLong(offsets[5], object.peleasPerdidas);
  writer.writeLong(offsets[6], object.puntosTotales);
  writer.writeString(offsets[7], object.telefono);
  writer.writeString(offsets[8], object.uid);
}

ParticipanteDb _participanteDbDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ParticipanteDb();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.equipo = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.nombre = reader.readString(offsets[2]);
  object.peleasEmpatadas = reader.readLong(offsets[3]);
  object.peleasGanadas = reader.readLong(offsets[4]);
  object.peleasPerdidas = reader.readLong(offsets[5]);
  object.puntosTotales = reader.readLong(offsets[6]);
  object.telefono = reader.readStringOrNull(offsets[7]);
  object.uid = reader.readString(offsets[8]);
  return object;
}

P _participanteDbDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _participanteDbGetId(ParticipanteDb object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _participanteDbGetLinks(ParticipanteDb object) {
  return [];
}

void _participanteDbAttach(
    IsarCollection<dynamic> col, Id id, ParticipanteDb object) {
  object.id = id;
}

extension ParticipanteDbByIndex on IsarCollection<ParticipanteDb> {
  Future<ParticipanteDb?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  ParticipanteDb? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<ParticipanteDb?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<ParticipanteDb?> getAllByUidSync(List<String> uidValues) {
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

  Future<Id> putByUid(ParticipanteDb object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(ParticipanteDb object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<ParticipanteDb> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<ParticipanteDb> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension ParticipanteDbQueryWhereSort
    on QueryBuilder<ParticipanteDb, ParticipanteDb, QWhere> {
  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ParticipanteDbQueryWhere
    on QueryBuilder<ParticipanteDb, ParticipanteDb, QWhereClause> {
  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterWhereClause> idBetween(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterWhereClause> uidEqualTo(
      String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterWhereClause> uidNotEqualTo(
      String uid) {
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

extension ParticipanteDbQueryFilter
    on QueryBuilder<ParticipanteDb, ParticipanteDb, QFilterCondition> {
  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'equipo',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'equipo',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'equipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'equipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'equipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'equipo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'equipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'equipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'equipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'equipo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'equipo',
        value: '',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      equipoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'equipo',
        value: '',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      nombreEqualTo(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      nombreGreaterThan(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      nombreLessThan(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      nombreBetween(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      nombreStartsWith(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      nombreEndsWith(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      nombreContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      nombreMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nombre',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      nombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      nombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasEmpatadasEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peleasEmpatadas',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasEmpatadasGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peleasEmpatadas',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasEmpatadasLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peleasEmpatadas',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasEmpatadasBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peleasEmpatadas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasGanadasEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peleasGanadas',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasGanadasGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peleasGanadas',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasGanadasLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peleasGanadas',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasGanadasBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peleasGanadas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasPerdidasEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peleasPerdidas',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasPerdidasGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peleasPerdidas',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasPerdidasLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peleasPerdidas',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      peleasPerdidasBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peleasPerdidas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      puntosTotalesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'puntosTotales',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      puntosTotalesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'puntosTotales',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      puntosTotalesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'puntosTotales',
        value: value,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      puntosTotalesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'puntosTotales',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'telefono',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'telefono',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'telefono',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'telefono',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'telefono',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'telefono',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'telefono',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'telefono',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'telefono',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'telefono',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'telefono',
        value: '',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      telefonoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'telefono',
        value: '',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      uidEqualTo(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      uidGreaterThan(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      uidLessThan(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      uidBetween(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      uidStartsWith(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      uidEndsWith(
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

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      uidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      uidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterFilterCondition>
      uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }
}

extension ParticipanteDbQueryObject
    on QueryBuilder<ParticipanteDb, ParticipanteDb, QFilterCondition> {}

extension ParticipanteDbQueryLinks
    on QueryBuilder<ParticipanteDb, ParticipanteDb, QFilterCondition> {}

extension ParticipanteDbQuerySortBy
    on QueryBuilder<ParticipanteDb, ParticipanteDb, QSortBy> {
  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> sortByEquipo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipo', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByEquipoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipo', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> sortByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByPeleasEmpatadas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasEmpatadas', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByPeleasEmpatadasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasEmpatadas', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByPeleasGanadas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasGanadas', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByPeleasGanadasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasGanadas', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByPeleasPerdidas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasPerdidas', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByPeleasPerdidasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasPerdidas', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByPuntosTotales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosTotales', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByPuntosTotalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosTotales', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> sortByTelefono() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telefono', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      sortByTelefonoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telefono', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension ParticipanteDbQuerySortThenBy
    on QueryBuilder<ParticipanteDb, ParticipanteDb, QSortThenBy> {
  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> thenByEquipo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipo', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByEquipoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipo', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> thenByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByPeleasEmpatadas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasEmpatadas', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByPeleasEmpatadasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasEmpatadas', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByPeleasGanadas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasGanadas', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByPeleasGanadasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasGanadas', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByPeleasPerdidas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasPerdidas', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByPeleasPerdidasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peleasPerdidas', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByPuntosTotales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosTotales', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByPuntosTotalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'puntosTotales', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> thenByTelefono() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telefono', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy>
      thenByTelefonoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telefono', Sort.desc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension ParticipanteDbQueryWhereDistinct
    on QueryBuilder<ParticipanteDb, ParticipanteDb, QDistinct> {
  QueryBuilder<ParticipanteDb, ParticipanteDb, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QDistinct> distinctByEquipo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'equipo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QDistinct> distinctByNombre(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nombre', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QDistinct>
      distinctByPeleasEmpatadas() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peleasEmpatadas');
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QDistinct>
      distinctByPeleasGanadas() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peleasGanadas');
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QDistinct>
      distinctByPeleasPerdidas() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peleasPerdidas');
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QDistinct>
      distinctByPuntosTotales() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'puntosTotales');
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QDistinct> distinctByTelefono(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'telefono', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParticipanteDb, ParticipanteDb, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension ParticipanteDbQueryProperty
    on QueryBuilder<ParticipanteDb, ParticipanteDb, QQueryProperty> {
  QueryBuilder<ParticipanteDb, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ParticipanteDb, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ParticipanteDb, String?, QQueryOperations> equipoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'equipo');
    });
  }

  QueryBuilder<ParticipanteDb, String, QQueryOperations> nombreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nombre');
    });
  }

  QueryBuilder<ParticipanteDb, int, QQueryOperations>
      peleasEmpatadasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peleasEmpatadas');
    });
  }

  QueryBuilder<ParticipanteDb, int, QQueryOperations> peleasGanadasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peleasGanadas');
    });
  }

  QueryBuilder<ParticipanteDb, int, QQueryOperations> peleasPerdidasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peleasPerdidas');
    });
  }

  QueryBuilder<ParticipanteDb, int, QQueryOperations> puntosTotalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'puntosTotales');
    });
  }

  QueryBuilder<ParticipanteDb, String?, QQueryOperations> telefonoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'telefono');
    });
  }

  QueryBuilder<ParticipanteDb, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}
