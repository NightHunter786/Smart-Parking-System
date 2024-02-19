import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Keep this import
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final SharedPreferences prefs;
  final FirebaseAuth firebaseAuth;
  final DatabaseReference database; // Change to DatabaseReference

  AuthService({
    required this.prefs,
    required this.firebaseAuth,
    required this.database, // Change to DatabaseReference
  });

  Future<bool> login(String username, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      return true;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );

      // Additional: Create a user document in Realtime Database if needed
      await database.child('users').child(username).set({
        'field': 'value', // Add other user-related fields if needed
      });

      return true;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // Other methods (e.g., get user data) using Realtime Database
}
