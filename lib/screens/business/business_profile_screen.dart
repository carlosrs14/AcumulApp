
import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:flutter/material.dart';

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
            return const Center(child: Text('Error al cargar el perfil del negocio.'));
          } else {
            final business = snapshot.data!;
            return Padding(
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
                  const SizedBox(height: 20),
                  const Divider(),
                  // Aquí se pueden añadir más detalles como links, categorías, etc.
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para editar el perfil
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
