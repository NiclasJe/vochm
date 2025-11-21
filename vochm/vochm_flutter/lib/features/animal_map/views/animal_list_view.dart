import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';
import '../controllers/animal_map_controller.dart';

class AnimalListView extends StatefulWidget {
  const AnimalListView({super.key});

  @override
  State<AnimalListView> createState() => _AnimalListViewState();
}

class _AnimalListViewState extends State<AnimalListView> {
  late final AnimalMapController controller;

  @override
  void initState() {
    super.initState();
    controller = getIt<AnimalMapController>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimalMapController, AnimalMapState>(
      bloc: controller,
      builder: (context, state) {
        if (state.animals.isEmpty) {
          return const Center(
            child: Text('No animals registered yet. Add one using the + button.'),
          );
        }

        return ListView.builder(
          itemCount: state.animals.length,
          itemBuilder: (context, index) {
            final animal = state.animals[index];
            final findingsForAnimal = state.findings
                .where((f) => f.animalId == animal.id)
                .toList();

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ExpansionTile(
                title: Text(
                  animal.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${findingsForAnimal.length} finding(s)'),
                children: [
                  if (findingsForAnimal.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No findings for this animal yet.'),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: state.isLoading
                                ? null
                                : () async {
                                    if (animal.id != null) {
                                      await controller
                                          .fetchNearestNeighborsForAnimal(
                                              animal.id!);
                                    }
                                  },
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Calculate nearest distance'),
                          ),
                          const SizedBox(height: 12),
                          if (animal.id != null && state.nearestDistanceByAnimalId.containsKey(animal.id))
                            Card(
                              color: Colors.blue.shade50,
                              child: ListTile(
                                leading: const Icon(Icons.straighten, color: Colors.blue),
                                title: const Text('Nearest distance between findings'),
                                subtitle: Text(
                                  '${state.nearestDistanceByAnimalId[animal.id]!.toStringAsFixed(1)} meters',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          const Text(
                            'All findings:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...findingsForAnimal.map((finding) {
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.location_on, size: 20),
                              title: Text(
                                'Finding #${finding.id ?? "?"}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                'Lat: ${finding.latitude?.toStringAsFixed(6) ?? "?"}, Lng: ${finding.longitude?.toStringAsFixed(6) ?? "?"}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
