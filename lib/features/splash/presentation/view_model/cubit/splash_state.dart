part of 'splash_cubit.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.initial() = _Initial;
  const factory SplashState.authenticated() = UserAuthenticatedState;
  const factory SplashState.showOnBoarding() = ShowOnBoardingState;
  const factory SplashState.unAuthenticated() = UserUnAuthenticatedState;
}
