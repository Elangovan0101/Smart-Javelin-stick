// ignore: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PastThrowsScreen extends StatefulWidget {
  const PastThrowsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PastThrowsScreenState createState() => _PastThrowsScreenState();
}

class _PastThrowsScreenState extends State<PastThrowsScreen> {
  List<Map<String, dynamic>> pastData = [];

  @override
  void initState() {
    super.initState();
    fetchPastData();
  }

  Future<void> fetchPastData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/past')); // Replace with your past data endpoint
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          pastData = List<Map<String, dynamic>>.from(jsonData);
        });
      } else {
        throw Exception('Failed to load past data');
      }
    } catch (error) {
      print('Error fetching past data: $error');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to fetch past data. Please check your connection."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Throws'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: pastData.length,
          itemBuilder: (context, index) {
            final throwData = pastData[index];
            return Card(
              child: ListTile(
                title: Text('Throw ${index + 1}'),
                subtitle: Text(
                  'Angle: ${throwData['angle']}\n'
                  'Time: ${throwData['time']}\n'
                  'Force: ${throwData['force']}\n'
                  'Distance: ${throwData['distance']}',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
