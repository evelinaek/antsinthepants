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

  final ScrollController _scrollController = ScrollController();

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
    // Starta scroll längst ned när sidan öppnas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<Map<String, String>?> _askOfferName() =>
      showDialog<Map<String, String>>(
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
                  if (t.isNotEmpty && c.isNotEmpty) {
                    Navigator.pop(context, {'title': t, 'customer': c});
                  }
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          widget.editingBooking != null ? 'Redigera paket' : 'Bygg paket',
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Colors.grey[100],
            selectedIndex: categories.indexOf(selectedCategory),
            onDestinationSelected: (index) {
              setState(() {
                selectedCategory = categories[index];
              });
            },
            labelType: NavigationRailLabelType.all,
            selectedIconTheme: IconThemeData(color: Colors.deepPurple[400]),
            destinations: categories
                .map(
                  (cat) => NavigationRailDestination(
                    icon: const Icon(Icons.folder_outlined),
                    selectedIcon: const Icon(Icons.folder),
                    label: Text(cat),
                  ),
                )
                .toList(),
            // knapp för att lägga till kategori i sidobaren
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Lägg till kategori',
                    onPressed: () async {
                      String temp = '';
                      final newCategory = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Ny kategori'),
                            content: TextField(
                              autofocus: true,
                              decoration: const InputDecoration(
                                labelText: 'Kategorinamn',
                              ),
                              onChanged: (v) => temp = v,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Avbryt'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final val = temp.trim();
                                  if (val.isNotEmpty &&
                                      !categories.contains(val))
                                    Navigator.pop(context, val);
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
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add module button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
                    ),

                    // Module list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: modules.length,
                        itemBuilder: (context, i) {
                          final module = modules[i];
                          final isSelected = selectedModules.contains(module);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(
                                vertical: -2,
                                horizontal: -1,
                              ),
                              title: Text(
                                '${module.name} (${module.price.toStringAsFixed(0)} kr)',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 20,
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.add, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          selectedModules.add(module);
                                        });
                                        // Hoppa automatiskt till botten
                                        Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                            if (_scrollController.hasClients) {
                                              _scrollController.jumpTo(
                                                _scrollController
                                                    .position
                                                    .maxScrollExtent,
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Footer med synlig scroll och börjar längst ned
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 160),
                        child: Scrollbar(
                          thumbVisibility: true,
                          radius: const Radius.circular(8),
                          controller: _scrollController,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            reverse: true, // börjar längst ned
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Valda moduler:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: selectedModules
                                      .map(
                                        (m) => Chip(
                                          labelPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          labelStyle: const TextStyle(
                                            fontSize: 12,
                                          ),
                                          visualDensity: const VisualDensity(
                                            vertical: -3,
                                            horizontal: -3,
                                          ),
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
                                              reference: widget
                                                  .editingBooking!
                                                  .reference,
                                              customerName: widget
                                                  .editingBooking!
                                                  .customerName,
                                              date: widget.editingBooking!.date,
                                              status:
                                                  widget.editingBooking!.status,
                                              notes:
                                                  widget.editingBooking!.notes,
                                              modules: List.from(
                                                selectedModules,
                                              ),
                                              title:
                                                  widget.editingBooking!.title,
                                            );
                                            Navigator.pop(context, updated);
                                          } else {
                                            final vals = await _askOfferName();
                                            if (vals == null) return;
                                            final newBooking = Booking(
                                              id: DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString(),
                                              reference:
                                                  'ANT-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch % 100000}',
                                              title: vals['title'] ?? '',
                                              customerName:
                                                  vals['customer'] ?? '',
                                              date: DateTime.now(),
                                              status: 'Utkast',
                                              modules: List.from(
                                                selectedModules,
                                              ),
                                            );
                                            mockBookings.insert(0, newBooking);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Offert sparad som utkast',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple[400],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    widget.editingBooking != null
                                        ? 'Spara ändringar'
                                        : 'Spara offert',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
