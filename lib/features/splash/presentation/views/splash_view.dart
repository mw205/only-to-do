import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_to_do/features/splash/presentation/view_model/cubit/splash_cubit.dart';

import 'widget/splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static String id = "/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SplashCubit()..checkAuthAndNavigate(),
        child: SplashViewBody(),
      ),
    );
  }
}
