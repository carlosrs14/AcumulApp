import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/user_card_provider.dart';
import 'package:acumulapp/widgets/pagination.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomerManagementScreen extends StatefulWidget {
  final int indexSelected;
  final Collaborator user;
  const CustomerManagementScreen({
    super.key,
    required this.user,
    required this.indexSelected,
  });

  @override
  State<CustomerManagementScreen> createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final UserCardProvider userCardProvider = UserCardProvider();
  final TextEditingController stampTextEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String code = '';
  final TextEditingController _searchController = TextEditingController();
  Map<int, String> stateList = {
    1: "Activo",
    2: "Completado",
    3: "Redimido",
    4: "Inactivo",
    5: "Vencido",
  };
  List<UserCard> userCards = [];
  bool _isLoadingCardsActivate = true;
  bool _errorCardsActivate = false;
  int selectedState = 1;
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPage = 10;

  Future<void> _loadUserCards() async {
    setState(() {
      _isLoadingCardsActivate = true;
      _errorCardsActivate = false;
    });
    try {
      final paginationData = await userCardProvider.filterByBusiness(
        widget.user.business[widget.indexSelected].id,
        selectedState,
        itemsPerPage,
        currentPage,
      );

      setState(() {
        userCards = paginationData!.list as List<UserCard>;

        currentPage = paginationData.currentPage;
        itemsPerPage = paginationData.pageSize;
        totalPage = paginationData.totalPages;
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
    _loadUserCards();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Clientes')),
      body: _isLoadingCardsActivate
          ? Center(child: CircularProgressIndicator())
          : _errorCardsActivate
          ? Center(child: Text("Error"))
          : userCards.isEmpty
          ? noCards()
          : Container(child: cuerpo()),
    );
  }

  Widget cuerpo() {
    return SafeArea(
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [filtro()]),
          Expanded(child: list()),

          PaginacionWidget(
            currentPage: currentPage,
            itemsPerPage: itemsPerPage,
            totalItems: userCards.length,
            totalPages: totalPage,
            onPageChanged: (newPage) {
              setState(() {
                currentPage = newPage;
                _loadUserCards();
              });
            },
            onItemsPerPageChanged: (newCount) {
              setState(() {
                itemsPerPage = newCount;
                currentPage = 1;
                _loadUserCards();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget list() {
    return ListView.builder(
      itemCount: userCards.length,
      itemBuilder: (context, index) {
        final UserCard userCard = userCards[index];
        return swichtCard(userCard);
      },
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
              filtros(newValue);
            }
          },
        ),
      ),
    );
  }

  void filtros(int idState) async {
    setState(() {
      selectedState = idState;
      _loadUserCards();
    });
  }

  Widget swichtCard(UserCard userCard) {
    switch (selectedState) {
      case 1:
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userCard.code ?? ''),
                      const SizedBox(height: 4),
                      Text(
                        'Sellos: ${userCard.currentStamps}/${userCard.businessCard!.maxStamp}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(MdiIcons.stamper),
                  iconSize: 30,
                  onPressed: () {
                    code = userCard.code!;
                    addStampsDialog();
                    setState(() {
                      _loadUserCards();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      case 2:
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userCard.code ?? ''),
                      const SizedBox(height: 4),
                      Text(
                        'Sellos: ${userCard.currentStamps}/${userCard.businessCard!.maxStamp}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        'Restictions: ${userCard.businessCard!.restrictions}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(MdiIcons.check),
                  iconSize: 30,
                  onPressed: () {
                    code = userCard.code!;
                    redeemCard();
                    setState(() {
                      _loadUserCards();
                    });
                  },
                ),
              ],
            ),
          ),
        );

      case 3:
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userCard.code ?? ''),
                      const SizedBox(height: 4),
                      Text('nada', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case 4:
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userCard.code ?? ''),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(MdiIcons.check),
                  iconSize: 30,
                  onPressed: () {
                    code = userCard.code!;
                    activateCard();
                    setState(() {
                      _loadUserCards();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      case 5:
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userCard.code ?? ''),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(MdiIcons.alert),
                  iconSize: 30,
                  onPressed: null,
                ),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget buttom(IconData icon, void Function() function) {
    return IconButton(onPressed: function, icon: Icon(icon), iconSize: 30);
  }

  void addStampsDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add stamps'),
        content: Column(
          children: [
            const Text('¿Ingresa la cantidad de sellos que vas a añadir?'),
            Form(key: _formKey, child: textFieldStamp()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      addStamp();
    }
  }

  Widget textFieldStamp() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        controller: stampTextEditingController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  void addStamp() async {
    final success = await userCardProvider.addStamp(
      code,
      int.parse(stampTextEditingController.text),
    );
    if (success != null) {
      setState(() {
        _loadUserCards();
      });
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al agregar sellos')));
    }
  }

  void activateCard() async {
    await userCardProvider.activateCard(code);
  }

  void redeemCard() async {
    await userCardProvider.redeemCard(code);
  }
}
