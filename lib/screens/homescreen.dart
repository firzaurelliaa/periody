import 'package:flutter/material.dart';
import 'package:periody/screens/alert_page.dart' hide StatusAlert; // Pastikan AlertPage ada di sini
import 'package:periody/screens/notification_screen.dart';
import 'package:periody/widget/status_alert.dart';
import 'package:periody/widget/cycle_visualizer.dart'; // Import CycleVisualizer
import 'package:periody/screens/edukasi.dart'; // Asumsi ini mengimpor EdukasiScreen
import 'package:periody/screens/add_note_page.dart';


class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih untuk seluruh Scaffold
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Mengisi lebar penuh
          children: [
            // Header Section (latar belakang pink lengkung)
            Container(
              height: 180, // Tinggi konsisten dengan desain
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF48A8A), Color(0xFFF48A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                // Padding lebih banyak di atas untuk memberi ruang status bar dan align dengan desain
                padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start, // Pastikan konten di atas
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20, // Ukuran avatar
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Halo, Elvira!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20, // Ukuran font
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 28, // Ukuran ikon notifikasi
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20), // Spasi setelah header

            // Circle Menstruasi (CycleVisualizer)
            // Ini akan membutuhkan penyesuaian di file cycle_visualizer.dart
            Center(
              child: CycleVisualizer(
                currentDay: 7, // Akan disesuaikan di CyclePainter
                totalDaysInCycle: 28,
                mensDuration: 5,
                follicularDuration: 9,
                ovulationDuration: 3,
                lutealDuration: 11,
              ),
            ),

            const SizedBox(height: 20), // Spasi setelah CycleVisualizer

            // Status Alert
            // Ini akan membutuhkan penyesuaian di file status_alert.dart
            Center(
              child: StatusAlert(
                status: AlertStatus.normal, // Menggunakan enum dari status_alert.dart
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlertPage(),
                    ),
                  );
                },
              ),
            ),

           const SizedBox(height: 20), // Spasi setelah Status Alert

                        // Reminder Catatan Harian
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                // Menggunakan lebar penuh layar dikurangi padding horizontal
                height: 160, // Ketinggian container disesuaikan agar mirip desain
                decoration: BoxDecoration(
                  color: const Color(0xFFF99D9D), // Warna latar belakang pink solid dari desain
                  borderRadius: BorderRadius.circular(20), // Radius lebih besar seperti desain
                  image: const DecorationImage(
                    image: AssetImage('assets/img/Banner.png'), // Pastikan ini path yang benar ke ilustrasi di banner
                    fit: BoxFit.cover, // Sesuaikan ini, mungkin BoxFit.fitHeight atau BoxFit.contain jika ilustrasi tidak memenuhi seluruh lebar
                    alignment: Alignment.centerRight, // Posisikan gambar ke kanan
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  // Padding diatur agar teks tidak menutupi ilustrasi di sisi kanan
                  padding: const EdgeInsets.fromLTRB(20, 20, 100, 20), // Padding kanan 100 untuk memberi ruang gambar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, // Pusatkan secara vertikal
                    children: [
                      const Text(
                        'Jangan Lupa Catatan\nHarianmu!', // Teks dibagi dua baris
                        style: TextStyle(
                          fontSize: 18, // Ukuran font
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Warna teks putih
                        ),
                      ),
                      const SizedBox(height: 6), // Spasi antar judul dan deskripsi
                      const Text(
                        'Isi gejala, mood, dan kondisi tubuhmu hari ini yuk~\nBiar kamu makin paham pola siklusmu.', // Teks deskripsi
                        style: TextStyle(
                          fontSize: 12, // Ukuran font deskripsi
                          color: Colors.white, // Warna teks putih
                        ),
                        maxLines: 2, // Batasi 2 baris
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 15), // Spasi antara teks dan button
                      ElevatedButton(
                        onPressed: () {
                          // Integrasi dengan AddNotePage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNotePage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 243, 185, 185), // Warna latar belakang button putih
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Border radius button
                          ),
                          elevation: 0, // **Sudah sesuai desain, tanpa shadow button menonjol**
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding button
                          minimumSize: const Size(160, 45), // Ukuran minimum button agar konsisten
                          // foregroundColor: Color(0xFFF99D9D), // Ini mengatur warna splash dan icon/text default jika tidak di-override
                        ),
                        child: const Text(
                          'Tambah Catatan', // Teks button
                          style: TextStyle(
                            color: Color.fromARGB(255, 248, 245, 245), // Warna teks button pink sesuai desain
                            fontSize: 14, // Ukuran font button
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spasi setelah Reminder

            // Siklus Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Siklus',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150, // Tinggi keseluruhan chart
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (index) { // Ubah menjadi 7 untuk "16 Jun"
                        List<String> dates = [
                          '17 Des', '12 Jan', '9 Feb', '4 Mar', '29 Apr', '25 Mei', '16 Jun' // Tambah '16 Jun'
                        ];
                        List<double> heights = [
                          70, 50, 100, 80, 120, 90, 60 // Contoh tinggi, sesuaikan agar mirip desain
                        ];
                        List<String> labels = [
                          '', '', '', 'Rerata', '', '', '' // Label "Rerata"
                        ];

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              labels[index],
                              style: TextStyle(fontSize: 10, color: Colors.grey[700]), // Font "Rerata"
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 20,
                              height: heights[index],
                              decoration: BoxDecoration(
                                color: Colors.pink.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dates[index],
                              style: const TextStyle(fontSize: 10), // Ukuran font tanggal
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Expanded(
                        child: Text(
                          'Panjang Siklus\n35-40 Hari',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Rata-Rata Siklus\n36 Hari',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Rata-Rata Mens\n6 Hari',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Spasi setelah chart

            // Artikel Preview Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Artikel',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Edukasi(), // Pastikan nama kelas EdukasiScreen
                            ),
                          );
                        },
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(color: Colors.pink, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Artikel 1
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Edukasi(), // Pastikan nama kelas EdukasiScreen
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.article_outlined, size: 30, color: Colors.pink),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '5 Cara Efektif untuk Mengeksplorasi Minat dan Bakat',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Menemukan minat dan bakat sejati adalah sebuah perjalanan...',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Artikel 2
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Edukasi(), // Pastikan nama kelas EdukasiScreen
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.favorite_outline,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tips Menjaga Kesehatan Mental Selama Menstruasi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Fluktuasi hormon bisa memengaruhi suasana hati...',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Edukasi(), // Pastikan nama kelas EdukasiScreen
                          ),
                        );
                      },
                      child: const Text(
                        'Lihat Semua Artikel',
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // Spasi di bawah konten
          ],
        ),
      ),
    );
  }
}