import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Position? currentPosition;
RxString locationMessage = "Fetching location...".obs;
RxString updateTime = "".obs;

Future<void> getCurrentLocation() async {
    try {
      print('Updated location attempt at ${DateTime.now().toLocal()}');
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: true);
      updateLocationMessage(position);
    } catch (e) {
      locationMessage.value = "Failed to get location: $e";
      print("Failed to get location: $e");
    }
  }

  Future<void> checkPermissionsAndFetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationMessage.value = "Location services are disabled. Please enable them in settings.";
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationMessage.value = "Location permissions are denied. Please enable them in settings.";
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      locationMessage.value = "Location permissions are permanently denied. Please enable them in settings.";
      return;
    }

    getCurrentLocation();
  }

void updateLocationMessage(Position position) {
    currentPosition = position;
    locationMessage.value = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    updateTime.value = "Last update: ${DateTime.now().toLocal()}";
    _sendLocationToAPI(position.latitude, position.longitude);
    print("Updated location at ${DateTime.now().toLocal()}: ${position.latitude}, ${position.longitude}");
  }

Future<void> _sendLocationToAPI(double latitude, double longitude) async {
    const String jobId = "02042023T";
    const String vehicleId = "1431";

    var url = Uri.parse('https://fastandsafetest.cvs-global.com/api/driver/location_update');

    var response = await http.post(
      url,
      body: {
        'job_id': jobId,
        'longitude': longitude.toString(),
        'lattitude': latitude.toString(),
        'vehicle_id': vehicleId,
      },
    );

    if (response.statusCode == 200) {
      print("Location sent successfully");
    } else {
      print("Failed to send location: ${response.body}");
    }
  }