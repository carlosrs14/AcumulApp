import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/pagination_data.dart';
import 'package:acumulapp/providers/card_provider.dart';
import 'package:acumulapp/screens/business/add_edit_card_screen.dart';
import 'package:flutter/material.dart';

class ManageCardsScreen extends StatefulWidget {
  final int selectedIndex = 0;
  final Collaborator user;

  const ManageCardsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ManageCardsScreenState createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  late Future<PaginationData?> _cardsFuture;
  final CardProvider _cardProvider = CardProvider();

  @override
  void initState() {
    super.initState();
    _cardsFuture = _loadCards();
  }

  Future<PaginationData?> _loadCards() async {
    try {
      return await _cardProvider.filterByBusiness(
        widget.user.business[widget.selectedIndex].id,
        10,
        1,
      );
    } catch (e) {
      // Handle error appropriately
      print(e);
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
        _cardsFuture = _loadCards();
      });
    }
  }

  void _deleteCard(int cardId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta tarjeta?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _cardProvider.delete(cardId);
      if (success) {
        setState(() {
          _cardsFuture = _loadCards();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la tarjeta')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PaginationData?>(
        future: _cardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.list.isEmpty) {
            return const Center(child: Text('No tienes tarjetas creadas.'));
          } else {
            final cards = snapshot.data!.list;
            return ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        Text('Vence en ${card.expiration} días'),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sellos: ${card.maxStamp}'),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _navigateAndReload(
                                    AddEditCardScreen(
                                      card: card,
                                      idBusiness: widget
                                          .user
                                          .business[widget.selectedIndex]
                                          .id,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteCard(card.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndReload(
          AddEditCardScreen(
            idBusiness: widget.user.business[widget.selectedIndex].id,
          ),
        ),
        tooltip: 'Añadir nueva tarjeta',
        child: const Icon(Icons.add),
      ),
    );
  }
}
