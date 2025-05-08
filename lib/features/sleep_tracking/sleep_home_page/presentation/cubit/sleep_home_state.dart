part of 'sleep_home_cubit.dart';

@freezed
class SleepHomeState with _$SleepHomeState {
  const factory SleepHomeState.initial() = _Initial;
  const factory SleepHomeState.userInfoLoading() = UserInfoLoading;
  const factory SleepHomeState.userInfoFetched(UserModel user) = UserInfoFetched;
  const factory SleepHomeState.userInfoFailure(String error) = UserInfoFailure;
}
