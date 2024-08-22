// job_controller.dart
import 'package:get/get.dart';
import 'joborder_model.dart';

class JobController extends GetxController {
  var jobList = <JobModel>[].obs;

  void updateJobList(List<dynamic> jsonList) {
    jobList.value = jsonList.map((json) => JobModel.fromJson(json as Map<String, dynamic>)).toList();
  }

}
