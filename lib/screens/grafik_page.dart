// ignore_for_file: prefer_for_elements_to_map_fromiterable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:periody/models/menstrual_note.dart'; // Pastikan path ini benar

class GrafikPage extends StatefulWidget {
  const GrafikPage({super.key});

  @override
  State<GrafikPage> createState() => _GrafikPageState();
}

class _GrafikPageState extends State<GrafikPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<MenstrualNote> _allNotes = [];
  List<MenstrualNote> _filteredNotes = [];
  bool _isLoading = true;
  String? _errorMessage;
  DateTime _selectedMonth = DateTime.now();

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


  final List<String> _displaySymptoms = [
    'Jerawat',
    'Mood Swing',
    'Rontok',
    'Kram Perut',
  ];

  final Map<String, Color> _displaySymptomColors = {};
  final List<Color> _availableDisplayColors = [
    const Color(0xFFFFE1E1),
    const Color(0xFFFFB6B6),
    const Color(0xFFEE7E7E),
    const Color(0xFFB76868),
  ];

  @override
  void initState() {
    super.initState();
    _assignDisplaySymptomColors();
    _fetchMenstrualNotes();
  }

  void _assignDisplaySymptomColors() {
    for (int i = 0; i < _displaySymptoms.length; i++) {
      _displaySymptomColors[_displaySymptoms[i]] =
          _availableDisplayColors[i % _availableDisplayColors.length];
    }
  }

  Future<void> _fetchMenstrualNotes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        setState(() {
          _errorMessage = 'Anda perlu login untuk melihat data analisis.';
          _isLoading = false;
        });
        return;
      }

      final querySnapshot =
          await _firestore
              .collection('catatanMenstruasi')
              .where('userId', isEqualTo: currentUser.uid)
              .orderBy('tanggalCatatan', descending: false)
              .get();

      _allNotes =
          querySnapshot.docs
              .map((doc) => MenstrualNote.fromFirestore(doc))
              .toList();
      _filterNotesByMonth();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data analisis: $e';
        _isLoading = false;
      });
    }
  }

  void _filterNotesByMonth() {
    _filteredNotes =
        _allNotes.where((note) {
          return note.tanggalCatatan.year == _selectedMonth.year &&
              note.tanggalCatatan.month == _selectedMonth.month;
        }).toList();
    setState(() {});
  }

  void _changeMonth(int monthsToAdd) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + monthsToAdd,
        1,
      );
    });
    _filterNotesByMonth();
  }






  int _getFlowValue(String? flow) {
    switch (flow) {
      case 'Tidak Ada':
        return 0;
      case 'Sedikit':
        return 1;
      case 'Sedang':
        return 2;
      case 'Banyak':
        return 3;
      case 'Deras':
        return 4;
      default:
        return -1;
    }
  }

  String _getFlowLabel(int value) {
    switch (value) {
      case 0:
        return 'Tidak Ada';
      case 1:
        return 'Sedikit';
      case 2:
        return 'Sedang';
      case 3:
        return 'Banyak';
      case 4:
        return 'Deras';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFBFBFB),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Grafik',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: const Color(0xffF48A8A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xffF48A8A)),
              )
              : _errorMessage != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthNavigation(),
                    _buildSectionTitle('Gejala'),
                    _buildSymptomsMonthlyChart(),
                    const SizedBox(height: 10),
                    _buildSymptomsLegend(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('Suasana Hati'),
                    _buildMoodFrequency(),
                    const SizedBox(height: 30),
                    _buildSectionTitle('Aliran Darah'),
                    SizedBox(height: 250, child: _buildLineChartForFlow()),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
    );
  }

  Widget _buildMonthNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _changeMonth(-1),
          color: const Color(0xffF48A8A),
        ),
        Text(
          DateFormat('MMMM yyyy', 'id_ID').format(_selectedMonth),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xffDC7C7C),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _changeMonth(1),
          color: const Color(0xffF48A8A),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xff383838),
        ),
      ),
    );
  }



  Widget _buildSymptomsLegend() {
    return Wrap(
      spacing: 12.0,
      runSpacing: 8.0,
      children:
          _displaySymptoms.map((symptomName) {
            final color = _displaySymptomColors[symptomName] ?? Colors.grey;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  symptomName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff383838),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildSymptomsMonthlyChart() {
    Map<int, Map<String, int>> symptomsByMonth = {};

    DateTime now = DateTime.now();
    DateTime twelveMonthsAgo = DateTime(now.year - 1, now.month + 1, 1);

    for (var note in _allNotes) {
      if (note.tanggalCatatan.isAfter(twelveMonthsAgo) &&
          note.tanggalCatatan.isBefore(now.add(const Duration(days: 30)))) {
        final month = note.tanggalCatatan.month;
        final year = note.tanggalCatatan.year;
        final monthKey = month + (year * 100);

        symptomsByMonth.putIfAbsent(monthKey, () => {});

        for (var symptom in note.gejala) {
          if (_displaySymptoms.contains(symptom)) {
            symptomsByMonth[monthKey]!.update(
              symptom,
              (value) => value + 1,
              ifAbsent: () => 1,
            );
          }
        }
      }
    }

    List<int> sortedMonthKeys = symptomsByMonth.keys.toList()..sort();

    if (sortedMonthKeys.isEmpty) {
      return const Center(
        child: Text('Tidak ada data gejala untuk grafik ini.'),
      );
    }

    List<int> allMonthKeysInPeriod = [];
    for (int i = 0; i < 12; i++) {
      DateTime monthToAdd = DateTime(
        twelveMonthsAgo.year,
        twelveMonthsAgo.month + i,
        1,
      );
      allMonthKeysInPeriod.add(monthToAdd.month + (monthToAdd.year * 100));
    }
    allMonthKeysInPeriod.sort();

    List<BarChartGroupData> barGroups = [];
    double maxY = 0;

    for (int i = 0; i < allMonthKeysInPeriod.length; i++) {
      final monthKey = allMonthKeysInPeriod[i];
      final currentMonthData = symptomsByMonth[monthKey] ?? {};

      List<BarChartRodStackItem> rodStackItems = [];
      double currentStackY = 0;

      for (var symptom in _displaySymptoms) {
        final count = currentMonthData[symptom] ?? 0;
        if (count > 0) {
          rodStackItems.add(
            BarChartRodStackItem(
              currentStackY,
              currentStackY + count.toDouble(),
              _displaySymptomColors[symptom]!,
            ),
          );
          currentStackY += count.toDouble();
        }
      }

      if (currentStackY > maxY) {
        maxY = currentStackY;
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: currentStackY,
              width: 16,
              borderRadius: BorderRadius.circular(4),
              rodStackItems: rodStackItems,
            ),
          ],
        ),
      );
    }

    maxY = maxY + (maxY * 0.2);
    if (maxY == 0) maxY = 1;

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final int monthKey = allMonthKeysInPeriod[group.x];
                final int month = monthKey % 100;
                final int year = monthKey ~/ 100;
                final DateTime monthDate = DateTime(year, month);
                final String monthName = DateFormat(
                  'MMM',
                  'id_ID',
                ).format(monthDate);

                String tooltipText = '$monthName $year\n';
                final currentMonthData = symptomsByMonth[monthKey] ?? {};

                bool hasSymptoms = false;
                for (var symptom in _displaySymptoms) {
                  final count = currentMonthData[symptom] ?? 0;
                  if (count > 0) {
                    tooltipText += '$symptom: ${count}x\n';
                    hasSymptoms = true;
                  }
                }
                if (!hasSymptoms) {
                  tooltipText += 'Tidak ada gejala';
                }

                return BarTooltipItem(
                  tooltipText.trim(),
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final int monthKey = allMonthKeysInPeriod[value.toInt()];
                  final int month = monthKey % 100;
                  final DateTime monthDate = DateTime(monthKey ~/ 100, month);
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(
                      DateFormat('MMM', 'id_ID').format(monthDate),
                      style: const TextStyle(
                        color: Color(0xff7589a2),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('');
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Color(0xff7589a2),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 28,
                interval: maxY / 5 > 1 ? (maxY / 5).ceilToDouble() : 1,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingVerticalLine:
                (value) => const FlLine(color: Colors.grey, strokeWidth: 0.5),
            drawHorizontalLine: true,
            getDrawingHorizontalLine:
                (value) => const FlLine(color: Colors.grey, strokeWidth: 0.5),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          barGroups: barGroups,
        ),
        swapAnimationDuration: const Duration(milliseconds: 150),
        swapAnimationCurve: Curves.linear,
      ),
    );
  }

  Widget _buildMoodFrequency() {
    Map<String, int> moodFrequency = Map.fromIterable(
      _moodImages.keys,
      key: (mood) => mood as String,
      value: (mood) => 0,
    );

    for (var note in _filteredNotes) {
      for (var mood in note.mood) {
        if (mood.isNotEmpty && moodFrequency.containsKey(mood)) {
          moodFrequency.update(mood, (value) => value + 1);
        }
      }
    }

    List<MapEntry<String, int>> sortedMoods =
        moodFrequency.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = constraints.maxWidth / 4;

        return Wrap(
          spacing: 0.0,
          runSpacing: 12.0,
          alignment: WrapAlignment.start,
          children:
              sortedMoods.map((entry) {
                String mood = entry.key;
                int count = entry.value;
                String? imagePath = _moodImages[mood];

                return SizedBox(
                  width: itemWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      imagePath != null
                          ? Image.asset(imagePath, width: 40, height: 40)
                          : const Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Colors.grey,
                          ),
                      const SizedBox(height: 4),
                      Text(
                        '$mood (${count}x)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff383838),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildLineChartForFlow() {
    List<MenstrualNote> validFlowNotes =
        _filteredNotes
            .where(
              (note) => note.flow != null && _getFlowValue(note.flow) != -1,
            )
            .toList();

    if (validFlowNotes.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data aliran darah yang valid untuk ditampilkan.',
        ),
      );
    }

    validFlowNotes.sort((a, b) => a.tanggalCatatan.compareTo(b.tanggalCatatan));

    List<FlSpot> spots = [];
    for (var note in validFlowNotes) {
      spots.add(
        FlSpot(
          note.tanggalCatatan.millisecondsSinceEpoch.toDouble(),
          _getFlowValue(note.flow).toDouble(),
        ),
      );
    }

    double minX = spots.first.x;
    double maxX = spots.last.x;

    if (spots.length == 1) {
      spots.add(FlSpot(spots.first.x + 86400000.0, spots.first.y));
      maxX = spots.last.x;
    }

    double minY = -0.5;
    double maxY = 4.5;

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8.0,
                  child: Text(
                    DateFormat('dd/MM').format(date),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xff7589a2),
                    ),
                  ),
                );
              },
              interval:
                  (maxX - minX) / 4 > 86400000.0
                      ? (maxX - minX) / 4
                      : 86400000.0,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value <= 4) {
                  return Text(
                    _getFlowLabel(value.toInt()),
                    style: const TextStyle(
                      color: Color(0xff7589a2),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 60,
              interval: 1,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return const FlLine(color: Colors.grey, strokeWidth: 0.5);
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(color: Colors.grey, strokeWidth: 0.5);
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xffF48A8A),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xffF48A8A).withOpacity(0.5),
                  const Color(0xffF48A8A).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
