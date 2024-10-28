import 'package:flutter/material.dart';
import 'dart:async';

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
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
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$_seconds',
        style: TextStyle(fontSize: 60, color: Colors.white, backgroundColor: Colors.black),
      ),
    );
  }
}
