import 'package:flutter/material.dart';

class TemplateLibraryPage extends StatelessWidget {
  const TemplateLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FFF8),
      appBar: AppBar(
        title: const Text('Mallbibliotek'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {}, // gemensam burgarmeny-knapp (placeholder)
          ),
        ],
      ),
      body: const Center(
        child: Text('Placeholder: Mallbibliotek'),
      ),
    );
  }
}
