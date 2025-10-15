import 'package:flutter/material.dart';
import 'package:antsinthepants/models/models.dart';
import 'package:antsinthepants/pages/quote_templates.dart';


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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Förhandsgranska mallar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (mockBookings.isEmpty)
              const Text('Inga bokningar att visa som exempel')
            else ...[
              ListTile(
                title: const Text('Visa Vintermall (ljusblå)'),
                subtitle: Text('Exempel: ${mockBookings.first.title}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final c = context;
                  final sent = await Navigator.of(c).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => QuotePreviewPage(booking: mockBookings.first, theme: QuoteTheme.winter),
                    ),
                  );
                  if (sent == true) {
                    ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('Skickat (prototyp)')));
                  }
                },
              ),
              ListTile(
                title: const Text('Visa Sommarmall (grön)'),
                subtitle: Text('Exempel: ${mockBookings.first.title}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final c = context;
                  final sent = await Navigator.of(c).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => QuotePreviewPage(booking: mockBookings.first, theme: QuoteTheme.summer),
                    ),
                  );
                  if (sent == true) {
                    ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('Skickat (prototyp)')));
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
