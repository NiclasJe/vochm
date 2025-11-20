import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:vochm_server/src/generated/protocol.dart';

class AnimalFindingEndpoint extends Endpoint {
  Future<void> insertAnimalFinding(
      Session session, double latitude, double longitude, int animalId) async {

    await session.db.unsafeQuery('''
      INSERT INTO animal_findings (animalId, location)
      VALUES ('$animalId', ST_SetSRID(ST_MakePoint($longitude, $latitude), 4326))
      ''');
  }

  Future<List<AnimalFinding>> getAnimalFindings(Session session) async {
    final result = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        animalid,
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

  /// For the given [animalId], find the nearest other finding for each
  /// finding of that animal. Returns a list of maps with keys:
  /// - 'id' (int): the finding id
  /// - 'nearestId' (int?): the nearest other finding id, or null if none
  /// - 'distanceMeters' (double?): distance in meters to the nearest finding, or null
  Future<double> getNearestNeighborsForAnimal(
      Session session, int animalId) async {
    // Use a lateral join + KNN (<->) to find the nearest neighbor for each row.
    final result = await session.db.unsafeQuery('''
      SELECT ST_DistanceSphere(a.location, b.location) AS distance_meters
      FROM animal_findings a
      LEFT JOIN LATERAL (
        SELECT id, location
        FROM animal_findings b
        WHERE b.animalId = $animalId
          AND b.id != a.id
        ORDER BY a.location <-> b.location
        LIMIT 1
      ) b ON true
      WHERE a.animalId = $animalId
      ORDER BY distance_meters NULLS LAST, a.id;
    ''');

    if (result.isEmpty || result[0][0] == null) {
      return -1.0;
    }

    return result[0][0] as double;
  }
}