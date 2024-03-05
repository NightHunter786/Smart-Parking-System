import 'package:firebase_database/firebase_database.dart';

class ApiService {
  final DatabaseReference _database;

  ApiService({required DatabaseReference database}) : _database = database;

  Future<DataSnapshot> fetchSlots() async {
    try {
      DatabaseEvent event = await _database.child('parking_slot').once();
      DataSnapshot dataSnapshot = event.snapshot;

      return dataSnapshot;
    } catch (e) {
      print('Error fetching slots: $e');
      rethrow;
    }
  }

  DateTime _parseTime(String timeString) {
    return DateTime.parse(timeString);
  }

  Duration parseDuration(String durationString) {
    // Split the durationString to extract hours, minutes, and seconds
    List<String> parts = durationString.split(':');

    // Convert hours, minutes, and seconds strings to integers
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    // Create and return the Duration object
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  Future<void> storeBookingInfo(int slotNumber, Map<String, dynamic> bookingData) async {
    // Get a reference to the 'booking_info' label
    DatabaseReference bookingInfoRef = _database.child('booking_info');

    // Get a reference to the slot under 'booking_info'
    DatabaseReference slotRef = bookingInfoRef.child('slot$slotNumber');

    // Store booking information under the slot reference
    await slotRef.set(bookingData);
  }

  Future<DataSnapshot> retrieveSlotsData() async {
  try {
    DataSnapshot dataSnapshot = (await _database.child('parking_slot').once()).snapshot;

    return dataSnapshot;
  } catch (e) {
    print('Error retrieving slots data: $e');
    rethrow;
  }
}

Future<bool> isSlotBookedDuringTime(int slotNumber, DateTime startTime, DateTime endTime) async {
  try {
    DataSnapshot snapshot = (await _database.child('booking_info').child('slot$slotNumber').once()).snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> bookings = snapshot.value as Map<dynamic, dynamic>;
      for (var booking in bookings.values) {
        DateTime bookingStartTime = DateTime.parse(booking['startTime']);
        DateTime bookingEndTime = DateTime.parse(booking['endTime']);

        if ((bookingStartTime.isBefore(endTime) || bookingStartTime.isAtSameMomentAs(endTime)) &&
            (bookingEndTime.isAfter(startTime) || bookingEndTime.isAtSameMomentAs(startTime))) {
          return true;
        }
      }
    }

    return false;
  } catch (e) {
    print('Error checking for overlapping bookings: $e');
    return false;
  }
}

  Future<void> bookSlot(int slotNumber, DateTime startTime, DateTime endTime, Duration totalDuration) async {
    try {
      // Perform booking logic here
      // Update database to mark the slot as booked
      // For example:
      await _database.child('parking_slots').child('slot$slotNumber').update({
        'book_time_start': startTime.toString(),
        'book_time_end': endTime.toString(),
        'availability': false,
        'occupancy_status': true,
        //'total_duration': totalDuration.toString(), // Calculate total duration
      });
    } catch (e) {
      print('Error booking slot: $e');
      throw e;
    }
  }
}
