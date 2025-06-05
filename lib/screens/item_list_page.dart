import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:periody/models/item.dart';

// MyApp juga tidak perlu di sini lagi

class ItemListPage extends StatefulWidget {
  const ItemListPage({Key? key}) : super(key: key);

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editQuantityController = TextEditingController();

  // --- CREATE (Menambah Data) ---
  Future<void> _addItem() async {
    if (_nameController.text.isEmpty || _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama dan Kuantitas tidak boleh kosong!')));
      return;
    }

    try {
      await _firestore.collection('items').add({
        'name': _nameController.text,
        'quantity': int.parse(_quantityController.text),
        'timestamp': FieldValue.serverTimestamp(),
      });
      _nameController.clear();
      _quantityController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Item berhasil ditambahkan!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menambahkan item: $e')));
    }
  }

  // --- READ (Membaca Data) ---
  // Menggunakan StreamBuilder untuk realtime updates
  Stream<List<Item>> _readItems() {
    return _firestore.collection('items').orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Item.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  // --- UPDATE (Mengubah Data) ---
  Future<void> _updateItem(Item item) async {
    _editNameController.text = item.name;
    _editQuantityController.text = item.quantity.toString();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editNameController,
                decoration: const InputDecoration(labelText: 'Nama Item'),
              ),
              TextField(
                controller: _editQuantityController,
                decoration: const InputDecoration(labelText: 'Kuantitas'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_editNameController.text.isEmpty || _editQuantityController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nama dan Kuantitas tidak boleh kosong!')));
                  return;
                }
                try {
                  await _firestore.collection('items').doc(item.id).update({
                    'name': _editNameController.text,
                    'quantity': int.parse(_editQuantityController.text),
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item berhasil diperbarui!')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal memperbarui item: $e')));
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // --- DELETE (Menghapus Data) ---
  Future<void> _deleteItem(String itemId) async {
    try {
      await _firestore.collection('items').doc(itemId).delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Item berhasil dihapus!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menghapus item: $e')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _editNameController.dispose();
    _editQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tessssttg'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Barang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Kuantitas',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addItem,
              child: const Text('Tambah'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Daftar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Item>>(
                stream: _readItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Belum ada barang.'));
                  }

                  final items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text('Kuantitas: ${item.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _updateItem(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteItem(item.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}