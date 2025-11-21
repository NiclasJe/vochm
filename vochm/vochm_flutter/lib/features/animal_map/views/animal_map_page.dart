import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';
import '../controllers/animal_map_controller.dart';
import 'animal_map_view.dart';
import 'animal_list_view.dart';
import 'animal_registration_dialog.dart';

class AnimalMapPage extends StatefulWidget {
  const AnimalMapPage({super.key});

  @override
  State<AnimalMapPage> createState() => _AnimalMapPageState();
}

class _AnimalMapPageState extends State<AnimalMapPage>
    with SingleTickerProviderStateMixin {
  late final AnimalMapController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = getIt<AnimalMapController>();
    _tabController = TabController(length: 2, vsync: this);
    _controller.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showAddAnimalDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const AnimalRegistrationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimalMapController, AnimalMapState>(
      bloc: _controller,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Animal Map'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.map), text: 'Map'),
                Tab(icon: Icon(Icons.list), text: 'Animals'),
              ],
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                controller: _tabController,
                children: const [
                  AnimalMapView(),
                  AnimalListView(),
                ],
              ),
              if (state.errorMessage != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    color: Colors.red,
                    child: ListTile(
                      title: Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: _controller.clearError,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            key: const Key('addAnimalButton'),
            onPressed: _showAddAnimalDialog,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
