import 'package:firebase_database/firebase_database.dart';

class ApiService {
  final DatabaseReference _database;

  ApiService({required DatabaseReference database}) : _database = database;

  Future<DataSnapshot> fetchSlots() async {
    try {
      // Use the `once()` method to listen for a single event
      DatabaseEvent event = await _database.child('parking_slots').once();
      DataSnapshot dataSnapshot = event.snapshot; // Get the DataSnapshot from the DatabaseEvent
      return dataSnapshot;
    } catch (e) {
      print('Error fetching slots: $e');
      throw e;
    }
  }
}
