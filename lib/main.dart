import 'package:event_planner_buisness/screens/home_page.dart';
import 'package:event_planner_buisness/screens/login_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late Widget _firstWidget;
  final User _firebaseUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (_firebaseUser == null)
      _firstWidget = LoginScreen();
    else
      _firstWidget = HomePage();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Color(0xFFFF8038),
        primaryColor: Color(0xFF033249),
        fontFamily: 'Montserrat',
      ),
      home: _firstWidget,
      routes: {
        LoginScreen.loginScreen: (context) => LoginScreen(),
        HomePage.homePage: (context) => HomePage(),
      },
    );
  }
}
