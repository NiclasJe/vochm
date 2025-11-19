/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class AnimalFinding implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int animalId;

  double latitude;

  double longitude;

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
