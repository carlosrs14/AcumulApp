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
    if (!mounted) return;
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
          ? Center(child: Text("Error de conexion"))
          : userCards.isEmpty
          ? noCards()
          : Container(child: cuerpo()),
    );
  }

  Widget cuerpo() {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(padding: const EdgeInsets.only(top: 11), child: filtro()),
            ],
          ),
          Expanded(child: list()),

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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
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

    await _loadUserCards();
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
                ElevatedButton.icon(
                  icon: Icon(MdiIcons.stamper),
                  label: Text("Add"),
                  iconAlignment: IconAlignment.end,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () async {
                    code = userCard.code!;
                    await addStampsDialog(
                      userCard.code!,
                      userCard.businessCard!.maxStamp - userCard.currentStamps!,
                    );
                    await _loadUserCards();
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
                ElevatedButton.icon(
                  icon: Icon(MdiIcons.check),
                  label: Text("Redimir"),
                  iconAlignment: IconAlignment.end,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () async {
                    await redeemCard(userCard.code!);
                    await _loadUserCards();
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
                      Text(userCard.businessCard!.name),
                      const SizedBox(height: 4),
                      Text(
                        "Esta tarjeta a sido redimida",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
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
                ElevatedButton.icon(
                  icon: Icon(MdiIcons.check),
                  label: Text("Activar"),
                  iconAlignment: IconAlignment.end,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () async {
                    await activateCard(userCard.code!);
                    await _loadUserCards();
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
                ElevatedButton(child: Icon(MdiIcons.alert), onPressed: null),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Future<void> addStampsDialog(String code, int remainingStamps) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add stamps'),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sellos restantes $remainingStamps, ingresa la cantidad de sellos que vas a añadir',
              ),
              const SizedBox(height: 10),
              Form(key: _formKey, child: textFieldStamp(remainingStamps)),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await addStamp(code, remainingStamps);
    }
  }

  Widget textFieldStamp(int remainingStamps) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        controller: stampTextEditingController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          errorMaxLines: 2,
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }
          final parsed = int.tryParse(value);
          if (parsed == null) {
            return 'Debe ser un número válido';
          } else if (parsed > remainingStamps) {
            return 'Debe ser menor o igual a los sellos restantes';
          }
          return null;
        },
      ),
    );
  }

  Future<void> addStamp(String code, int remainingStamps) async {
    final success = await userCardProvider.addStamp(
      code,
      int.parse(stampTextEditingController.text),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (success != null) {
      await _loadUserCards();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sellos agregados exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar sellos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> activateCard(String code) async {
    final success = await userCardProvider.activateCard(code);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (success != null) {
      await _loadUserCards();
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

  Future<void> redeemCard(String code) async {
    final success = await userCardProvider.redeemCard(code);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (success != null) {
      await _loadUserCards();
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
