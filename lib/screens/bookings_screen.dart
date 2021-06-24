import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class BookingsScreen extends StatefulWidget {
  static const String bookingsScreen = '/bookings_screen';

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _currentVenueUID;
  List _currentVenueBookingsList = [];
  bool isStartAcceptingOrRejecting = false;
  bool isStartRejecting = false;
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
    print('INSIDE DIDCHANGEDEPENDENCIES');
    _currentVenueUID = _auth.currentUser!.uid;
    try {
      DocumentSnapshot _currentVenueDoc =
          await _firestore.collection('venues').doc(_currentVenueUID).get();

      _currentVenueBookingsList = _currentVenueDoc['bookings'];
      // ignore: unnecessary_null_comparison
      if (_currentVenueBookingsList == null ||
          _currentVenueBookingsList.length == 0) {
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
              'No new bookings',
            ),
          )
        : ModalProgressHUD(
            inAsyncCall: isStartAcceptingOrRejecting,
            child: FutureBuilder<QuerySnapshot>(
              future:
                  _firestore.collection('bookings').orderBy('startDate').get(),
              builder: (context, asyncSnap) {
                if (asyncSnap.hasError) {
                  return Center(
                    child:
                        Text('Something went wrong!!\nPlease try again later'),
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
                    return _currentVenueBookingsList.contains(bookingID.id);
                  },
                ).toList();

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemBuilder: (context, i) {
                      print('HELLOOOOLLO ' +
                          '${DateTime.fromMicrosecondsSinceEpoch(
                            (_currentVenueBookings[i]['startDate']
                                    as Timestamp)
                                .microsecondsSinceEpoch,
                          )}');
                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildRow(
                                title: 'Booker Name :   ',
                                detail:
                                    _currentVenueBookings[i]['booker'],
                              ),
                              buildRow(
                                title: 'Total peoples :    ',
                                detail:
                                    _currentVenueBookings[i]['peoples'],
                              ),
                              buildRow(
                                title: 'Start Date :          ',
                                detail: DateFormat.yMd().format(
                                  DateTime.fromMicrosecondsSinceEpoch(
                                    (_currentVenueBookings[i]
                                            ['startDate'] as Timestamp)
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
                                detail: _currentVenueBookings[i]
                                    ['startTime'],
                              ),
                              buildRow(
                                title: 'End Time :            ',
                                detail:
                                    _currentVenueBookings[i]['endTime'],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        isStartAcceptingOrRejecting = true;
                                      });
                                      await _firestore
                                          .collection('bookings')
                                          .doc(_currentVenueBookings[i].id)
                                          .update({
                                        'status': 'accepted',
                                      });
                                      await _firestore
                                          .collection('venues')
                                          .doc(_auth.currentUser!.uid)
                                          .update(
                                        {
                                          'acceptedBookings':
                                              FieldValue.arrayUnion([
                                            _currentVenueBookings[i].id
                                          ]),
                                          'bookings': FieldValue.arrayRemove(
                                            [_currentVenueBookings[i].id],
                                          ),
                                        },
                                      );
                                      didChangeDependencies();
                                      setState(() {
                                        isStartAcceptingOrRejecting = false;
                                      });
                                    },
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 10,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        isStartAcceptingOrRejecting = true;
                                      });
                                      await _firestore
                                          .collection('bookings')
                                          .doc(_currentVenueBookings[i].id)
                                          .update({
                                        'status': 'rejected',
                                      });
                                      await _firestore
                                          .collection('venues')
                                          .doc(_auth.currentUser!.uid)
                                          .update(
                                        {
                                          'rejectedBookings':
                                              FieldValue.arrayUnion([
                                            _currentVenueBookings[i].id
                                          ]),
                                          'bookings': FieldValue.arrayRemove(
                                            [_currentVenueBookings[i].id],
                                          ),
                                        },
                                      );
                                      didChangeDependencies();
                                      setState(() {
                                        isStartAcceptingOrRejecting = false;
                                      });
                                    },
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 10,
                                      ),
                                    ),
                                  ),
                                ],
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
            ),
          );
  }
}
