import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Ensure this import is correct
import 'screens/dashboard_screen.dart'; // Make sure you have this file and route defined

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Javelin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(), // Make sure you have this screen defined
      },
    );
  }
}
