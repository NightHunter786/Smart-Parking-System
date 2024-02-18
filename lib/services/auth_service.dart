import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final String baseUrl;
  final SharedPreferences prefs;
  final FirebaseAuth firebaseAuth;

  AuthService({
    required this.baseUrl,
    required this.prefs,
    required this.firebaseAuth,
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

      // Additional: Create a user document in Firestore if needed
      await FirebaseFirestore.instance.collection('users').doc(username).set({
        'field': 'value', // Add other user-related fields if needed
      });

      return true;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // Other methods (e.g., get user data) using FirebaseFirestore
}
