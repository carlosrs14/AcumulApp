import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/providers/card_provider.dart';
import 'package:acumulapp/screens/user/business_cards_info_screen.dart';

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

  bool _isLoadingBusinessCards = true;
  String? _errorBusinessCards;

  List<BusinessCard> businessCardsList = [];

  Future<void> _loadBusinessCards() async {
    setState(() {
      _isLoadingBusinessCards = true;
      _errorBusinessCards = null;
    });
    try {
      final lista = await cardProvider.filterByBusiness(widget.business.id);

      setState(() {
        businessCardsList = lista;
      });
    } catch (e) {
      setState(() {
        _errorBusinessCards = 'Error al cargar categorías';
      });
    } finally {
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
    return Column(children: [Expanded(child: listCards())]);
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
            side: BorderSide(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
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
              title: Text(
                "Card",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              trailing: addCardButton(),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Expirataion: ${card.expiration}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.stars, size: 18, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text(
                        "Max Stamp: ${card.maxStamp}",
                        style: TextStyle(fontSize: 14),
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
          ),
        );
      },
    );
  }

  Widget addCardButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(MdiIcons.cardsOutline),
      label: Text("Add Card"),
      iconAlignment: IconAlignment.end,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: TextStyle(fontSize: 14),
        elevation: 4,
      ),
    );
  }
}
