import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_tracker_state.dart';
part 'sleep_tracker_cubit.freezed.dart';

class SleepTrackerCubit extends Cubit<SleepTrackerState> {
  SleepTrackerCubit() : super(SleepTrackerState.initial());

}
