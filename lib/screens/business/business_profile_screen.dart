
import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessProfileScreen extends StatefulWidget {
  final User user;
  const BusinessProfileScreen({super.key, required this.user});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final BusinessProvider _businessProvider = BusinessProvider();
  late Future<Business?> _businessFuture;

  @override
  void initState() {
    super.initState();
    _businessFuture = _businessProvider.get(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Business?>(
        future: _businessFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error al cargar el perfil del negocio.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _businessFuture = _businessProvider.get(widget.user.id);
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else {
            final business = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(business.logoUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(business.name, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  Text(business.direction, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 5),
                      Text(business.rating.toString(), style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  _buildLinks(business.links),
                  const Divider(),
                  _buildCategories(business.categories),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para navegar a la pantalla de edición
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildLinks(List<dynamic> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Redes Sociales', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        ...links.map((link) => InkWell(
              onTap: () => _launchURL(link.url),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(link.name, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
              ),
            )),
      ],
    );
  }

  Widget _buildCategories(List<dynamic> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categorías', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: categories.map((category) => Chip(label: Text(category.name))).toList(),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}
