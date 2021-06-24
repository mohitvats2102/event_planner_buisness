import 'package:flutter/material.dart';
import 'package:event_planner_buisness/screens/accepted_bookings.dart';
import 'package:event_planner_buisness/screens/bookings_screen.dart';

class TabsScreen extends StatefulWidget {
  static const String tabScreen = '/tabs_screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Bookings'),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('New bookings'),
              ),
              Tab(
                child: Text('Accepted bookings'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BookingsScreen(),
            AcceptedBookings(),
          ],
        ),
      ),
    );
  }
}
