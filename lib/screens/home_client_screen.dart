import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/providers/category_provider.dart';
import 'package:acumulapp/screens/app_bar_client.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:acumulapp/models/business.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Inicioclienteview extends StatefulWidget {
  final User user;
  const Inicioclienteview({super.key, required this.user});

  @override
  State<Inicioclienteview> createState() => _InicioclienteviewState();
}

class _InicioclienteviewState extends State<Inicioclienteview> {
  final BusinessProvider businessService = BusinessProvider();
  final CategoryProvider categoryService = CategoryProvider();

  List<Business> business = [];
  List<Business> filteredBusiness = [];
  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = 'All';
  bool _isLoadingCategories = true;
  String? _errorCategories;
  bool _isLoadingBusiness = true;
  String? _errorBusiness;

  List<Category> categoryList = [];

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _errorCategories = null;
    });
    try {
      final lista = await categoryService.all();
      setState(() {
        categoryList = lista;
      });
    } catch (e) {
      setState(() {
        _errorCategories = 'Error al cargar categorías';
      });
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _loadBusiness() async {
    setState(() {
      _isLoadingBusiness = true;
      _errorBusiness = null;
    });
    try {
      final lista = await businessService.all();
      setState(() {
        business = lista;
        filteredBusiness = business;
      });
    } catch (e) {
      setState(() {
        _errorBusiness = 'Error al cargar negocios';
      });
    } finally {
      setState(() {
        _isLoadingBusiness = false;
      });
    }
  }

  @override
  void initState() {
    _loadCategories();
    _loadBusiness();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarClient(
        currentScreen: "InicioClientView",
        user: widget.user,
      ),
      body: Container(child: home()),
    );
  }

  Widget home() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 20),
            search(),
            SizedBox(width: 10),
            filtro(),
          ],
        ),
        Expanded(child: listaBusiness()),
      ],
    );
  }

  Widget filtro() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          icon: Icon(Icons.arrow_drop_down),
          items: categoryList.map((Category value) {
            return DropdownMenuItem<String>(
              value: value.name,
              child: Text(value.name),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            if (newValue != null) {
              List<Business> negociosFiltrados = await businessService
                  .filterByCategoryName(newValue);
              setState(() {
                selectedCategory = newValue;
                filteredBusiness = negociosFiltrados;
              });
            }
          },
        ),
      ),
    );
  }

  Widget search() {
    return SizedBox(
      width: 220,
      height: 40,

      child: TextField(
        onChanged: (value) {
          setState(() {
            filteredBusiness = business.where((negocio) {
              return negocio.name.toLowerCase().contains(value.toLowerCase());
            }).toList();
          });
        },
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0),

          prefixIcon: Icon(Icons.search),

          hintText: "Search",
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget listaBusiness() {
    return ListView.builder(
      itemCount: filteredBusiness.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black),
          ),
          child: ListTile(
            onTap: () {
              //ir a detalles de negocio
            },
            title: Text(filteredBusiness[index].name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                //Text(filteredBusiness[index].ubication!.name),
                RatingBarIndicator(
                  rating: filteredBusiness[index].rating,
                  itemBuilder: (context, index) =>
                      Icon(MdiIcons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 25.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            leading: Container(
              width: 55,
              height: 55,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(35),
              ),

              child: Center(
                child: ClipOval(
                  child: Image.network(
                    filteredBusiness[index].logoUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        filteredBusiness[index].name[0],
                        style: TextStyle(fontSize: 20),
                      );
                    },
                  ),
                ),
              ),
            ),
            trailing: Container(
              width: 159,
              height: 55,
              padding: EdgeInsets.all(1),

              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  onPressed: () {
                    // ir a tarjertas de negocio
                  },
                  child: Row(
                    children: [
                      Text("Ver tarjetas"),
                      SizedBox(width: 10),
                      Icon(MdiIcons.cardsOutline),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
