import 'package:flutter/material.dart';
//import 'package:smart_parking/constant/esewa.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';
import 'payment_screen.dart';
//import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
//import "package:esewa_flutter_sdk/esewa_config.dart";
//import "package:esewa_flutter_sdk/esewa_payment.dart";
//import "package:esewa_flutter_sdk/esewa_payment_success_result.dart";
//import 'package:esewa_flutter/esewa_flutter.dart';
//import 'package:flutter/foundation.dart';

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
  double _estimatedCost = 0.0;

  void _handlePayment() {
    try {
      // Calculate the estimated cost when handling payment
      DateTime startTime = _convertTimeOfDayToDateTime(_selectedStartTime);
      DateTime endTime = _convertTimeOfDayToDateTime(_selectedEndTime);
      Duration duration = endTime.difference(startTime);
      double ratePerMinute = 50.0 / 30.0; // Cost per minute
      double totalCost = duration.inMinutes * ratePerMinute;
      totalCost = (totalCost / 10).ceil() * 10; // Round off to nearest tens place

      // Update the estimated cost
      setState(() {
        _estimatedCost = totalCost;
      });

      // Navigate to the payment screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(), // Use the PaymentScreen constructor
      ),
    );
    } catch (e) {
      debugPrint("EXCEPTION");
    }
  }

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
            Text(
              'Estimated Cost: \$${_estimatedCost.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle payment
                _handlePayment();
              },
              child: Text('Pay with eSewa'),
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

    // Recalculate the estimated cost when the user selects the start or end time
    if (pickedTime != null) {
      DateTime startTime = _convertTimeOfDayToDateTime(pickedTime);
      DateTime endTime = _convertTimeOfDayToDateTime(_selectedEndTime);
      Duration duration = endTime.difference(startTime);
      double ratePerMinute = 50.0 / 30.0; // Cost per minute
      double totalCost = duration.inMinutes * ratePerMinute;
      totalCost = (totalCost / 10).ceil() * 10; // Round off to nearest tens place
      setState(() {
        _estimatedCost = totalCost;
      });
    }

    return pickedTime ?? TimeOfDay.now();
  }

  // Method to book the slot
  void _bookSlot() async {
    // Check if start and end times are selected
  if (_selectedStartTime == TimeOfDay.now() || _selectedEndTime == TimeOfDay.now()) {
    // Show a dialog or snackbar indicating that start and end times are required
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Times'),
        content: Text('Please select both start and end times before booking.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
    return;
  }
  print("Booking data: Start Time: $_selectedStartTime, End Time: $_selectedEndTime");
    DateTime startTime = _convertTimeOfDayToDateTime(_selectedStartTime);
    DateTime endTime = _convertTimeOfDayToDateTime(_selectedEndTime);
    Duration duration = endTime.difference(startTime);

    // Calculate the cost based on the duration and rate per minute
    double ratePerMinute = 50.0 / 30.0; // Cost per minute
    double totalCost = duration.inMinutes * ratePerMinute;
    // Round off the total cost to the nearest tens place
    totalCost = (totalCost / 10).ceil() * 10;

    // Update the estimated cost
    setState(() {
      _estimatedCost = totalCost;
    });

    // Check if the slot is already booked during the selected time
    bool isSlotBooked = await widget.apiService.isSlotBookedDuringTime(widget.slotNumber, startTime, endTime);
    if (isSlotBooked) {
      // Show a dialog or toast indicating that the slot is already booked
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Slot Unavailable'),
          content: Text('Sorry, the selected slot is already booked during this time.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Format start and end times
    String formattedStartTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(startTime);
    String formattedEndTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(endTime);

    // Calculate total duration
    Duration totalDuration = endTime.difference(startTime);

    // Create a map to store booking information
    Map<String, dynamic> bookingData = {
      'booking_start_time': formattedStartTime,
      'booking_end_time': formattedEndTime,
      'duration': totalDuration.inMinutes,
      'cost': totalCost,
      // Add other booking information such as cost, etc.
    };

    // Store booking information in the 'booking_info' label
    widget.apiService.storeBookingInfo(widget.slotNumber, bookingData);

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  // Method to convert TimeOfDay to DateTime
  DateTime _convertTimeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
      now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute, 0);
  }
}
