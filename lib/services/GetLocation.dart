import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";

Future<String> getLocationInName() async {
  try {
    //get the location in coordinates
    final locationInCoordinates = await getLocationInCoordinates();

    //geocode the location from coordinates
    final result = await placemarkFromCoordinates(
        locationInCoordinates.latitude, locationInCoordinates.longitude);

    //return the processed location
    if (result.isNotEmpty) {
      Placemark location = result[0];
      return '${location.locality}, ${location.administrativeArea}';
    }
    throw Exception();
  } catch (exception) {
    //
    //permission denied exceptions
    if (exception.toString() == "Permssion is denied Forever! :(") {
      throw Exception(exception.toString());
    }
    if (exception.toString() == "Permssion is denied! :(") {
      throw Exception(exception.toString());
    }

    //location turned off exception
    if (exception.toString() == "Turn on Location for the feature! ") {
      throw Exception(exception.toString());
    }

    //generic exception
    throw Exception("Error Getting Location Automatically");
  }
}

Future<Position> getLocationInCoordinates() async {
  //permission denied checkers
  if (await Geolocator.checkPermission() == LocationPermission.deniedForever) {
    throw Exception("Permssion is denied Forever! :(");
  }
  if (await Geolocator.checkPermission() == LocationPermission.denied) {
    Geolocator.requestPermission();
    throw Exception("Permssion is denied! :(");
  }

  //location turned on check
  if (!(await Geolocator.isLocationServiceEnabled())) {
    throw Exception("Turn on Location for the feature! ");
  }

  try {
    //get the location from GPS of the device with high accuracy
    final location = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return location;
  } catch (exception) {
    //
    //generic exception
    throw Exception("Error retrieving device Location");
  }
}
