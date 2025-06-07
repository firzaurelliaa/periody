// File: lib/widgets/status_alert.dart

import 'package:flutter/material.dart';

// Enum untuk mendefinisikan tipe status alert
enum AlertStatus { normal, berpotensi, berisiko }

class StatusAlert extends StatelessWidget {
  final AlertStatus status;
  final VoidCallback? onTap; // Menambahkan callback onTap agar bisa diklik

  const StatusAlert({
    Key? key,
    required this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    // Menentukan warna, ikon, dan teks berdasarkan status
    switch (status) {
      case AlertStatus.normal:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green;
        icon = Icons.spa; // Menggunakan ikon daun/tunas seperti di gambar Alert.png
        text = 'Normal';
        break;
      case AlertStatus.berpotensi:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        icon = Icons.warning_amber_rounded;
        text = 'Berpotensi';
        break;
      case AlertStatus.berisiko:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red;
        icon = Icons.cancel_outlined; // Menggunakan ikon cancel untuk Berisiko
        text = 'Berisiko';
        break;
      // Default case jika ada status yang tidak terdefinisi
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey;
        icon = Icons.info_outline;
        text = 'Unknown';
    }

    return GestureDetector(
      onTap: onTap, // Menerapkan callback onTap
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20), // Bentuk kapsul
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Agar Container mengikuti ukuran kontennya
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}