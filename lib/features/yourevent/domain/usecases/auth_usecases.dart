import '../entities/user.dart';

abstract class AuthUseCases {
  /// Check if a user is currently authenticated
  Future<bool> isAuthenticated();

  /// Get the current user
  Future<User?> getCurrentUser();

  /// Sign in with email and password
  Future<User> signIn({required String email, required String password});

  /// Sign up with name, email, and password
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Sign out the current user
  Future<void> signOut();

  /// Get auth state changes as a stream
  Stream<bool> authStateChanges();
}
