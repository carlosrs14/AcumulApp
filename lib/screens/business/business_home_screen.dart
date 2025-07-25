import 'dart:developer';

import 'package:acumulapp/models/collaborator.dart';
import 'package:flutter/material.dart';
import 'package:acumulapp/screens/business/manage_cards_screen.dart';
import 'package:acumulapp/screens/business/business_profile_screen.dart';

class BusinessHomeScreen extends StatefulWidget {
  final Collaborator user;
  const BusinessHomeScreen({super.key, required this.user});

  @override
  State<BusinessHomeScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    for (var e in widget.user.business) {
      log(e.id.toString());
      log(e.name);  
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Negocio'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Inicio'),
            Tab(icon: Icon(Icons.credit_card), text: 'Tarjetas'),
            Tab(icon: Icon(Icons.person), text: 'Perfil'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Contenido de la pestaña de Inicio
          const Center(
            child: Text('Bienvenido al Panel de Negocio'),
          ),
          // Contenido de la pestaña de Tarjetas
          ManageCardsScreen(user: widget.user),
          // Contenido de la pestaña de Perfil
          BusinessProfileScreen(user: widget.user),
        ],
      ),
    );
  }
}
