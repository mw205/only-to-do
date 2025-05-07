import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});
  static String id = '/SleepScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Greeting and Profile Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Good Morning! Lujyy',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  // Placeholder for profile icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        // Replace with your actual image asset if available
                        image: NetworkImage(
                            'https://placehold.co/50x50/6666FF/FFFFFF?text=L&font=Inter'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 30), // Fallback icon
                  ),
                ],
              ),
              const Gap(30),

              // Sleep Cycle Display
              Center(
                child: SizedBox(
                  width: 280, // Adjusted size to better fit the content
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer circle
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1C2A4F)
                                .withValues(alpha: 0.8), // Darker purple-blue
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ]),
                      ),
                      // Inner circle for progress (simplified)
                      Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF3A2D69),
                              width: 12), // Darker purple border
                        ),
                      ),
                      // Custom painter for the clock face and progress
                      CustomPaint(
                        size: const Size(240, 240),
                        painter: SleepCyclePainter(
                            progressColor: const Color(
                                0xFF6750A4)), // Lighter purple for progress
                      ),
                      // Sleep duration text
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.nightlight_round,
                              color: Color(0xFFE063FF), size: 30), // Moon icon
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
                            style:
                                TextStyle(fontSize: 20, color: Colors.white70),
                          ),
                        ],
                      ),
                      // "Zzz" icon at the bottom of the circle
                      Positioned(
                        bottom: 35, // Adjust position as needed
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6750A4), // Lighter purple
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            'zZ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(25),

              // Start Sleep Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement start sleep functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4), // Lighter purple
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Start sleep',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const Gap(30),

              // Bed time, Alarm, Siesta Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn(Icons.king_bed_outlined, 'Bed time',
                        '22:00', const Color(0xFFE063FF)),
                    _buildInfoColumn(Icons.alarm, 'Alarm', '7:00 Am',
                        const Color(0xFFE063FF)),
                    _buildInfoColumn(Icons.wb_sunny_outlined, 'Siesta', '2hr',
                        const Color(0xFFE063FF),
                        iconText: "zZ"),
                  ],
                ),
              ),
              const Gap(30),

              // Sleeping Tips Section
              const Text(
                'Sleeping Tips',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Gap(10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(
                        0xFF1C2A4F), // Darker blue for card background
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Manage stress: Find healthy ways to cope with stress, such as meditation or deep breathing exercises.',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                height: 1.4),
                          ),
                          const Gap(10),
                          TextButton(
                            onPressed: () {
                              // TODO: Implement "Find out" functionality
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF6750A4)
                                    .withValues(alpha: 0.7),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Text(
                              'Find out',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    // Placeholder for the image in the card
                    // In a real app, you'd use an Image.asset or Image.network
                    // For simplicity, using a colored container or an icon
                    Opacity(
                      opacity: 0.7, // Making the placeholder image a bit subtle
                      child: Image.network(
                        'https://placehold.co/80x80/FFC0CB/000000?text=Tip&font=Inter', // Placeholder pinkish image
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.lightbulb_outline,
                                size: 50, color: Color(0xFFE063FF)),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(), // Pushes bottom nav to the bottom
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlight_round_outlined),
            activeIcon: Icon(Icons.nightlight_round),
            label: 'Sleep',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa_outlined), // Lotus like icon
            activeIcon: Icon(Icons.spa),
            label: 'Relax',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0, // Default selected tab
        onTap: (index) {
          // TODO: Handle navigation tap
        },
      ),
    );
  }

  Widget _buildInfoColumn(
      IconData icon, String title, String subtitle, Color iconColor,
      {String? iconText}) {
    return Column(
      children: [
        Row(
          children: [
            if (iconText != null)
              Text(iconText,
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold))
            else
              Icon(icon, color: iconColor, size: 20),
            const Gap(5),
            Text(title,
                style: const TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
        const Gap(4),
        Text(subtitle,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ],
    );
  }
}

// Custom Painter for the Sleep Cycle Clock
class SleepCyclePainter extends CustomPainter {
  final Color progressColor;

  SleepCyclePainter({required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) -
        10; // Adjusted radius for padding

    // Paint for the clock background (already handled by container, but can add details here)
    final backgroundPaint = Paint()
      ..color =
          Colors.transparent // Assuming outer container handles background
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1; // Thin line for the main circle if needed

    canvas.drawCircle(center, radius, backgroundPaint);

    // Paint for the hour markers
    final markerPaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double markerLength = 6;
    const double longMarkerLength = 10;

    for (int i = 0; i < 12; i++) {
      final angle = (i / 12.0) * 2 * math.pi - math.pi / 2; // Start from top
      final isHourMark = (i % 3 == 0); // Longer marks for 12, 3, 6, 9
      final currentMarkerLength = isHourMark ? longMarkerLength : markerLength;

      final Offset startPoint = Offset(
        center.dx +
            (radius - currentMarkerLength - 2) *
                math.cos(angle), // -2 for slight inset
        center.dy + (radius - currentMarkerLength - 2) * math.sin(angle),
      );
      final Offset endPoint = Offset(
        center.dx + (radius - 2) * math.cos(angle),
        center.dy + (radius - 2) * math.sin(angle),
      );
      canvas.drawLine(startPoint, endPoint, markerPaint);

      // Draw numbers for 12, 3, 6, 9
      if (isHourMark) {
        String numberText;
        switch (i) {
          case 0:
            numberText = "12";
            break;
          case 3:
            numberText = "3";
            break;
          case 6:
            numberText = "6";
            break;
          case 9:
            numberText = "9";
            break;
          default:
            numberText = "";
        }
        if (numberText.isNotEmpty) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: numberText,
              style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          // Adjust position to be outside the markers
          final textOffset = Offset(
            center.dx +
                (radius - currentMarkerLength - 15) * math.cos(angle) -
                textPainter.width / 2,
            center.dy +
                (radius - currentMarkerLength - 15) * math.sin(angle) -
                textPainter.height / 2,
          );
          textPainter.paint(canvas, textOffset);
        }
      }
    }

    // Paint for the progress arc (example: 6.5 hours out of 12)
    // This is a static representation for now.
    // 6.5 hours = 6.5 / 12 * 2 * PI
    final progressAngle = (6.5 / 12.0) * 2 * math.pi;
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 // Width of the progress arc
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(
          center: center, radius: radius - 6), // -6 to fit inside the border
      -math.pi / 2, // Start angle (top)
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Set to true if properties change and repaint is needed
  }
}
