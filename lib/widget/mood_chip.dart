

// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class MoodChip extends StatelessWidget {
  final String moodName;
  final bool isSelected;
  final Map<String, String> staticImages; 
  final Map<String, String> gifImages;

  const MoodChip({
    Key? key,
    required this.moodName,
    required this.isSelected,
    required this.staticImages,
    required this.gifImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath = isSelected
        ? gifImages[moodName]! 
        : staticImages[moodName]!;

    return Chip(
      avatar: Image.asset(
        imagePath,
        width: 24,
        height: 24, 
        gaplessPlayback: true, 
      ),
      label: Text(moodName),
      backgroundColor: isSelected ? const Color(0xffFDEDED) : Colors.grey[200], 
      side: isSelected ? const BorderSide(color: Color(0xffF48A8A), width: 1.5) : BorderSide.none, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelStyle: TextStyle(
        fontSize: 14,
        color: isSelected ? const Color(0xffF48A8A) : Colors.black87,
      ),
    );
  }
}