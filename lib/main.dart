import 'dart:async';
import 'dart:developer';

import 'package:acumulapp/models/business_datails_arguments.dart';
import 'package:acumulapp/models/client.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/user_provider.dart';
import 'package:acumulapp/screens/business/business_main_screen.dart';
import 'package:acumulapp/screens/business/update_info_screen.dart';
import 'package:acumulapp/screens/user/business_cards_screen.dart';
import 'package:acumulapp/screens/user/business_info_screen.dart';
import 'package:acumulapp/screens/user/home_screen.dart';
import 'package:acumulapp/screens/login_screen.dart';
import 'package:acumulapp/screens/register_screen.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:acumulapp/screens/theme_provider.dart';

const String clerkPublishableKey = 'pk_test_ZW5qb3llZC1ncnViLTM2LmNsZXJrLmFjY291bnRzLmRldiQ';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await initLocalStorage();
      await Firebase.initializeApp();
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      UserProvider userProvider = UserProvider();
      await userProvider.init();

      final user = await userProvider.getLoggedUser();
      final savedColor = await ThemeProvider.getSavedColor();
      runApp(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(savedColor),
          child: MyApp(isLogged: user != null, user: user),
        ),
      );
    },
    (error, stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  final User? user;
  const MyApp({super.key, required this.isLogged, required this.user});

  @override
  Widget build(BuildContext context) {
    log(user.toString());
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ClerkAuth(
      config: ClerkAuthConfig(publishableKey: clerkPublishableKey),
      child: MaterialApp(
        theme: themeProvider.lightTheme,
        darkTheme: themeProvider.darkTheme,
        themeMode: ThemeMode.system,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },

        home: user != null
            ? (user!.userType == "collaborator"
                  ? BusinessMainScreen(user: user as Collaborator)
                  : HomeScreen(user: user as Client))
            : InicioLogin(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              final args = settings.arguments;

              if (args == null || args is! User) {
                return MaterialPageRoute(builder: (_) => InicioLogin());
              }

              final user = args;
              log(user.userType.toString());
              if (user.userType == 'collaborator') {
                user as Collaborator;
                var indice = user.roles.indexWhere(
                  (roles) => "owner" == roles.toLowerCase(),
                );
                if (-1 != indice && "N/A" == user.business[indice].name) {
                  return MaterialPageRoute(
                    builder: (_) => UpdateInfoScreen(user: user),
                  );
                } else {
                  return MaterialPageRoute(
                    builder: (_) => BusinessMainScreen(user: user),
                  );
                }
              }

              return MaterialPageRoute(
                builder: (_) => HomeScreen(user: user as Client),
              );

            case '/register':
              return MaterialPageRoute(builder: (_) => RegisterScreen());

            case '/login':
              return MaterialPageRoute(builder: (_) => InicioLogin());
              
            case '/business_details':
              final args = settings.arguments;
              final businessDetails = args as BusinessDetailsArguments;
              return MaterialPageRoute(
                builder: (_) => BusinessInfo(
                  business: businessDetails.business,
                  user: businessDetails.user,
                ),
              );
            case '/business_cards':
              final args = settings.arguments;
              final businessDetails = args as BusinessDetailsArguments;
              return MaterialPageRoute(
                builder: (_) => BusinessCardsScreen(
                  business: businessDetails.business,
                  user: businessDetails.user,
                ),
              );
            default:
              return MaterialPageRoute(
                builder: (_) =>
                    Scaffold(body: Center(child: Text('Ruta no encontrada'))),
              );
          }
        },
      )
    );
  }
}
