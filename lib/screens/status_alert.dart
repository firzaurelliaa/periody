// File: lib/widget/status_alert.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:periody/models/alert_status.dart'; // Import the AlertStatus enum

class StatusAlert extends StatelessWidget {
  final AlertStatus status; // Changed from String to AlertStatus
  final VoidCallback onTap;

  const StatusAlert({
    super.key,
    required this.status,
    required this.onTap,
  });

  Color _getBackgroundColor() {
    switch (status) {
      case AlertStatus.normal:
        return const Color(0xFFF99D9D); // Warna untuk 'Normal'
      case AlertStatus.warning:
        return Colors.orange; // Warna untuk 'Peringatan'
      case AlertStatus.danger:
        return const Color(0xFFB76868); // Warna untuk 'Bahaya'
      default:
        return const Color(0xFFF99D9D); // Default
    }
  }

  String _getMessage() {
    switch (status) {
      case AlertStatus.normal:
        return 'Siklus kamu normal';
      case AlertStatus.warning:
        return 'Masa subur/mendekati';
      case AlertStatus.danger:
        return 'Masa menstruasi/telat';
      default:
        return 'Status tidak diketahui';
    }
  }

  IconData _getIcon() {
    switch (status) {
      case AlertStatus.normal:
        return Icons.check_circle_outline;
      case AlertStatus.warning:
        return Icons.warning_amber_rounded;
      case AlertStatus.danger:
        return Icons.error_outline_rounded;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  _getIcon(),
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  _getMessage(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}