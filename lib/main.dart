import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_web/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
        apiKey: "AIzaSyCUALfVbR9qxPfC4wk1ch_jRqdl8NWNRbg",
        authDomain: "cikitsa-international.firebaseapp.com",
        databaseURL: "https://cikitsa-international-default-rtdb.firebaseio.com",
        projectId: "cikitsa-international",
        storageBucket: "cikitsa-international.appspot.com",
        messagingSenderId: "199672298066",
        appId: "1:199672298066:web:d771f60baf8572cd9abd8b",
        measurementId: "G-NHSXVED5FY"
    ),
  );


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cikitsa International',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const LoginScreen(),
      // home: LoginScreenWeb(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      // navigatorKey: NavigationService.navigatorKey,
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior{
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };

}