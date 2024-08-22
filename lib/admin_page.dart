import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'joborder_controller.dart';
import 'globals.dart';

class AdminPage extends StatelessWidget {
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

  void _onContainerTap(String jobNo) {
    // Handle the tap event, for example, navigate to job details page
    print('Tapped on job $jobNo');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  SizedBox(height: 10), // Increased space between icon and text
                  Text(
                    'Welcome Admin',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TabBar(
              tabs: [
                Tab(text: 'Job Orders'),
                Tab(text: 'Pending Status'),
              ],
              labelStyle: TextStyle(fontSize: 18), // Text size for tab labels
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Job Orders Tab
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Obx(() {
                      // Fetch the job list from the controller
                      var jobList = Globals.jobController.jobList;

                      if (jobList.isEmpty) {
                        return Center(
                          child: Text('No Job Orders available'),
                        );
                      }

                      return ListView.builder(
                        itemCount: jobList.length,
                        itemBuilder: (context, index) {
                          var job = jobList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: InkWell(
                              onTap: () => _onContainerTap(job.jobNo),
                              child: Container(
                                color: Colors.grey[300], // Grey background
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Job Number:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              job.jobNo,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              'Driver Name:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              job.driverName,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              'Start Date:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              job.startDate,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              'Due Date:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              job.endDate,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              'Destination:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              job.destination,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          job.completed == "0" ? 'Active' : 'Completed',
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
                          );
                        },
                      );
                    }),
                  ),
                  // Pending Status Tab
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            // Handle the tap event
                          },
                          child: Container(
                            color: Colors.grey[300], // Grey background
                            padding: const EdgeInsets.all(16.0),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Job Number:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '', // Add the actual data here
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Driver Name:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '', // Add the actual data here
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Start Date:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '', // Add the actual data here
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Due Date:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '', // Add the actual data here
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Destination:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '', // Add the actual data here
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '', // Add the actual status here
                                      style: TextStyle(
                                        fontSize: 16,
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
                        // Add more containers or widgets as needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
