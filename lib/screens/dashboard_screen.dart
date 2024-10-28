import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_javelin/widgets/PastThrowsScreen.dart';
import 'package:flutter_application_javelin/widgets/player_guide_screen.dart'; // Import the new screen
import 'package:web_socket_channel/io.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String name = '';
  Map<String, dynamic> data = {
    'tof': 'No data available',
    'angle': 'No data available',
    'velocity': 'No data available',
    'distance': 'No data available',
    'pressure': 'No data available',
  };
  bool timerStarted = false;
  IOWebSocketChannel? channel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      name = arguments['name'] ?? 'User';
    }
  }

  void _connectWebSocket() {
    channel = IOWebSocketChannel.connect('ws://192.168.4.1:81/'); // Update with your ESP8266 IP and port
    channel!.stream.listen(
      (message) {
        print('Received message: $message'); // Debugging: Print received message
        try {
          final jsonData = jsonDecode(message);
          setState(() {
            data = {
              'tof': jsonData['tof']?.toString() ?? 'No data available',
              'angle': jsonData['angle']?.toString() ?? 'No data available',
              'velocity': jsonData['velocity']?.toString() ?? 'No data available',
              'distance': jsonData['distance']?.toString() ?? 'No data available',
              'pressure': jsonData['pressure']?.toString() ?? 'No data available',
            };
          });
        } catch (e) {
          print('Error decoding JSON: $e'); // Debugging: Print JSON decode error
        }
      },
      onError: (error) {
        print('WebSocket error: $error'); // Debugging: Print WebSocket error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to connect to the server. Please check your connection."),
          ),
        );
      },
      onDone: () {
        print('WebSocket connection closed'); // Debugging: Print WebSocket connection close
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Connection closed by the server."),
          ),
        );
      },
    );
  }

  void handleStart() {
    if (!timerStarted) {
      _connectWebSocket();
      setState(() {
        timerStarted = true;
      });
    }
  }

  void _navigateToPastThrows() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PastThrowsScreen(),
      ),
    );
  }

  void _navigateToPlayerGuide() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlayerGuideScreen(), // Update with the PlayerGuideScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Javelin Throw Dashboard'),
        backgroundColor: Colors.blueGrey[900],
        // Removed the IconButton from AppBar actions
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Past Throws Data'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _navigateToPastThrows();
              },
            ),
            ListTile(
              title: const Text('Player Guide'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _navigateToPlayerGuide();
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background-1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Hello $name',
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'To Get Started With Javelin throw Please click the button',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: handleStart,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Start'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Parameter',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Value',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(
                          Text(
                            'Time of Flight',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          Text(
                            data['tof'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
                      DataRow(cells: [
                        const DataCell(
                          Text(
                            'Angle of Throw',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          Text(
                            data['angle'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
                      DataRow(cells: [
                        const DataCell(
                          Text(
                            'Velocity',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          Text(
                            data['velocity'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
                      DataRow(cells: [
                        const DataCell(
                          Text(
                            'Distance of Throw',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          Text(
                            data['distance'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
                      DataRow(cells: [
                        const DataCell(
                          Text(
                            'Pressure',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          Text(
                            data['pressure'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel?.sink.close(); // Close WebSocket connection
    super.dispose();
  }
}
