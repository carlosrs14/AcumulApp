import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/providers/card_provider.dart';
import 'package:acumulapp/screens/app_bar_client.dart';
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
      appBar: AppbarClient(currentScreen: "bussines_cards", user: widget.user),
      body: _isLoadingBusinessCards
          ? Center(child: CircularProgressIndicator())
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
                /*Navigator.pushNamed(
                  context,
                  '/business_details',
                  arguments: BusinessDetailsArguments(
                    business: filteredBusiness[index],
                    user: widget.user,
                  ),
                );*/
              },
              title: Text("Card"),
              trailing: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.purple.shade50,
                child: IconButton(
                  icon: Icon(MdiIcons.plus, size: 30),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text("Expirataion: ${businessCardsList[index].expiration}"),
                  Text("Max Stamp: ${businessCardsList[index].maxStamp}"),
                  Text("Description: ${businessCardsList[index].description}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
