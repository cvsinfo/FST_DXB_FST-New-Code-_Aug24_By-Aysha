import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracklive/location_api.dart';
import 'package:workmanager/workmanager.dart';
import 'home_page.dart';
import 'location_controller.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_page.dart';
import 'globals.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await getCurrentLocation();
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LocationController());
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  Workmanager().registerPeriodicTask(
    "1",
    "locationTask",
    frequency: const Duration(minutes: 15),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pet Cart Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuart,
      ),
    );

    _controller.forward();

    // Navigate to the login page after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF043927),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              height: 300,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: child,
                  );
                },
                child: Image.asset('assets/images/fslogo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('https://locationtracker.cvs-global.com/api/Auth/login/'),
      body: {
        'email': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Login Response: $data');

      // Store job data in the controller
      Globals.jobController.updateJobList(data['job_id']);

      // Store user-related data in globals
      Globals.token = data['token'] ?? ''; // Assuming job_id is a list of jobs
      Globals.vehicleId = data['job_id']?[0]['vehicle_id'] ?? '';
      Globals.userId = data['user_id'] ?? '';
      Globals.jobId = data['job_id']?[0]['job_id'] ?? '';
      Globals.jobNo = data['job_id']?[0]['job_no'] ?? '';

      // Print the stored values to the terminal
      print('Token: ${Globals.token}');
      print('Vehicle ID: ${Globals.vehicleId}');
      print('User ID: ${Globals.userId}');
      print('Job ID: ${Globals.jobId}');
      print('Job No: ${Globals.jobNo}');


      final type = data['type'];
      if (type == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else if (type == 'driver') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      print('Login failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/login_bg.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  SizedBox(
                    width: 300,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: 300,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}