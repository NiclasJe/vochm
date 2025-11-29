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
import '../endpoints/animal_endpoints.dart' as _i2;
import '../endpoints/animal_finding_endpoint.dart' as _i3;
import '../greeting_endpoint.dart' as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'animal': _i2.AnimalEndpoint()
        ..initialize(
          server,
          'animal',
          null,
        ),
      'animalFinding': _i3.AnimalFindingEndpoint()
        ..initialize(
          server,
          'animalFinding',
          null,
        ),
      'greeting': _i4.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['animal'] = _i1.EndpointConnector(
      name: 'animal',
      endpoint: endpoints['animal']!,
      methodConnectors: {
        'addAnimal': _i1.MethodConnector(
          name: 'addAnimal',
          params: {
            'animalName': _i1.ParameterDescription(
              name: 'animalName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['animal'] as _i2.AnimalEndpoint).addAnimal(
            session,
            params['animalName'],
          ),
        ),
        'getAllAnimals': _i1.MethodConnector(
          name: 'getAllAnimals',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['animal'] as _i2.AnimalEndpoint)
                  .getAllAnimals(session),
        ),
        'getAnimalById': _i1.MethodConnector(
          name: 'getAnimalById',
          params: {
            'animalId': _i1.ParameterDescription(
              name: 'animalId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['animal'] as _i2.AnimalEndpoint).getAnimalById(
            session,
            params['animalId'],
          ),
        ),
        'testCall': _i1.MethodConnector(
          name: 'testCall',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['animal'] as _i2.AnimalEndpoint).testCall(session),
        ),
      },
    );
    connectors['animalFinding'] = _i1.EndpointConnector(
      name: 'animalFinding',
      endpoint: endpoints['animalFinding']!,
      methodConnectors: {
        'insertAnimalFinding': _i1.MethodConnector(
          name: 'insertAnimalFinding',
          params: {
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'animalId': _i1.ParameterDescription(
              name: 'animalId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['animalFinding'] as _i3.AnimalFindingEndpoint)
                  .insertAnimalFinding(
            session,
            params['latitude'],
            params['longitude'],
            params['animalId'],
          ),
        ),
        'getAnimalFindings': _i1.MethodConnector(
          name: 'getAnimalFindings',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['animalFinding'] as _i3.AnimalFindingEndpoint)
                  .getAnimalFindings(session),
        ),
        'getNearestNeighborsForAnimal': _i1.MethodConnector(
          name: 'getNearestNeighborsForAnimal',
          params: {
            'animalId': _i1.ParameterDescription(
              name: 'animalId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['animalFinding'] as _i3.AnimalFindingEndpoint)
                  .getNearestNeighborsForAnimal(
            session,
            params['animalId'],
          ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['greeting'] as _i4.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
  }
}
