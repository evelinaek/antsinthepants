import 'package:flutter/material.dart';
import 'package:antsinthepants/models/models.dart';

class BuildPackagePage extends StatefulWidget {
  final Booking? editingBooking;
  const BuildPackagePage({super.key, this.editingBooking});

  @override
  State<BuildPackagePage> createState() => _BuildPackagePageState();
}

class _BuildPackagePageState extends State<BuildPackagePage> {
  String selectedCategory = 'Aktiviteter';
  final List<Module> selectedModules = [];
  final List<Module> userModules = [];
  final List<String> userCategories = [];

  List<String> get categories =>
      {...allModules.map((m) => m.category), ...userCategories}.toList();

  List<Module> get allAvailableModules => [...allModules, ...userModules];

  @override
  void initState() {
    super.initState();
    if (widget.editingBooking != null) {
      selectedModules.addAll(widget.editingBooking!.modules);
      if (selectedModules.isNotEmpty) {
        selectedCategory = selectedModules.first.category;
      }
    }
  }

  Future<Map<String, String>?> _askOfferName() => showDialog<Map<String, String>>(
        context: context,
        builder: (context) {
          String title = '';
          String customer = '';
          return AlertDialog(
            title: const Text('Titel på offert & Kundnamn'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Titel på offert',
                    hintText: 'Exempel: Weekend med helikoptertur',
                  ),
                  onChanged: (v) => title = v,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Kundnamn',
                    hintText: 'Kundens namn',
                  ),
                  onChanged: (v) => customer = v,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Avbryt'),
              ),
              ElevatedButton(
                onPressed: () {
                  final t = title.trim();
                  final c = customer.trim();
                  if (t.isNotEmpty && c.isNotEmpty) Navigator.pop(context, {'title': t, 'customer': c});
                },
                child: const Text('Spara'),
              ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final modules = allAvailableModules
        .where((m) => m.category == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          widget.editingBooking != null ? 'Redigera paket' : 'Bygg paket',
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: categories.indexOf(selectedCategory),
            onDestinationSelected: (index) {
              setState(() {
                selectedCategory = categories[index];
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: categories
                .map(
                  (cat) => NavigationRailDestination(
                    icon: const Icon(Icons.folder),
                    label: Text(cat),
                  ),
                )
                .toList(),
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Lägg till kategori',
                onPressed: () async {
                  final newCategory = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      String temp = '';
                      return AlertDialog(
                        title: const Text('Ny kategori'),
                        content: TextField(
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Kategorinamn',
                          ),
                          onChanged: (value) => temp = value,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Avbryt'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (temp.trim().isNotEmpty &&
                                  !categories.contains(temp.trim())) {
                                Navigator.pop(context, temp.trim());
                              }
                            },
                            child: const Text('Lägg till'),
                          ),
                        ],
                      );
                    },
                  );
                  if (newCategory != null) {
                    setState(() {
                      userCategories.add(newCategory);
                      selectedCategory = newCategory;
                    });
                  }
                },
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Lägg till modul'),
                        onPressed: () async {
                          String modulNamn = '';
                          String prisText = '';
                          final result = await showDialog<Module>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Ny modul'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Namn på modul',
                                        hintText: 't.ex. Bowling',
                                      ),
                                      onChanged: (value) => modulNamn = value,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                        labelText: 'Pris (kr)',
                                        hintText: 't.ex. 500',
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) => prisText = value,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Avbryt'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final price = double.tryParse(
                                        prisText.replaceAll(',', '.'),
                                      );
                                      if (modulNamn.trim().isNotEmpty &&
                                          price != null &&
                                          price > 0) {
                                        Navigator.pop(
                                          context,
                                          Module(
                                            modulNamn.trim(),
                                            selectedCategory,
                                            price,
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Lägg till'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (result != null) {
                            setState(() {
                              userModules.add(result);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: modules.map((module) {
                      final isSelected = selectedModules.contains(module);
                      return ListTile(
                        title: Text(
                          '${module.name} (${module.price.toStringAsFixed(0)} kr)',
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    selectedModules.add(module);
                                  });
                                },
                              ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Valda moduler:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children: selectedModules
                            .map(
                              (m) => Chip(
                                label: Text(
                                  '${m.name} (${m.price.toStringAsFixed(0)} kr)',
                                ),
                                onDeleted: () {
                                  setState(() {
                                    selectedModules.remove(m);
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: selectedModules.isEmpty
                            ? null
                            : () async {
                                if (widget.editingBooking != null) {
                                  final updated = Booking(
                                    id: widget.editingBooking!.id,
                                    reference: widget.editingBooking!.reference,
                                    customerName:
                                        widget.editingBooking!.customerName,
                                    date: widget.editingBooking!.date,
                                    status: widget.editingBooking!.status,
                                    notes: widget.editingBooking!.notes,
                                    modules: List.from(selectedModules),
                                    title: widget.editingBooking!.title,
                                  );
                                  Navigator.pop(context, updated);
                                } else {
                                  final vals = await _askOfferName();
                                  if (vals == null) return;
                                  final newBooking = Booking(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    reference: 'ANT-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch % 100000}',
                                    title: vals['title'] ?? '',
                                    customerName: vals['customer'] ?? '',
                                    date: DateTime.now(),
                                    status: 'Utkast',
                                    modules: List.from(selectedModules),
                                  );
                                  mockBookings.insert(0, newBooking);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Offert sparad som utkast'),
                                    ),
                                  );
                                }
                              },
                        child: Text(
                          widget.editingBooking != null
                              ? 'Spara ändringar'
                              : 'Spara offert',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
