import 'package:flutter/material.dart';
import 'package:vochm_client/vochm_client.dart' as api;

import '../controllers/animal_map_controller.dart';

class FindingInfoSheet extends StatefulWidget {
  const FindingInfoSheet({
    super.key,
    required this.finding,
    required this.controller,
  });

  final api.AnimalFinding finding;
  final AnimalMapController controller;

  @override
  State<FindingInfoSheet> createState() => _FindingInfoSheetState();
}

class _FindingInfoSheetState extends State<FindingInfoSheet> {
  api.Animal? _animal;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnimal();
  }

  Future<void> _loadAnimal() async {
    try {
      final animal = await widget.controller.animalService
          .getAnimalById(widget.finding.animalId);
      if (mounted) {
        setState(() {
          _animal = animal;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Finding Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else ...[
              ListTile(
                leading: const Icon(Icons.pets, color: Colors.green),
                title: const Text('Animal'),
                subtitle: Text(
                  _animal?.name ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: const Text('Location'),
                subtitle: Text(
                  'Lat: ${widget.finding.latitude?.toStringAsFixed(6) ?? "?"}\n'
                  'Lng: ${widget.finding.longitude?.toStringAsFixed(6) ?? "?"}',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.tag, color: Colors.blue),
                title: const Text('Finding ID'),
                subtitle: Text('#${widget.finding.id ?? "?"}'),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

