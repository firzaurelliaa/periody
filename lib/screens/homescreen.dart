import 'package:flutter/material.dart';
import 'package:periody/screens/add_article.dart';
import 'package:periody/screens/add_note_page.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Home Screen'),
         actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddNotePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}