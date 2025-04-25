// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import 'package:only_to_do/features/edit_task/presentation/views/edit_task_view.dart';

// import 'package:only_to_do/features/pomodoro/presentation/views/pomodoro_view.dart';

// import '../../features/home/presentation/views/home_view.dart';
// import '../../features/splash/presentation/views/splash_view.dart';

// class AppRouter {
//   AppRouter._();
//   static final router = GoRouter(
//     initialLocation: EditTaskView.id,
//     routes: [
//       GoRoute(
//         path: SplashView.id,
//         builder: (context, state) => SplashView(),
//       ),
//       GoRoute(
//         path: HomeView.id,
//         pageBuilder: (context, state) {
//           return CustomTransitionPage(
//             child: HomeView(),
//             transitionDuration: Duration(milliseconds: 1500),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//               return FadeTransition(opacity: animation, child: child);
//             },
//           );
//         },
//       ),

//       GoRoute(
//         path: EditTaskView.id,
//         builder: (context, state) => EditTaskView(),
//         pageBuilder: (context, state) {
//           return CustomTransitionPage(
//             child: EditTaskView(),
//             transitionDuration: Duration(milliseconds: 1500),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//               return FadeTransition(opacity: animation, child: child);
//             },
//           );
//         },
//       ),
//       GoRoute(
//         path: PomodoroView.id,
//         pageBuilder: (context, state) {
//           return CustomTransitionPage(
//             child: PomodoroView(),
//             transitionDuration: Duration(milliseconds: 1500),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//               return FadeTransition(opacity: animation, child: child);
//             },
//           );
//         },
//       ),
//     ],
//   );
// }
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/views/home_view.dart';
import '../../features/pomodoro/presentation/views/pomodoro_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/yourevent/data/models/event_model.dart';
import '../../features/yourevent/presentation/pages/auth/login_page.dart';
import '../../features/yourevent/presentation/pages/auth/signup_page.dart';
import '../../features/yourevent/presentation/pages/dashboard/dashboard_page.dart';
import '../../features/yourevent/presentation/pages/events/add_edit_event_page.dart';
import '../../features/yourevent/presentation/pages/events/event_details_page.dart';
import '../../features/yourevent/presentation/pages/events/events_list_page.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: SplashView.id,
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
        path: HomeView.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const HomeView(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: EventsListPage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const EventsListPage(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: EventDetailsPage.id,
        pageBuilder: (context, state) {
          final event = state.extra as EventModel;
          return CustomTransitionPage(
            child: EventDetailsPage(event: event),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: AddEditEventPage.id,
        pageBuilder: (context, state) {
          final event = state.extra as EventModel?;
          return CustomTransitionPage(
            child: AddEditEventPage(event: event),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: PomodoroView.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const PomodoroView(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: DashboardPage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const DashboardPage(),
            transitionDuration: const Duration(milliseconds: 1500),
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
