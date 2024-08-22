class ApiResponse {
  final int status;
  final String message;
  final String userId;
  final String token;
  final List<JobModel> jobList;

  ApiResponse({
    required this.status,
    required this.message,
    required this.userId,
    required this.token,
    required this.jobList,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var jobListJson = json['job_id'] as List? ?? [];
    List<JobModel> jobList = jobListJson.map((jobJson) => JobModel.fromJson(jobJson)).toList();

    return ApiResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      userId: json['user_id'] ?? '',
      token: json['token'] ?? '',
      jobList: jobList,
    );
  }
}

class JobModel {
  final String jobId;
  final String vehicleId;
  final String jobNo;
  final String startDate;
  final String endDate;
  final String completed;
  final String destination;
  final String driverName;
  final String vehicleNo;
  final String clientName;

  JobModel({
    required this.jobId,
    required this.vehicleId,
    required this.jobNo,
    required this.startDate,
    required this.endDate,
    required this.completed,
    required this.destination,
    required this.driverName,
    required this.vehicleNo,
    required this.clientName,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      jobId: json['job_id'] ?? '',
      vehicleId: json['vehicle_id'] ?? '',
      jobNo: json['job_no'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['enddate'] ?? '',
      completed: json['completed'] ?? '',
      destination: json['destination'] ?? '',
      driverName: json['driver_name'] ?? '',
      vehicleNo: json['vehicleNo'] ?? '',
      clientName: json['clientName'] ?? '',
    );
  }
}

