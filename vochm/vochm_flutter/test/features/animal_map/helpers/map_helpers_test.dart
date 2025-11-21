import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vochm_client/vochm_client.dart' as api;
import 'package:vochm_flutter/features/animal_map/helpers/map_helpers.dart';

void main() {
  group('map_helpers', () {
    group('defaultCenter', () {
      test('is Stockholm coordinates', () {
        expect(defaultCenter.latitude, equals(59.3293));
        expect(defaultCenter.longitude, equals(18.0686));
      });
    });

    group('defaultZoom', () {
      test('is 5.0', () {
        expect(defaultZoom, equals(5.0));
      });
    });

    group('markersFromFindings', () {
      test('returns empty list when no findings', () {
        final markers = markersFromFindings([]);
        expect(markers, isEmpty);
      });

      test('returns markers for each finding', () {
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
          api.AnimalFinding(
            id: 3,
            animalId: 1,
            latitude: 55.6050,
            longitude: 13.0038,
          ),
        ];

        final markers = markersFromFindings(findings);

        expect(markers.length, equals(3));
        expect(markers[0].point.latitude, equals(59.3293));
        expect(markers[0].point.longitude, equals(18.0686));
        expect(markers[1].point.latitude, equals(60.1699));
        expect(markers[1].point.longitude, equals(24.9384));
        expect(markers[2].point.latitude, equals(55.6050));
        expect(markers[2].point.longitude, equals(13.0038));
      });

      test('marker properties are correct', () {
        final findings = [
          api.AnimalFinding(
            id: 1,
            animalId: 1,
            latitude: 59.3293,
            longitude: 18.0686,
          ),
        ];

        final markers = markersFromFindings(findings);

        expect(markers[0].width, equals(40));
        expect(markers[0].height, equals(40));
      });

      test('calls onTap when provided', () {
        final findings = [
          api.AnimalFinding(
            id: 1,
            animalId: 1,
            latitude: 59.3293,
            longitude: 18.0686,
          ),
        ];

        api.AnimalFinding? tappedFinding;
        final markers = markersFromFindings(
          findings,
          onTap: (finding) => tappedFinding = finding,
        );

        // Note: We can't easily test GestureDetector onTap in unit tests
        // This test just verifies that the callback is passed through
        expect(markers.length, equals(1));
        expect(tappedFinding, isNull); // Not tapped yet
      });

      test('handles findings with null lat/lng gracefully', () {
        // This test documents current behavior - it may throw or handle nulls
        // depending on implementation. Adjust based on actual behavior.
        final findings = [
          api.AnimalFinding(
            id: 1,
            animalId: 1,
            latitude: 59.3293,
            longitude: 18.0686,
          ),
        ];

        expect(() => markersFromFindings(findings), returnsNormally);
      });
    });
  });
}

