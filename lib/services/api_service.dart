import 'package:firebase_database/firebase_database.dart';

class ApiService {
  final DatabaseReference _database;

  ApiService({required DatabaseReference database}) : _database = database;

  Future<DataSnapshot> fetchSlots() async {
  try {
    DatabaseEvent event = await _database.child('parking_slots').once();
    DataSnapshot dataSnapshot = event.snapshot;
    return dataSnapshot;
  } catch (e) {
    print('Error fetching slots: $e');
    rethrow;
  }
}

DateTime _parseTime(String timeString) {
  final now = DateTime.now();
  final parts = timeString.split(':');
  return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

  Future<void> bookSlot(int slotNumber, DateTime entryTime, DateTime exitTime, Duration totalDuration) async {
    try {
      // Perform booking logic here
      // Update database to mark the slot as booked
      // For example:
      await _database.child('parking_slots').child('slot$slotNumber').update({
        'entry_time': entryTime.toString(),
        'exit_time': exitTime.toString(),
        'availability': false,
        'occupancy_status': true,
        'total_duration': totalDuration.toString(),
      });
    } catch (e) {
      print('Error booking slot: $e');
      throw e;
    }
  }
}
