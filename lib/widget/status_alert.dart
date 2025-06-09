import 'package:flutter/material.dart';

// Enum untuk status alert
enum AlertStatus { normal, potential, risky }

class StatusAlert extends StatelessWidget {
  final AlertStatus status;
  final VoidCallback? onTap;

  const StatusAlert({
    Key? key,
    required this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData iconData;
    String text;

    switch (status) {
      case AlertStatus.normal:
        backgroundColor = const Color(0xFFE0FFEF); // Green background
        textColor = const Color(0xFF28A745); // Darker green text
        iconData = Icons.grass; // Icon rumput
        text = 'Normal';
        break;
      case AlertStatus.potential:
        backgroundColor = const Color(0xFFFFF3CD); // Yellow background
        textColor = const Color(0xFFFFC107); // Orange-yellow text
        iconData = Icons.warning_amber_rounded; // Icon warning
        text = 'Berpotensi';
        break;
      case AlertStatus.risky:
        backgroundColor = const Color(0xFFF8D7DA); // Red background
        textColor = const Color(0xFFDC3545); // Darker red text
        iconData = Icons.crisis_alert; // Icon risiko
        text = 'Berisiko';
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150, // Lebar fixed sesuai desain (bisa disesuaikan)
        height: 50, // Tinggi fixed
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25), // Bentuk pill
          boxShadow: [ // Shadow ringan seperti di desain
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Agar row tidak mengambil lebar penuh
          mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten
          children: [
            Icon(
              iconData,
              color: textColor,
              size: 20, // Ukuran ikon
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16, // Ukuran font
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}