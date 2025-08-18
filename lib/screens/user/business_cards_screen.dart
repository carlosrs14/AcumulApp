import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/card_provider.dart';
import 'package:acumulapp/providers/user_card_provider.dart';
import 'package:acumulapp/screens/user/QrCode_screen.dart';
import 'package:acumulapp/screens/user/business_cards_info_screen.dart';
import 'package:acumulapp/widgets/pagination.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BusinessCardsScreen extends StatefulWidget {
  final Business business;
  final User user;
  const BusinessCardsScreen({
    super.key,
    required this.business,
    required this.user,
  });

  @override
  State<BusinessCardsScreen> createState() => _BusinessCardsScreenState();
}

class _BusinessCardsScreenState extends State<BusinessCardsScreen> {
  final CardProvider cardProvider = CardProvider();
  final UserCardProvider userCardProvider = UserCardProvider();

  bool _isLoadingBusinessCards = true;
  String? _errorBusinessCards;

  List<BusinessCard> businessCardsList = [];
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPage = 10;

  Future<void> _loadBusinessCards() async {
    if (!mounted) return;
    setState(() {
      _isLoadingBusinessCards = true;
      _errorBusinessCards = null;
    });
    try {
      final paginationData = await cardProvider.filterByBusiness(
        widget.business.id,
        itemsPerPage,
        currentPage,
      );
      if (!mounted) return;
      setState(() {
        businessCardsList = paginationData!.list as List<BusinessCard>;
        currentPage = paginationData.currentPage;
        itemsPerPage = paginationData.pageSize;
        totalPage = paginationData.totalPages;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorBusinessCards = 'Error al cargar categorías';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingBusinessCards = false;
      });
    }
  }

  @override
  void initState() {
    _loadBusinessCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingBusinessCards
          ? Center(child: CircularProgressIndicator())
          : businessCardsList.isEmpty
          ? Center(child: Text("No hay tarjetas disponibles"))
          : Container(child: cuerpo()),
    );
  }

  Widget cuerpo() {
    return Column(
      children: [
        Expanded(child: listCards()),
        PaginacionWidget(
          currentPage: currentPage,
          itemsPerPage: itemsPerPage,
          totalItems: businessCardsList.length,
          totalPages: totalPage,
          onPageChanged: (newPage) async {
            setState(() {
              currentPage = newPage;
            });
            await _loadBusinessCards();
          },
          onItemsPerPageChanged: (newCount) async {
            setState(() {
              itemsPerPage = newCount;
              currentPage = 1;
            });
            await _loadBusinessCards();
          },
        ),
      ],
    );
  }

  Widget listCards() {
    return ListView.builder(
      itemCount: businessCardsList.length,
      itemBuilder: (context, index) {
        final card = businessCardsList[index];
        return Card(
          elevation: 4,

          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BusinessInfoCards(
                    business: widget.business,
                    user: widget.user,
                    businessCard: businessCardsList[index],
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(18),
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
                                style: TextStyle(fontSize: 14),
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
                                style: TextStyle(fontSize: 14),
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
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 12),
                    child: addCardButton(card),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget addCardButton(BusinessCard businessCard) {
    return ElevatedButton.icon(
      onPressed: () async {
        UserCard? userCard = await userCardProvider.create(
          UserCard(0, widget.user.id, businessCard.id),
        );
        if (userCard != null && userCard.code != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QrCodeScreen(
                code: userCard!.code!,
                text:
                    "Presenta este QR al negocio para que te activen tu tarjeta",
              ),
            ),
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tarjeta creada exitosamente',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.greenAccent,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '"Alancazaste la cantidad maxima de tarjetas"',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      icon: Icon(MdiIcons.cardsOutline),
      label: Text("Add Card"),
      iconAlignment: IconAlignment.end,
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: TextStyle(fontSize: 14),
        elevation: 4,
      ),
    );
  }
}
