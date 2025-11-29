import 'package:vochm_client/vochm_client.dart' as api;

class AnimalService {
  AnimalService(this._client);

  final api.Client _client;

  Future<List<api.Animal>> getAllAnimals() async {
    return _client.animal.getAllAnimals();
  }

  Future<api.Animal> addAnimal(String name) async {
    return _client.animal.addAnimal(name);
  }

  Future<api.Animal?> getAnimalById(int animalId) async {
    return _client.animal.getAnimalById(animalId);
  }

  Future<String> test() async {
    return await _client.animal.testCall();
  }
}

