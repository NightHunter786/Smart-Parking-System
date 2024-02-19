import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ParkingScreen extends StatefulWidget {
  final ApiService apiService;

  ParkingScreen({required this.apiService});

  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  List<Map<String, dynamic>> slots = [];

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width *
        0.3; // Adjust the percentage as needed

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
                    var slotsData = dataSnapshot.value as Map<dynamic, dynamic>;
                    List<Map<String, dynamic>> fetchedSlots = [];
                    slotsData.forEach((key, value) {
                      fetchedSlots.add({
                        'slotNumber': key,
                        'status': value['availability'],
                        'entryTime': value['entry_time'],
                        'exitTime': value['exit_time'],
                        'occupancyStatus': value['occupancy_status'],
                        'totalDuration': value['total_duration'],
                      });
                    });
                    setState(() {
                      slots = fetchedSlots;
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
                  Color buttonColor = slots[index]['status'] == true //bool value not string
                      ? Colors.green
                      : Colors.red;
                  print('Slot ${slots[index]['slotNumber']} status: ${slots[index]['status']}');

                  return ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                        // Handle button press if needed
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
