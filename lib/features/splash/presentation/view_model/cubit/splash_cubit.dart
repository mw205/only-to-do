import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_cubit.freezed.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.initial());

  void checkAuthAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(
      Duration(seconds: 3),
      () async {
        // Check if user is logged in with Firebase
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          emit(UserAuthenticatedState());
          // User is logged in, navigate to home
        } else if (prefs.getBool('showOnBoarding') ?? true) {
          // Check to show on boarding screen
          emit(ShowOnBoardingState());
        } else {
          // User is not logged in, navigate to login page
          emit(UserUnAuthenticatedState());
        }
      },
    );
  }
}
