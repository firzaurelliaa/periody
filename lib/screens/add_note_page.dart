// ignore_for_file: use_super_parameters, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:periody/models/menstrual_note.dart';
import 'package:periody/screens/notepage.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();
  String? _selectedFase;
  String? _selectedFlow;
  List<String> _selectedGejala = [];
  List<String> _selectedMood = [];
  final TextEditingController _notesController = TextEditingController();

  final List<String> _faseOptions = [
    '🩸 Menstruasi',
    '💧 Ovulasi',
    '⚡ PMS',
    '🌱 Fase Folikular',
    '🌙 Fase Luteal',
  ];

  final List<Map<String, dynamic>> _flowOptions = [
    {'label': 'Tidak Ada', 'image': 'assets/img/tidak_ada.png'},
    {'label': 'Sedikit', 'image': 'assets/img/sedikit.png'},
    {'label': 'Sedang', 'image': 'assets/img/sedang.png'},
    {'label': 'Banyak', 'image': 'assets/img/banyak.png'},
    {'label': 'Deras', 'image': 'assets/img/deras.png'},
  ];

  final List<Map<String, dynamic>> _gejalaOptions = [
    {'label': 'Jerawat', 'image': 'assets/img/jerawat.png'},
    {'label': 'Mood Swing', 'image': 'assets/img/mood_swing.png'},
    {'label': 'Rambut Rontok', 'image': 'assets/img/rambut_rontok.png'},
    {'label': 'Kram Perut', 'image': 'assets/img/kram_perut.png'},
  ];

  final List<Map<String, dynamic>> _moodOptions = [
    {
      'label': 'Bahagia',
      'image': 'assets/img/bahagia.png',
      'gif_image': 'assets/img/bahagia.gif',
    },
    {
      'label': 'Biasa saja',
      'image': 'assets/img/biasa_aja.png',
      'gif_image': 'assets/img/biasa_aja.gif',
    },
    {
      'label': 'Mellow',
      'image': 'assets/img/mellow.png',
      'gif_image': 'assets/img/mellow.gif',
    },
    {
      'label': 'Sedih',
      'image': 'assets/img/sedih.png',
      'gif_image': 'assets/img/sedih.gif',
    },
    {
      'label': 'Tak Fokus',
      'image': 'assets/img/tidak_fokus.png',
      'gif_image': 'assets/img/tidak_fokus.gif',
    },
    {
      'label': 'Marah',
      'image': 'assets/img/marah.png',
      'gif_image': 'assets/img/marah.gif',
    },
    {
      'label': 'Cemas',
      'image': 'assets/img/cemas.png',
      'gif_image': 'assets/img/cemas.gif',
    },
    {
      'label': 'Lelah',
      'image': 'assets/img/lelah.png',
      'gif_image': 'assets/img/lelah.gif',
    },
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _resetFields() {
    setState(() {
      _selectedFase = null;
      _selectedFlow = null;
      _selectedGejala = [];
      _selectedMood = [];
      _notesController.text = '';
    });
  }

  Future<void> _saveNote() async {
    String userId = 'contohUserId123';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda perlu login untuk menyimpan catatan.'),
        ),
      );
      return;
    }

    final newNote = MenstrualNote(
      userId: userId,
      tanggalCatatan: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ),
      fase: _selectedFase,
      flow: _selectedFlow,
      gejala: _selectedGejala,
      mood: _selectedMood,
      catatanTambahan: _notesController.text,
      timestamp: DateTime.now(),
    );

    try {
      final existingNoteQuery =
          await _firestore
              .collection('catatanMenstruasi')
              .where('userId', isEqualTo: userId)
              .where(
                'tanggalCatatan',
                isEqualTo: Timestamp.fromDate(
                  DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                  ),
                ),
              )
              .get();

      if (existingNoteQuery.docs.isNotEmpty) {
        final docIdToUpdate = existingNoteQuery.docs.first.id;
        await _firestore
            .collection('catatanMenstruasi')
            .doc(docIdToUpdate)
            .update(newNote.toFirestore());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan berhasil diperbarui!'),
            backgroundColor: Color(0xffF48A8A),
          ),
        );
      } else {
        await _firestore
            .collection('catatanMenstruasi')
            .add(newNote.toFirestore());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan berhasil disimpan!'),
            backgroundColor: Color(0xffF48A8A),
          ),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      print('Error saving note: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan catatan: $e')));
    }
  }

  Future<void> _loadExistingNote(DateTime date) async {
    String userId = 'contohUserId123';

    if (userId.isEmpty) return;

    try {
      final querySnapshot =
          await _firestore
              .collection('catatanMenstruasi')
              .where('userId', isEqualTo: userId)
              .where(
                'tanggalCatatan',
                isEqualTo: Timestamp.fromDate(
                  DateTime(date.year, date.month, date.day),
                ),
              )
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _selectedFase = data['fase'];
          _selectedFlow = data['flow'];
          _selectedGejala = List<String>.from(data['gejala'] ?? []);
          _selectedMood = List<String>.from(data['mood'] ?? []);
          _notesController.text = data['catatanTambahan'] ?? '';
        });
      } else {
        _resetFields();
      }
    } catch (e) {
      print('Error loading existing note: $e');
      _resetFields();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadExistingNote(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFBFBFB),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Tambah Catatan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xffF48A8A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateNavigator(),
            const SizedBox(height: 20),
            _buildSectionTitle('Fase'),
            _buildChoiceChipRow(
              options: _faseOptions,
              selectedOption: _selectedFase,
              onSelected: (String? value) {
                setState(() {
                  _selectedFase = value;
                });
              },
              isSingleSelect: true,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Aliran Darah'),
            _buildFlowSelection(),
            const SizedBox(height: 20),

            _buildSectionTitle('Gejala'),
            _buildImageChoiceChipGrid(
              options: _gejalaOptions,
              selectedOptions: _selectedGejala,
              onSelected: (String label) {
                setState(() {
                  if (_selectedGejala.contains(label)) {
                    _selectedGejala.remove(label);
                  } else {
                    _selectedGejala.add(label);
                  }
                });
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Suasana Hati'),
            _buildGifChoiceChipGrid(
              options: _moodOptions,
              selectedOptions: _selectedMood,
              onSelected: (String label) {
                setState(() {
                  if (_selectedMood.contains(label)) {
                    _selectedMood.remove(label);
                  } else {
                    _selectedMood.add(label);
                  }
                });
              },
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('Catatan'),
            TextField(
              controller: _notesController,

              decoration: InputDecoration(
                hintText: 'Masukan catatan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),

                filled: true,
                fillColor: Colors.grey[100],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Color(0xffF48A8A), width: 2.0),
                ),
              ),
              maxLines: 4,
              cursorColor: const Color(0xffF48A8A),
            ),
            const SizedBox(height: 30),

            Container(
              margin: EdgeInsets.only(bottom: 40.0),
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              child: ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF48A8A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateNavigator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 36.0,
                width: 36.0,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffFDEDED),
                ),
                child: IconButton(
                  icon: Center(
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xffF48A8A),
                      size: 20.0,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(
                        const Duration(days: 1),
                      );
                    });
                    _loadExistingNote(_selectedDate);
                  },
                ),
              ),
              Text(
                DateFormat('MMMM dd,yyyy').format(_selectedDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffDC7C7C),
                ),
              ),
              Container(
                height: 36.0,
                width: 36.0,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffFDEDED),
                ),
                child: IconButton(
                  icon: Center(
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffF48A8A),
                      size: 20.0,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(
                        const Duration(days: 1),
                      );
                    });
                    _loadExistingNote(_selectedDate);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              controller: PageController(initialPage: 3),
              itemBuilder: (context, index) {
                DateTime displayDate = _selectedDate.add(
                  Duration(days: index - 3),
                );

                bool isToday =
                    displayDate.day == DateTime.now().day &&
                    displayDate.month == DateTime.now().month &&
                    displayDate.year == DateTime.now().year;

                bool isSelected =
                    displayDate.day == _selectedDate.day &&
                    displayDate.month == _selectedDate.month &&
                    displayDate.year == _selectedDate.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = displayDate;
                    });
                    _loadExistingNote(_selectedDate);
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xffF48A8A)
                              : (isToday ? Colors.grey[200] : Colors.white),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xffF48A8A)
                                : Colors.grey[300]!,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 12.0),
                        Text(
                          DateFormat('EEE').format(displayDate),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected ? Colors.white : Color(0xff383838),
                          ),
                        ),
                        Text(
                          displayDate.day.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected ? Colors.white : Color(0xff383838),
                          ),
                        ),
                        SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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

  Widget _buildChoiceChipRow({
    required List<String> options,
    required String? selectedOption,
    required Function(String?) onSelected,
    bool isSingleSelect = true,
  }) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children:
          options.map((option) {
            bool isSelected = (isSingleSelect && selectedOption == option);

            return ChoiceChip(
              showCheckmark: false,
              label: Text(option),
              selected: isSelected,
              selectedColor: const Color(0xffF48A8A),
              backgroundColor: Colors.grey[100],
              disabledColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.grey[300]!,
                ),
              ),
              onSelected: (selected) {
                onSelected(selected ? option : null);
              },
            );
          }).toList(),
    );
  }

  Widget _buildFlowSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          _flowOptions.map((flowOption) {
            String label = flowOption['label'];
            String imagePath = flowOption['image'];
            bool isSelected = _selectedFlow == label;
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFlow = null;
                  } else {
                    _selectedFlow = label;
                  }
                });
              },
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Color(0xffFFE4E4) : Colors.grey[100],
                      border: Border.all(
                        color:
                            isSelected ? Color(0xffF48A8A) : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Image.asset(imagePath, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isSelected
                              ? const Color(0xffF48A8A)
                              : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildImageChoiceChipGrid({
    required List<Map<String, dynamic>> options,
    required List<String> selectedOptions,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 12.0,
      children:
          options.map((option) {
            String label = option['label'];
            String imagePath = option['image'];
            bool isSelected = selectedOptions.contains(label);

            return GestureDetector(
              onTap: () => onSelected(label),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xffFCDBDB)
                              : Colors.grey[100],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xffF48A8A)
                                : Colors.grey[300]!,
                        width: 1,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: const Color(
                                    0xffF48A8A,
                                  ).withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                              : [],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(imagePath, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isSelected
                              ? const Color(0xffF48A8A)
                              : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildGifChoiceChipGrid({
    required List<Map<String, dynamic>> options,
    required List<String> selectedOptions,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 20.0,
      runSpacing: 12.0,
      children:
          options.map((option) {
            String label = option['label'];
            String staticImagePath = option['image'];
            String gifImagePath = option['gif_image'];

            bool isSelected = selectedOptions.contains(label);

            String displayImagePath =
                isSelected ? gifImagePath : staticImagePath;

            return GestureDetector(
              onTap: () => onSelected(label),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xffFDEDED) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            isSelected ? Color(0xffFCDBDB) : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        displayImagePath,
                        fit: BoxFit.contain,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xffF48A8A)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
