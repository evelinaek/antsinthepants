import 'package:flutter/material.dart';

class Module {
  final String name;
  final String category;
  final double price;
  Module(this.name, this.category, this.price);

  get description => null;
}

final List<Module> allModules = [
  Module('Bergsklättring', 'Aktiviteter', 1200),
  Module('Åka släde', 'Aktiviteter', 800),
  Module('Middag på restaurang', 'Mat', 350),
  Module('Grillbuffé', 'Mat', 250),
  Module('Flyg', 'Transport', 2500),
  Module('Tåg', 'Transport', 900),
];

class Booking {
  final String id;
  final String reference;
  final String customerName;
  final DateTime date;
  String status;
  String notes;
  List<Module> modules;
  String title; // offertens namn

  Booking({
    required this.id,
    required this.reference,
    required this.customerName,
    required this.date,
    this.status = 'Utkast',
    this.notes = '',
    List<Module>? modules,
    this.title = '',
  }) : modules = modules ?? [];

  double get total => modules.fold(0.0, (s, m) => s + m.price);
}

// Global mock-lista (används av bookings.dart och builder.dart)
final List<Booking> mockBookings = [
  Booking(
    id: '1',
    reference: 'ANT-2025-001',
    title: 'Soloresa med helikoptertur',
    customerName: 'Erik Svensson',
    date: DateTime(2025, 10, 01),
    status: 'Skickad',
    notes: 'Behöver extra transfer vid ankomst.',
    modules: [allModules[0], allModules[4]],
  ),
  Booking(
    id: '2',
    reference: 'ANT-2025-002',
    title: 'Mötesresa Servicebolaget AB',
    customerName: 'Anna Karlsson',
    date: DateTime(2025, 11, 12),
    status: 'Utkast',
    modules: [allModules[2]],
  ),
  Booking(
    id: '3',
    reference: 'ANT-2025-003',
    title: 'Aktiv weekend för familjen Johansson',
    customerName: 'Resebyrån AB',
    date: DateTime(2025, 09, 05),
    status: 'Bekräftad',
    modules: [allModules[5]],
  ),
];



// 🎨 ---- TEMPLATE ----
class Template {
  final String id;
  final String name;
  final String title;
  final String introText;
  final String creatorImage;
  final bool isDefault;
  final int? primaryColorValue;

  Template({
    required this.id,
    required this.name,
    required this.title,
    required this.introText,
    required this.creatorImage,
    required this.isDefault,
    this.primaryColorValue,
  });

  Template copyWith({
    String? id,
    String? name,
    String? title,
    String? introText,
    String? creatorImage,
    bool? isDefault,
    int? primaryColorValue,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      introText: introText ?? this.introText,
      creatorImage: creatorImage ?? this.creatorImage,
      isDefault: isDefault ?? this.isDefault,
      primaryColorValue: primaryColorValue ?? this.primaryColorValue,
    );
  }
}

// 🔄 Global notifier för templates
final ValueNotifier<List<Template>> globalTemplates =
    ValueNotifier<List<Template>>([
  Template(
    id: 'default',
    name: 'Vintermall',
    title: 'Vår standardmall',
    introText: 'Detta är en enkel standardmall som används som utgångspunkt.',
    creatorImage: '',
    isDefault: true,
    primaryColorValue: 0xFFB3E5FC,
  ),
  Template(
    id: 'summer',
    name: 'Sommarmall',
    title: 'Sommarmall',
    introText: 'En ljus och luftig mall för sommaroffert.',
    creatorImage: '',
    isDefault: false,
    primaryColorValue: 0xFFBEE7C6,
  ),
]);