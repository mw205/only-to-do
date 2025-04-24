import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/edit_task/presentation/views/edit_task_view.dart';

import '../../features/home/presentation/views/home_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';

class AppRouter {
  AppRouter._();
  static final router = GoRouter(
    initialLocation: EditTaskView.id,
    routes: [
      GoRoute(
        path: SplashView.id,
        builder: (context, state) => SplashView(),
      ),
      GoRoute(
        path: HomeView.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: HomeView(),
            transitionDuration: Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      //=====================//
      GoRoute(
        path: EditTaskView.id,
        builder: (context, state) => EditTaskView(),
      ),
    ],
  );
}
