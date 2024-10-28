import 'package:flutter/material.dart';

class Records extends StatelessWidget {
  final Map<String, dynamic> data;

  Records({required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Angle of Throw: ${data['angle']} Degree'),
          ),
          ListTile(
            title: Text('Time of Flight: ${data['tof']} sec'),
          ),
          ListTile(
            title: Text('Force: ${data['force']}'),
          ),
          ListTile(
            title: Text('Distance of Throw: ${data['distance']} cm'),
          ),
        ],
      ),
    );
  }
}
