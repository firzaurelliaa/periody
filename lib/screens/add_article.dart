// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:periody/models/article.dart'; 

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  

  String _selectedCategoryDropdown = 'Rekomendasi'; 
  final List<String> _dropdownCategories = const [
    'Rekomendasi',
    'Terbaru',
    'Trending',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }


  Future<void> _addArticle() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<String> tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();


      final newArticle = Article(
        title: _titleController.text,
        content: _contentController.text,
        imageUrl: _imageUrlController.text,
        author: _authorController.text.isNotEmpty ? _authorController.text : 'Periody Team',
        publishDate: DateTime.now(),
        category: _selectedCategoryDropdown,
        tags: tags,
      );

      try {
        await _firestore.collection('article').add(newArticle.toFirestore());
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel berhasil ditambahkan!')),
        );
        _titleController.clear();
        _contentController.clear();
        _imageUrlController.clear();
        _authorController.clear();
        _tagsController.clear();
        setState(() {
          _selectedCategoryDropdown = 'Rekomendasi';
        });

        Navigator.pop(context);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan artikel: $e')),
        );
        print('Error adding article: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tambah Artikel', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),),
        backgroundColor: const Color(0xFFF48A8A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Artikel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Isi Artikel'),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi artikel tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL Gambar Artikel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL gambar tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Penulis (Opsional)'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategoryDropdown,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _dropdownCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategoryDropdown = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                    labelText: 'Tags (pisahkan dengan koma, mis: kesehatan, wanita)'),
              ),
              const SizedBox(height: 20),
              Container(
              margin: const EdgeInsets.only(bottom: 40.0),
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              child: ElevatedButton(
                onPressed: _addArticle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF48A8A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  disabledBackgroundColor: const Color(0xffF48A8A).withOpacity(0.5),
                ),
                child: Text(
                        'Tambah Artikel',
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
      ),
    );
  }
}