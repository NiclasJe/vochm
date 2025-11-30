import 'package:get_it/get_it.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:vochm_client/vochm_client.dart';

import 'features/animal_map/controllers/animal_map_controller.dart';
import 'features/animal_map/services/animal_finding_service.dart';
import 'features/animal_map/services/animal_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator({String? serverUrl}) async {
  // Serverpod Client
  final url = 'http://172.24.4.239:5432/';
  final client = Client(url)..connectivityMonitor = FlutterConnectivityMonitor();

  getIt.registerLazySingleton<Client>(() => client);

  // Services
  getIt.registerLazySingleton<AnimalService>(
    () => AnimalService(getIt<Client>()),
  );

  getIt.registerLazySingleton<AnimalFindingService>(
    () => AnimalFindingService(getIt<Client>()),
  );

  // Controller (Cubit)
  getIt.registerLazySingleton<AnimalMapController>(
    () => AnimalMapController(
      animalService: getIt<AnimalService>(),
      animalFindingService: getIt<AnimalFindingService>(),
    ),
  );
}

