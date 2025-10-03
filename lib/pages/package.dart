import 'package:flutter/material.dart';

class StartNewOfferPage extends StatelessWidget {
  const StartNewOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Start / Nya erbjudandet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {}, // gemensam burgarmeny-knapp (placeholder)
          ),
        ],
      ),
      body: const Center(
        child: Text('Placeholder: Start / Nya erbjudandet'),
      ),
    );
  }
}
