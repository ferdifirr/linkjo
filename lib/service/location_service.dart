import 'package:geolocator/geolocator.dart';
import 'package:linkjo/util/log.dart';

class LocationService {
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<Position?> getCurrentPosition() async {
    bool hasPermission = await requestPermission();
    if (!hasPermission) {
      Log.d("Permission denied");
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      Log.d("Error getting location: $e");
      return null;
    }
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: 10,
      ),
    );
  }
}
