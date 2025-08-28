import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/user_card_provider.dart';
import 'package:acumulapp/screens/user/client_cards/card_filter_dropdown.dart';
import 'package:acumulapp/screens/user/client_cards/client_cards_list.dart';
import 'package:acumulapp/widgets/pagination.dart';
import 'package:flutter/material.dart';

class ClientCardsScreen extends StatefulWidget {
  final User user;

  const ClientCardsScreen({super.key, required this.user});

  @override
  State<ClientCardsScreen> createState() => _ClientCardsScreenState();
}

class _ClientCardsScreenState extends State<ClientCardsScreen> {
  final UserCardProvider userCardProvider = UserCardProvider();
  List<UserCard> userCards = [];

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

  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _isError = false;
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
        _isError = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isError) {
      return const Center(child: Text("Error de conexión"));
    }

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 11, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CardFilterDropdown(
                  selectedState: selectedState,
                  stateList: stateList,
                  onChanged: (int? newValue) async {
                    if (newValue != null) {
                      currentPage = 1;
                      await _onFilterChanged(newValue);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: userCards.isEmpty
                ? const Center(child: Text("No hay tarjetas", style: TextStyle(fontSize: 17)))
                : ClientCardsList(
                    userCards: userCards,
                    user: widget.user,
                    selectedState: selectedState,
                  ),
          ),
          if (userCards.isNotEmpty)
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
    );
  }

  Future<void> _onFilterChanged(int idState) async {
    setState(() {
      selectedState = idState;
    });
    await _loadCards();
  }
}