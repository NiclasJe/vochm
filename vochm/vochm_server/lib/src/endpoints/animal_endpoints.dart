import 'package:serverpod/serverpod.dart';
import 'package:vochm_server/src/generated/animal.dart';

class AnimalEndpoint extends Endpoint {
  Future<Animal> addAnimal(
      Session session, String animalName) async {
    final existing = await Animal.db.findFirstRow(
      session,
      where: (t) => t.name.equals(animalName),
    );

    if (existing != null) {
      return existing;
    }

    final animal = Animal(
      name: animalName,
    );

    return await Animal.db.insertRow(session, animal);
  }

  Future<List<Animal>> getAllAnimals(Session session) async {
    return await Animal.db.find(session);
  }
}