import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_parking/screens/booking_screen.dart';
import 'package:smart_parking/screens/parking_screen.dart';
import 'package:smart_parking/main.dart'; // Ensure this path is correct
import 'package:smart_parking/services/api_service.dart'; // Ensure this path is correct
import 'package:smart_parking/services/auth_service.dart'; // Ensure this path is correct

// Create a mock ApiService class
class MockApiService extends Mock implements ApiService {}

// Create a mock AuthService class
class MockAuthService extends Mock implements AuthService {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create mock ApiService and AuthService instances
    final mockApiService = MockApiService();
    final mockAuthService = MockAuthService();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(apiService: mockApiService, authService: mockAuthService));

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
