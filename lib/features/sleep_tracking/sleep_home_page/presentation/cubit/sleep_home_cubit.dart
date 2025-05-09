import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:only_to_do/core/data/repositories/auth_repository.dart';

import '../../../../../core/data/models/user_model.dart';

part 'sleep_home_cubit.freezed.dart';
part 'sleep_home_state.dart';

class SleepHomeCubit extends Cubit<SleepHomeState> {
  SleepHomeCubit(this.authRepository) : super(SleepHomeState.initial());

  AuthRepository authRepository;
  void getUserInfo() {
    emit(SleepHomeState.userInfoLoading());
    authRepository.getCurrentUser().then(
      (value) {
        if (value != null) {
          emit(SleepHomeState.userInfoFetched(value));
        } else if (value == null) {
          emit(SleepHomeState.userInfoFailure('User not found'));
        }
      },
    );
  }
}
