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
