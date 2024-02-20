import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
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
  return DateTime.parse(dateTimeString);
}

class _ParkingScreenState extends State<ParkingScreen> {
  List<Map<String, dynamic>> slots = [];
  late Timer _timer; // Timer for periodic time check

  DateTime _parseTime(String timeString) {
  try {
    // Try parsing as DateTime
    return DateTime.parse(timeString);
  } catch (_) {
    // If parsing as DateTime fails, handle it as TimeOfDay
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final second = int.parse(parts[2]);
    return DateTime(0, 0, 0, hour, minute, second);
  }
}


  @override
  void initState() {
    super.initState();
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

  void updateSlotStatus() {
    // Get current time
    DateTime currentTime = DateTime.now();
    // Update slot status based on exit time
    setState(() {
      slots.forEach((slot) {
        // Check if current time is after exit time
        if (currentTime.isAfter(slot['exitTime'])) {
          slot['status'] = true; // Slot is available
        } else {
          slot['status'] = false; // Slot is not available
        }
      });
    });
  }

  DateTime _parseDateTime(String dateTimeString) {
  try {
    return DateTime.parse(dateTimeString);
  } catch (e) {
    // Handle the error, and return a default value or show an error message
    print('Error parsing date: $e');
    return DateTime.now(); // Return a default value, or handle differently based on your requirements
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
            Text(
              'Select a parking slot',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  var dataSnapshot = await widget.apiService.fetchSlots();
                  if (dataSnapshot != null) {
                    var slotsData =
                        dataSnapshot.value as Map<dynamic, dynamic>;
                    List<Map<String, dynamic>> fetchedSlots = [];
                    slotsData.forEach((key, value) {
                      fetchedSlots.add({
                        'slotNumber': key,
                        'status': value['availability'] == true,
                        'entryTime': _parseTime(value['entry_time']),
                        'exitTime': _parseTime(value['exit_time']),
                        'occupancyStatus': value['occupancy_status'],
                        'totalDuration': value['total_duration'],
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
              },
              child: Text('Fetch Slots'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  Color buttonColor = slots[index]['status'] == true
                      ? Colors.green
                      : Colors.red;
                  return ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                        if (slots[index]['status'] == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                slotNumber: int.parse(
                                    slots[index]['slotNumber']
                                        .replaceAll('slot', '')),
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
                      style: ElevatedButton.styleFrom(
                        primary: buttonColor,
                        fixedSize: Size(buttonWidth, 40),
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
