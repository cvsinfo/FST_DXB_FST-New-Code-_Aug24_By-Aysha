enum JobStatus {
  pending,
  approved,
  unknown,
}

class JobHistory {
  final String statusDate;
  final String statusTime;
  final String status;
  final String location;
  final String vehicleNo;
  final JobStatus status2;

  JobHistory({
    required this.statusDate,
    required this.statusTime,
    required this.status,
    required this.location,
    required this.vehicleNo,
    required this.status2,
  });

  factory JobHistory.fromJson(Map<String, dynamic> json) {
    return JobHistory(
      statusDate: json['status_date'],
      statusTime: json['status_time'],
      status: json['status'],
      location: json['location'],
      vehicleNo: json['vehicleNo'],
      status2: json['status2'] == '42'
          ? JobStatus.pending
          : json['status2'] == '43'
          ? JobStatus.approved
          : JobStatus.unknown,
    );
  }
}
