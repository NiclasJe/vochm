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
import '../endpoints/animal_finding_endpoint.dart' as _i2;
import '../endpoints/recipe_endpoint.dart' as _i3;
import '../greeting_endpoint.dart' as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'animalFinding': _i2.AnimalFindingEndpoint()
        ..initialize(
          server,
          'animalFinding',
          null,
        ),
      'recipe': _i3.RecipeEndpoint()
        ..initialize(
          server,
          'recipe',
          null,
        ),
      'greeting': _i4.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
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
              (endpoints['animalFinding'] as _i2.AnimalFindingEndpoint)
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
              (endpoints['animalFinding'] as _i2.AnimalFindingEndpoint)
                  .getAnimalFindings(session),
        ),
        'getDistanceBetweenFindings': _i1.MethodConnector(
          name: 'getDistanceBetweenFindings',
          params: {
            'findingId1': _i1.ParameterDescription(
              name: 'findingId1',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'findingId2': _i1.ParameterDescription(
              name: 'findingId2',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['animalFinding'] as _i2.AnimalFindingEndpoint)
                  .getDistanceBetweenFindings(
            session,
            params['findingId1'],
            params['findingId2'],
          ),
        ),
      },
    );
    connectors['recipe'] = _i1.EndpointConnector(
      name: 'recipe',
      endpoint: endpoints['recipe']!,
      methodConnectors: {
        'generateRecipe': _i1.MethodConnector(
          name: 'generateRecipe',
          params: {
            'ingredients': _i1.ParameterDescription(
              name: 'ingredients',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recipe'] as _i3.RecipeEndpoint).generateRecipe(
            session,
            params['ingredients'],
          ),
        ),
        'getRecipes': _i1.MethodConnector(
          name: 'getRecipes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['recipe'] as _i3.RecipeEndpoint).getRecipes(session),
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
