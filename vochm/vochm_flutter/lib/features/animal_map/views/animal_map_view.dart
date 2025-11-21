import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:vochm_client/vochm_client.dart' as api;

import '../../../service_locator.dart';
import '../controllers/animal_map_controller.dart';
import '../helpers/map_helpers.dart';
import 'animal_selection_sheet.dart';
import 'finding_info_sheet.dart';

class AnimalMapView extends StatefulWidget {
  const AnimalMapView({super.key});

  @override
  State<AnimalMapView> createState() => _AnimalMapViewState();
}

class _AnimalMapViewState extends State<AnimalMapView> {
  late final AnimalMapController controller;

  @override
  void initState() {
    super.initState();
    controller = getIt<AnimalMapController>();
  }

  void _handleMapTap(TapPosition tapPos, LatLng latLng, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AnimalSelectionSheet(
        location: latLng,
      ),
    );
  }

  void _handleMarkerTap(api.AnimalFinding finding, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => FindingInfoSheet(
        finding: finding,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimalMapController, AnimalMapState>(
      bloc: controller,
      builder: (context, state) {
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
                      state.findings,
                      onTap: (finding) => _handleMarkerTap(finding, context),
                      keyBuilder: (finding) => Key('marker-${finding.id ?? 'new'}'),
                    ),
                  ),
                ],
              ),
            ),
            if (state.isLoading) const LinearProgressIndicator(),
          ],
        );
      },
    );
  }
}
