import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
//import 'package:flutter_web/flutter_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDbAwVRyQZwseyc2Npvr5MMaWjDxnpEzHM",
            appId: "1:246089811699:web:d815bccc3aefb843961986",
            messagingSenderId: "246089811699",
            projectId: "smartparking-a6015")); // Initialize Firebase
  } else {
    await Firebase.initializeApp();
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final FirebaseAuth firebaseAuth =
      FirebaseAuth.instance; // Get FirebaseAuth instance
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:3001');
  final AuthService authService = AuthService(
    baseUrl: 'http://localhost:3001',
    prefs: prefs,
    firebaseAuth: firebaseAuth, // Pass FirebaseAuth instance to AuthService
  );
  runApp(MyApp(apiService: apiService, authService: authService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final AuthService authService;

  MyApp({required this.apiService, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(
        apiService: apiService,
        authService: authService,
      ),
    );
  }
}
