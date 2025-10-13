import 'package:antsinthepants/pages/branding.dart';
import 'package:antsinthepants/pages/package.dart';
import 'package:antsinthepants/pages/builder.dart';
import 'package:antsinthepants/pages/send.dart';
import 'package:antsinthepants/pages/bookings.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // Ordningen här måste matcha NavigationDestination-ordningen nedan:
  late final List<Widget> _pages = [
    StartNewOfferPage(), // Start (index 0)
    BrandingPage(), // Branding (index 1)
    BuildPackagePage(), // Bygg (index 2)
    BookingsPage(), // Bokningar (index 3)
    ExportSendPage(), // Export / Skicka (index 4)
    Center(child: Text('Settings Page')), // Inställningar (index 5)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack bevarar state i varje flik och visar rätt sida per index
      body: IndexedStack(index: _index, children: _pages),
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
            icon: Icon(Icons.brush_outlined),
            selectedIcon: Icon(Icons.brush),
            label: 'Branding',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_quilt_outlined),
            selectedIcon: Icon(Icons.view_quilt),
            label: 'Bygg',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Bokningar',
          ),
          NavigationDestination(
            icon: Icon(Icons.ios_share_outlined),
            selectedIcon: Icon(Icons.ios_share),
            label: 'Export',
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
