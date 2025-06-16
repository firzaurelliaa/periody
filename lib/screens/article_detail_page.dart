// ignore_for_file: use_super_parameters, avoid_print

import 'package:flutter/material.dart';
import 'package:periody/models/article.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _incrementReadCount(); 
  }


  void _incrementReadCount() async {
    try {
      final articleRef = _firestore.collection('article').doc(widget.article.id);
      await articleRef.update({'readCount': FieldValue.increment(1)});
    } catch (e) {
      print('Error incrementing read count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffefefe),
      appBar: AppBar(
        backgroundColor: const Color(0xffF48A8A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                widget.article.imageUrl.isEmpty
                    ? 'https://via.placeholder.com/600x300?text=No+Image'
                    : widget.article.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(0xffF48A8A),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.article.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF383838),
                
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.article.author} | ${DateFormat('dd MMMM yyyy').format(widget.article.publishDate)}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff929292),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.article.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF383838),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}