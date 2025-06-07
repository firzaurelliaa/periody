// File: lib/screens/homescreen.dart
import 'package:flutter/material.dart';
// Pastikan path ini benar untuk file alert_page.dart dan notification_screen.dart Anda
import 'package:periody/screens/alert_page.dart' hide StatusAlert;
import 'package:periody/screens/notification_screen.dart';

// Impor widget yang baru dibuat
import 'package:periody/widget/status_alert.dart';
import 'package:periody/widget/cycle_visualizer.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Alert')),
      body: const Center(child: Text('Ini adalah halaman Alert. Anda bisa menambahkan detail di sini.')),
    );
  }
}


class Homescreen extends StatelessWidget {
  const Homescreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF48A8A), // Warna header seperti di gambar
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Mengubah menjadi Column agar bisa di-align start
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, Elvira!', // Teks sapaan
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // Jika ada sub-teks di bawah "Halo, Elvira!" bisa ditambahkan di sini
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Circle Menstruasi (Menggunakan widget CycleVisualizer yang baru)
              Center(
                child: CycleVisualizer(
                  currentDay: 1, // Contoh: Hari ke-1 dari siklus
                  totalDaysInCycle: 28, // Contoh: Panjang siklus rata-rata
                  mensDuration: 5,    // Contoh: Durasi menstruasi
                  follicularDuration: 10, // Contoh: Durasi fase folikuler
                  ovulationDuration: 3,   // Contoh: Durasi fase ovulasi
                  lutealDuration: 10,     // Contoh: Durasi fase luteal
                ),
              ),

              const SizedBox(height: 20), // Spasi antara lingkaran dan alert

              // Status Alert (Menggunakan widget StatusAlert yang baru)
              Center(
                child: StatusAlert(
                  status: AlertStatus.normal, // Teks "Normal"
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AlertPage()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20), // Spasi antara alert dan reminder

              // Reminder Catatan Harian
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC1C5), // Warna latar belakang
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jangan Lupa Catatan Harianmu!',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Isi gejala, mood, dan kondisi tubuhmu hari ini yuk. Biar kamu makin paham pola siklusmu.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Tambahkan navigasi ke halaman tambah catatan harian
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder( // Bentuk rounded rectangle
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0, // Tanpa bayangan
                        ),
                        child: const Text('Tambah Catatan', style: TextStyle(color: Colors.pink)),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20), // Spasi antara reminder dan chart

              // Siklus Chart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Siklus',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround, // Menggunakan spaceAround
                        crossAxisAlignment: CrossAxisAlignment.end, // Agar batang dimulai dari bawah
                        children: List.generate(6, (index) {
                          List<String> dates = ['17 Des', '12 Jan', '9 Feb', '4 Mar', '29 Apr', '25 Mei'];
                          List<double> heights = [70, 50, 100, 80, 120, 90]; // Menggunakan double untuk height

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end, // Memastikan konten Column juga di align ke bawah
                            children: [
                              Container(
                                width: 20,
                                height: heights[index], // Menggunakan double
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dates[index],
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Menggunakan spaceEvenly untuk distribusi teks
                      children: const [
                        Expanded(child: Text('Panjang Siklus\n35-40 Hari', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),
                        Expanded(child: Text('Rata-Rata Siklus\n36 Hari', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),
                        Expanded(child: Text('Rata-Rata Mens\n6 Hari', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20), // Spasi antara chart dan artikel

              // Artikel Preview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Artikel',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Artikel 1
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
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
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.article_outlined, size: 30, color: Colors.grey),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '5 Cara Efektif untuk Mengeksplorasi Minat dan Bakat',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 2, // Batasi 2 baris
                                  overflow: TextOverflow.ellipsis, // Tambahkan ellipsis jika teks terlalu panjang
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
                    const SizedBox(height: 10),
                    // Artikel 2
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
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
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.favorite_outline, size: 30, color: Colors.grey), // Menggunakan ikon lain sebagai contoh
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tips Menjaga Kesehatan Mental Selama Menstruasi',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Fluktuasi hormon bisa memengaruhi suasana hati...',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40), // Spasi di bagian paling bawah
            ],
          ),
        ),
      ),
    );
  }
}