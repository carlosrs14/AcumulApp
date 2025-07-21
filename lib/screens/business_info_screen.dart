import 'dart:ffi';

import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/business_datails_arguments.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/screens/home_screen.dart';
import 'package:acumulapp/screens/business_cards_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BusinessInfo extends StatefulWidget {
  final Business business;
  final User user;
  const BusinessInfo({super.key, required this.business, required this.user});

  @override
  State<BusinessInfo> createState() => _BusinessInfoState();
}

class _BusinessInfoState extends State<BusinessInfo> {
  late double screenWidth;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(12),
          child: cuerpo(),
        ),
      ),
    );
  }

  Widget cuerpo() {
    return SafeArea(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: const Color.fromARGB(255, 72, 25, 58),
            width: 3,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          imagen_negocio(),
                          SizedBox(height: 30),
                          name(),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Categorias:",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: categories(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: ratingbar(),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(widget.business.direction),
                        ],
                      ),

                      SizedBox(height: 20),
                      buttom(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget imagen_negocio() {
    return Container(
      width: 120,
      height: 120,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(70),
      ),
      child: Center(
        child: ClipOval(
          child: Image.network(
            widget.business.logoUrl,
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
                widget.business.name[0],
                style: TextStyle(fontSize: 40),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget name() {
    return Text(
      widget.business.name,
      style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
    );
  }

  Widget ratingbar() {
    return Container(
      child: RatingBarIndicator(
        rating: widget.business.rating,
        itemBuilder: (context, index) =>
            Icon(MdiIcons.star, color: Colors.amber),
        itemCount: 5,
        itemSize: screenWidth * 0.065,
        direction: Axis.horizontal,
      ),
    );
  }

  Widget buttom() {
    return Container(
      width: screenWidth * 0.6,
      height: 55,
      padding: EdgeInsets.all(1),

      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BusinessCardsScreen(
                  business: widget.business,
                  user: widget.user,
                ),
              ),
            );
          },
          icon: Icon(MdiIcons.cardsOutline, size: 20),
          iconAlignment: IconAlignment.end,
          label: Text("View cards"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: TextStyle(fontSize: 14),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  Widget categories() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: widget.business.categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(category.name, style: TextStyle(fontSize: 16)),
          );
        }).toList(),
      ),
    );
  }
}
