// lib/models/menstrual_note.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MenstrualNote {
  final String userId;
  final DateTime tanggalCatatan;
  final String? fase;
  final String? flow;
  final List<String> gejala;
  final List<String> mood;
  final String catatanTambahan;
  final DateTime timestamp;
  final String? id;

  MenstrualNote({
    required this.userId,
    required this.tanggalCatatan,
    this.fase,
    this.flow,
    this.gejala = const [],
    this.mood = const [],
    this.catatanTambahan = '',
    required this.timestamp,
    this.id,
  });

  factory MenstrualNote.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MenstrualNote(
      id: doc.id,
      userId: data['userId'] ?? '',
      tanggalCatatan: (data['tanggalCatatan'] as Timestamp).toDate(),
      fase: data['fase'],
      flow: data['flow'],
      gejala: List<String>.from(data['gejala'] ?? []),
      mood: List<String>.from(data['mood'] ?? []),
      catatanTambahan: data['catatanTambahan'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'tanggalCatatan': Timestamp.fromDate(tanggalCatatan),
      'fase': fase,
      'flow': flow,
      'gejala': gejala,
      'mood': mood,
      'catatanTambahan': catatanTambahan,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}