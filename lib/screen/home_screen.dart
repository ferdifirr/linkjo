import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:linkjo/config/routes.dart';
import 'package:linkjo/config/url.dart';
import 'package:linkjo/service/hive_service.dart';
import 'package:linkjo/service/location_service.dart';
import 'package:linkjo/service/websocket_service.dart';
import 'package:linkjo/util/asset.dart';
import 'package:linkjo/util/log.dart';
import 'package:linkjo/widget/home_drawer.dart';
import 'package:linkjo/widget/map_widget.dart';
import 'package:linkjo/widget/vendor_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WebSocketService _webSocketService = WebSocketService();
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  final LatLng _defaultLocation = const LatLng(-7.494855, 112.715499);
  final List<Marker> _markers = [];
  final double _defaultZoom = 17.0;

  void _getUsersLocation() async {
    Position? position = await _locationService.getCurrentPosition();
    if (position != null) {
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        _defaultZoom,
      );
    }
  }

  void _initWebsocket() {
    var username = HiveService.getUserData()['username'];
    var handshakeMsg = {
      "type": "handshake",
      "role": "user",
      "username": username,
    };
    _webSocketService.connect(
      Url.WS_URL,
      onMessageCallback: _handleMessage,
    );
    _webSocketService.sendMessage(
      handshakeMsg,
    );
  }

  _handleMessage(dynamic message) {
    Log.d(message);
    switch (message['type']) {
      case 'locationUpdate':
        _updateVendorLocation(message);
        break;
      case 'vendorList':
        _initializeVendorMarkers(message);
        break;
      case 'vendorDisconnected':
        final username = message['username'];
        setState(() {
          _markers.removeWhere((m) => m.key == Key(username));
        });
        break;
      default:
        Log.d("Pesan tidak dikenali: ${message['type']}");
    }
  }

  void _updateVendorLocation(dynamic message) {
    final LatLng location = LatLng(
      message['latitude'],
      message['longitude'],
    );
    final String username = message['username'];

    final marker = Marker(
      key: Key(username),
      point: location,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () => _showVendorInfo(location),
        child: const CircleAvatar(
          backgroundImage: AssetImage(
            Asset.logo,
          ),
        ),
      ),
    );

    setState(() {
      final index = _markers.indexWhere((m) => m.key == Key(username));
      if (index != -1) {
        _markers[index] = marker;
      } else {
        _markers.add(marker);
      }
    });
  }

  void _initializeVendorMarkers(dynamic message) {
    Log.d(message);
    final List<dynamic> vendors = message['vendors'];
    setState(() {
      _markers.clear();
      if (vendors.isEmpty) return;
      for (var vendor in vendors) {
        final LatLng location = LatLng(vendor['latitude'], vendor['longitude']);
        final String username = vendor['username'];

        final marker = Marker(
          key: Key(username),
          point: location,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () => _showVendorInfo(location),
            child: const CircleAvatar(
              backgroundImage: AssetImage(
                Asset.logo,
              ),
            ),
          ),
        );

        _markers.add(marker);
      }
    });
  }

  _showVendorInfo(LatLng location) {
    _mapController.move(location, _defaultZoom);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const VendorInfo();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getUsersLocation();
    _initWebsocket();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Linkjo'),
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: const CircleAvatar(
                backgroundImage: AssetImage(
                  Asset.logo,
                ),
              ),
            ),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              _getUsersLocation();
              _initWebsocket();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.message,
              );
            },
            icon: const Icon(Icons.forum_rounded),
          ),
        ],
      ),
      body: MapWidget(
        mapController: _mapController,
        defaultLocation: _defaultLocation,
        defaultZoom: _defaultZoom,
        markers: _markers,
      ),
      drawer: const HomeDrawer(),
    );
  }
}
