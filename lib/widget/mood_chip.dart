// lib/screens/add_note_page.dart (Tambahkan ini di bagian paling bawah)

import 'package:flutter/material.dart';

class MoodChip extends StatelessWidget {
  final String moodName;
  final bool isSelected;
  final Map<String, String> staticImages; // Map untuk gambar B&W
  final Map<String, String> gifImages;    // Map untuk gambar GIF

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
        ? gifImages[moodName]! // Jika dipilih, gunakan GIF
        : staticImages[moodName]!; // Jika tidak, gunakan B&W PNG

    return Chip(
      avatar: Image.asset(
        imagePath,
        width: 24, // Sesuaikan ukuran sesuai keinginan Anda
        height: 24, // Sesuaikan ukuran sesuai keinginan Anda
        gaplessPlayback: true, // Penting untuk GIF agar tidak flicker
      ),
      label: Text(moodName),
      backgroundColor: isSelected ? const Color(0xffFDEDED) : Colors.grey[200], // Warna background chip saat dipilih/tidak
      side: isSelected ? const BorderSide(color: Color(0xffF48A8A), width: 1.5) : BorderSide.none, // Border saat dipilih
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelStyle: TextStyle(
        fontSize: 14,
        color: isSelected ? const Color(0xffF48A8A) : Colors.black87, // Warna teks saat dipilih/tidak
      ),
    );
  }
}