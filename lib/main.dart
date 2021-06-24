import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner_buisness/screens/events_check_box.dart';
import 'package:event_planner_buisness/screens/extra_details_of_venue.dart';
import 'package:event_planner_buisness/screens/home_page.dart';
import 'package:event_planner_buisness/screens/login_screen.dart';
import 'package:event_planner_buisness/screens/venue_detail_screen.dart';
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
  final User _firebaseUser = FirebaseAuth.instance.currentUser;
  // ignore: unnecessary_null_comparison
  if (_firebaseUser != null) {
    bool _doesContain = false;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot _venuesCollection =
        await _firestore.collection('venues').get();
    List<QueryDocumentSnapshot> _venuesCollectionDOC = _venuesCollection.docs;

    for (int i = 0; i < _venuesCollectionDOC.length; i++) {
      if (_venuesCollectionDOC[i].id == _firebaseUser.uid) {
        _doesContain = true;
      }
    }
    runApp(MyApp(doesContain: _doesContain));
  } else
    runApp(MyApp(doesContain: null));
}

class MyApp extends StatelessWidget {
  bool? doesContain;
  MyApp({this.doesContain});
  Widget? _firstWidget;
  final User _firebaseUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    if (doesContain == null) {
      // ignore: unnecessary_null_comparison
      if (_firebaseUser == null)
        _firstWidget = LoginScreen();
      else
        _firstWidget = HomePage();
    } else {
      if (!doesContain!) {
        _firstWidget = EventsCheckBox();
      } else {
        _firstWidget = HomePage();
      }
    }
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
        EventsCheckBox.eventsCheckBox: (context) => EventsCheckBox(),
        VenueDetailForm.venueDetailFrom: (context) => VenueDetailForm(),
        ExtraVenueDetail.extraVenueDetail: (context) => ExtraVenueDetail(),
      },
    );
  }
}
