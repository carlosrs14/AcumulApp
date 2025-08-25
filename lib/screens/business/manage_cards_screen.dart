import 'dart:developer';

import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/models/collaborator.dart';
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
  bool _isLoadingCardsActivate = true;
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPage = 10;
  List<BusinessCard> cards = [];

  Future<void> _loadCards(int page, int size) async {
    if (!mounted) return;
    setState(() {
      _isLoadingCardsActivate = true;
    });
    try {
      final paginationData = await cardProvider.filterByBusiness(
        widget.user.business[widget.selectedIndex].id,
        size,
        page,
      );
      if (!mounted) return;
      setState(() {
        cards = paginationData!.list as List<BusinessCard>;
        currentPage = paginationData.currentPage;
        itemsPerPage = paginationData.pageSize;
        totalPage = paginationData.totalPages;
      });
    } catch (e) {
      log(e.toString());
    } finally {
      _isLoadingCardsActivate = false;
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

  void _deleteCard(int cardId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar desactivacion'),
        content: const Text(
          '¿Estás seguro de que quieres desactivar esta tarjeta?',
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
        await _loadCards(currentPage, itemsPerPage);
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
      body: _isLoadingCardsActivate
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 6,
                                ),
                                child: Text(
                                  card.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Row(
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
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Row(
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
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Row(
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
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      MdiIcons.comment,
                                      size: 18,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        "Descripcion: \n${card.description}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),
                              ?actionButtons(
                                card,
                                true,
                                "Editar",
                                "Desactivar",
                              ),
                            ],
                          ),
                        ),
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

  Widget? actionButtons(
    BusinessCard card,
    bool mostrar,
    String texto,
    String texto2,
  ) {
    return !mostrar
        ? null
        : Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditCardScreen(
                          card: card,
                          idBusiness:
                              widget.user.business[widget.selectedIndex].id,
                        ),
                      ),
                    );
                    await _loadCards(currentPage, itemsPerPage);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(Icons.edit),
                  label: Text(texto),
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _deleteCard(card.id);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(Icons.delete),
                  label: Text(texto2),
                ),
              ),
            ],
          );
  }
}
