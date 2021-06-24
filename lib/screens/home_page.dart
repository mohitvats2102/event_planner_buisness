import 'package:event_planner_buisness/screens/tabs_screen.dart';
import 'package:event_planner_buisness/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:helping_hands_buisness/screens/tabs_screen.dart';
// import 'package:helping_hands_buisness/widget/main_drawer.dart';

import 'login_screen.dart';

class HomePage extends StatelessWidget {
  static const String homePage = '/home_page';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _venueProviderName;
  late String _venueName;
  late String _totalBookings;
  late String _acceptLen;
  late String _rejectLen;

  void logout(BuildContext context) async {
    if (_auth.currentUser!.providerData != null) {
      if (_auth.currentUser!.providerData[0].providerId == 'google.com') {
        await GoogleSignIn().disconnect();
      }
    }
    _auth.signOut();
    Navigator.of(context).pushReplacementNamed(LoginScreen.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        logoutFun: logout,
        ctx: context,
      ),
      appBar: AppBar(
        title: Text(
          'Helping Hands',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('venues').snapshots(),
        builder: (context, asyncSnap) {
          if (asyncSnap.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (asyncSnap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF033249),
              ),
            );
          }
          List<QueryDocumentSnapshot> _allVenuesList = asyncSnap.data!.docs;
          late QueryDocumentSnapshot _currentVenueDoc;
          for (int i = 0; i < _allVenuesList.length; i++) {
            if (_allVenuesList[i].id == _auth.currentUser!.uid)
              _currentVenueDoc = _allVenuesList[i];
          }

          _venueProviderName =
              (_currentVenueDoc.data()! as Map)['providerName'];
          _venueName = (_currentVenueDoc.data()! as Map)['name'].toUpperCase();
          if ((_currentVenueDoc.data()! as Map)['totalBookings'] == null)
            _totalBookings = '0';
          else
            _totalBookings =
                (_currentVenueDoc.data()! as Map)['totalBookings'].toString();

          if ((_currentVenueDoc.data()! as Map)['acceptedBookings'] == null)
            _acceptLen = '0';
          else
            _acceptLen = (_currentVenueDoc.data()! as Map)['acceptedBookings']
                .length
                .toString();

          if ((_currentVenueDoc.data()! as Map)['rejectedBookings'] == null)
            _rejectLen = '0';
          else
            _rejectLen = (_currentVenueDoc.data()! as Map)['rejectedBookings']
                .length
                .toString();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  color: Color(0xFF033249),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _venueProviderName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFFFF8038),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _venueName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFFFF8038),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Bookings : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFFF8038),
                              ),
                            ),
                            Text(
                              _totalBookings,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFFF8038),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'Accepted',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                _acceptLen,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'Rejected',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                _rejectLen,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF033249),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(TabsScreen.tabScreen);
                  },
                  child: Text(
                    'Check new bookings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF8038),
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}
