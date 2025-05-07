import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:only_to_do/core/data/models/user_model.dart';
import 'package:only_to_do/core/data/repositories/auth_repository.dart';
import 'package:only_to_do/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:only_to_do/features/auth/presentation/cubit/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(UserModel(
      id: 'fallbackId',
      email: 'fallback@example.com',
      name: 'Fallback User',
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
      isPremium: false,
    ));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authCubit = AuthCubit(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authCubit.close();
  });

  final tUser = UserModel(
    id: 'testId',
    email: 'test@example.com',
    name: 'Test User',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isPremium: false,
  );
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tName = 'Test User';
  final tException = Exception('Operation failed'); // Reusable exception

  group('AuthCubit', () {
    test('initial state is AuthState.initial()', () {
      expect(authCubit.state, equals(AuthState.initial()));
    });

    group('signIn', () {
      blocTest<AuthCubit, AuthState>(
        'emits [loading, authenticated] when signIn is successful',
        build: () {
          // Use mocktail's `when` syntax
          when(() => mockAuthRepository.signIn(tEmail, tPassword))
              .thenAnswer((_) async => tUser);
          return authCubit;
        },
        act: (cubit) => cubit.signIn(tEmail, tPassword),
        expect: () => [
          AuthState.initial().copyWithLoading(),
          AuthState.initial().copyWithAuthenticated(tUser),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.signIn(tEmail, tPassword)).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, failure] when signIn throws an exception',
        build: () {
          when(() => mockAuthRepository.signIn(tEmail, tPassword))
              .thenThrow(tException);
          return authCubit;
        },
        act: (cubit) => cubit.signIn(tEmail, tPassword),
        expect: () => [
          AuthState.initial().copyWithLoading(),
          // Ensure the error message format matches how the cubit wraps it
          AuthState.initial().copyWithFailure(tException.toString()),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.signIn(tEmail, tPassword)).called(1);
        },
      );
    });

    group('signUp', () {
      blocTest<AuthCubit, AuthState>(
        'emits [loading, authenticated] when signUp is successful',
        build: () {
          when(() => mockAuthRepository.signUp(tName, tEmail, tPassword))
              .thenAnswer((_) async => tUser);
          return authCubit;
        },
        act: (cubit) => cubit.signUp(tName, tEmail, tPassword),
        expect: () => [
          AuthState.initial().copyWithLoading(),
          AuthState.initial().copyWithAuthenticated(tUser),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.signUp(tName, tEmail, tPassword))
              .called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, failure] when signUp throws an exception',
        build: () {
          when(() => mockAuthRepository.signUp(tName, tEmail, tPassword))
              .thenThrow(tException);
          return authCubit;
        },
        act: (cubit) => cubit.signUp(tName, tEmail, tPassword),
        expect: () => [
          AuthState.initial().copyWithLoading(),
          AuthState.initial().copyWithFailure(tException.toString()),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.signUp(tName, tEmail, tPassword))
              .called(1);
        },
      );
    });
    // You can add tests for checkAuth similarly, mocking getCurrentUser and authStateChanges stream
    group('checkAuth', () {
      blocTest<AuthCubit, AuthState>(
        'emits [loading, authenticated] when user is already logged in',
        build: () {
          when(() => mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => tUser);
          // Mock the auth state changes stream
          when(() => mockAuthRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(true));
          return authCubit;
        },
        act: (cubit) => cubit.checkAuth(),
        expect: () => [
          AuthState.initial().copyWithLoading(),
          AuthState.initial().copyWithAuthenticated(tUser),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.getCurrentUser()).called(1);
          verify(() => mockAuthRepository.authStateChanges()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, unauthenticated] when user is not logged in',
        build: () {
          when(() => mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => null);
          when(() => mockAuthRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(false));
          return authCubit;
        },
        act: (cubit) => cubit.checkAuth(),
        expect: () => [
          AuthState.initial().copyWithLoading(),
          AuthState.initial().copyWithUnauthenticated(),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.getCurrentUser()).called(1);
          verify(() => mockAuthRepository.authStateChanges()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [loading, failure] when checkAuth throws an exception',
        build: () {
          when(() => mockAuthRepository.getCurrentUser()).thenThrow(tException);
          // Don't need to mock the stream here as getCurrentUser fails first
          // when(() => mockAuthRepository.authStateChanges()).thenAnswer((_) => Stream.error(tException));
          return authCubit;
        },
        act: (cubit) => cubit.checkAuth(),
        expect: () => [
          AuthState.initial().copyWithLoading(),
          AuthState.initial().copyWithFailure(tException.toString()),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.getCurrentUser()).called(1);
          // authStateChanges might not be called if getCurrentUser throws
          verifyNever(() => mockAuthRepository.authStateChanges());
        },
      );
    });
  });
}
