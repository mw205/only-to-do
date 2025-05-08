import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../gen/assets.gen.dart';

class SleepCycle extends StatelessWidget {
  const SleepCycle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1C2A4F),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
          ),
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF3A2D69),
                width: 25,
              ),
            ),
          ),

          Transform.scale(
            scale: 1.3,
            child: Assets.images.clockOutline.svg(),
          ),

          // Sleep duration text
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(8),
              Text(
                '6Hr',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                '30min',
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
            ],
          ),
          SizedBox(
            width: 280, // Should match the CustomPaint size for alignment
            height: 280,
            child: SleepClockWidget(progressPercent: 0.75), // Example progress
          ),
        ],
      ),
    );
  }
}

class SleepClockWidget extends StatelessWidget {
  final double progressPercent;

  const SleepClockWidget({super.key, required this.progressPercent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: const Size(280, 280),
        painter: ClockPainter(progressPercent: progressPercent),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final double progressPercent;

  ClockPainter({required this.progressPercent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double arcStrokeWidth = 25;
    final double effectiveRadius =
        (min(size.width, size.height) / 2) - (arcStrokeWidth / 2);

    final arcPaint = Paint()
      ..color = const Color(0xFF645D96) // Lighter purple for progress
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcStrokeWidth
      ..strokeCap = StrokeCap.round;

    final Rect arcRect =
        Rect.fromCircle(center: center, radius: effectiveRadius);
    double startAngle = -pi / 2; // Start at the top
    double sweepAngle = 2 * pi * progressPercent;

    canvas.drawArc(arcRect, startAngle, sweepAngle, false, arcPaint);

    final markerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double markerRadius = arcStrokeWidth / 3.5;
    final startMarkerX = center.dx + effectiveRadius * cos(startAngle);
    final startMarkerY = center.dy + effectiveRadius * sin(startAngle);
    final startMarkerCenter = Offset(startMarkerX, startMarkerY);
    canvas.drawCircle(startMarkerCenter, markerRadius, markerPaint);

    if (sweepAngle > 0) {
      final endAngle = startAngle + sweepAngle;
      final endMarkerX = center.dx + effectiveRadius * cos(endAngle);
      final endMarkerY = center.dy + effectiveRadius * sin(endAngle);
      final endMarkerCenter = Offset(endMarkerX, endMarkerY);
      canvas.drawCircle(endMarkerCenter, markerRadius, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) =>
      oldDelegate.progressPercent != progressPercent;
}
