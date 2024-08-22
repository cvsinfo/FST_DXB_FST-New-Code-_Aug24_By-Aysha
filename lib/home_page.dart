// home_page.dart
// home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'joborder_controller.dart';
import 'job_details_page.dart'; // Import the JobDetailsPage

class HomePage extends GetView<JobController> {
  const HomePage({super.key});

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle sign out logic here
                Navigator.of(context).pop();
              },
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _refreshPage() {
    // Handle refresh logic here
  }

  void _onContainerTap(job) {
    Get.to(() => JobDetailsPage(job: job)); // Navigate to JobDetailsPage with the job object
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF043927),
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/fslogo.png',
                height: 50.0,
                width: 130,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white),
                    onPressed: _refreshPage,
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      _showSignOutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        final jobs = controller.jobList;

        if (jobs.isEmpty) {
          return Center(child: Text('No job details available.'));
        }

        final job = jobs[0]; // Assuming you want to show the first job

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFF043927),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Welcome ${job.driverName}',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  margin: const EdgeInsets.only(left: 20.0), // Add left margin here
                  child: Text(
                    'Job Orders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () => _onContainerTap(job),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildJobDetailRow('Job Number:', '${job.jobNo}'),
                            _buildJobDetailRow('Driver:', '${job.driverName}'),
                            _buildJobDetailRow('Start Date:', '${job.startDate}'),
                            _buildJobDetailRow('End Date:', '${job.endDate}'),
                            _buildJobDetailRow('Destination:', '${job.destination}'),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: job.completed == '1' ? Colors.green : Colors.green,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              job.completed == '0' ? 'Active' : 'Completed',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

Widget _buildJobDetailRow(String label, String data) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            data,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
