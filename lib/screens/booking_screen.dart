import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BookingScreen extends StatefulWidget {
  final int slotNumber;
  final ApiService apiService;

  BookingScreen({required this.slotNumber, required this.apiService});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Screen'),
      ),
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Booking for Slot ${widget.slotNumber}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Show time picker for start time
                _showTimePicker('Select Booking Start Time').then((startTime) {
                  setState(() {
                    _selectedStartTime = startTime;
                  });
                });
              },
              child: Text('Select Start Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Show time picker for end time
                _showTimePicker('Select Booking End Time').then((endTime) {
                  setState(() {
                    _selectedEndTime = endTime;
                  });
                });
              },
              child: Text('Select End Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Book the slot
                _bookSlot();
              },
              child: Text('Book Slot'),
            ),
          ],
        ),
      ),
    );
  }

  Future<TimeOfDay> _showTimePicker(String title) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    return pickedTime ?? TimeOfDay.now();
  }

  // Method to book the slot
  void _bookSlot() {
    DateTime startTime = _convertTimeOfDayToDateTime(_selectedStartTime);
    DateTime endTime = _convertTimeOfDayToDateTime(_selectedEndTime);

    // Calculate total duration
    Duration totalDuration = endTime.difference(startTime);

    // Perform booking
    widget.apiService.bookSlot(
      widget.slotNumber, // Slot number
      startTime,         // Booking start time
      endTime,           // Booking end time
      totalDuration,     // Total duration      
    );

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  // Method to convert TimeOfDay to DateTime
  DateTime _convertTimeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }
}
