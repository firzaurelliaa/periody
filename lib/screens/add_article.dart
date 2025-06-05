import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:periody/models/article.dart'; 

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers untuk setiap input field
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController(); // Untuk tag, dipisahkan koma
  
  // Menambahkan _selectedCategory untuk dropdown
  String _selectedCategoryDropdown = 'Rekomendasi'; // Default category for dropdown
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
    _categoryController.dispose(); // Masih dibutuhkan jika Anda ingin membiarkan input manual
    _tagsController.dispose();
    super.dispose();
  }

  // Fungsi untuk menambahkan artikel ke Firestore
  Future<void> _addArticle() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<String> tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      // Anda bisa menambahkan default nilai untuk readCount dan featured jika tidak ada di form
      final newArticle = Article(
        title: _titleController.text,
        content: _contentController.text,
        imageUrl: _imageUrlController.text,
        author: _authorController.text.isNotEmpty ? _authorController.text : 'Periody Team',
        publishDate: DateTime.now(),
        category: _selectedCategoryDropdown, // Menggunakan nilai dari dropdown
        tags: tags,
        // readCount: 0, // Nilai default untuk artikel baru
        // featured: false, // Nilai default untuk artikel baru
        // subtitle: _contentController.text.length > 100 // Menambahkan subtitle otomatis dari content
        //     ? '${_contentController.text.substring(0, 100)}...'
        //     : _contentController.text,
      );

      try {
        await _firestore.collection('article').add(newArticle.toFirestore());
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel berhasil ditambahkan!')),
        );
        // Kosongkan form setelah sukses
        _titleController.clear();
        _contentController.clear();
        _imageUrlController.clear();
        _authorController.clear();
        _tagsController.clear();
        setState(() {
          _selectedCategoryDropdown = 'Rekomendasi'; // Reset dropdown
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
        title: const Text('Tambah Artikel Baru'),
        backgroundColor: const Color(0xFFF48A8A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
              // Mengubah input kategori menjadi DropdownButton
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
              ElevatedButton(
                onPressed: _addArticle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48A8A),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Tambah Artikel',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}