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
import 'package:acumulapp/widgets/stamp_container.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: filtro(),
                ),
              ],
            ),
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
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
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
                      userCard: card,
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(height: 10),
                        StampContainer(
                          stamps: stampsGenenator(
                            card.currentStamps!,
                            card.businessCard!.maxStamp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: qrState(card, selectedState),
                        ),
                      ),
                      SizedBox(height: 30),
                      Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(7),

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Meta: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  Text(
                                    "${card.businessCard!.maxStamp}",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    MdiIcons.starCircle,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Actual: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  Text(
                                    "${card.currentStamps}",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),

                                  SizedBox(width: 4),
                                  Icon(
                                    MdiIcons.starCircle,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Faltan: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  Text(
                                    "${card.businessCard!.maxStamp - card.currentStamps!}",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    MdiIcons.starCircleOutline,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ],
                              ),
                            ],
                          ),
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

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget? qrState(UserCard userCard, int selectedState) {
    switch (selectedState) {
      case 1:
        return addCardButton(
          userCard,
          true,
          "Presenta este QR en el negocio para recibir tus sellos.",
          "Añadir\nSellos",
        );
      case 2:
        return addCardButton(
          userCard,
          true,
          "Presenta este QR en el negocio para recibir tu recompensa.",
          "Redimir",
        );
      case 3:
        return addCardButton(userCard, false, "", "");
      case 4:
        return addCardButton(
          userCard,
          true,
          "Presenta este QR al negocio para que te activen tu tarjeta",
          "Activar",
        );
      case 5:
        return addCardButton(userCard, false, "", "");
      default:
        return Text('');
    }
  }

  ElevatedButton? addCardButton(
    UserCard userCard,
    bool mostrar,
    String texto,
    String labelBoton,
  ) {
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

            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textStyle: TextStyle(fontSize: 14),
              elevation: 4,
            ),
            icon: Icon(MdiIcons.qrcode),
            iconAlignment: IconAlignment.end,
            label: Text(
              labelBoton,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget filtro() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
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
              child: Text(
                entry.value,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            );
          }).toList(),
          onChanged: (int? newValue) async {
            if (newValue != null) {
              currentPage = 1;
              await filtros(newValue);
            }
          },
          iconEnabledColor: Theme.of(context).colorScheme.primary,
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

  List<bool> stampsGenenator(int current, int max) {
    List<bool> result = [];
    for (int i = 0; i < current; i++) {
      result.add(true);
    }
    for (int i = 0; i < max - current; i++) {
      result.add(false);
    }
    return result;
  }
}
