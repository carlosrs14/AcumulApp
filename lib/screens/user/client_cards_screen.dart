import 'dart:async';
import 'dart:developer';

import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/user_card_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ClientCardsScreen extends StatefulWidget {
  final User user;
  const ClientCardsScreen({super.key, required this.user});

  @override
  State<ClientCardsScreen> createState() => _ClientCardsScreenState();
}

class _ClientCardsScreenState extends State<ClientCardsScreen> {
  final UserCardProvider userCardProvider = UserCardProvider();
  Timer? _debounce;
  List<UserCard> userCards = [];
  late double screenWidth;
  Map<int, String> stateList = {
    1: "Activo",
    2: "nose",
    3: "Redimido",
    4: "Inactivo",
    5: "Vencido",
  };
  int selectedState = 4;

  bool _isLoadingCardsActivate = true;
  bool _errorCardsActivate = false;

  Future<void> _loadCards(int idState) async {
    setState(() {
      _isLoadingCardsActivate = true;
      _errorCardsActivate = false;
    });
    try {
      final lista = await userCardProvider.filterByClient(
        widget.user.id,
        idState,
      );

      setState(() {
        userCards = lista;
      });
    } catch (e) {
      setState(() {
        _errorCardsActivate = true;
      });
    } finally {
      setState(() {
        _isLoadingCardsActivate = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCards(selectedState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(12),
          child: cuerpo(),
        ),
      ),
    );
  }

  Widget cuerpo() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [filtro()]),
        Expanded(child: listCards()),
      ],
    );
  }

  Widget listCards() {
    log(userCards.length.toString());
    return ListView.builder(
      itemCount: userCards.length,

      itemBuilder: (context, index) {
        final card = userCards[index];

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
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => BusinessInfoCards(
                //       business: widget.business,
                //       user: widget.user,
                //       businessCard: businessCardsList[index],
                //     ),
                //   ),
                // );
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
                        "CurrentStamps: ${card.currentStamps}",
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
                        "Bounty: ${card.businessCard}",
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
                          "Restricciones: ${card.id}",
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
      icon: Icon(MdiIcons.qrcode),
      label: Text(""),
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

  Widget filtro() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black26),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedState,
          icon: Icon(Icons.arrow_drop_down),
          items: stateList.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (int? newValue) async {
            if (newValue != null) {
              filtros("", newValue);
            }
          },
        ),
      ),
    );
  }

  void filtros(String query, int idState) async {
    setState(() {
      selectedState = idState;
      _loadCards(selectedState);
    });
  }
}
