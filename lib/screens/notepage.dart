// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:periody/models/menstrual_note.dart';
import 'package:periody/screens/add_note_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, String> _moodImages = {
    'Bahagia': 'assets/img/bahagia.gif',
    'Biasa saja': 'assets/img/biasa_aja.gif',
    'Mellow': 'assets/img/mellow.gif',
    'Sedih': 'assets/img/sedih.gif',
    'Tidak Fokus': 'assets/img/tidak_fokus.gif',
    'Marah': 'assets/img/marah.gif',
    'Cemas': 'assets/img/cemas.gif',
    'Lelah': 'assets/img/lelah.gif',
  };

  final Map<String, String> _gejalaImages = {
    'Jerawat': 'assets/img/jerawat.png',
    'Mood Swing': 'assets/img/mood_swing.png',
    'Rambut Rontok': 'assets/img/rambut_rontok.png',
    'Kram Perut': 'assets/img/kram_perut.png',
    'Sakit Kepala': 'assets/img/sakit_kepala.png',
    'Nyeri Payudara': 'assets/img/nyeri_payudara.png',
    'Perut Kembung': 'assets/img/perut_kembung.png',
    'Kelelahan': 'assets/img/lelah.png',
  };

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0XFFFEFEFE),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Pencatatan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xffF48A8A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: userId == null || userId.isEmpty
          ? const Center(child: Text('Mohon login untuk melihat catatan Anda.'))
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('catatanMenstruasi')
                  .where('userId', isEqualTo: userId)
                  .orderBy('tanggalCatatan', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xffF48A8A),
                  ));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child:
                          Text('Belum ada catatan. Tekan + untuk menambahkan.'));
                }

                final notes = snapshot.data!.docs.map((doc) {
                  return MenstrualNote.fromFirestore(doc);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return _buildNoteCard(note);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotePage()),
          ).then((_) {});
        },
        backgroundColor: const Color(0xffF48A8A),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNoteCard(MenstrualNote note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: SizedBox(
                width: 90,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      color: const Color(0xffF48A8A),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('MMMM,yyyy').format(note.tanggalCatatan),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      color: const Color(0xffFDEDED),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('EEE').format(note.tanggalCatatan),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            note.tanggalCatatan.day.toString(),
                            style: const TextStyle(
                              color: Color(0xffF48A8A),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (note.mood.isNotEmpty) ...[
                    _buildDetailRow(
                      'Suasana Hati:',
                      note.mood
                          .map((m) => _buildChipWithImage(_moodImages[m], m))
                          .toList(),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (note.gejala.isNotEmpty) ...[
                    _buildDetailRow(
                      'Gejala:',
                      note.gejala
                          .map((g) => _buildChipWithImage(_gejalaImages[g], g))
                          .toList(),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (note.fase != null && note.fase!.isNotEmpty) ...[
                    _buildDetailRow(
                      'Fase:',
                      [_buildTextChip(note.fase!)],
                    ),
                  ],
                  if (note.catatanTambahan.isNotEmpty)
                    Text(
                      'Catatan: ${note.catatanTambahan}',
                      style:
                          const TextStyle(fontSize: 14, color: Color(0xFF383838)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: children,
        ),
      ],
    );
  }

  Widget _buildChipWithImage(String? imagePath, String label) {
    if (imagePath == null) return const SizedBox.shrink();
    return Chip(
      avatar: Image.asset(imagePath, width: 20, height: 20),
      label: Text(label),
      backgroundColor: const Color(0xffFDEDED),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      labelStyle: const TextStyle(fontSize: 12, color: Color(0xff383838)),
    );
  }

  Widget _buildTextChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: const Color(0xffFDEDED),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      labelStyle: const TextStyle(fontSize: 12, color: Color(0xff383838)),
    );
  }
}