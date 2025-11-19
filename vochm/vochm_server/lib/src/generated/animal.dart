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

abstract class Animal implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Animal._({
    this.id,
    required this.name,
  });

  factory Animal({
    int? id,
    required String name,
  }) = _AnimalImpl;

  factory Animal.fromJson(Map<String, dynamic> jsonSerialization) {
    return Animal(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
    );
  }

  static final t = AnimalTable();

  static const db = AnimalRepository._();

  @override
  int? id;

  String name;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Animal]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Animal copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  static AnimalInclude include() {
    return AnimalInclude._();
  }

  static AnimalIncludeList includeList({
    _i1.WhereExpressionBuilder<AnimalTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnimalTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnimalTable>? orderByList,
    AnimalInclude? include,
  }) {
    return AnimalIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Animal.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Animal.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnimalImpl extends Animal {
  _AnimalImpl({
    int? id,
    required String name,
  }) : super._(
          id: id,
          name: name,
        );

  /// Returns a shallow copy of this [Animal]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Animal copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return Animal(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}

class AnimalTable extends _i1.Table<int?> {
  AnimalTable({super.tableRelation}) : super(tableName: 'animals') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];
}

class AnimalInclude extends _i1.IncludeObject {
  AnimalInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Animal.t;
}

class AnimalIncludeList extends _i1.IncludeList {
  AnimalIncludeList._({
    _i1.WhereExpressionBuilder<AnimalTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Animal.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Animal.t;
}

class AnimalRepository {
  const AnimalRepository._();

  /// Returns a list of [Animal]s matching the given query parameters.
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
  Future<List<Animal>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnimalTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnimalTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnimalTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Animal>(
      where: where?.call(Animal.t),
      orderBy: orderBy?.call(Animal.t),
      orderByList: orderByList?.call(Animal.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Animal] matching the given query parameters.
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
  Future<Animal?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnimalTable>? where,
    int? offset,
    _i1.OrderByBuilder<AnimalTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnimalTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Animal>(
      where: where?.call(Animal.t),
      orderBy: orderBy?.call(Animal.t),
      orderByList: orderByList?.call(Animal.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Animal] by its [id] or null if no such row exists.
  Future<Animal?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Animal>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Animal]s in the list and returns the inserted rows.
  ///
  /// The returned [Animal]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Animal>> insert(
    _i1.Session session,
    List<Animal> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Animal>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Animal] and returns the inserted row.
  ///
  /// The returned [Animal] will have its `id` field set.
  Future<Animal> insertRow(
    _i1.Session session,
    Animal row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Animal>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Animal]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Animal>> update(
    _i1.Session session,
    List<Animal> rows, {
    _i1.ColumnSelections<AnimalTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Animal>(
      rows,
      columns: columns?.call(Animal.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Animal]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Animal> updateRow(
    _i1.Session session,
    Animal row, {
    _i1.ColumnSelections<AnimalTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Animal>(
      row,
      columns: columns?.call(Animal.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Animal]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Animal>> delete(
    _i1.Session session,
    List<Animal> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Animal>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Animal].
  Future<Animal> deleteRow(
    _i1.Session session,
    Animal row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Animal>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Animal>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnimalTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Animal>(
      where: where(Animal.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnimalTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Animal>(
      where: where?.call(Animal.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
