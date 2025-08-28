import 'package:acumulapp/utils/categories_icons.dart';
import 'package:acumulapp/utils/redes_icons.dart';
import 'package:flutter/material.dart';
import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/link.dart';
import 'package:acumulapp/providers/business_provider.dart';

class SocialLinksForm extends StatefulWidget {
  final Business business;

  const SocialLinksForm({super.key, required this.business});

  @override
  State<SocialLinksForm> createState() => _SocialLinksFormState();
}

class _SocialLinksFormState extends State<SocialLinksForm> {
  final BusinessProvider provider = BusinessProvider();
  final Map<int, String> availableNetworks = {
    1: "Website",
    2: "Facebook",
    3: "Instagram",
    4: "Whatsapp",
  };

  final Map<int, bool> selected = {};
  final Map<int, TextEditingController> controllers = {};

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    for (var id in availableNetworks.keys) {
      selected[id] = false;
      controllers[id] = TextEditingController();
    }
    if (widget.business.links != null) {
      for (var link in widget.business.links!) {
        if (availableNetworks.containsKey(link.id)) {
          selected[link.id] = true;
          controllers[link.id]?.text = link.url;
        }
      }
    }
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> saveLinks() async {
    setState(() => isLoading = true);

    List<Link> links = [];
    selected.forEach((id, isSelected) {
      if (isSelected && controllers[id]!.text.isNotEmpty) {
        links.add(Link(id, controllers[id]!.text, availableNetworks[id]!));
      }
    });

    final messenger = ScaffoldMessenger.of(context);

    try {
      final updated = await provider.updateLinks(widget.business, links);
      if (!mounted) return;
      setState(() => isLoading = false);

      if (updated) {
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              "Links actualizados con exito",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      } else {
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              "Error al actualizar links",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      String error = e.toString().replaceAll("Exception: ", "");
      if (error == "Error de validación") {
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              "Url invalido",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          ),
        );
      }

      return;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurar links"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: availableNetworks.entries.map((entry) {
                  final id = entry.key;
                  final name = entry.value;

                  IconData? icon = iconosRedes[normalize(name)];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Row(
                              children: [
                                Icon(
                                  icon,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            value: selected[id],
                            onChanged: (val) {
                              setState(() {
                                selected[id] = val ?? false;
                              });
                            },
                          ),
                          if (selected[id] == true)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextField(
                                controller: controllers[id],
                                decoration: InputDecoration(
                                  labelText: "URL de $name",

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : saveLinks,
                icon: const Icon(Icons.save),
                label: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Guardar cambios"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
