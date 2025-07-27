import 'dart:developer';

import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/ubication.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/providers/category_provider.dart';
import 'package:acumulapp/screens/business/business_home_screen.dart';
import 'package:acumulapp/screens/category_selector_screen.dart';
import 'package:flutter/material.dart';

class UpdateInfoScreen extends StatefulWidget {
  final Collaborator user;
  const UpdateInfoScreen({super.key, required this.user});

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  CategoryProvider categoryProvider = CategoryProvider();
  BusinessProvider businessProvider = BusinessProvider();
  List<Category> _allCategories = [];
  List<Category> _selectedIds = [];
  bool _isLoadingCategories = true;
  bool _errorCategories = false;

  @override
  void initState() {
    _loadCategories();
    super.initState();
  }

  TextEditingController nameTextEditting = TextEditingController();
  TextEditingController logoTextEditting = TextEditingController();
  TextEditingController addressTextEditting = TextEditingController();

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _errorCategories = false;
    });
    try {
      final lista = await categoryProvider.all();

      setState(() {
        _allCategories = lista;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cuerpo());
  }

  Widget cuerpo() {
    return SafeArea(
      child: Column(
        children: [
          // Título fijo arriba
          Padding(padding: const EdgeInsets.all(16.0), child: titulo()),

          // Todo lo demás scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100),
                    name("Business name"),
                    textFile(nameTextEditting),
                    name("Logo"),
                    textFile(logoTextEditting),
                    name("Address"),
                    textFile(addressTextEditting),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _isLoadingCategories
                          ? const Center(child: CircularProgressIndicator())
                          : CategorySelector(
                              categories: _allCategories,
                              selectedIds: _selectedIds,
                              onChanged: (newSelected) {
                                setState(() {
                                  _selectedIds = newSelected;
                                });
                              },
                            ),
                    ),
                    SizedBox(height: 20),
                    botonEntrar(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget titulo() {
    return Text(
      "AcumulApp",
      style: TextStyle(
        color: Color(0xFF212121),
        fontSize: 35,
        fontFamily: 'sans-serif',
      ),
    );
  }

  Widget name(String name) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(name, style: TextStyle(fontSize: 15)),
    );
  }

  Widget textFile(TextEditingController textEditingController) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
    );
  }

  Widget botonEntrar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
        onPressed: () async {
          late Business businessRequest;
          Business? businessResponse;
          Ubication ubication = Ubication(2, "nose");
          Collaborator colab = widget.user;
          businessRequest = Business(
            colab.business[0].id,
            nameTextEditting.text,
            email: colab.email,
            ubication: ubication,
            logoUrl: logoTextEditting.text,
            direction: addressTextEditting.text,
            categories: _selectedIds,
          );

          businessResponse = await businessProvider.update(businessRequest);

          if (businessResponse != null) {
            bool state = await businessProvider.updateCategories(
              businessRequest,
            );
            if (state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Update sucefull',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => BusinessHomeScreen(user: widget.user),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 3),
                ),
              );
            }
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
        child: Text(
          "Update info",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
