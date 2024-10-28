import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double value;
  final double size;

  CircularProgress({required this.value, required this.size});

  @override
  Widget build(BuildContext context) {
    final radius = size / 2;
    final circumference = 2 * 3.14 * radius;

    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: CirclePainter(
                progress: value,
                radius: radius,
                circumference: circumference,
              ),
            ),
          ),
          Text('${value.toStringAsFixed(0)}%', style: TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;
  final double radius;
  final double circumference;

  CirclePainter({
    required this.progress,
    required this.radius,
    required this.circumference,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawCircle(Offset(radius, radius), radius - 5, paint);
    paint.color = Colors.red;
    paint.strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius - 5),
      -3.14 / 2,
      2 * 3.14 * (progress / 100),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
