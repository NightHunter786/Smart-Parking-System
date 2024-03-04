import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'booking_screen.dart';
import 'dart:async';
import 'dart:core';

class ParkingScreen extends StatefulWidget {
  final ApiService apiService;

  ParkingScreen({required this.apiService});

  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

DateTime parseDateTime(String dateTimeString) {
  return dateTimeString.isNotEmpty ? DateTime.parse(dateTimeString) : DateTime.utc(0, 0, 0, 0, 0, 0);
}

class _ParkingScreenState extends State<ParkingScreen> {
  late ApiService _apiService;
  List<Map<String, dynamic>> slots = [];
  late Timer _timer; // Timer for periodic time check

  //ApiService get _apiService => widget.apiService; // Getter for ApiService

  DateTime _parseEmptyTime(String timeString) {
  if (timeString.isNotEmpty) {
    final parts = timeString.split(' ');
    final dateString = parts[0];
    final timeStringWithoutDate = parts[1];
    final date = DateTime.parse(dateString);
    final time = DateFormat.jm().parse(timeStringWithoutDate);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  } else {
    return DateTime.utc(0, 0, 0, 0, 0);
  }
}

DateTime _parseFullTime(String timeString) {
  if (timeString.isNotEmpty) {
    final parts = timeString.split(' ');
    final dateString = parts[0];
    final timeStringWithoutDate = parts[1];
    final date = DateTime.parse(dateString);
    final time = DateFormat.jm().parse(timeStringWithoutDate);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  } else {
    return DateTime.utc(0, 0, 0, 0, 0);
  }
}

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(database: FirebaseDatabase.instance.reference());
    // Fetch slots when the widget is first initialized
    updateSlotStatus();
    // Start the timer to periodically update slot statuses
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      updateSlotStatus(); // Call function to update slot statuses
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> updateSlotStatus() async {
  try {
    var dataSnapshot = await _apiService.fetchSlots();
    print('DataSnapshot: $dataSnapshot');
    if (dataSnapshot != null) {
      var slotsData = dataSnapshot.value as Map<dynamic, dynamic>;
      print('Slots data keys: ${slotsData.keys}');
      print('Slots data values: ${slotsData.values}');
      List<Map<String, dynamic>> fetchedSlots = [];
      slotsData.forEach((key, value) {
        // Check if status is available or not
        fetchedSlots.add({
          'slotNumber': key,
          'status': value['status'] == 'Empty', // Check status for Empty
        });
      });
      setState(() {
        slots = fetchedSlots;
        print('Updated slots: $slots');
      });
    } else {
      print('Fetched slots are null');
    }
  } catch (e) {
    print('Error fetching slots: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.3;

    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Screen'),
      ),
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Select a parking slot',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                updateSlotStatus(); // Call the updateSlotStatus method when the button is pressed
              },
              child: Text('Fetch Slots'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                        if (!slots[index]['status']) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                slotNumber: int.parse(slots[index]['slotNumber'].replaceAll('slot', '')),
                                apiService: widget.apiService,
                              ),
                            ),
                          );
                        } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Slot is unavailable'),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        slots[index]['status'] ? Colors.green : Colors.red,
                      ),
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size(buttonWidth, 40),
                      ),
                    ),                      
                      child: Text('Slot ${slots[index]['slotNumber']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
             
