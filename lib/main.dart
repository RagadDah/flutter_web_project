import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/gestures.dart";
import 'package:flutter/material.dart';
import 'package:flutter_web_project/Pages/auth_screen.dart';
import 'package:flutter_web_project/Pages/login.dart';
import 'package:flutter_web_project/Pages/manager_home_screen.dart';
import 'package:flutter_web_project/Pages/signup.dart';
import 'package:flutter_web_project/Providers/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_project/Utils/util.dart';

import 'package:provider/provider.dart';
import "package:flutter_web_project/Pages/home_screen.dart";

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyB-6vJXKq7vkH95r1p0onlzq6pbOWW9vL0",
          appId: "1:1089410454702:web:0a660d74461821b1d5c93f",
          messagingSenderId: "1089410454702",
          projectId: "hotel-booking-b3367"));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Controller(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Util.messangerKey,
      routes: {
        '/': (context) => MyHomePage(),
        'HomePage': (context) => HomeScreen(),
        'Manager': (context) => ManagerScreen(),
        'LogIn': (context) => LogIn()
      },
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Controller>(
        builder: (context, controller, child) {
          return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return controller.user.isManager!
                      ? ManagerScreen()
                      : HomeScreen();
                }
                return AuthPage();

                // return ManagerScreen();
              });
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
