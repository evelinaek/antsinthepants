import 'package:flutter/material.dart';
import 'package:antsinthepants/models/models.dart';

enum QuoteTheme { winter, summer }

class QuotePreviewPage extends StatelessWidget {
  final Booking booking;
  final QuoteTheme theme;
  const QuotePreviewPage({super.key, required this.booking, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isWinter = theme == QuoteTheme.winter;
    final title = isWinter ? 'Mall: Vinter (ljusblå)' : 'Mall: Sommar (grön)';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: isWinter ? const Color(0xFF0288D1) : const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: _QuoteCard(booking: booking, theme: theme),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Avbryt'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Skicka offert'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final Booking booking;
  final QuoteTheme theme;
  const _QuoteCard({Key? key, required this.booking, required this.theme}) : super(key: key);

  Color get primaryColor => theme == QuoteTheme.winter ? const Color(0xFF90CAF9) : const Color(0xFFA5D6A7);
  Color get accentColor => theme == QuoteTheme.winter ? const Color(0xFF0288D1) : const Color(0xFF2E7D32);
  Gradient get headerGradient => theme == QuoteTheme.winter
      ? const LinearGradient(colors: [Color(0xFFE1F5FE), Color(0xFF90CAF9)])
      : const LinearGradient(colors: [Color(0xFFE8F5E9), Color(0xFFA5D6A7)]);

  @override
  Widget build(BuildContext context) {
    final modules = booking.modules;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: headerGradient,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                // Logo placeholder
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'AiP',
                    style: TextStyle(fontWeight: FontWeight.bold, color: accentColor, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your custom Ants In pants holiday', style: TextStyle(color: accentColor, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      if (booking.title.isNotEmpty) Text(booking.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Kund: ${booking.customerName}', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                ),
                Text(booking.reference, style: TextStyle(color: accentColor)),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Inkluderade moduler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                      child: Text('Antal: ${modules.length}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                // Modules list
                Column(
                  children: modules.map((m) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(m.name, style: const TextStyle(fontWeight: FontWeight.w600))])),
                        const SizedBox(width: 12),
                        Text('${m.price.toStringAsFixed(0)} kr', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text('${booking.total.toStringAsFixed(0)} kr', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accentColor)),
                ]),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: theme == QuoteTheme.winter ? const Color(0xFFF1F8FF) : const Color(0xFFF1FFF3), borderRadius: BorderRadius.circular(8)),
                  child: Text('Giltighet: 30 dagar. Moms ej inkluderat om ej annat anges. Förändringar i paket kan påverka priset.', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                ),
                if (booking.notes.isNotEmpty) ...[const SizedBox(height: 12), const SizedBox(height: 4), Text('Noteringar:', style: TextStyle(fontWeight: FontWeight.bold)), Text(booking.notes)],
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)), border: Border(top: BorderSide(color: Colors.grey.shade200))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ants In pants', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 6),
                      // Use Wrap so long contact lines wrap instead of overflowing
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.phone, size: 16, color: Colors.black54), const SizedBox(width: 6), Text('Tel. 070-000 00 00', style: TextStyle(color: Colors.black54))]),
                          Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.email, size: 16, color: Colors.black54), const SizedBox(width: 6), Text('antsinpants@mail.com', style: TextStyle(color: Colors.black54))]),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size(96, 36),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Stäng'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
