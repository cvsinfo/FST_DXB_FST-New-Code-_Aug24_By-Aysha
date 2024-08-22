// globals.dart
import 'package:get/get.dart';
import 'joborder_controller.dart';

class Globals {
  static final jobController = Get.put(JobController());

  static String token = '';
  static String jobNo = '';
  static String vehicleId = '';
  static String userId = '';
  static String jobId = '';
}
