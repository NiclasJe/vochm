import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vochm_client/vochm_client.dart' as api;
import 'package:vochm_flutter/features/animal_map/controllers/animal_map_controller.dart';
import 'package:vochm_flutter/features/animal_map/services/animal_finding_service.dart';
import 'package:vochm_flutter/features/animal_map/services/animal_service.dart';

class MockAnimalService extends Mock implements AnimalService {}

class MockAnimalFindingService extends Mock implements AnimalFindingService {}

void main() {
  late AnimalMapController controller;
  late MockAnimalService mockAnimalService;
  late MockAnimalFindingService mockAnimalFindingService;

  setUp(() {
    mockAnimalService = MockAnimalService();
    mockAnimalFindingService = MockAnimalFindingService();
    controller = AnimalMapController(
      animalService: mockAnimalService,
      animalFindingService: mockAnimalFindingService,
    );
  });

  group('AnimalMapController', () {
    test('initial state is correct', () {
      expect(controller.state, equals(AnimalMapState.initial()));
      expect(controller.animals, isEmpty);
      expect(controller.findings, isEmpty);
      expect(controller.nearestDistanceByAnimalId, isEmpty);
      expect(controller.isLoading, isFalse);
      expect(controller.isSubmitting, isFalse);
      expect(controller.errorMessage, isNull);
      expect(controller.lastTappedLocation, isNull);
    });

    group('init', () {
      test('fetches animals and findings on success', () async {
        when(() => mockAnimalService.getAllAnimals()).thenAnswer(
          (_) async => [
            api.Animal(id: 1, name: 'Älg'),
            api.Animal(id: 2, name: 'Björn'),
          ],
        );
        when(() => mockAnimalFindingService.getAllFindings()).thenAnswer(
          (_) async => [
            api.AnimalFinding(
              id: 1,
              animalId: 1,
              latitude: 59.3293,
              longitude: 18.0686,
            ),
          ],
        );

        await controller.init();

        expect(controller.animals.length, equals(2));
        expect(controller.animals[0].id, equals(1));
        expect(controller.animals[0].name, equals('Älg'));
        expect(controller.animals[1].id, equals(2));
        expect(controller.animals[1].name, equals('Björn'));
        expect(controller.findings.length, equals(1));
        expect(controller.findings[0].id, equals(1));
        expect(controller.isLoading, isFalse);
        verify(() => mockAnimalService.getAllAnimals()).called(1);
        verify(() => mockAnimalFindingService.getAllFindings()).called(1);
      });

      test('sets error message when fetching data fails', () async {
        when(() => mockAnimalService.getAllAnimals())
            .thenThrow(Exception('Network error'));

        await controller.init();

        expect(controller.errorMessage, equals('Exception: Network error'));
        expect(controller.isLoading, isFalse);
      });
    });

    group('addAnimal', () {
      test('adds animal to list on success', () async {
        when(() => mockAnimalService.addAnimal('Räv')).thenAnswer(
          (_) async => api.Animal(id: 3, name: 'Räv'),
        );

        await controller.addAnimal('Räv');

        expect(controller.animals.length, equals(1));
        expect(controller.animals[0].id, equals(3));
        expect(controller.animals[0].name, equals('Räv'));
        expect(controller.isSubmitting, isFalse);
        verify(() => mockAnimalService.addAnimal('Räv')).called(1);
      });

      test('does not add duplicate animal', () async {
        // Pre-populate with an animal
        when(() => mockAnimalService.getAllAnimals()).thenAnswer(
          (_) async => [api.Animal(id: 1, name: 'Älg')],
        );
        when(() => mockAnimalFindingService.getAllFindings()).thenAnswer(
          (_) async => [],
        );
        await controller.init();

        // Try to add the same animal
        when(() => mockAnimalService.addAnimal('Älg')).thenAnswer(
          (_) async => api.Animal(id: 1, name: 'Älg'),
        );

        await controller.addAnimal('Älg');

        expect(controller.animals.length, equals(1));
        expect(controller.animals[0].id, equals(1));
      });

      test('sets error message when adding animal fails', () async {
        when(() => mockAnimalService.addAnimal('Räv'))
            .thenThrow(Exception('Failed to add'));

        await controller.addAnimal('Räv');

        expect(controller.errorMessage, equals('Exception: Failed to add'));
        expect(controller.isSubmitting, isFalse);
      });
    });

    group('onMapTap', () {
      test('updates lastTappedLocation', () {
        controller.onMapTap(const LatLng(60.0, 15.0));

        expect(controller.lastTappedLocation, equals(const LatLng(60.0, 15.0)));
      });
    });

    group('addFindingForAnimal', () {
      test('adds finding and fetches nearest neighbors on success', () async {
        // Set a tapped location first
        controller.onMapTap(const LatLng(60.0, 15.0));

        when(() => mockAnimalFindingService.insertAnimalFinding(
              animalId: 1,
              latitude: 60.0,
              longitude: 15.0,
            )).thenAnswer(
          (_) async => api.AnimalFinding(
            id: 10,
            animalId: 1,
            latitude: 60.0,
            longitude: 15.0,
          ),
        );
        when(() => mockAnimalFindingService.getNearestNeighborsForAnimal(1))
            .thenAnswer((_) async => 1234.5);

        await controller.addFindingForAnimal(api.Animal(id: 1, name: 'Älg'));

        expect(controller.findings.length, equals(1));
        expect(controller.findings[0].animalId, equals(1));
        expect(controller.findings[0].latitude, equals(60.0));
        expect(controller.findings[0].longitude, equals(15.0));
        expect(controller.lastTappedLocation, isNull);
        expect(controller.nearestDistanceByAnimalId[1], equals(1234.5));
        expect(controller.isSubmitting, isFalse);
        verify(() => mockAnimalFindingService.insertAnimalFinding(
              animalId: 1,
              latitude: 60.0,
              longitude: 15.0,
            )).called(1);
        verify(() => mockAnimalFindingService.getNearestNeighborsForAnimal(1))
            .called(1);
      });

      test('does nothing when lastTappedLocation is null', () async {
        await controller.addFindingForAnimal(api.Animal(id: 1, name: 'Älg'));

        expect(controller.findings, isEmpty);
        verifyNever(() => mockAnimalFindingService.insertAnimalFinding(
              animalId: any(named: 'animalId'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
            ));
      });

      test('does nothing when animal id is null', () async {
        controller.onMapTap(const LatLng(60.0, 15.0));

        await controller.addFindingForAnimal(api.Animal(name: 'Älg'));

        expect(controller.findings, isEmpty);
        verifyNever(() => mockAnimalFindingService.insertAnimalFinding(
              animalId: any(named: 'animalId'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
            ));
      });

      test('sets error message when adding finding fails', () async {
        controller.onMapTap(const LatLng(60.0, 15.0));

        when(() => mockAnimalFindingService.insertAnimalFinding(
              animalId: 1,
              latitude: 60.0,
              longitude: 15.0,
            )).thenThrow(Exception('Failed to insert'));

        await controller.addFindingForAnimal(api.Animal(id: 1, name: 'Älg'));

        expect(controller.errorMessage, equals('Exception: Failed to insert'));
        expect(controller.isSubmitting, isFalse);
      });
    });

    group('fetchNearestNeighborsForAnimal', () {
      test('updates nearestDistanceByAnimalId on success', () async {
        when(() => mockAnimalFindingService.getNearestNeighborsForAnimal(1))
            .thenAnswer((_) async => 567.89);

        await controller.fetchNearestNeighborsForAnimal(1);

        expect(controller.nearestDistanceByAnimalId[1], equals(567.89));
        expect(controller.isLoading, isFalse);
        verify(() => mockAnimalFindingService.getNearestNeighborsForAnimal(1))
            .called(1);
      });

      test('sets error message when fetching nearest neighbors fails',
          () async {
        when(() => mockAnimalFindingService.getNearestNeighborsForAnimal(1))
            .thenThrow(Exception('Query failed'));

        await controller.fetchNearestNeighborsForAnimal(1);

        expect(controller.errorMessage, equals('Exception: Query failed'));
        expect(controller.isLoading, isFalse);
      });
    });

    group('clearError', () {
      test('clears error message', () async {
        // Set an error first
        when(() => mockAnimalService.addAnimal('Räv'))
            .thenThrow(Exception('Some error'));
        await controller.addAnimal('Räv');
        expect(controller.errorMessage, isNotNull);

        controller.clearError();

        expect(controller.errorMessage, isNull);
      });
    });
  });
}

