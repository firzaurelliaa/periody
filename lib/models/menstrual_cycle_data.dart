// lib/models/menstrual_cycle_data.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MenstrualCycleData {
  final int totalDaysInCycle;
  final int mensDuration;
  final int follicularDuration;
  final int ovulationDuration;
  final int lutealDuration;
  final DateTime? lastPeriodStartDate;

  MenstrualCycleData({
    required this.totalDaysInCycle,
    required this.mensDuration,
    required this.follicularDuration,
    required this.ovulationDuration,
    required this.lutealDuration,
    this.lastPeriodStartDate,
  });

  factory MenstrualCycleData.fromFirestore(Map<String, dynamic> data) {
    return MenstrualCycleData(
      totalDaysInCycle: (data['totalDaysInCycle'] as num?)?.toInt() ?? 28,
      mensDuration: (data['mensDuration'] as num?)?.toInt() ?? 5,
      follicularDuration: (data['follicularDuration'] as num?)?.toInt() ?? 9,
      ovulationDuration: (data['ovulationDuration'] as num?)?.toInt() ?? 3,
      lutealDuration: (data['lutealDuration'] as num?)?.toInt() ?? 11,
      lastPeriodStartDate: (data['lastPeriodStartDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalDaysInCycle': totalDaysInCycle,
      'mensDuration': mensDuration,
      'follicularDuration': follicularDuration,
      'ovulationDuration': ovulationDuration,
      'lutealDuration': lutealDuration,
      'lastPeriodStartDate': lastPeriodStartDate != null ? Timestamp.fromDate(lastPeriodStartDate!) : null,
    };
  }
}