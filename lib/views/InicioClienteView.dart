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
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Food', 'clothing', 'Music'];
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
}
