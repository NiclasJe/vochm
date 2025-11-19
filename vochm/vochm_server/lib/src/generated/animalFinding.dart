/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class AnimalFinding
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AnimalFinding._({
    this.id,
    required this.animalId,
    required this.latitude,
    required this.longitude,
  });

  factory AnimalFinding({
    int? id,
    required int animalId,
    required double latitude,
    required double longitude,
  }) = _AnimalFindingImpl;

  factory AnimalFinding.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnimalFinding(
      id: jsonSerialization['id'] as int?,
      animalId: jsonSerialization['animalId'] as int,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
    );
  }

  static final t = AnimalFindingTable();

  static const db = AnimalFindingRepository._();

  @override
  int? id;

  int animalId;

  double latitude;

  double longitude;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AnimalFinding]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnimalFinding copyWith({
    int? id,
    int? animalId,
    double? latitude,
    double? longitude,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'animalId': animalId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'animalId': animalId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static AnimalFindingInclude include() {
    return AnimalFindingInclude._();
  }

  static AnimalFindingIncludeList includeList({
    _i1.WhereExpressionBuilder<AnimalFindingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnimalFindingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnimalFindingTable>? orderByList,
    AnimalFindingInclude? include,
  }) {
    return AnimalFindingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnimalFinding.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AnimalFinding.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnimalFindingImpl extends AnimalFinding {
  _AnimalFindingImpl({
    int? id,
    required int animalId,
    required double latitude,
    required double longitude,
  }) : super._(
          id: id,
          animalId: animalId,
          latitude: latitude,
          longitude: longitude,
        );

  /// Returns a shallow copy of this [AnimalFinding]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnimalFinding copyWith({
    Object? id = _Undefined,
    int? animalId,
    double? latitude,
    double? longitude,
  }) {
    return AnimalFinding(
      id: id is int? ? id : this.id,
      animalId: animalId ?? this.animalId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class AnimalFindingTable extends _i1.Table<int?> {
  AnimalFindingTable({super.tableRelation})
      : super(tableName: 'animal_findings') {
    animalId = _i1.ColumnInt(
      'animalId',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
  }

  late final _i1.ColumnInt animalId;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  @override
  List<_i1.Column> get columns => [
        id,
        animalId,
        latitude,
        longitude,
      ];
}

class AnimalFindingInclude extends _i1.IncludeObject {
  AnimalFindingInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AnimalFinding.t;
}

class AnimalFindingIncludeList extends _i1.IncludeList {
  AnimalFindingIncludeList._({
    _i1.WhereExpressionBuilder<AnimalFindingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AnimalFinding.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AnimalFinding.t;
}

class AnimalFindingRepository {
  const AnimalFindingRepository._();

  /// Returns a list of [AnimalFinding]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<AnimalFinding>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnimalFindingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnimalFindingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnimalFindingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AnimalFinding>(
      where: where?.call(AnimalFinding.t),
      orderBy: orderBy?.call(AnimalFinding.t),
      orderByList: orderByList?.call(AnimalFinding.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AnimalFinding] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<AnimalFinding?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnimalFindingTable>? where,
    int? offset,
    _i1.OrderByBuilder<AnimalFindingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnimalFindingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AnimalFinding>(
      where: where?.call(AnimalFinding.t),
      orderBy: orderBy?.call(AnimalFinding.t),
      orderByList: orderByList?.call(AnimalFinding.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AnimalFinding] by its [id] or null if no such row exists.
  Future<AnimalFinding?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AnimalFinding>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AnimalFinding]s in the list and returns the inserted rows.
  ///
  /// The returned [AnimalFinding]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AnimalFinding>> insert(
    _i1.Session session,
    List<AnimalFinding> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AnimalFinding>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AnimalFinding] and returns the inserted row.
  ///
  /// The returned [AnimalFinding] will have its `id` field set.
  Future<AnimalFinding> insertRow(
    _i1.Session session,
    AnimalFinding row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AnimalFinding>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AnimalFinding]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AnimalFinding>> update(
    _i1.Session session,
    List<AnimalFinding> rows, {
    _i1.ColumnSelections<AnimalFindingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AnimalFinding>(
      rows,
      columns: columns?.call(AnimalFinding.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnimalFinding]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AnimalFinding> updateRow(
    _i1.Session session,
    AnimalFinding row, {
    _i1.ColumnSelections<AnimalFindingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AnimalFinding>(
      row,
      columns: columns?.call(AnimalFinding.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AnimalFinding]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AnimalFinding>> delete(
    _i1.Session session,
    List<AnimalFinding> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AnimalFinding>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AnimalFinding].
  Future<AnimalFinding> deleteRow(
    _i1.Session session,
    AnimalFinding row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AnimalFinding>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AnimalFinding>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnimalFindingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AnimalFinding>(
      where: where(AnimalFinding.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnimalFindingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AnimalFinding>(
      where: where?.call(AnimalFinding.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
