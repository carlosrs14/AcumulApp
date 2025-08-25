import 'dart:developer';

import 'package:acumulapp/models/business_stat.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BusinessHomeScreen extends StatefulWidget {
  final int indexSelected;
  final Collaborator user;
  const BusinessHomeScreen({
    super.key,
    required this.user,
    required this.indexSelected,
  });

  @override
  State<BusinessHomeScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  final BusinessProvider businessProvider = BusinessProvider();
  BusinessStat? businessStat;
  bool _isLoadingBusinessStats = false;
  bool _errorBusinessStats = false;

  Future<void> _loadUserCards() async {
    if (!mounted) return;
    setState(() {
      _isLoadingBusinessStats = true;
      _errorBusinessStats = false;
    });
    try {
      final businessStats = await businessProvider.getBusinessStats(
        widget.user.business[widget.indexSelected].id,
      );
      if (!mounted) return;
      setState(() {
        businessStat = businessStats;
        log(businessStats!.cardStats.toString());
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorBusinessStats = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBusinessStats = false;
        });
      }
    }
  }

  @override
  void initState() {
    _loadUserCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingBusinessStats
          ? Center(child: CircularProgressIndicator())
          : _errorBusinessStats
          ? Center(child: Text("Error"))
          : SafeArea(child: cuerpo()),
    );
  }

  Widget cuerpo() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.user.business[widget.indexSelected].name,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.3),
            child: Row(
              children: [
                Text("Total stamps:", style: TextStyle(fontSize: 20)),
                SizedBox(width: 10),
                Text(
                  businessStat?.totalStamps.toString() ?? "0",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.3),
            child: Row(
              children: [
                Text("Total cards:", style: TextStyle(fontSize: 20)),
                SizedBox(width: 10),
                Text(
                  businessStat?.totalCards.toString() ?? "0",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                  sections: _getSections(),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.3),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Text("Vencido", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.3),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Text("Activa", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.3),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Text("Inactiva", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.3),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Text("Redimida", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.3),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Text("Completa", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    if (businessStat == null) return [];
    Map<String, MaterialColor> map = {
      "vencida": Colors.red,
      "Activa": Colors.blue,
      "Inactiva": Colors.yellow,
      "Canjeada": Colors.purple,
      "Completada": Colors.green,
    };
    List<PieChartSectionData> lista = [];

    for (CardStat element in businessStat!.cardStats) {
      lista.add(
        PieChartSectionData(
          color: map[element.state],
          value: element.total.toDouble(),
          title: '${element.total}',
          radius: 80,
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    return lista;
  }
}
