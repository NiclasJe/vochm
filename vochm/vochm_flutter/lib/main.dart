import 'package:flutter/material.dart';
import 'service_locator.dart';
import 'features/animal_map/views/animal_map_page.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl = serverUrlFromEnv.isEmpty ? null : serverUrlFromEnv;

  await setupServiceLocator(serverUrl: serverUrl);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnimalMapPage(),
    );
  }
}