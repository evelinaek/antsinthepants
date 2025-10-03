import 'package:flutter/material.dart';

class ExportSendPage extends StatelessWidget {
  const ExportSendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F2),
      appBar: AppBar(
        title: const Text('Export & utskick'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {}, // gemensam burgarmeny-knapp (placeholder)
          ),
        ],
      ),
      body: const Center(
        child: Text('Placeholder: Export & utskick'),
      ),
    );
  }
}
