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
import 'dart:async' as _i2;
import 'package:vochm_client/src/protocol/animal.dart' as _i3;
import 'package:vochm_client/src/protocol/animalFinding.dart' as _i4;
import 'package:vochm_client/src/protocol/greeting.dart' as _i5;
import 'protocol.dart' as _i6;

/// {@category Endpoint}
class EndpointAnimal extends _i1.EndpointRef {
  EndpointAnimal(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'animal';

  _i2.Future<_i3.Animal> addAnimal(String animalName) =>
      caller.callServerEndpoint<_i3.Animal>(
        'animal',
        'addAnimal',
        {'animalName': animalName},
      );

  _i2.Future<List<_i3.Animal>> getAllAnimals() =>
      caller.callServerEndpoint<List<_i3.Animal>>(
        'animal',
        'getAllAnimals',
        {},
      );

  _i2.Future<_i3.Animal?> getAnimalById(int animalId) =>
      caller.callServerEndpoint<_i3.Animal?>(
        'animal',
        'getAnimalById',
        {'animalId': animalId},
      );

  _i2.Future<String> testCall() => caller.callServerEndpoint<String>(
        'animal',
        'testCall',
        {},
      );
}

/// {@category Endpoint}
class EndpointAnimalFinding extends _i1.EndpointRef {
  EndpointAnimalFinding(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'animalFinding';

  _i2.Future<void> insertAnimalFinding(
    double latitude,
    double longitude,
    int animalId,
  ) =>
      caller.callServerEndpoint<void>(
        'animalFinding',
        'insertAnimalFinding',
        {
          'latitude': latitude,
          'longitude': longitude,
          'animalId': animalId,
        },
      );

  _i2.Future<List<_i4.AnimalFinding>> getAnimalFindings() =>
      caller.callServerEndpoint<List<_i4.AnimalFinding>>(
        'animalFinding',
        'getAnimalFindings',
        {},
      );

  /// For the given [animalId], find the nearest other finding for each
  /// finding of that animal. Returns a list of maps with keys:
  /// - 'id' (int): the finding id
  /// - 'nearestId' (int?): the nearest other finding id, or null if none
  /// - 'distanceMeters' (double?): distance in meters to the nearest finding, or null
  _i2.Future<double> getNearestNeighborsForAnimal(int animalId) =>
      caller.callServerEndpoint<double>(
        'animalFinding',
        'getNearestNeighborsForAnimal',
        {'animalId': animalId},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i5.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i5.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i6.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    animal = EndpointAnimal(this);
    animalFinding = EndpointAnimalFinding(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointAnimal animal;

  late final EndpointAnimalFinding animalFinding;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'animal': animal,
        'animalFinding': animalFinding,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
