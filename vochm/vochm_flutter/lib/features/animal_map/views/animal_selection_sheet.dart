import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vochm_client/vochm_client.dart' as api;

import '../controllers/animal_map_controller.dart';

class AnimalSelectionSheet extends StatefulWidget {
  const AnimalSelectionSheet({
    super.key,
    required this.controller,
    required this.location,
  });

  final AnimalMapController controller;
  final LatLng location;

  @override
  State<AnimalSelectionSheet> createState() => _AnimalSelectionSheetState();
}

class _AnimalSelectionSheetState extends State<AnimalSelectionSheet> {
  api.Animal? _selected;

  @override
  void initState() {
    super.initState();
    widget.controller.onMapTap(widget.location);
  }

  Future<void> _onSelectedChanged(api.Animal? a) async {
    setState(() => _selected = a);
    if (a != null && a.id != null) {
      await widget.controller.fetchNearestNeighborsForAnimal(a.id!);
    }
  }

  Future<void> _submit() async {
    final selected = _selected;
    if (selected == null || selected.id == null) return;
    await widget.controller.addFindingForAnimal(selected);
    // Controller has refreshed nearest neighbors for this animal.
    if (mounted && widget.controller.errorMessage == null) {
      // Show the nearest distance for this animal (if any)
      final distance = widget.controller.nearestDistanceByAnimalId[selected.id];

      if (distance != null && distance > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nearest distance: ${distance.toStringAsFixed(1)} m')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No nearest finding available yet.')),
        );
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register finding',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<api.Animal>(
              decoration: const InputDecoration(labelText: 'Animal'),
              items: widget.controller.animals
                  .map(
                    (a) => DropdownMenuItem(
                      value: a,
                      child: Text(a.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => _onSelectedChanged(value),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: widget.controller.isSubmitting || _selected == null ? null : _submit,
                child: widget.controller.isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save finding'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
