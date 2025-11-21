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
import 'greeting.dart' as _i2;
import 'animal.dart' as _i3;
import 'animalFinding.dart' as _i4;
import 'package:vochm_client/src/protocol/animal.dart' as _i5;
import 'package:vochm_client/src/protocol/animalFinding.dart' as _i6;
export 'greeting.dart';
export 'animal.dart';
export 'animalFinding.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.Animal) {
      return _i3.Animal.fromJson(data) as T;
    }
    if (t == _i4.AnimalFinding) {
      return _i4.AnimalFinding.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Animal?>()) {
      return (data != null ? _i3.Animal.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AnimalFinding?>()) {
      return (data != null ? _i4.AnimalFinding.fromJson(data) : null) as T;
    }
    if (t == List<_i5.Animal>) {
      return (data as List).map((e) => deserialize<_i5.Animal>(e)).toList()
          as T;
    }
    if (t == List<_i6.AnimalFinding>) {
      return (data as List)
          .map((e) => deserialize<_i6.AnimalFinding>(e))
          .toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Greeting) {
      return 'Greeting';
    }
    if (data is _i3.Animal) {
      return 'Animal';
    }
    if (data is _i4.AnimalFinding) {
      return 'AnimalFinding';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'Animal') {
      return deserialize<_i3.Animal>(data['data']);
    }
    if (dataClassName == 'AnimalFinding') {
      return deserialize<_i4.AnimalFinding>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
