import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/edit_task/presentation/views/edit_task_view.dart';


import '../../features/pomodoro/presentation/views/pomodoro_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/yourevent/presentation/pages/auth/login_page.dart';
import '../../features/yourevent/presentation/pages/auth/signup_page.dart';
import '../../features/yourevent/presentation/pages/home_page.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
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
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: SignupPage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SignupPage(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
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
        path: EditTaskView.id,
        builder: (context, state) => EditTaskView(),
      ),
      GoRoute(
        path: PomodoroView.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: PomodoroView(),
            transitionDuration: Duration(milliseconds: 1500),
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
