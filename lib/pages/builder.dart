import 'package:flutter/material.dart';

class Module {
  final String name;
  final String category;
  final double price;
  Module(this.name, this.category, this.price);
}

final List<Module> allModules = [
  Module('Bergsklättring', 'Aktiviteter', 1200),
  Module('Åka släde', 'Aktiviteter', 800),
  Module('Middag på restaurang', 'Mat', 350),
  Module('Grillbuffé', 'Mat', 250),
  Module('Flyg', 'Transport', 2500),
  Module('Tåg', 'Transport', 900),
];

class BuildPackagePage extends StatefulWidget {
  const BuildPackagePage({super.key});

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
  Widget build(BuildContext context) {
    final modules = allAvailableModules
        .where((m) => m.category == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('Bygg paket'),
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () {})],
      ),
      body: Row(
        children: [
          // Kategorilista
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
          VerticalDivider(width: 1),
          // Modulbibliotek och valda moduler
          Expanded(
            child: Column(
              children: [
                // Lägg till modul-knapp
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
                // Modulbibliotek
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
                // Valda moduler
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
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Offert skickad!'),
                                  ),
                                );
                              },
                        child: const Text('Skicka offert'),
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
