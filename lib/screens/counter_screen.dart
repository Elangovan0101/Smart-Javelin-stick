import 'package:flutter/material.dart';
import 'dart:async';

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _seconds = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        timer.cancel();
        // Handle timer completion
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$_seconds',
        style: TextStyle(fontSize: 48, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
