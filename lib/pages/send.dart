import 'package:flutter/material.dart';
import 'package:antsinthepants/models/models.dart';
import 'package:antsinthepants/pages/quote_templates.dart';

class ExportSendPage extends StatelessWidget {
  const ExportSendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Export & utskick',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Förhandsgranska mallar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),

              if (mockBookings.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Inga bokningar att visa som exempel',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                )
              else ...[
                _buildTemplateCard(
                  context,
                  title: 'Visa Vintermall',
                  subtitle: 'Exempel: ${mockBookings.first.title}',
                  color: const Color(0xFF90CAF9), // vinterblå
                  onTap: () async {
                    final c = context;
                    final sent = await Navigator.of(c).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => QuotePreviewPage(
                          booking: mockBookings.first,
                          theme: QuoteTheme.winter,
                        ),
                      ),
                    );
                    if (sent == true) {
                      ScaffoldMessenger.of(c).showSnackBar(
                        const SnackBar(content: Text('Skickat (prototyp)')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildTemplateCard(
                  context,
                  title: 'Visa Sommarmall',
                  subtitle: 'Exempel: ${mockBookings.first.title}',
                  color: const Color(0xFFA5D6A7), // sommargrön
                  onTap: () async {
                    final c = context;
                    final sent = await Navigator.of(c).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => QuotePreviewPage(
                          booking: mockBookings.first,
                          theme: QuoteTheme.summer,
                        ),
                      ),
                    );
                    if (sent == true) {
                      ScaffoldMessenger.of(c).showSnackBar(
                        const SnackBar(content: Text('Skickat (prototyp)')),
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 🎨 Färgruta istället för ikon
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.6),
                    color,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
