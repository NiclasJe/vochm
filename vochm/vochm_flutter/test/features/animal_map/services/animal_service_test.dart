import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vochm_client/vochm_client.dart' as api;
import 'package:vochm_flutter/features/animal_map/services/animal_service.dart';

class MockClient extends Mock implements api.Client {}

class MockAnimalEndpoint extends Mock implements api.EndpointAnimal {}

void main() {
  late AnimalService service;
  late MockClient mockClient;
  late MockAnimalEndpoint mockAnimalEndpoint;

  setUp(() {
    mockClient = MockClient();
    mockAnimalEndpoint = MockAnimalEndpoint();
    when(() => mockClient.animal).thenReturn(mockAnimalEndpoint);
    service = AnimalService(mockClient);
  });

  group('AnimalService', () {
    group('getAllAnimals', () {
      test('returns list of animals from client', () async {
        final animals = [
          api.Animal(id: 1, name: 'Älg'),
          api.Animal(id: 2, name: 'Björn'),
          api.Animal(id: 3, name: 'Varg'),
        ];

        when(() => mockAnimalEndpoint.getAllAnimals())
            .thenAnswer((_) async => animals);

        final result = await service.getAllAnimals();

        expect(result, equals(animals));
        verify(() => mockAnimalEndpoint.getAllAnimals()).called(1);
      });

      test('throws exception when client fails', () async {
        when(() => mockAnimalEndpoint.getAllAnimals())
            .thenThrow(Exception('Connection error'));

        expect(
          () => service.getAllAnimals(),
          throwsException,
        );
      });
    });

    group('addAnimal', () {
      test('returns added animal from client', () async {
        final animal = api.Animal(id: 4, name: 'Räv');

        when(() => mockAnimalEndpoint.addAnimal('Räv'))
            .thenAnswer((_) async => animal);

        final result = await service.addAnimal('Räv');

        expect(result, equals(animal));
        verify(() => mockAnimalEndpoint.addAnimal('Räv')).called(1);
      });

      test('throws exception when client fails', () async {
        when(() => mockAnimalEndpoint.addAnimal('Räv'))
            .thenThrow(Exception('Database error'));

        expect(
          () => service.addAnimal('Räv'),
          throwsException,
        );
      });
    });

    group('getAnimalById', () {
      test('returns animal when found', () async {
        final animal = api.Animal(id: 1, name: 'Älg');

        when(() => mockAnimalEndpoint.getAnimalById(1))
            .thenAnswer((_) async => animal);

        final result = await service.getAnimalById(1);

        expect(result, equals(animal));
        verify(() => mockAnimalEndpoint.getAnimalById(1)).called(1);
      });

      test('returns null when animal not found', () async {
        when(() => mockAnimalEndpoint.getAnimalById(999))
            .thenAnswer((_) async => null);

        final result = await service.getAnimalById(999);

        expect(result, isNull);
        verify(() => mockAnimalEndpoint.getAnimalById(999)).called(1);
      });

      test('throws exception when client fails', () async {
        when(() => mockAnimalEndpoint.getAnimalById(1))
            .thenThrow(Exception('Database error'));

        expect(
          () => service.getAnimalById(1),
          throwsException,
        );
      });
    });
  });
}

