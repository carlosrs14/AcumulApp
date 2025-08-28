import 'dart:developer';

import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/providers/card_provider.dart';
import 'package:acumulapp/screens/business/add_edit_card_screen.dart';
import 'package:acumulapp/widgets/business_card_list_item.dart';
import 'package:acumulapp/widgets/pagination.dart';
import 'package:flutter/material.dart';

class ManageCardsScreen extends StatefulWidget {
  final int selectedIndex;
  final Collaborator user;

  const ManageCardsScreen({
    super.key,
    required this.user,
    required this.selectedIndex,
  });

  @override
   State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  final CardProvider cardProvider = CardProvider();
  bool _isLoadingCardsActivate = true;
  bool _errorLoadingCards = false;
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPage = 10;
  List<BusinessCard> cards = [];

  Future<void> _loadCards(int page, int size) async {
    if (!mounted) return;
    setState(() {
      _isLoadingCardsActivate = true;
      _errorLoadingCards = false;
    });
    try {
      final paginationData = await cardProvider.filterByBusiness(
        widget.user.business[widget.selectedIndex].id,
        size,
        page,
        null
      );
      if (!mounted) return;
      setState(() {
        cards = paginationData!.list as List<BusinessCard>;
        currentPage = paginationData.currentPage;
        itemsPerPage = paginationData.pageSize;
        totalPage = paginationData.totalPages;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorLoadingCards = true;
      });

      log(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCardsActivate = false;
        });
      }
      
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
      await _loadCards(currentPage, itemsPerPage);
    }
  }

  void _archiveCard(BusinessCard card) async {
    final String extraText = card.isActive? "archivar": "desarchivar";
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$extraText tarjeta"),
        content: Text(
          '¿Estás seguro de que quieres $extraText esta tarjeta?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Seguro'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await cardProvider.archive(card.id, card.isActive);
      if (!mounted) return;
      if (success) {
        await _loadCards(currentPage, itemsPerPage);
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al $extraText la tarjeta')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de tarjetas')),
      body: _isLoadingCardsActivate
          ? Center(child: CircularProgressIndicator())
          : _errorLoadingCards
          ? Center(child: Text("Error de conexion"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      BusinessCard card = cards[index];
                      return BusinessCardListItem(
                        card: card,
                        onEdit: () => _navigateAndReload(
                          AddEditCardScreen(
                            card: card,
                            idBusiness:
                                widget.user.business[widget.selectedIndex].id,
                          ),
                        ),
                        onArchive: () => _archiveCard(card),
                      );
                    },
                  ),
                ),
                SizedBox(height: 50),
                PaginacionWidget(
                  currentPage: currentPage,
                  itemsPerPage: itemsPerPage,
                  totalItems: cards.length,
                  totalPages: totalPage,
                  onPageChanged: (newPage) async {
                    setState(() {
                      currentPage = newPage;
                    });
                    await _loadCards(newPage, itemsPerPage);
                  },
                  onItemsPerPageChanged: (newCount) async {
                    setState(() {
                      itemsPerPage = newCount;
                      currentPage = 1;
                    });
                    await _loadCards(currentPage, itemsPerPage);
                  },
                ),
              ],
            ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: FloatingActionButton(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
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
