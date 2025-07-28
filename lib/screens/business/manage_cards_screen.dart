import 'dart:developer';

import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/pagination_data.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/card_provider.dart';
import 'package:acumulapp/screens/business/add_edit_card_screen.dart';
import 'package:acumulapp/widgets/pagination.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ManageCardsScreen extends StatefulWidget {
  final int selectedIndex;
  final Collaborator user;

  const ManageCardsScreen({
    super.key,
    required this.user,
    required this.selectedIndex,
  });

  @override
  _ManageCardsScreenState createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  final CardProvider cardProvider = CardProvider();

  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPage = 10;
  List<BusinessCard> cards = [];

  Future<void> _loadCards(int page, int size) async {
    try {
      final paginationData = await cardProvider.filterByBusiness(
        widget.user.business[widget.selectedIndex].id,
        size,
        page,
      );
      setState(() {
        cards = paginationData!.list as List<BusinessCard>;
        currentPage = paginationData.currentPage;
        itemsPerPage = paginationData.pageSize;
        totalPage = paginationData.totalPages;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    _loadCards(currentPage, itemsPerPage);
    super.initState();
  }

  void _navigateAndReload(Widget screen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    if (result == true) {
      setState(() {
        _loadCards(currentPage, itemsPerPage);
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
      final success = await cardProvider.delete(cardId);
      if (success) {
        setState(() {
          _loadCards(currentPage, itemsPerPage);
        });
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la tarjeta')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de tarjetas')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                BusinessCard card = cards[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.stars,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "Bounty: ${card.reward}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.stamper,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "MaxStamp: ${card.maxStamp}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "Restricciones: ${card.restrictions}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.comment,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "Description: ${card.description}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Botones a la derecha
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
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
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCard(card.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          PaginacionWidget(
            currentPage: currentPage,
            itemsPerPage: itemsPerPage,
            totalItems: cards.length,
            totalPages: totalPage,
            onPageChanged: (newPage) {
              setState(() {
                currentPage = newPage;
                _loadCards(newPage, itemsPerPage);
              });
            },
            onItemsPerPageChanged: (newCount) {
              setState(() {
                itemsPerPage = newCount;
                currentPage = 1;
                _loadCards(currentPage, itemsPerPage);
              });
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: () => _navigateAndReload(
            AddEditCardScreen(
              idBusiness: widget.user.business[widget.selectedIndex].id,
            ),
          ),
          tooltip: 'Añadir nueva tarjeta',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
