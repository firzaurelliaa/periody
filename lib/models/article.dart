import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String? id;
  String title;
  String content;
  String imageUrl;
  String author;
  DateTime publishDate;
  String category;
  List<String> tags;

  Article({
    this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.publishDate,
    required this.category,
    this.tags = const [],
  });

  factory Article.fromFirestore(Map<String, dynamic> data, String id) {
    return Article(
      id: id,
      title: data['title'] ?? 'No Title',
      content: data['content'] ?? 'No Content',
      imageUrl: data['imageUrl'] ?? '',
      author: data['author'] ?? 'Anonim',
      publishDate: (data['publishDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: data['category'] ?? 'Lainnya',
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'author': author,
      'publishDate': publishDate,
      'category': category,
      'tags': tags,
    };
  }
}