import 'package:app/misc/wallet.dart';
import 'package:app/pages/SUlogin_page.dart';
import 'package:app/pages/signup_page.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/profile_page.dart';
import 'package:app/pages/edit_page.dart';
import 'package:app/pages/transaction_pages/main_page.dart';
import 'package:app/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/pages/edit_page.dart';

import 'utils/routes.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => WalletProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SU Wallet',
      initialRoute: count == 0 ? MyRoutes.welcomeRoute : MyRoutes.homeRoute,
      routes: {
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.welcomeRoute: (context) => const WelcomePage(),
        MyRoutes.suloginRoute: (context) => const suloginPage(),
        MyRoutes.profileRoute: (context) => ProfilePage(),
        MyRoutes.susignupRoute: (context) => const SignupPage(),
        MyRoutes.editRoute: (context) => const EditPage(),
      },
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
