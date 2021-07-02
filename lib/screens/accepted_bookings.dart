import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class AcceptedBookings extends StatefulWidget {
  @override
  _AcceptedBookingsState createState() => _AcceptedBookingsState();
}

class _AcceptedBookingsState extends State<AcceptedBookings> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String currentVenueUID;
  List _currentVenueAcceptedBookingsList = [];
  bool isNull = false;

  Widget buildRow({required String title, required String detail}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Expanded(
              child: Text(
                detail,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20)
      ],
    );
  }

  @override
  void didChangeDependencies() async {
    currentVenueUID = _auth.currentUser!.uid;
    try {
      DocumentSnapshot _currentVenueDoc =
          await _firestore.collection('venues').doc(currentVenueUID).get();

      _currentVenueAcceptedBookingsList = _currentVenueDoc['acceptedBookings'];
      // ignore: unnecessary_null_comparison
      if (_currentVenueAcceptedBookingsList == null ||
          _currentVenueAcceptedBookingsList.length == 0) {
        isNull = true;
      }
      setState(() {});
    } catch (e) {
      print(e.toString());
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isNull
        ? Center(
            child: Text(
              'No bookings accepted yet',
            ),
          )
        : FutureBuilder<QuerySnapshot>(
            future:
                _firestore.collection('bookings').orderBy('startDate').get(),
            builder: (context, asyncSnap) {
              if (asyncSnap.hasError) {
                return Center(
                  child: Text('Something went wrong!!\nPlease try again later'),
                );
              }
              if (asyncSnap.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }

              List<QueryDocumentSnapshot> _currentVenueBookings =
                  asyncSnap.data!.docs.where(
                (bookingID) {
                  return _currentVenueAcceptedBookingsList
                      .contains(bookingID.id);
                },
              ).toList();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemBuilder: (context, i) {
                    return Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRow(
                              title: 'Booker Name :   ',
                              detail: _currentVenueBookings[i]['booker'],
                            ),
                            buildRow(
                              title: 'Total peoples :    ',
                              detail: _currentVenueBookings[i]['peoples'],
                            ),
                            buildRow(
                              title: 'Start Date :          ',
                              detail: DateFormat.yMd().format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                  (_currentVenueBookings[i]['startDate']
                                          as Timestamp)
                                      .microsecondsSinceEpoch,
                                ),
                              ),
                            ),
                            buildRow(
                              title: 'End Date :            ',
                              detail: DateFormat.yMd().format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                  (_currentVenueBookings[i]['endDate']
                                          as Timestamp)
                                      .microsecondsSinceEpoch,
                                ),
                              ),
                            ),
                            buildRow(
                              title: 'Start Time :          ',
                              detail: _currentVenueBookings[i]['startTime'],
                            ),
                            buildRow(
                              title: 'End Time :            ',
                              detail: _currentVenueBookings[i]['endTime'],
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await FlutterPhoneDirectCaller.callNumber(
                                    _currentVenueBookings[i]['booker_contact']);
                              },
                              child: Text(
                                'Call',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF033249),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: _currentVenueBookings.length,
                ),
              );
            },
          );
  }
}
