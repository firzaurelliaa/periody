// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';

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
        backgroundColor = const Color(0xFFD2FCE2); 
        textColor = const Color(0xFF38B069);
        iconData = Icons.grass;
        text = 'Normal';
        break;
      case AlertStatus.potential:
        backgroundColor = const Color(0xFFFFE9B6);
        textColor = const Color(0xFFDFB034);
        iconData = Icons.warning_amber_rounded; 
        text = 'Berpotensi';
        break;
      case AlertStatus.risky:
        backgroundColor = const Color(0xFFFFC9CC);
        textColor = const Color(0xFFDD424C);
        iconData = Icons.dangerous;
        text = 'Berisiko';
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 42.0,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
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
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(          
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: textColor,
                size: 20, 
              ),
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}