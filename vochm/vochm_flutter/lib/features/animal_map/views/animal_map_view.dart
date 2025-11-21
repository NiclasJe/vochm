import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vochm_client/vochm_client.dart' as api;

import '../controllers/animal_map_controller.dart';
import '../helpers/map_helpers.dart';
import 'animal_selection_sheet.dart';
import 'finding_info_sheet.dart';

class AnimalMapView extends StatelessWidget {
  const AnimalMapView({
    super.key,
    required this.controller,
  });

  final AnimalMapController controller;

  void _handleMapTap(TapPosition tapPos, LatLng latLng, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AnimalSelectionSheet(
        controller: controller,
        location: latLng,
      ),
    );
  }

  void _handleMarkerTap(api.AnimalFinding finding, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => FindingInfoSheet(
        finding: finding,
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: defaultCenter,
              initialZoom: defaultZoom,
              onTap: (tapPos, latLng) => _handleMapTap(tapPos, latLng, context),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.vochm_flutter',
              ),
              MarkerLayer(
                markers: markersFromFindings(
                  controller.findings,
                  onTap: (finding) => _handleMarkerTap(finding, context),
                ),
              ),
            ],
          ),
        ),
        if (controller.isLoading)
          const LinearProgressIndicator(),
      ],
    );
  }
}
