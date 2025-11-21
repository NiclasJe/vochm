import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:vochm_client/vochm_client.dart';

import 'features/animal_map/controllers/animal_map_controller.dart';
import 'features/animal_map/services/animal_finding_service.dart';
import 'features/animal_map/services/animal_service.dart';
import 'features/animal_map/views/animal_map_page.dart';

late final Client client;

late String serverUrl;

late final AnimalMapController animalMapController;

void main() {
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final resolvedServerUrl =
      serverUrlFromEnv.isEmpty ? 'http://$localhost:8080/' : serverUrlFromEnv;

  serverUrl = resolvedServerUrl;
  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final animalService = AnimalService(client);
    final animalFindingService = AnimalFindingService(client);
    final controller = AnimalMapController(
      animalService: animalService,
      animalFindingService: animalFindingService,
    );

    return MaterialApp(
      title: 'Animal Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimalMapPage(controller: controller),
    );
  }
}