import 'package:flutter/material.dart';

class PlayerGuideScreen extends StatelessWidget {
  const PlayerGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Guide'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Text(
              'Master Your Throw:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Grip Technique Section
            const Text(
              '1. Holding the Grip:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/grip.jpg',
              height: 135,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            const Text(
              'The Finnish grip is generally considered the best and most popular grip among professional javelin throwers. It provides a balance between control and power, allowing the athlete to generate optimal force and maintain stability during the throw. ',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Best Angle to Throw Section
            const Text(
              '2. Best Angle to Throw:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/angle.jpg', // Replace with the path to your image
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            const Text(
              'The optimal angle for maximum distance in a projectile motion (like a javelin throw) is around 45° under ideal conditions—this assumes no air resistance and a flat surface. However, for javelin throws, the real-world optimal angle tends to be 30° to 36° because the javelin behaves differently than a standard projectile, due to factors like aerodynamic drag and the need to control its flight stability.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
