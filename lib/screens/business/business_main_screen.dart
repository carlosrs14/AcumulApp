import 'dart:developer';

import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/screens/business/business_home_screen.dart';
import 'package:acumulapp/screens/business/customer_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:acumulapp/screens/business/manage_cards_screen.dart';
import 'package:acumulapp/screens/business/business_profile_screen.dart';

class BusinessMainScreen extends StatefulWidget {
  final Collaborator user;
  const BusinessMainScreen({super.key, required this.user});

  @override
  State<BusinessMainScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessMainScreen> {
  int _selectedIndex = 0;
  int selectedBusiness = 0;

  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Future<bool> _onWillPop() async {
    final currentNavigator = navigatorKeys[_selectedIndex].currentState!;
    if (currentNavigator.canPop()) {
      currentNavigator.pop();
      return false;
    }
    return true;
  }

  Widget _buildTab(int index) {
    return Navigator(
      key: navigatorKeys[index],
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        switch (index) {
          case 0:
            builder = (context) => BusinessHomeScreen(
              user: widget.user,
              indexSelected: selectedBusiness,
            );
            break;
          case 1:
            builder = (context) => SafeArea(
              child: CustomerManagementScreen(
                user: widget.user,
                indexSelected: selectedBusiness,
              ),
            );
            break;
          case 2:
            builder = (context) => SafeArea(
              child: ManageCardsScreen(
                user: widget.user,
                selectedIndex: selectedBusiness,
              ),
            );
            break;
          case 3:
            builder = (context) => SafeArea(
              child: BusinessProfileScreen(
                user: widget.user,
                selectedIndex: selectedBusiness,
              ),
            );
            break;
          default:
            builder = (context) =>
                const Center(child: Text('Bienvenido al Panel de Negocio'));
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    for (var negocio in widget.user.business) {
      log(negocio.id.toString());
      log(negocio.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _buildTab(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Clientes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Tarjetas',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
