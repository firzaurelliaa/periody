import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Kesehatan'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: const Center(
        child: Text(
          'Detail status menstruasi kamu akan muncul di sini.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}