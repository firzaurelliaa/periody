// lib/models/item.dart
class Item {
  String? id; // ID dokumen dari Firestore
  String name;
  int quantity;

  Item({this.id, required this.name, required this.quantity});

  // Factory constructor untuk membuat objek Item dari dokumen Firestore
  factory Item.fromFirestore(Map<String, dynamic> data, String id) {
    return Item(
      id: id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }

  // Metode untuk mengkonversi objek Item menjadi Map untuk Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }
}