import 'package:event_planner_buisness/screens/venue_detail_screen.dart';
import 'package:flutter/material.dart';

class EventsCheckBox extends StatefulWidget {
  static const String eventsCheckBox = '/eventsCheckBox';
  const EventsCheckBox({Key? key}) : super(key: key);

  @override
  _EventsCheckBoxState createState() => _EventsCheckBoxState();
}

class _EventsCheckBoxState extends State<EventsCheckBox> {
  Map<String, bool> _events = {
    'Baby Shower': false,
    'Birthday Party': false,
    'College Party': false,
    'Kitty Party': false,
    'Marriage Ceremony': false,
    'New Year Party': false,
    'Ring Ceremony': false,
    'Seminar': false,
  };

  bool checkBoxValue = false;

  List<String> _selectedEvents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select events')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, bottom: 20),
            child: FittedBox(
              child: Text(
                'Select events which you can perform : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: _events.keys.map((event) {
                return CheckboxListTile(
                    title: Text(event),
                    value: _events[event],
                    onChanged: (value) {
                      setState(() {
                        _events[event] = value!;
                      });
                      if (_events[event]!) {
                        _selectedEvents.add(event);
                      } else {
                        _selectedEvents.remove(event);
                      }
                    });
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: _selectedEvents.length == 0
                ? null
                : () {
                    Navigator.pushNamed(
                        context, VenueDetailForm.venueDetailFrom,
                        arguments: _selectedEvents);
                  },
            child: Text('Next'),
            style: ElevatedButton.styleFrom(primary: Color(0xFF033249)),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
