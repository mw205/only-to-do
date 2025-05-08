import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_to_do/core/data/repositories/auth_repository.dart';
import 'package:only_to_do/core/di/di.dart';
import 'package:only_to_do/features/sleep_tracking/sleep_home_page/presentation/cubit/sleep_home_cubit.dart';
import 'package:only_to_do/features/sleep_tracking/sleep_home_page/presentation/widgets/sleep_screen_body.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});
  static String id = '/SleepScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SleepHomeCubit(
          serviceLocator.get<AuthRepository>(),
        )..getUserInfo(),
        child: SleepScreenBody(),
      ),
    );
  }
}
