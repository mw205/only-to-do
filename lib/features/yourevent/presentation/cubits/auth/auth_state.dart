import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  final UserModel? user;
  final AuthStatus status;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.user,
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.isLoading = false,
  });

  // Initial state
  factory AuthState.initial() => const AuthState();

  // Loading state
  AuthState copyWithLoading() {
    return copyWith(
      status: AuthStatus.loading,
      isLoading: true,
      errorMessage: null,
    );
  }

  // Authenticated state
  AuthState copyWithAuthenticated(UserModel user) {
    return copyWith(
      user: user,
      status: AuthStatus.authenticated,
      isLoading: false,
      errorMessage: null,
    );
  }

  // Unauthenticated state
  AuthState copyWithUnauthenticated() {
    return copyWith(
      user: null,
      status: AuthStatus.unauthenticated,
      isLoading: false,
      errorMessage: null,
    );
  }

  // Failure state
  AuthState copyWithFailure(String errorMessage) {
    return copyWith(
      status: AuthStatus.failure,
      isLoading: false,
      errorMessage: errorMessage,
    );
  }

  // Copy with specified attributes changed
  AuthState copyWith({
    UserModel? user,
    AuthStatus? status,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [user, status, errorMessage, isLoading];
}
