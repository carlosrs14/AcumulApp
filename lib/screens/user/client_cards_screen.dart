import 'dart:async';
import 'dart:developer';

import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/providers/user_card_provider.dart';
import 'package:acumulapp/screens/user/QrCode_screen.dart';
import 'package:acumulapp/screens/user/business_cards_info_screen.dart';
import 'package:acumulapp/widgets/pagination.dart';
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
  final BusinessProvider businessProvider = BusinessProvider();
  Timer? _debounce;
  List<UserCard> userCards = [];
  late double screenWidth;
  Map<int, String> stateList = {
    1: "Activo",
    2: "Completado",
    3: "Redimido",
    4: "Inactivo",
    5: "Vencido",
  };
  int selectedState = 1;
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPage = 10;

  bool _isLoadingCardsActivate = true;
  bool _errorCardsActivate = false;

  Future<void> _loadCards() async {
    if (!mounted) return;
    setState(() {
      _isLoadingCardsActivate = true;
      _errorCardsActivate = false;
    });
    try {
      final paginationData = await userCardProvider.filterByClient(
        widget.user.id,
        selectedState,
        itemsPerPage,
        currentPage,
      );
      if (!mounted) return;
      setState(() {
        userCards = paginationData!.list as List<UserCard>;

        currentPage = paginationData.currentPage;
        itemsPerPage = paginationData.pageSize;
        totalPage = paginationData.totalPages;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorCardsActivate = true;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingCardsActivate = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingCardsActivate
          ? Center(child: CircularProgressIndicator())
          : _errorCardsActivate
          ? Center(child: Text("Error"))
          : userCards.isEmpty
          ? noCards()
          : Container(child: cuerpo()),
    );
  }

  Widget noCards() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [filtro()]),
            Expanded(
              child: Center(
                child: Text("No hay tarjetas", style: TextStyle(fontSize: 17)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cuerpo() {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [filtro()]),
            Expanded(child: listCards()),

            PaginacionWidget(
              currentPage: currentPage,
              itemsPerPage: itemsPerPage,
              totalItems: userCards.length,
              totalPages: totalPage,
              onPageChanged: (newPage) async {
                setState(() {
                  currentPage = newPage;
                });
                await _loadCards();
              },
              onItemsPerPageChanged: (newCount) async {
                setState(() {
                  itemsPerPage = newCount;
                  currentPage = 1;
                });
                await _loadCards();
              },
            ),
          ],
        ),
      ),
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
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              Business? businessResponse = await businessProvider.get(
                card.idBusinessCard,
              );
              if (businessResponse != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BusinessInfoCards(
                      business: businessResponse,
                      user: widget.user,
                      businessCard: card.businessCard!,
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.businessCard!.name,
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
                              MdiIcons.stamper,
                              size: 18,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "CurrentStamps: ${card.currentStamps}",
                              ),
                            ),
                          ],
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
                                "Bounty: ${card.businessCard!.reward}",
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
                                "MaxStamp: ${card.businessCard!.maxStamp}",
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
                                "Restricciones: ${card.businessCard!.restrictions}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Botón a la derecha centrado verticalmente
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Align(
                      alignment: Alignment.center,
                      child: qrState(card, selectedState),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget? qrState(UserCard userCard, int selectedState) {
    switch (selectedState) {
      case 1:
        return addCardButton(
          userCard,
          true,
          "Presenta este QR en el negocio para recibir tus sellos.",
        );
      case 2:
        return addCardButton(
          userCard,
          true,
          "Presenta este QR en el negocio para recibir tu recompensa.",
        );
      case 3:
        return addCardButton(userCard, false, "");
      case 4:
        return addCardButton(
          userCard,
          true,
          "Presenta este QR al negocio para que te activen tu tarjeta",
        );
      case 5:
        return addCardButton(userCard, false, "");
      default:
        return Text('');
    }
  }

  ElevatedButton? addCardButton(UserCard userCard, bool mostrar, String texto) {
    return !mostrar
        ? null
        : ElevatedButton.icon(
            onPressed: () async {
              if (userCard.code != null) {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        QrCodeScreen(code: userCard.code!, text: texto),
                  ),
                );
                await _loadCards();
              } else {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error de conexion',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            icon: Icon(MdiIcons.qrcode),
            label: Text(""),
            iconAlignment: IconAlignment.end,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.primary,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
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
              currentPage = 1;
              await filtros(newValue);
            }
          },
        ),
      ),
    );
  }

  Future<void> filtros(int idState) async {
    setState(() {
      selectedState = idState;
    });
    await _loadCards();
  }
}
