import 'package:flutter/material.dart';

class BuildPackagePage extends StatelessWidget {
  const BuildPackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('Bygg paket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {}, // gemensam burgarmeny-knapp (placeholder)
          ),
        ],
      ),
      body: const Center(
        child: Text('Placeholder: Bygg paket'),
      ),
    );
  }
}
