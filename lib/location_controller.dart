import 'package:get/get.dart';
import 'dart:async';

import 'package:tracklive/location_api.dart';

class LocationController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    checkPermissionsAndFetchLocation();
    startLocationUpdates();
  }



  void startLocationUpdates() {
    Timer.periodic(Duration(minutes: 5), (Timer timer) async {
      await getCurrentLocation();
    });
  }
  
  @override
  void onDetached() {
    // TODO: implement onDetached
  }
  
  @override
  void onHidden() {
    // TODO: implement onHidden
  }
  
  @override
  void onInactive() {
    // TODO: implement onInactive
  }
  
  @override
  void onPaused() {
    // TODO: implement onPaused
  }
  
  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}