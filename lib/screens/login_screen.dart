import 'package:flutter/material.dart';
import 'parking_screen.dart'; // Import the ParkingScreen
//import 'registration_screen.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart'; // Import the AuthService

class LoginScreen extends StatelessWidget {
  final ApiService apiService;
  final AuthService authService;

  LoginScreen({required this.apiService, required this.authService});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      backgroundColor: Colors.lightBlue, // Set background color here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change line color when focused
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change line color when focused
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                // Simulate a login validation using the AuthService
                bool loginSuccess = await authService.login(
                  usernameController.text,
                  passwordController.text,
                );

                if (loginSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ParkingScreen(apiService: apiService),
                    ),
                  );
                } else {
                  // Show an error message or handle the failed login attempt
                  print('Invalid credentials');
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the registration screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationScreen(
                      apiService: apiService,
                      authService: authService,
                    ),
                  ),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  final ApiService apiService;
  final AuthService authService;

  RegistrationScreen({required this.apiService, required this.authService});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      backgroundColor: Colors.lightBlue, // Set background color here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change line color when focused
                ),
              ),  
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Change line color when focused
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                // Simulate a registration logic using the AuthService
                bool registrationSuccess = await authService.register(
                  usernameController.text,
                  passwordController.text,
                );

                if (registrationSuccess) {
                  // Registration successful, go back to the login screen
                  Navigator.pop(context);
                } else {
                  // Show an error message or handle the failed registration attempt
                  print('Registration failed');
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
