import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vochm_client/vochm_client.dart' as api;
import 'package:vochm_flutter/features/animal_map/services/animal_finding_service.dart';

class MockClient extends Mock implements api.Client {}

class MockAnimalFindingEndpoint extends Mock
    implements api.EndpointAnimalFinding {}

void main() {
  late AnimalFindingService service;
  late MockClient mockClient;
  late MockAnimalFindingEndpoint mockAnimalFindingEndpoint;

  setUp(() {
    mockClient = MockClient();
    mockAnimalFindingEndpoint = MockAnimalFindingEndpoint();
    when(() => mockClient.animalFinding).thenReturn(mockAnimalFindingEndpoint);
    service = AnimalFindingService(mockClient);
  });

  group('AnimalFindingService', () {
    group('getAllFindings', () {
      test('returns list of findings from client', () async {
        final findings = [
          api.AnimalFinding(
            id: 1,
            animalId: 1,
            latitude: 59.3293,
            longitude: 18.0686,
          ),
          api.AnimalFinding(
            id: 2,
            animalId: 2,
            latitude: 60.1699,
            longitude: 24.9384,
          ),
        ];

        when(() => mockAnimalFindingEndpoint.getAnimalFindings())
            .thenAnswer((_) async => findings);

        final result = await service.getAllFindings();

        expect(result, equals(findings));
        verify(() => mockAnimalFindingEndpoint.getAnimalFindings()).called(1);
      });

      test('throws exception when client fails', () async {
        when(() => mockAnimalFindingEndpoint.getAnimalFindings())
            .thenThrow(Exception('Connection error'));

        expect(
          () => service.getAllFindings(),
          throwsException,
        );
      });
    });

    group('insertAnimalFinding', () {
      test('inserts finding and returns constructed model', () async {
        when(() => mockAnimalFindingEndpoint.insertAnimalFinding(
              59.3293,
              18.0686,
              1,
            )).thenAnswer((_) async {});

        final result = await service.insertAnimalFinding(
          animalId: 1,
          latitude: 59.3293,
          longitude: 18.0686,
        );

        expect(result.animalId, equals(1));
        expect(result.latitude, equals(59.3293));
        expect(result.longitude, equals(18.0686));
        verify(() => mockAnimalFindingEndpoint.insertAnimalFinding(
              59.3293,
              18.0686,
              1,
            )).called(1);
      });

      test('throws exception when client fails', () async {
        when(() => mockAnimalFindingEndpoint.insertAnimalFinding(
              59.3293,
              18.0686,
              1,
            )).thenThrow(Exception('Database error'));

        expect(
          () => service.insertAnimalFinding(
            animalId: 1,
            latitude: 59.3293,
            longitude: 18.0686,
          ),
          throwsException,
        );
      });
    });

    group('getNearestNeighborsForAnimal', () {
      test('returns distance from client', () async {
        when(() => mockAnimalFindingEndpoint.getNearestNeighborsForAnimal(1))
            .thenAnswer((_) async => 1234.56);

        final result = await service.getNearestNeighborsForAnimal(1);

        expect(result, equals(1234.56));
        verify(() => mockAnimalFindingEndpoint.getNearestNeighborsForAnimal(1))
            .called(1);
      });

      test('returns 0.0 when no neighbors found', () async {
        when(() => mockAnimalFindingEndpoint.getNearestNeighborsForAnimal(999))
            .thenAnswer((_) async => 0.0);

        final result = await service.getNearestNeighborsForAnimal(999);

        expect(result, equals(0.0));
      });

      test('throws exception when client fails', () async {
        when(() => mockAnimalFindingEndpoint.getNearestNeighborsForAnimal(1))
            .thenThrow(Exception('Query error'));

        expect(
          () => service.getNearestNeighborsForAnimal(1),
          throwsException,
        );
      });
    });
  });
}

