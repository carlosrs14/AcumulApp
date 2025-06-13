import 'dart:ffi';
import 'package:acumulapp/models/CategoryModel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:acumulapp/models/BusinessModel.dart';
import 'package:acumulapp/models/LinkModel.dart';
import 'package:acumulapp/models/UbicationModel.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Inicioclienteview extends StatefulWidget {
  const Inicioclienteview({super.key});

  @override
  State<Inicioclienteview> createState() => _InicioclienteviewState();
}

class _InicioclienteviewState extends State<Inicioclienteview> {
  late Widget cuerpo;
  @override
  void initState() {
    cuerpo = home();
    filteredBusiness = business;
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';

  final List<String> categories = ['All', 'Food', 'clothing', 'Music'];
  List<BusinessModel> business = [
    BusinessModel(
      1,
      "tienda empres",
      "Av. Central #123",
      "https://static.vecteezy.com/system/resources/previews/020/662/330/non_2x/store-icon-logo-illustration-vector.jpg",
      [
        LinkModel(1, "https://instagram.com/tienda", "Instagram"),
        LinkModel(2, "https://facebook.com/tienda", "Facebook"),
      ],
      UbicationModel(1, "Santa marta"),
      [CategoryModel(2, "clothing", "_description")],
      3.5,
    ),

    BusinessModel(
      2,
      "El chorro",
      "Calle 45 Sur #8-22",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAw_UHRzFcfVBrK2mANMr6c9SY_y8CKxAxIw&s",
      [
        LinkModel(3, "https://instagram.com/tienda", "Instagram"),
        LinkModel(4, "https://facebook.com/tienda", "Facebook"),
      ],
      UbicationModel(1, "Santa marta"),
      [CategoryModel(1, "Food", "_description")],
      4.5,
    ),
  ];
  List<BusinessModel> filteredBusiness = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    cuerpo = home();
                  });
                },
                icon: Icon(MdiIcons.home),
                iconSize: 33,
              ),
              SizedBox(width: 30),
              IconButton(
                onPressed: () {
                  setState(() {
                    cuerpo = Text("cards");
                  });
                },
                icon: Icon(MdiIcons.cards),
                iconSize: 33,
              ),
              SizedBox(width: 30),
              IconButton(
                onPressed: () {
                  setState(() {
                    cuerpo = Text("Notificaciones");
                  });
                },
                icon: Icon(MdiIcons.bell),
                iconSize: 33,
              ),
              SizedBox(width: 30),

              IconButton(
                onPressed: () {
                  setState(() {
                    cuerpo = Text("Pefil");
                  });
                },
                icon: Icon(MdiIcons.accountCircle),
                iconSize: 33,
              ),
              SizedBox(width: 90),
            ],
          ),
        ],
      ),
      body: Container(child: cuerpo),
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
            SizedBox(width: 20),
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
          items: categories.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedCategory = newValue;
                cuerpo = home();
              });
            }
          },
        ),
      ),
    );
  }

  Widget search() {
    return Container(
      width: 300,
      height: 40,

      child: TextField(
        onChanged: (value) {
          setState(() {
            filteredBusiness = business.where((negocio) {
              return negocio.name.toLowerCase().contains(value.toLowerCase());
            }).toList();
            cuerpo = home();
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
                Text(filteredBusiness[index].ubication!.name),
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
            leading: ClipOval(
              child: Image.network(filteredBusiness[index].logoUrl),
            ),
            trailing: Container(
              width: 55,
              height: 55,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(MdiIcons.cardsOutline),
                  onPressed: () {
                    //ir a tarjetas del negocio
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
