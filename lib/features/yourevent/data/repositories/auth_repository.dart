import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/firebase_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // Reference to users collection
  CollectionReference get _usersCollection =>
      _firebaseService.firestore.collection('users');

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final currentUser = _firebaseService.auth.currentUser;
    if (currentUser == null) return null;

    try {
      final docSnapshot = await _usersCollection.doc(currentUser.uid).get();
      if (!docSnapshot.exists) return null;

      return UserModel.fromFirestore(docSnapshot);
    } catch (e) {
      log('Error getting current user: $e');
      return null;
    }
  }

  // Check if user is authenticated
  Stream<bool> authStateChanges() {
    return _firebaseService.auth.authStateChanges().map((user) => user != null);
  }

  // Sign in with email and password
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        throw Exception('Authentication failed');
      }

      // Get user data from Firestore
      final docSnapshot =
          await _usersCollection.doc(userCredential.user!.uid).get();

      if (!docSnapshot.exists) {
        // Create user document if it doesn't exist
        final newUser = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: email.split('@')[0],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _usersCollection
            .doc(userCredential.user!.uid)
            .set(newUser.toFirestore());

        // Save user info to SharedPreferences
        await _saveUserToPrefs(newUser);

        return newUser;
      }

      // User exists, get data and save to prefs
      final userModel = UserModel.fromFirestore(docSnapshot);
      await _saveUserToPrefs(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found with this email');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password');
      } else {
        throw Exception('Authentication failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Authentication failed: $e');
    }
  }

  // Sign up with email and password
  Future<UserModel> signUp(String name, String email, String password) async {
    try {
      final userCredential = await _firebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        throw Exception('Registration failed');
      }

      // Create user document in Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _usersCollection
          .doc(userCredential.user!.uid)
          .set(newUser.toFirestore());

      // Save user info to SharedPreferences
      await _saveUserToPrefs(newUser);

      return newUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for this email');
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseService.auth.signOut();

      // Clear user info from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Save user info to SharedPreferences
  Future<void> _saveUserToPrefs(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.id);
      await prefs.setString('user_email', user.email);
      await prefs.setString('user_name', user.name);
    } catch (e) {
      log('Error saving user to preferences: $e');
    }
  }
}
