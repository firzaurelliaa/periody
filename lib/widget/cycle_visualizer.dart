import 'package:flutter/material.dart';
import 'dart:math'; // Untuk fungsi pi dan perhitungan sudut

class CycleVisualizer extends StatelessWidget {
  // Properti untuk data siklus yang akan diterima secara dinamis
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
    return Stack(
      alignment: Alignment.center,
      children: [
        // Lingkaran latar belakang utama (inner circle)
        Container(
          width: 250, // Ukuran inner circle
          height: 250,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFDE9EA), // Warna latar belakang dalam
          ),
        ),
        // Indikator siklus menggunakan CustomPainter
        SizedBox(
          width: 280, // Ukuran CustomPaint (lebih besar dari inner circle)
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
        // Konten teks dan ikon di tengah lingkaran
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.water_drop_rounded, size: 60, color: Colors.red), // Ikon utama di tengah
            SizedBox(height: 10),
            Text(
              'Hari -1', // TODO: Ganti dengan hari dinamis berdasarkan currentDay
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Menstruasi', // TODO: Ganti dengan fase dinamis berdasarkan currentDay
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 4),
            Text(
              '3 hari lagi pra Ovulasi', // TODO: Ganti dengan pesan dinamis
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),

        Positioned(
          top: 40, // Atur posisi Y
          left: 60, // Atur posisi X
          child: Transform.rotate(
            angle: -0.5, // Sudut rotasi
            child: Image.asset(
              'assets/img/darah.png', // <-- Path gambar tetesan darah Anda
              width: 20, // Ukuran gambar
              height: 20,
              color: Colors.red.shade400, // Memberi warna jika gambar ikon polos
            ),
          ),
        ),
        Positioned(
          bottom: 50, // Atur posisi Y
          right: 50, // Atur posisi X
          child: Transform.rotate(
            angle: 0.8, // Sudut rotasi
            child: Image.asset(
              'assets/img/darah.png', // <-- Path gambar tetesan darah Anda
              width: 20, // Ukuran gambar
              height: 20,
              color: Colors.red.shade400, // Memberi warna jika gambar ikon polos
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Painter untuk visualisasi siklus
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
    const outerRadius = 135.0; // Radius untuk lingkaran luar
    const strokeWidth = 12.0; // Ketebalan garis lingkaran

    // Warna dasar untuk setiap fase
    final Color trackBaseColor = Colors.pink.shade100.withOpacity(0.5);
    final Color mensActiveColor = Colors.red.shade300; // Warna aktif menstruasi
    final Color follicularActiveColor = Colors.pink.shade200; // Warna aktif folikuler
    final Color ovulationActiveColor = Colors.purple.shade200; // Warna aktif ovulasi
    final Color lutealActiveColor = Colors.blue.shade200; // Warna aktif luteal (disesuaikan dengan gambar Fase Siklus.png)

    // Warna pudar untuk fase yang sudah lewat
    final Color mensFadedColor = Colors.red.shade100;
    final Color follicularFadedColor = Colors.pink.shade50;
    final Color ovulationFadedColor = Colors.purple.shade50;
    final Color lutealFadedColor = Colors.blue.shade50; // Warna pudar luteal

    // Paint untuk track/latar belakang
    final Paint backgroundPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = trackBaseColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Sudut awal (mulai dari atas, -90 derajat)
    const startAngle = -pi / 2; // -90 derajat dalam radian

    // Gambar track lingkaran penuh sebagai latar belakang
    canvas.drawCircle(center, outerRadius, backgroundPaint);

    // Hitung sudut sapuan (sweep angle) untuk setiap fase
    final double mensSweepAngle = (mensDuration / totalDaysInCycle) * 2 * pi;
    final double follicularSweepAngle = (follicularDuration / totalDaysInCycle) * 2 * pi;
    final double ovulationSweepAngle = (ovulationDuration / totalDaysInCycle) * 2 * pi;
    final double lutealSweepAngle = (lutealDuration / totalDaysInCycle) * 2 * pi;

    double currentArcStartAngle = startAngle; // Sudut awal untuk segmen yang sedang digambar

    // --- Fase Menstruasi ---
    Paint mensPaint;
    if (currentDay >= 1 && currentDay <= mensDuration) {
      mensPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = mensActiveColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    } else {
      mensPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = mensFadedColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    }
    canvas.drawArc(Rect.fromCircle(center: center, radius: outerRadius), currentArcStartAngle, mensSweepAngle, false, mensPaint);
    currentArcStartAngle += mensSweepAngle;

    // --- Fase Folikuler ---
    Paint follicularPaint;
    if (currentDay > mensDuration && currentDay <= (mensDuration + follicularDuration)) {
      follicularPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = follicularActiveColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    } else if (currentDay < (mensDuration + follicularDuration)) { // Belum sampai fase ini
      follicularPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = follicularActiveColor.withOpacity(0.5) // Agak pudar jika belum sampai
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    }
    else { // Sudah lewat fase ini
      follicularPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = follicularFadedColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    }
    canvas.drawArc(Rect.fromCircle(center: center, radius: outerRadius), currentArcStartAngle, follicularSweepAngle, false, follicularPaint);
    currentArcStartAngle += follicularSweepAngle;

    // --- Fase Ovulasi ---
    Paint ovulationPaint;
    if (currentDay > (mensDuration + follicularDuration) && currentDay <= (mensDuration + follicularDuration + ovulationDuration)) {
      ovulationPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = ovulationActiveColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    } else if (currentDay < (mensDuration + follicularDuration + ovulationDuration)) { // Belum sampai fase ini
       ovulationPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = ovulationActiveColor.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    }
    else { // Sudah lewat fase ini
      ovulationPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = ovulationFadedColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    }
    canvas.drawArc(Rect.fromCircle(center: center, radius: outerRadius), currentArcStartAngle, ovulationSweepAngle, false, ovulationPaint);
    currentArcStartAngle += ovulationSweepAngle;

    // --- Fase Luteal ---
    Paint lutealPaint;
    if (currentDay > (mensDuration + follicularDuration + ovulationDuration) && currentDay <= totalDaysInCycle) {
      lutealPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = lutealActiveColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    } else { // Sudah lewat fase ini atau belum sampai
      lutealPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = lutealFadedColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    }
    canvas.drawArc(Rect.fromCircle(center: center, radius: outerRadius), currentArcStartAngle, lutealSweepAngle, false, lutealPaint);
  }

  @override
  bool shouldRepaint(covariant CyclePainter oldDelegate) {
    // Repaint hanya jika ada perubahan pada data siklus
    return oldDelegate.currentDay != currentDay ||
           oldDelegate.totalDaysInCycle != totalDaysInCycle ||
           oldDelegate.mensDuration != mensDuration ||
           oldDelegate.follicularDuration != follicularDuration ||
           oldDelegate.ovulationDuration != ovulationDuration ||
           oldDelegate.lutealDuration != lutealDuration;
  }
}