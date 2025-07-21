
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/user_card_provider.dart';
import 'package:flutter/material.dart';

class CustomerManagementScreen extends StatefulWidget {
  final User user;
  const CustomerManagementScreen({super.key, required this.user});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final UserCardProvider _userCardProvider = UserCardProvider();
  late Future<List<UserCard>> _userCardsFuture;
  List<UserCard> _filteredUserCards = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserCards();
    _searchController.addListener(_filterUserCards);
  }

  void _loadUserCards() {
    _userCardsFuture = _userCardProvider.filterByBusiness(widget.user.id);
    _userCardsFuture.then((userCards) {
      setState(() {
        _filteredUserCards = userCards;
      });
    });
  }

  void _filterUserCards() {
    final query = _searchController.text.toLowerCase();
    _userCardsFuture.then((userCards) {
      setState(() {
        _filteredUserCards = userCards
            .where((userCard) => userCard.name.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Clientes'),
      ),
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
            child: FutureBuilder<List<UserCard>>(
              future: _userCardsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tienes clientes aún.'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredUserCards.length,
                    itemBuilder: (context, index) {
                      final userCard = _filteredUserCards[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(userCard.name),
                          subtitle: Text('Sellos: ${userCard.currentStamps}/${userCard.totalStamps}'),
                          trailing: Text(userCard.state, style: TextStyle(color: userCard.state == 'active' ? Colors.green : Colors.red)),
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
