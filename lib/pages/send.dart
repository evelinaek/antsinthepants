import 'package:flutter/material.dart';
import 'package:antsinthepants/models/models.dart';
import 'package:antsinthepants/pages/quote_templates.dart';

class ExportSendPage extends StatelessWidget {
  const ExportSendPage({super.key});

  QuoteTheme _getThemeForTemplate(Template t) {
    final name = t.name.toLowerCase();
    if (name.contains('vinter')) return QuoteTheme.winter;
    if (name.contains('sommar')) return QuoteTheme.summer;
    // andra mallar får neutral vintertema som fallback
    return QuoteTheme.winter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Export & utskick',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ValueListenableBuilder<List<Template>>(
        valueListenable: globalTemplates,
        builder: (context, templates, _) {
          if (templates.isEmpty) {
            return const Center(child: Text('Inga mallar tillgängliga'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: templates.length,
            itemBuilder: (context, i) {
              final t = templates[i];
              final color = Color(t.primaryColorValue ?? 0xFFB3E5FC);
              final theme = _getThemeForTemplate(t);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () async {
                    final sent = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuotePreviewPage(
                          booking: mockBookings.first,
                          theme: theme,
                        ),
                      ),
                    );
                    if (sent == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mall "${t.name}" skickad')),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // 🔹 Färgrutan visar mallens faktiska färg
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                t.title.isNotEmpty
                                    ? t.title
                                    : 'Ingen beskrivning',
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
