import 'package:flutter/material.dart';

class Template {
  final String id;
  final String name;
  final String title;
  final String introText;
  final String creatorName;
  final String creatorImage;
  final String bodyText;
  final String greeting;
  final List<String> activityImages;
  final bool isDefault;

  Template({
    required this.id,
    required this.name,
    required this.title,
    required this.introText,
    required this.creatorName,
    required this.creatorImage,
    required this.bodyText,
    required this.greeting,
    required this.activityImages,
    required this.isDefault,
  });

  Template copyWith({
    String? id,
    String? name,
    String? title,
    String? introText,
    String? creatorName,
    String? creatorImage,
    String? bodyText,
    String? greeting,
    List<String>? activityImages,
    bool? isDefault,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      introText: introText ?? this.introText,
      creatorName: creatorName ?? this.creatorName,
      creatorImage: creatorImage ?? this.creatorImage,
      bodyText: bodyText ?? this.bodyText,
      greeting: greeting ?? this.greeting,
      activityImages: activityImages ?? this.activityImages,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class BrandingPage extends StatefulWidget {
  const BrandingPage({super.key});

  @override
  State<BrandingPage> createState() => _BrandingPageState();
}

class _BrandingPageState extends State<BrandingPage> {
  List<Template> templates = [];
  Template? editingTemplate;

  @override
  void initState() {
    super.initState();
    templates = [
      Template(
        id: "1",
        name: "Klassisk Resemall",
        title: "Din personliga reseupplevelse",
        introText:
            "Vi har satt ihop detta exklusiva paket för er, med noggrant utvalda upplevelser för minnesvärda stunder.",
        creatorName: "Sara Svensson",
        creatorImage:
            "https://images.unsplash.com/photo-1425421669292-0c3da3b8f529",
        bodyText: """
Dag 1–3: Strandparadis
Njut av vårt exklusiva strandhotell med alla bekvämligheter.

Dag 4–5: Äventyr i bergen
Vandring genom hisnande landskap.

Dag 6–7: Stadsupptäckter
Upplev stadens puls och lokala smaker.
""",
        greeting: "Vi ser fram emot att hjälpa er skapa minnen för livet!",
        activityImages: [],
        isDefault: true,
      ),
    ];
  }

  void handleToggleDefault(String id) {
    setState(() {
      templates = templates.map((t) {
        return t.copyWith(isDefault: t.id == id);
      }).toList();
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

  void handleCreateOrEdit([Template? t]) {
    final nameCtrl = TextEditingController(text: t?.name ?? '');
    final titleCtrl = TextEditingController(text: t?.title ?? '');
    final introCtrl = TextEditingController(text: t?.introText ?? '');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t == null ? "Skapa mall" : "Redigera mall",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Namn'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Rubrik'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: introCtrl,
                decoration: const InputDecoration(labelText: 'Introduktionstext'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () {
                    final newTemplate = Template(
                      id: t?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text,
                      title: titleCtrl.text,
                      introText: introCtrl.text,
                      creatorName: "Sara Svensson",
                      creatorImage:
                          "https://images.unsplash.com/photo-1425421669292-0c3da3b8f529",
                      bodyText: "",
                      greeting: "",
                      activityImages: [],
                      isDefault: false,
                    );

                    setState(() {
                      if (t != null) {
                        templates = templates.map((temp) {
                          return temp.id == t.id ? newTemplate : temp;
                        }).toList();
                        _showSnack("Mallen uppdaterad");
                      } else {
                        templates.add(newTemplate);
                        _showSnack("Mall skapad");
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Spara"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handlePreview(Template t) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(t.introText, style: Theme.of(context).textTheme.bodyMedium),
                const Divider(height: 24),
                Text(t.bodyText),
                const SizedBox(height: 16),
                Text(
                  t.greeting,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Stäng"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          constraints: const BoxConstraints(maxWidth: 600),
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
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final t = templates[index];
                            return Container(
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
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  t.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  t.title,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == "preview") handlePreview(t);
                                    if (value == "edit") handleCreateOrEdit(t);
                                    if (value == "default")
                                      handleToggleDefault(t.id);
                                    if (value == "delete") handleDelete(t.id);
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                        value: "preview",
                                        child: Text("Förhandsgranska")),
                                    const PopupMenuItem(
                                        value: "edit", child: Text("Redigera")),
                                    const PopupMenuItem(
                                        value: "default",
                                        child: Text("Sätt som standard")),
                                    const PopupMenuItem(
                                        value: "delete", child: Text("Ta bort")),
                                  ],
                                ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(t.creatorImage),
                                ),
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
