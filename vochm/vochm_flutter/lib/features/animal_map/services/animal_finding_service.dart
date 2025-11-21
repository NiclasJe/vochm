import 'package:vochm_client/vochm_client.dart' as api;

class AnimalFindingService {
  AnimalFindingService(this._client);

  final api.Client _client;

  Future<List<api.AnimalFinding>> getAllFindings() async {
    return _client.animalFinding.getAnimalFindings();
  }

  Future<api.AnimalFinding> insertAnimalFinding({
    required int animalId,
    required double latitude,
    required double longitude,
  }) async {
    await _client.animalFinding.insertAnimalFinding(
      latitude,
      longitude,
      animalId,
    );
    // The endpoint returns void, so construct a local model instance.
    return api.AnimalFinding(
      animalId: animalId,
      latitude: latitude,
      longitude: longitude,
    );
  }

  // New: fetch nearest neighbor results for a given animalId
  Future<double> getNearestNeighborsForAnimal(
      int animalId) async {
    return _client.animalFinding.getNearestNeighborsForAnimal(animalId);
  }
}
