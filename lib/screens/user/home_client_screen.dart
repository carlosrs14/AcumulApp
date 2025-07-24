import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/providers/category_provider.dart';
import 'package:acumulapp/screens/user/business_cards_screen.dart';
import 'package:acumulapp/screens/user/business_info_screen.dart';
import 'package:acumulapp/widgets/pagination.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:acumulapp/models/business.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:async';

class Inicioclienteview extends StatefulWidget {
  final User user;
  const Inicioclienteview({super.key, required this.user});

  @override
  State<Inicioclienteview> createState() => _InicioclienteviewState();
}

class _InicioclienteviewState extends State<Inicioclienteview> {
  final BusinessProvider businessProvider = BusinessProvider();
  final CategoryProvider categoryProvider = CategoryProvider();
  late double screenWidth;
  Timer? _debounce;
  List<Business> business = [];
  List<Business> filteredBusiness = [];
  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = 'All';
  bool _isLoadingCategories = true;
  bool _errorCategories = false;
  bool _isLoadingBusiness = true;
  bool _errorBusiness = false;

  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPage = 10;

  List<Category> categoryList = [];

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _errorCategories = false;
    });
    try {
      final lista = await categoryProvider.all();
      lista.insert(0, Category(-1, "All", "All"));
      setState(() {
        categoryList = lista;
      });
    } catch (e) {
      setState(() {
        _errorCategories = true;
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
      _errorBusiness = false;
    });
    try {
      final lista = await businessProvider.all();
      setState(() {
        business = lista;
        filteredBusiness = business;
      });
    } catch (e) {
      setState(() {
        _errorBusiness = true;
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
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: _isLoadingBusiness || _isLoadingCategories
            ? Center(child: CircularProgressIndicator())
            : _errorBusiness || _errorCategories
            ? Center(child: Text("Error"))
            : Container(padding: EdgeInsets.all(8), child: home()),
      ),
    );
  }

  Widget home() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 10),
            search(),
            SizedBox(width: 10),
            filtro(),
          ],
        ),
        SizedBox(height: 10),
        Expanded(child: listaBusiness()),
        PaginacionWidget(
          currentPage: currentPage,
          itemsPerPage: itemsPerPage,
          totalItems: filteredBusiness.length,
          totalPages: totalPage,
          onPageChanged: (newPage) {
            setState(() {
              currentPage = newPage;
              _loadBusiness();
            });
          },
          onItemsPerPageChanged: (newCount) {
            setState(() {
              itemsPerPage = newCount;
              currentPage = 1;
              _loadBusiness();
            });
          },
        ),
      ],
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
              filtros(_searchController.text, newValue);
            }
          },
        ),
      ),
    );
  }

  Widget search() {
    return SizedBox(
      width: screenWidth * 0.3,
      height: 40,
      child: TextField(
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 1000), () async {
            filtros(value, selectedCategory);
          });
        },
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          prefixIcon: Icon(Icons.search),
          hintText: "Search",
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black26),
          ),
        ),
      ),
    );
  }

  void filtros(String query, String categoria) async {
    if (categoria == "All" && query.trim().isEmpty) {
      setState(() {
        selectedCategory = "All";
        filteredBusiness = business;
      });
      return;
    }
    List<Business> negociosFiltrados;
    cargatrue();
    if (categoria == "All") {
      negociosFiltrados = await businessProvider.filterByName(query);
    } else {
      negociosFiltrados = await businessProvider.filterByNameAndCategory(
        query,
        categoria,
      );
    }
    setState(() {
      selectedCategory = categoria;
      filteredBusiness = negociosFiltrados;
    });
    cargafalse();
  }

  Widget listaBusiness() {
    return ListView.builder(
      itemCount: filteredBusiness.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black12),
          ),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BusinessInfo(
                    business: filteredBusiness[index],
                    user: widget.user,
                  ),
                ),
              );
            },
            title: Text(
              filteredBusiness[index].name,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(filteredBusiness[index].direction!),
                SizedBox(height: 4),
                RatingBarIndicator(
                  rating: 3.5,
                  itemBuilder: (context, index) =>
                      Icon(MdiIcons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            leading: Container(
              width: 55,
              height: 55,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 1),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Center(
                child: ClipOval(
                  child: Image.network(
                    filteredBusiness[index].logoUrl!,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
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
              width: screenWidth * 0.2,
              height: 50,

              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BusinessCardsScreen(
                          business: filteredBusiness[index],
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  icon: Icon(MdiIcons.cardsOutline, size: 20),
                  iconAlignment: IconAlignment.end,
                  label: Text(""),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: TextStyle(fontSize: 14),
                    elevation: 4,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void cargatrue() {
    setState(() {
      _isLoadingCategories = true;
    });
  }

  void cargafalse() {
    setState(() {
      _isLoadingCategories = false;
    });
  }
}
