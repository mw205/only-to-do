import '../../data/repositories/auth_repository.dart';
import '../entities/user.dart';
import 'auth_usecases.dart';

class AuthUseCasesImpl implements AuthUseCases {
  final AuthRepository _authRepository;

  AuthUseCasesImpl(this._authRepository);

  @override
  Future<bool> isAuthenticated() async {
    final currentUser = await _authRepository.getCurrentUser();
    return currentUser != null;
  }

  @override
  Future<User?> getCurrentUser() async {
    final userModel = await _authRepository.getCurrentUser();
    if (userModel == null) return null;

    // Map data model to domain entity
    return User(
      id: userModel.id,
      email: userModel.email,
      name: userModel.name,
      photoUrl: userModel.photoUrl,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
    );
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    final userModel = await _authRepository.signIn(email, password);

    // Map data model to domain entity
    return User(
      id: userModel.id,
      email: userModel.email,
      name: userModel.name,
      photoUrl: userModel.photoUrl,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
    );
  }

  @override
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final userModel = await _authRepository.signUp(name, email, password);

    // Map data model to domain entity
    return User(
      id: userModel.id,
      email: userModel.email,
      name: userModel.name,
      photoUrl: userModel.photoUrl,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
    );
  }

  @override
  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  @override
  Stream<bool> authStateChanges() {
    return _authRepository.authStateChanges();
  }
}
