import 'dart:developer';

import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/pagination_data.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/user_card_provider.dart';
import 'package:flutter/material.dart';

class CustomerManagementScreen extends StatefulWidget {
  final indexSelected = 0;
  final Collaborator user;
  const CustomerManagementScreen({super.key, required this.user});

  @override
  State<CustomerManagementScreen> createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final UserCardProvider _userCardProvider = UserCardProvider();
  late Future<PaginationData?> _cardsUserFuture;
  int idStateSelected = 1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardsUserFuture = _loadUserCards();
  }

  Future<PaginationData?> _loadUserCards() async {
    try {
      return await _userCardProvider.filterByBusiness(
        widget.user.business[widget.indexSelected].id,
        idStateSelected,
      );
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  void _navigateAndReload(Widget screen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    if (result == true) {
      setState(() {
        _cardsUserFuture = _loadUserCards();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Clientes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar cliente',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<PaginationData?>(
              future: _cardsUserFuture,
              builder: (context, snapshot) {
                List cards = [];
                if (snapshot.data != null) {
                  cards = snapshot.data!.list;
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.list.isEmpty) {
                  return const Center(child: Text('No tienes clientes aún.'));
                } else {
                  return ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final UserCard userCard = cards[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(userCard.code ?? ''),
                          subtitle: Text(
                            'Sellos: ${userCard.currentStamps}/${userCard.businessCard!.maxStamp}',
                          ),
                          trailing: Text(
                            userCard.state!,
                            style: TextStyle(
                              color: userCard.state == 'active'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
