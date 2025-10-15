import 'package:flutter/material.dart';
import 'package:antsinthepants/models/models.dart';
import 'package:antsinthepants/pages/builder.dart';
import 'package:antsinthepants/pages/quote_templates.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'Alla';
  List<String> get _statuses => [
    'Alla',
    'Utkast',
    'Skickad',
    'Bekräftad',
    'Avbokad',
  ];

  List<Booking> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    return mockBookings.where((b) {
      final matchesStatus =
          _statusFilter == 'Alla' || b.status == _statusFilter;
      final matchesQuery =
          q.isEmpty ||
          b.customerName.toLowerCase().contains(q) ||
          b.reference.toLowerCase().contains(q) ||
          b.title.toLowerCase().contains(q);
      return matchesStatus && matchesQuery;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Utkast':
        return Colors.orange;
      case 'Skickad':
        return Colors.blue;
      case 'Bekräftad':
        return Colors.green;
      case 'Avbokad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _askSendEmailAndSetStatus(
    Booking b,
    String newStatus,
    String label,
  ) async {
    String email = '';
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$label - ange epost'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'mejladress@example.com',
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) => email = v,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Avbryt'),
            ),
            ElevatedButton(
              onPressed: () {
                if (email.trim().isNotEmpty) Navigator.pop(context, true);
              },
              child: const Text('Skicka'),
            ),
          ],
        );
      },
    );
    if (ok == true) {
      setState(() {
        b.status = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label skickad till $email (prototyp)')),
      );
    }
  }

  void _showActions(Booking b) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Avboka'),
              onTap: () {
                setState(() {
                  b.status = 'Avbokad';
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bokning avbokad')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Skicka offert'),
              onTap: () async {
                Navigator.pop(context);
                // Ask which template to use
                // Capture a local context to avoid using the widget context after async gaps
                final c = context;
                final theme = await showModalBottomSheet<QuoteTheme>(
                  context: c,
                  builder: (_) => SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.ac_unit),
                          title: const Text('Vintermall (ljusblå)'),
                          onTap: () => Navigator.pop(c, QuoteTheme.winter),
                        ),
                        ListTile(
                          leading: const Icon(Icons.wb_sunny),
                          title: const Text('Sommarmall (grön)'),
                          onTap: () => Navigator.pop(c, QuoteTheme.summer),
                        ),
                        ListTile(
                          leading: const Icon(Icons.close),
                          title: const Text('Avbryt'),
                          onTap: () => Navigator.pop(c, null),
                        ),
                      ],
                    ),
                  ),
                );
                if (theme == null) return;
                // Show preview and ask to confirm sending
                final sent = await Navigator.of(c).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => QuotePreviewPage(booking: b, theme: theme),
                  ),
                );
                if (sent == true) {
                  // Ask for email and set status
                  await _askSendEmailAndSetStatus(b, 'Skickad', 'Offert');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Skicka faktura'),
              onTap: () {
                Navigator.pop(context);
                _askSendEmailAndSetStatus(b, 'Skickad faktura', 'Faktura');
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Stäng'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(Booking b) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              ListTile(
                title: Text(
                  '${b.title.isNotEmpty ? b.title : b.customerName} • ${b.reference}',
                ),
                subtitle: Text('Datum: ${_formatDate(b.date)}'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.monetization_on),
                title: Text('${b.total.toStringAsFixed(0)} kr'),
                subtitle: const Text('Totalpris'),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text('Status: ${b.status}'),
              ),
              if (b.notes.isNotEmpty)
                ListTile(leading: const Icon(Icons.note), title: Text(b.notes)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        final updated = await Navigator.push<Booking>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BuildPackagePage(editingBooking: b),
                          ),
                        );
                        if (updated != null) {
                          setState(() {
                            final idx = mockBookings.indexWhere(
                              (x) => x.id == updated.id,
                            );
                            if (idx >= 0) mockBookings[idx] = updated;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Bokning uppdaterad')),
                          );
                        }
                      },
                      child: const Text('Redigera'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showActions(b);
                      },
                      child: const Text('Åtgärder'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bokningar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Sök på kund, titel eller referens',
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _statusFilter,
                  items: _statuses
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _statusFilter = v ?? 'Alla';
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const Center(
                    child: Text('Inga bokningar matchar din sökning'),
                  )
                : ListView.separated(
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final b = results[index];
                      return ListTile(
                        onTap: () => _showDetails(b),
                        title: Text(
                          '${b.title.isNotEmpty ? b.title : b.customerName}',
                        ),
                        subtitle: Text(
                          '${b.reference} • ${_formatDate(b.date)}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${b.total.toStringAsFixed(0)} kr',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              b.status,
                              style: TextStyle(color: _statusColor(b.status)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
