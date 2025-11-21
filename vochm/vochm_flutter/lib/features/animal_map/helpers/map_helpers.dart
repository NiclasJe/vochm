import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vochm_client/vochm_client.dart' as api;

const defaultCenter = LatLng(59.3293, 18.0686);
const defaultZoom = 5.0;

List<Marker> markersFromFindings(
  List<api.AnimalFinding> findings, {
  void Function(api.AnimalFinding)? onTap,
}) {
  return findings
      .map(
        (f) => Marker(
          point: LatLng(f.latitude!, f.longitude!),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: onTap != null ? () => onTap(f) : null,
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
      )
      .toList();
}
