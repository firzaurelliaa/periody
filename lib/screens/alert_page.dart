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

class StatusAlert extends StatelessWidget {
  final String status;

  const StatusAlert({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.green;
    String statusText = 'Normal';

    if (status.toLowerCase() == 'warning') {
      statusColor = Colors.orange;
      statusText = 'Perlu Diperhatikan';
    } else if (status.toLowerCase() == 'danger') {
      statusColor = Colors.red;
      statusText = 'Berbahaya';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info, color: statusColor),
          const SizedBox(width: 10),
          Text(
            'Status: $statusText',
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
