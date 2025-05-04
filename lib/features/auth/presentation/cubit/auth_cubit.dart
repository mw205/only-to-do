import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authStateSubscription;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.initial());

  // Check authentication status
  Future<void> checkAuth() async {
    emit(state.copyWithLoading());

    try {
      final currentUser = await _authRepository.getCurrentUser();

      if (currentUser != null) {
        emit(state.copyWithAuthenticated(currentUser));
      } else {
        emit(state.copyWithUnauthenticated());
      }

      // Listen to auth state changes
      _authStateSubscription?.cancel();
      _authStateSubscription = _authRepository.authStateChanges().listen((
        isAuthenticated,
      ) {
        if (!isAuthenticated && state.status == AuthStatus.authenticated) {
          emit(state.copyWithUnauthenticated());
        } else if (isAuthenticated &&
            state.status == AuthStatus.unauthenticated) {
          checkAuth();
        }
      });
    } catch (e) {
      emit(state.copyWithFailure(e.toString()));
    }
  }

  // Sign in with email and password
  Future<void> signIn(String email, String password) async {
    emit(state.copyWithLoading());

    try {
      final user = await _authRepository.signIn(email, password);
      emit(state.copyWithAuthenticated(user));
    } catch (e) {
      emit(state.copyWithFailure(e.toString()));
    }
  }

  // Sign up with email and password
  Future<void> signUp(String name, String email, String password) async {
    emit(state.copyWithLoading());

    try {
      final user = await _authRepository.signUp(name, email, password);
      emit(state.copyWithAuthenticated(user));
    } catch (e) {
      emit(state.copyWithFailure(e.toString()));
    }
  }

  // Sign out
  Future<void> signOut() async {
    emit(state.copyWithLoading());

    try {
      await _authRepository.signOut();
      emit(state.copyWithUnauthenticated());
    } catch (e) {
      emit(state.copyWithFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
