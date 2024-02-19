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
                  List<Map<String, dynamic>> fetchedSlots =
                      await widget.apiService.fetchSlots();
                  print('Fetched Slots: $fetchedSlots');
                  setState(() {
                    slots = fetchedSlots;
                  });
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
                  Color buttonColor = slots[index]['status'] == 'available'
                      ? Colors.green
                      : Colors.red;

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
