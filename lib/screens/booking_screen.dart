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
  TimeOfDay _selectedEntryTime = TimeOfDay.now();
  TimeOfDay _selectedExitTime = TimeOfDay.now();

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
                // Show time picker for entry time
                _showEntryTimePicker();
              },
              child: Text('Select Entry Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Show time picker for exit time
                _showExitTimePicker();
              },
              child: Text('Select Exit Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Calculate total duration and cost
                DateTime entryTime = _convertTimeOfDayToDateTime(_selectedEntryTime);
                DateTime exitTime = _convertTimeOfDayToDateTime(_selectedExitTime);
                widget.apiService.bookSlot(widget.slotNumber, entryTime, exitTime);
                // Navigate back to ParkingScreen
                Navigator.pop(context);
              },
              child: Text('Book Slot'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEntryTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedEntryTime) {
      setState(() {
        _selectedEntryTime = pickedTime;
      });
    }
  }

  Future<void> _showExitTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedExitTime) {
      setState(() {
        _selectedExitTime = pickedTime;
      });
    }
  }

  DateTime _convertTimeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }
}
