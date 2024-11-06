import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:linkjo/config/url.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required MapController mapController,
    required LatLng defaultLocation,
    required double defaultZoom,
    required List<Marker> markers,
  })  : _mapController = mapController,
        _defaultLocation = defaultLocation,
        _defaultZoom = defaultZoom,
        _markers = markers;

  final MapController _mapController;
  final LatLng _defaultLocation;
  final double _defaultZoom;
  final List<Marker> _markers;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _defaultLocation,
        initialZoom: _defaultZoom,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom |
              InteractiveFlag.drag |
              InteractiveFlag.doubleTapZoom,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: Url.MAP_LAYER,
        ),
        MarkerLayer(
          markers: _markers,
        ),
      ],
    );
  }
}
