import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  final ApiService apiService;
  final AuthService authService;

  RegistrationScreen({required this.apiService, required this.authService});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                      });

                      // Simulate a registration logic using the AuthService
                      bool registrationSuccess =
                          await widget.authService.register(
                        usernameController.text,
                        passwordController.text,
                      );

                      setState(() {
                        isLoading = false;
                      });

                      if (registrationSuccess) {
                        // Registration successful, go back to the login screen
                        Navigator.pop(context);
                      } else {
                        // Show an error message or handle the failed registration attempt
                        print('Registration failed');
                      }
                    },
              child: isLoading ? CircularProgressIndicator() : Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
