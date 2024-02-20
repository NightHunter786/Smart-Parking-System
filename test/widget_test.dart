import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_parking/screens/booking_screen.dart';
import 'package:smart_parking/screens/parking_screen.dart';
import 'package:smart_parking/main.dart'; // Ensure this path is correct
import 'package:smart_parking/services/api_service.dart'; // Ensure this path is correct

// Create a mock ApiService class
class MockApiService extends Mock implements ApiService {}

void main() {
  testWidgets('ParkingScreen Test', (WidgetTester tester) async {
    // Create a mock ApiService instance
    final mockApiService = MockApiService();

    // Build ParkingScreen widget with the mock ApiService instance
    await tester.pumpWidget(MaterialApp(
      home: ParkingScreen(apiService: mockApiService),
    ));

    // Perform your test assertions here
  });

  testWidgets('BookingScreen Test', (WidgetTester tester) async {
    // Create a mock ApiService instance
    final mockApiService = MockApiService();

    // Build BookingScreen widget with the mock ApiService instance
    await tester.pumpWidget(MaterialApp(
      home: BookingScreen(slotNumber: 1, apiService: mockApiService),
    ));

    // Perform your test assertions here
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
