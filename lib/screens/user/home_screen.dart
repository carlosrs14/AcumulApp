import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/screens/user/client_cards_screen.dart';
import 'package:acumulapp/screens/user/ejemplo.dart';
import 'package:acumulapp/screens/user/home_client_screen.dart';
import 'package:acumulapp/screens/user/user_profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
            builder = (context) => Inicioclienteview(user: widget.user);
            break;
          case 1:
            builder = (context) => ClientCardsScreen(user: widget.user);
            break;
          case 2:
            builder = (context) => Ejemplo(user: widget.user);
            break;
          case 3:
            builder = (context) => UserProfileScreen(user: widget.user);
            break;
          default:
            builder = (context) => Inicioclienteview(user: widget.user);
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
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
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'notifications',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
          ],
        ),
      ),
    );
  }
}
