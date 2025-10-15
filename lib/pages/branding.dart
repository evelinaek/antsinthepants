import 'package:flutter/material.dart';

class Template {
  final String id;
  final String name;
  final String title;
  final String introText;
  final String creatorImage;
  final bool isDefault;
  final int? primaryColorValue; // nullable för att undvika runtime-nullfel

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

class BrandingPage extends StatefulWidget {
  const BrandingPage({super.key});

  @override
  State<BrandingPage> createState() => _BrandingPageState();
}

class _BrandingPageState extends State<BrandingPage> {
  // En förifylld mall visas som kort
  List<Template> templates = [];

  // Fallbackfärg om template.primaryColorValue är null
  static const int _defaultPastel = 0xFFB3E5FC;

  @override
  void initState() {
    super.initState();
    templates = [
      Template(
        id: 'default',
        name: 'Vintermall',
        title: 'Vår standardmall',
        introText: 'Detta är en enkel standardmall som används som utgångspunkt.',
        creatorImage: '',
        isDefault: true,
        primaryColorValue: _defaultPastel,
      ),
      Template(
        id: 'sommarmall',
        name: 'Sommarmall',
        title: 'Sommarmall',
        introText: 'En ljus och luftig mall för sommaroffert.',
        creatorImage: '',
        isDefault: false,
        primaryColorValue: 0xFFBEE7C6, // pastellgrön
      ),
    ];
  }

  void handleToggleDefault(String id) {
    setState(() {
      templates = templates.map((t) => t.copyWith(isDefault: t.id == id)).toList();
    });
    _showSnack("Standardmall uppdaterad");
  }

  void handleDelete(String id) {
    final template = templates.firstWhere((t) => t.id == id);
    if (template.isDefault) {
      _showSnack("Kan inte ta bort standardmallen", isError: true);
      return;
    }
    setState(() => templates.removeWhere((t) => t.id == id));
    _showSnack("Mallen raderad");
  }

  Future<void> handleCreateOrEdit([Template? t]) async {
    // öppna bottom sheet som flyttar upp sig vid tangentbord
    final result = await showModalBottomSheet<Template>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (c) {
        final bottomInset = MediaQuery.of(c).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: TemplateEditor(template: t),
            ),
          ),
        );
      },
    );

    if (result == null) return;

    setState(() {
      final exists = templates.indexWhere((item) => item.id == result.id);
      if (exists >= 0) {
        templates[exists] = result;
        _showSnack("Mallen uppdaterad");
      } else {
        templates.add(result);
        _showSnack("Mall skapad");
      }
    });
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.primaryContainer,
        content: Text(
          msg,
          style: TextStyle(
            color: isError
                ? Theme.of(context).colorScheme.onErrorContainer
                : Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Ta bort mall'),
        content: Text('Vill du verkligen ta bort mallen "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Avbryt')),
          ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('Ta bort')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Brandingmallar"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FilledButton.icon(
                  onPressed: () => handleCreateOrEdit(),
                  icon: const Icon(Icons.add),
                  label: const Text("Skapa ny mall"),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: templates.isEmpty
                      ? const Center(
                          child: Text(
                            "Inga mallar ännu. Skapa din första mall!",
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : ListView.separated(
                          itemCount: templates.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final t = templates[index];
                            final colorValue = t.primaryColorValue ?? _defaultPastel;
                            return Container(
                              padding: const EdgeInsets.all(12),
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // färgkolumn till vänster
                                  Container(
                                    width: 8,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Color(colorValue),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Vänster: mallinfo + toggle under namnet
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                t.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            if (t.isDefault)
                                              Container(
                                                margin: const EdgeInsets.only(left: 8),
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.green[50],
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Text('Standard', style: TextStyle(fontSize: 12)),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          t.title,
                                          style: const TextStyle(color: Colors.black54),
                                        ),
                                        const SizedBox(height: 12),
                                        // Toggle "Sätt som standard"
                                        Row(
                                          children: [
                                            Switch(
                                              value: t.isDefault,
                                              onChanged: (v) {
                                                if (v) {
                                                  handleToggleDefault(t.id);
                                                } else {
                                                  _showSnack('En mall måste vara standard', isError: true);
                                                }
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            const Text('Sätt som standard'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Höger: redigera och ta bort-knappar
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        tooltip: 'Redigera mall',
                                        onPressed: () => handleCreateOrEdit(t),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        tooltip: 'Ta bort mall',
                                        color: Colors.red,
                                        onPressed: () async {
                                          final ok = await _confirmDelete(context, t.name);
                                          if (ok == true) handleDelete(t.id);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TemplateEditor extends StatefulWidget {
  final Template? template;
  const TemplateEditor({super.key, this.template});

  @override
  State<TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends State<TemplateEditor> {
  late TextEditingController _nameCtrl;
  late TextEditingController _titleCtrl;
  late TextEditingController _introCtrl;
  String? _error;

  // Pastellfärgpalett (svenska namn i kommentar)
  final List<Color> pastelColors = const [
    Color(0xFFBEE7C6), // pastellgrön
    Color(0xFFB3E5FC), // pastellblå
    Color(0xFFF8BBD0), // pastellrosa
    Color(0xFFFFF9C4), // pastellgul
    Color(0xFFFFE0B2), // pastellorange
  ];

  late int _selectedColorValue;

  @override
  void initState() {
    super.initState();
    final t = widget.template;
    _nameCtrl = TextEditingController(text: t?.name ?? '');
    _titleCtrl = TextEditingController(text: t?.title ?? '');
    _introCtrl = TextEditingController(text: t?.introText ?? '');
    _selectedColorValue = t?.primaryColorValue ?? pastelColors.first.value;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _introCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Ange ett namn för mallen');
      return;
    }

    final tpl = Template(
      id: widget.template?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      title: _titleCtrl.text.trim(),
      introText: _introCtrl.text.trim(),
      creatorImage: widget.template?.creatorImage ?? '',
      isDefault: widget.template?.isDefault ?? false,
      primaryColorValue: _selectedColorValue,
    );

    Navigator.of(context).pop(tpl);
  }

  @override
  Widget build(BuildContext context) {
    // Extra padding längst ner så innehållet inte döljs av tangentbordet
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 24 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.template == null ? 'Skapa mall' : 'Redigera mall',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
              ],
            ),
            const SizedBox(height: 8),
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Namn')),
            const SizedBox(height: 8),
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Rubrik')),
            const SizedBox(height: 8),
            TextField(
              controller: _introCtrl,
              decoration: const InputDecoration(labelText: 'Introduktionstext'),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            const Text('Välj huvudfärg (pastell):'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pastelColors.map((c) {
                final selected = c.value == _selectedColorValue;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorValue = c.value),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(8),
                      border: selected ? Border.all(color: Colors.black54, width: 2) : Border.all(color: Colors.black12),
                    ),
                    child: selected ? const Icon(Icons.check, size: 18, color: Colors.black54) : null,
                  ),
                );
              }).toList(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Avbryt'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: _save, child: const Text('Spara'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
