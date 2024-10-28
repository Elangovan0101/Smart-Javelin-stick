import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../widgets/circular_progress.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtain the data from the DataProvider
    final dataProvider = Provider.of<DataProvider>(context);
    final data = dataProvider.data ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Throw Details'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background-1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Throw Details', style: TextStyle(fontSize: 24, color: Colors.white)),
                  const SizedBox(height: 20),
                  CircularProgress(value: data['angle']?.toDouble() ?? 0, size: 120),
                  Text('Angle of Throw: ${data['angle'] ?? 'No data available'}', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),
                  CircularProgress(value: data['tof']?.toDouble() ?? 0, size: 120),
                  Text('Time of Flight: ${data['tof'] ?? 'No data available'}', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),
                  CircularProgress(value: data['distance']?.toDouble() ?? 0, size: 120),
                  Text('Distance of Throw: ${data['distance'] ?? 'No data available'}', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),
                  CircularProgress(value: data['velocity']?.toDouble() ?? 0, size: 120),
                  Text('Velocity: ${data['velocity'] ?? 'No data available'}', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
