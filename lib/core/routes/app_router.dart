import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/informations/presentation/user_health_form.dart';
import 'package:only_to_do/features/pomodoro/presentation/views/pomodoro_page.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/edit_task/presentation/views/edit_task_view.dart';
import '../../features/informations/presentation/informations_view.dart';
import '../../features/on_boarding/on_boarding_view.dart';
import '../../features/on_boarding/widgets/welcome_screen.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/yourevent/presentation/pages/home_page.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: SleepQuestionsFlow.id,
    routes: [
      GoRoute(
        path: SplashView.id,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: LoginPage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const LoginPage(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child);
            },
          );
        },
      ),
      GoRoute(
        path: SignupPage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SignupPage(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child);
            },
          );
        },
      ),
      GoRoute(
        path: HomePage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const HomePage(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: PomodoroPage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: PomodoroPage(),
            transitionDuration: Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: WelcomeScreen.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: WelcomeScreen(),
            transitionDuration: Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: EditTaskView.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: EditTaskView(),
            transitionDuration: Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: OnBoardingView.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: OnBoardingView(),
            transitionDuration: Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: SleepQuestionsFlow.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: SleepQuestionsFlow(),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: UserHealthForm.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: UserHealthForm(),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
    ],
  );
}
