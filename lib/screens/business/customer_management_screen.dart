import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/user_card_provider.dart';
import 'package:acumulapp/screens/business/customer_management/add_stamp_dialog.dart';
import 'package:acumulapp/screens/business/customer_management/customer_cards_list.dart';
import 'package:acumulapp/screens/business/customer_management/filter_dropdown.dart';
import 'package:acumulapp/widgets/pagination.dart';
import 'package:flutter/material.dart';

class CustomerManagementScreen extends StatefulWidget {
  final int indexSelected;
  final Collaborator user;

  const CustomerManagementScreen({
    super.key,
    required this.user,
    required this.indexSelected,
  });

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final UserCardProvider userCardProvider = UserCardProvider();

  Map<int, String> stateList = {
    1: "Activo",
    2: "Completado",
    3: "Redimido",
    4: "Inactivo",
    5: "Vencido",
  };

  List<UserCard> userCards = [];
  bool _isLoading = true;
  bool _isError = false;
  int selectedState = 1;
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPage = 10;

  @override
  void initState() {
    super.initState();
    _loadUserCards();
  }

  Future<void> _loadUserCards() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      final paginationData = await userCardProvider.filterByBusiness(
        widget.user.business[widget.indexSelected].id,
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
      appBar: AppBar(title: const Text('Gestión de Clientes')),
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 11, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilterDropdown(
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
              : CustomerCardsList(
                  userCards: userCards,
                  selectedState: selectedState,
                  onAddStamps: _showAddStampsDialog,
                  onRedeem: _redeemCard,
                  onActivate: _activateCard,
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
              await _loadUserCards();
            },
            onItemsPerPageChanged: (newCount) async {
              setState(() {
                itemsPerPage = newCount;
                currentPage = 1;
              });
              await _loadUserCards();
            },
          ),
      ],
    );
  }

  Future<void> _onFilterChanged(int idState) async {
    setState(() {
      selectedState = idState;
    });
    await _loadUserCards();
  }

  void _showAddStampsDialog(String code, int remainingStamps) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AddStampDialog(
        remainingStamps: remainingStamps,
        onAdd: (stamps) async {
          await _addStamp(code, stamps);
        },
      ),
    );

    if (confirmed == true) {
      await _loadUserCards();
    }
  }

  Future<void> _addStamp(String code, int stamps) async {
    final success = await userCardProvider.addStamp(code, stamps);
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (success != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sellos agregados exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar sellos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _activateCard(String code) async {
    final success = await userCardProvider.activateCard(code);
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (success != null) {
      await _loadUserCards();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarjeta activada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al activar tarjeta'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _redeemCard(String code) async {
    final success = await userCardProvider.redeemCard(code);
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (success != null) {
      await _loadUserCards();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarjeta redimida exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al redimir tarjeta'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

