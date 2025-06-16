import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:periody/models/menstrual_cycle_data.dart';

class CycleInitialSetupPage extends StatefulWidget {
  const CycleInitialSetupPage({super.key});

  @override
  State<CycleInitialSetupPage> createState() => _CycleInitialSetupPageState();
}

class _CycleInitialSetupPageState extends State<CycleInitialSetupPage> {
  DateTime? _selectedLastPeriodStartDate;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _totalDaysController;
  late TextEditingController _mensDurationController;
  late TextEditingController _follicularDurationController;
  late TextEditingController _ovulationDurationController;
  late TextEditingController _lutealDurationController;


  @override
  void initState() {
    super.initState();
    _totalDaysController = TextEditingController();
    _mensDurationController = TextEditingController();
    _follicularDurationController = TextEditingController();
    _ovulationDurationController = TextEditingController();
    _lutealDurationController = TextEditingController();
    _loadCycleData();
  }

  @override
  void dispose() {
    _totalDaysController.dispose();
    _mensDurationController.dispose();
    _follicularDurationController.dispose();
    _ovulationDurationController.dispose();
    _lutealDurationController.dispose();
    super.dispose();
  }

  Future<void> _loadCycleData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data() as Map<String, dynamic>;
        final cycleDataMap = data['cycleData'] as Map<String, dynamic>?;
        if (cycleDataMap != null) {
          final cycleData = MenstrualCycleData.fromFirestore(cycleDataMap);
          _totalDaysController.text = cycleData.totalDaysInCycle.toString();
          _mensDurationController.text = cycleData.mensDuration.toString();
          _follicularDurationController.text = cycleData.follicularDuration.toString();
          _ovulationDurationController.text = cycleData.ovulationDuration.toString();
          _lutealDurationController.text = cycleData.lutealDuration.toString();
          setState(() {
            _selectedLastPeriodStartDate = cycleData.lastPeriodStartDate;
          });
        }
      }
    }
  }

  Future<void> _saveCycleData() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final cycleData = MenstrualCycleData(
            totalDaysInCycle: int.parse(_totalDaysController.text),
            mensDuration: int.parse(_mensDurationController.text),
            follicularDuration: int.parse(_follicularDurationController.text),
            ovulationDuration: int.parse(_ovulationDurationController.text),
            lutealDuration: int.parse(_lutealDurationController.text),
            lastPeriodStartDate: _selectedLastPeriodStartDate,
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({'cycleData': cycleData.toFirestore()}, SetOptions(merge: true));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengaturan siklus berhasil disimpan!')),
          );
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan: $e')),
          );
        }
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedLastPeriodStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedLastPeriodStartDate) {
      setState(() {
        _selectedLastPeriodStartDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Siklus Anda'),
        backgroundColor: const Color(0xFFF48A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _totalDaysController,
                decoration: const InputDecoration(labelText: 'Total Hari Siklus (rata-rata)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan total hari siklus';
                  }
                  final intValue = int.tryParse(value);
                  if (intValue == null || intValue < 21 || intValue > 35) {
                    return 'Masukkan angka antara 21-35';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mensDurationController,
                decoration: const InputDecoration(labelText: 'Durasi Menstruasi (rata-rata)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan durasi menstruasi';
                  }
                  final intValue = int.tryParse(value);
                  if (intValue == null || intValue < 2 || intValue > 7) {
                    return 'Masukkan angka antara 2-7';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _follicularDurationController,
                decoration: const InputDecoration(labelText: 'Durasi Fase Folikular'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan durasi fase folikular';
                  }
                  final intValue = int.tryParse(value);
                  if (intValue == null || intValue < 1) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ovulationDurationController,
                decoration: const InputDecoration(labelText: 'Durasi Fase Ovulasi'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan durasi fase ovulasi';
                  }
                  final intValue = int.tryParse(value);
                  if (intValue == null || intValue < 1) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lutealDurationController,
                decoration: const InputDecoration(labelText: 'Durasi Fase Luteal'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan durasi fase luteal';
                  }
                  final intValue = int.tryParse(value);
                  if (intValue == null || intValue < 1) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Tanggal Mulai Periode Terakhir:', style: TextStyle(fontWeight: FontWeight.bold)),
              ListTile(
                title: Text(
                  _selectedLastPeriodStartDate == null
                      ? 'Pilih Tanggal'
                      : '${_selectedLastPeriodStartDate!.day}/${_selectedLastPeriodStartDate!.month}/${_selectedLastPeriodStartDate!.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveCycleData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48A8A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Simpan Pengaturan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}