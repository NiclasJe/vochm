import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:vochm_server/src/generated/protocol.dart';

class AnimalFindingEndpoint extends Endpoint {
  Future<void> insertAnimalFinding(
      Session session, double latitude, double longitude, int animalId) async {
    final animalFinding = AnimalFinding(
      latitude: latitude,
      longitude: longitude,
      animalId: animalId,
    );

    await session.db.unsafeQuery('''
      INSERT INTO animal_findings (animal, location)
      VALUES ('${animalFinding.animalId}', ST_SetSRID(ST_MakePoint(${animalFinding.longitude}, ${animalFinding.latitude}), 4326))
      ''');
  }

  Future<List<AnimalFinding>> getAnimalFindings(Session session) async {
    final result = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        animal,
        ST_Y(location) AS latitude,
        ST_X(location) AS longitude
      FROM animal_findings
      ORDER BY id DESC
      ''',
    );

    return result
        .map(
          (row) => AnimalFinding(
            id: row[0] as int,
            animalId: row[1] as int,
            latitude: row[2] as double,
            longitude: row[3] as double,
          ),
        )
        .toList();
  }

  Future<double> getDistanceBetweenFindings(
    Session session,
    int findingId1,
    int findingId2,
  ) async {
    final result = await session.db.unsafeQuery('''
      SELECT ST_DistanceSphere(
        (SELECT location FROM animal_findings WHERE id = $findingId1),
        (SELECT location FROM animal_findings WHERE id = $findingId2)
      ) AS distance_meters
    ''');

    if (result.isEmpty || result[0][0] == null) {
      throw Exception('Could not calculate distance. Check that both findings exist.');
    }

    return result[0][0] as double;
  }
}