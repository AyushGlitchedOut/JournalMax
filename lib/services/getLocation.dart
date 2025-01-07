import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";

Future<String> getLocationInName() async {
  try {
    final LocationInCoordinates = await getLocationInCoordinates();
    final result = await placemarkFromCoordinates(
        LocationInCoordinates.latitude, LocationInCoordinates.longitude);
    if (result.isNotEmpty) {
      Placemark location = result[0];
      return '${location.locality}, ${location.administrativeArea}';
    }
    throw Exception();
  } catch (exception) {
    if (exception.toString() == "Permssion is denied Forever! :(") {
      throw Exception(exception.toString());
    }
    if (exception.toString() == "Permssion is denied! :(") {
      throw Exception(exception.toString());
    }
    if (exception.toString() == "Turn on Location for the feature! ") {
      throw Exception(exception.toString());
    }
    throw Exception("Error Getting Location Automatically");
  }
}

Future<Position> getLocationInCoordinates() async {
  if (await Geolocator.checkPermission() == LocationPermission.deniedForever) {
    throw Exception("Permssion is denied Forever! :(");
  }
  if (await Geolocator.checkPermission() == LocationPermission.denied) {
    Geolocator.requestPermission();
    throw Exception("Permssion is denied! :(");
  }
  if (!await Geolocator.isLocationServiceEnabled()) {
    throw Exception("Turn on Location for the feature! ");
  }
  try {
    final location = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return location;
  } catch (exception) {
    throw Exception("Error retrieving device Location");
  }
}
