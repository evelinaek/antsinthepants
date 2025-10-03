import 'package:antsinthepants/pages/branding.dart';
import 'package:antsinthepants/pages/builder.dart';
import 'package:antsinthepants/pages/package.dart';
import 'package:antsinthepants/pages/send.dart';
import 'package:antsinthepants/pages/template.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  late final List<Widget> _pages = const [
  BrandingPage(),
  StartNewOfferPage(),
  BuildPackagePage(),
  ExportSendPage(),
  TemplateLibraryPage(),
    Center(child: Text('Settings Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.playlist_add_outlined),
            selectedIcon: Icon(Icons.playlist_add),
            label: 'Start',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_quilt_outlined),
            selectedIcon: Icon(Icons.view_quilt),
            label: 'Bygg',
          ),
          NavigationDestination(
            icon: Icon(Icons.brush_outlined),
            selectedIcon: Icon(Icons.brush),
            label: 'Branding',
          ),
          NavigationDestination(
            icon: Icon(Icons.ios_share_outlined),
            selectedIcon: Icon(Icons.ios_share),
            label: 'Export',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_copy_outlined),
            selectedIcon: Icon(Icons.folder_copy),
            label: 'Mallar',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Inställningar',
          ),
        ],
      ),
    );
  }
}
