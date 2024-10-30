import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_javelin/widgets/PastThrowsScreen.dart';
import 'package:flutter_application_javelin/widgets/player_guide_screen.dart';
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
  String suggestionMessage = 'To get started with javelin throw, please click the button.';
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
    channel = IOWebSocketChannel.connect('ws://192.168.4.1:81/');
    channel!.stream.listen(
      (message) {
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
          _generateSuggestion();
        } catch (e) {
          print('Error decoding JSON: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
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

  // Function to generate suggestions based on throw data
  void _generateSuggestion() {
    String suggestion = '';
    
    double? angle = double.tryParse(data['angle']);
    double? velocity = double.tryParse(data['velocity']);
    double? distance = double.tryParse(data['distance']);
    double? tof = double.tryParse(data['tof']);
    double? pressure = double.tryParse(data['pressure']);
    
    // Feedback based on angle
    if (angle != null) {
      if (angle < 25) {
        suggestion += 'Consider increasing your throw angle for better distance. ';
      } else if (angle > 35) {
        suggestion += 'Try lowering your angle slightly for improved trajectory. ';
      } else {
        suggestion += 'Good angle! Maintaining this should help your throws. ';
      }
    }

    // Feedback based on velocity and distance
    if (velocity != null && distance != null) {
      if (velocity < 15) {
        suggestion += 'Focus on increasing your throw speed to cover more distance. ';
      } else if (velocity > 20 && distance < 30) {
        suggestion += 'Work on your release technique to make better use of your speed. ';
      }     }

    // Feedback based on pressure
    if (pressure != null) {
      if (pressure < 5) {
        suggestion += 'Strengthen your grip for a more controlled throw. ';
      } else if (pressure > 10) {
        suggestion += 'Loosen your grip slightly for a smooth release. ';
      }
    }

    // Feedback based on time of flight
    if (tof != null) {
      if (tof < 2) {
        suggestion += 'Improve your follow-through for longer flight ';
      } else {
        suggestion += 'Great follow-through! Keep it consistent. ';
      }
    }

    // Provide a summary suggestion if applicable
    if (suggestion.isEmpty) {
      suggestion = 'Keep practicing! Your progress is key to improvement.';
    }

    // Debugging statement to check the suggestion
    print('Suggestion: $suggestion');

    // Update the suggestion message to be displayed in the UI
    setState(() {
      suggestionMessage = suggestion.isNotEmpty ? suggestion : 'To get started with javelin throw, please click the button.';
    });
  }

  void _navigateToPastThrows() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PastThrowsScreen()), // Ensure PastThrowsScreen is imported correctly
    );
  }

  void _navigateToPlayerGuide() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayerGuideScreen()), // Ensure PlayerGuideScreen is imported correctly
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Javelin Throw Dashboard'),
        backgroundColor: Colors.blueGrey[900],
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
                Navigator.pop(context);
                _navigateToPastThrows();
              },
            ),
            ListTile(
              title: const Text('Player Guide'),
              onTap: () {
                Navigator.pop(context);
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
                  Text(
                    suggestionMessage, // Display suggestion message here
                    style: const TextStyle(fontSize: 20, color: Colors.white),
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
    channel?.sink.close();
    super.dispose();
  }
}
