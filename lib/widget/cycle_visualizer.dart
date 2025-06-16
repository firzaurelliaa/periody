// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math';

class CycleVisualizer extends StatelessWidget {
  final int currentDay;
  final int totalDaysInCycle;
  final int mensDuration;
  final int follicularDuration;
  final int ovulationDuration;
  final int lutealDuration;

  const CycleVisualizer({
    Key? key,
    required this.currentDay,
    required this.totalDaysInCycle,
    required this.mensDuration,
    required this.follicularDuration,
    required this.ovulationDuration,
    required this.lutealDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double anglePerDay = (2 * pi) / totalDaysInCycle;
    const double startAngle = -pi / 2;
    const double outerRadius = 135.0;
    const double strokeWidth = 30.0;

    final double currentDayAngle = startAngle + (anglePerDay * (currentDay - 0.5));
    final double centerX = 280 / 2; // Center of the CustomPaint's size
    final double centerY = 280 / 2; // Center of the CustomPaint's size

    final double currentDayX = centerX + outerRadius * cos(currentDayAngle);
    final double currentDayY = centerY + outerRadius * sin(currentDayAngle);

    Widget phaseIcon;
    Color phaseIndicatorColor;

    if (currentDay >= 1 && currentDay <= mensDuration) {
      phaseIcon = Icon(Icons.water_drop_rounded, size: 30, color: Colors.red);
      phaseIndicatorColor = Colors.white;
    } else if (currentDay > mensDuration &&
        currentDay <= (mensDuration + follicularDuration)) {
      phaseIcon = const Icon(Icons.spa_rounded, size: 20, color: Colors.white);
      phaseIndicatorColor = Colors.pink.shade200;
    } else if (currentDay > (mensDuration + follicularDuration) &&
        currentDay <= (mensDuration + follicularDuration + ovulationDuration)) {
      phaseIcon = const Icon(Icons.favorite_rounded, size: 20, color: Colors.white);
      phaseIndicatorColor = Colors.purple.shade200;
    } else {
      phaseIcon = const Icon(Icons.wb_sunny_rounded, size: 20, color: Colors.white);
      phaseIndicatorColor = Colors.blue.shade200;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFDE9EA),
          ),
        ),
        SizedBox(
          width: 280,
          height: 280,
          child: CustomPaint(
            painter: CyclePainter(
              currentDay: currentDay,
              totalDaysInCycle: totalDaysInCycle,
              mensDuration: mensDuration,
              follicularDuration: follicularDuration,
              ovulationDuration: ovulationDuration,
              lutealDuration: lutealDuration,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentDay >= 1 && currentDay <= mensDuration)
              Icon(Icons.water_drop_rounded, size: 60, color: Colors.red)
            else if (currentDay > mensDuration &&
                currentDay <= (mensDuration + follicularDuration))
              Icon(Icons.spa_rounded, size: 60, color: Colors.pink.shade300)
            else if (currentDay > (mensDuration + follicularDuration) &&
                currentDay <=
                    (mensDuration + follicularDuration + ovulationDuration))
              Icon(Icons.favorite_rounded, size: 60, color: Colors.purple.shade300)
            else
              Icon(Icons.wb_sunny_rounded, size: 60, color: Colors.blue.shade300),
            const SizedBox(height: 10),
            Text(
              'Hari-$currentDay',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            if (currentDay >= 1 && currentDay <= mensDuration)
              const Text('Menstruasi', style: TextStyle(color: Colors.red))
            else if (currentDay > mensDuration &&
                currentDay <= (mensDuration + follicularDuration))
              Text('Folikuler', style: TextStyle(color: Colors.pink.shade300))
            else if (currentDay > (mensDuration + follicularDuration) &&
                currentDay <=
                    (mensDuration + follicularDuration + ovulationDuration))
              Text('Ovulasi', style: TextStyle(color: Colors.purple.shade300))
            else
              Text('Luteal', style: TextStyle(color: Colors.blue.shade300)),
            const SizedBox(height: 4),
            Text(
              '${totalDaysInCycle - currentDay} hari lagi siklus berakhir',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        Positioned(
          left: currentDayX - (strokeWidth / 2) - 4, // Adjust for size of container
          top: currentDayY - (strokeWidth / 2) - 4, // Adjust for size of container
          child: Container(
            width: strokeWidth + 8, // Make it slightly larger than stroke
            height: strokeWidth + 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: phaseIndicatorColor,
              border: Border.all(color: Colors.white, width: 2.0),
            ),
            child: Center(
              child: phaseIcon,
            ),
          ),
        ),
      ],
    );
  }
}

class CyclePainter extends CustomPainter {
  final int currentDay;
  final int totalDaysInCycle;
  final int mensDuration;
  final int follicularDuration;
  final int ovulationDuration;
  final int lutealDuration;

  CyclePainter({
    required this.currentDay,
    required this.totalDaysInCycle,
    required this.mensDuration,
    required this.follicularDuration,
    required this.ovulationDuration,
    required this.lutealDuration,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const outerRadius = 135.0;
    const strokeWidth = 12.0;

    final Color mensColor = Colors.red.shade300;
    final Color follicularColor = Colors.pink.shade200;
    final Color ovulationColor = Colors.purple.shade200;
    final Color lutealColor = Colors.blue.shade200;

    final Paint trackPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    const startAngle = -pi / 2;
    final anglePerDay = (2 * pi) / totalDaysInCycle;

    int dayCounter = 0;

    for (int i = 0; i < mensDuration; i++) {
      dayCounter++;
      final Color color =
          dayCounter <= currentDay ? mensColor : mensColor.withOpacity(0.3);
      trackPaint.color = color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle + (anglePerDay * (dayCounter - 1)),
        anglePerDay,
        false,
        trackPaint,
      );
    }

    for (int i = 0; i < follicularDuration; i++) {
      dayCounter++;
      final Color color =
          dayCounter <= currentDay ? follicularColor : follicularColor.withOpacity(0.3);
      trackPaint.color = color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle + (anglePerDay * (dayCounter - 1)),
        anglePerDay,
        false,
        trackPaint,
      );
    }

    for (int i = 0; i < ovulationDuration; i++) {
      dayCounter++;
      final Color color =
          dayCounter <= currentDay ? ovulationColor : ovulationColor.withOpacity(0.3);
      trackPaint.color = color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle + (anglePerDay * (dayCounter - 1)),
        anglePerDay,
        false,
        trackPaint,
      );
    }

    for (int i = 0; i < lutealDuration; i++) {
      dayCounter++;
      final Color color =
          dayCounter <= currentDay ? lutealColor : lutealColor.withOpacity(0.3);
      trackPaint.color = color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle + (anglePerDay * (dayCounter - 1)),
        anglePerDay,
        false,
        trackPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CyclePainter oldDelegate) {
    return oldDelegate.currentDay != currentDay ||
        oldDelegate.totalDaysInCycle != totalDaysInCycle ||
        oldDelegate.mensDuration != mensDuration ||
        oldDelegate.follicularDuration != follicularDuration ||
        oldDelegate.ovulationDuration != ovulationDuration ||
        oldDelegate.lutealDuration != lutealDuration;
  }
}