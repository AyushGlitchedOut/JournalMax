Future<String> getLocationInName() async {
  try {
    final LocationInCoordinates = getLocationInCoordinates();
    //convert co-ordinates to place name using geocoder
    return "Unknown";
  } catch (exception) {
    //Use this for permission Error from : throw Exception(exception.toString());
    throw Exception("Error Getting Location Automatically");
  }
}

Future<String> getLocationInCoordinates() async {
  try {
    //get co-ordinates from geo-locater
    return "Unknown*N/S and Unknown*E/W";
  } catch (exception) {
    //Use this for permission Error: throw Exception("Permission not Given");
    throw Exception("Error loading location values automatically");
  }
}
