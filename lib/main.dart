import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_database/firebase_database.dart'; // Import FirebaseDatabase
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDbAwVRyQZwseyc2Npvr5MMaWjDxnpEzHM",
        authDomain: "smartparking-a6015.firebaseapp.com",
        databaseURL: "https://smartparking-a6015-default-rtdb.firebaseio.com",
        projectId: "smartparking-a6015",
        storageBucket: "smartparking-a6015.appspot.com",
        messagingSenderId: "246089811699",
        appId: "1:246089811699:web:d815bccc3aefb843961986",
        measurementId: "G-N1T7KM9GYK",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance; 
  final DatabaseReference database = FirebaseDatabase.instance.reference(); // Get reference to the root of the database
  final ApiService apiService = ApiService(database: database); // Pass DatabaseReference to ApiService
  final AuthService authService = AuthService(
    prefs: prefs,
    firebaseAuth: firebaseAuth,
    database: database, // Pass DatabaseReference to AuthService
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
