import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/pomodoro/presentation/views/pomodoro_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/yourevent/data/models/event_model.dart';
import '../../features/yourevent/presentation/pages/auth/login_page.dart';
import '../../features/yourevent/presentation/pages/auth/signup_page.dart';
import '../../features/yourevent/presentation/pages/calendar/calendar_page.dart';
import '../../features/yourevent/presentation/pages/calendar/monthly_view_page.dart';
import '../../features/yourevent/presentation/pages/calendar/weekly_view_page.dart';
import '../../features/yourevent/presentation/pages/dashboard/dashboard_page.dart';
import '../../features/yourevent/presentation/pages/events/add_edit_event_page.dart';
import '../../features/yourevent/presentation/pages/events/event_details_page.dart';
import '../../features/yourevent/presentation/pages/events/events_list_page.dart';

import '../../features/yourevent/presentation/pages/home_page.dart';
import '../../features/yourevent/presentation/pages/mailboxes/mailboxes_page.dart';

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
      // GoRoute(
      //   path: HomeView.id,
      //   pageBuilder: (context, state) {
      //     return CustomTransitionPage(
      //       child: const HomeView(),
      //       transitionDuration: const Duration(milliseconds: 1500),
      //       transitionsBuilder:
      //           (context, animation, secondaryAnimation, child) {
      //         return FadeTransition(opacity: animation, child: child);
      //       },
      //     );
      //   },
      // ),
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
      // Added routes from old AppRoutes
      GoRoute(
        path: CalendarPage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const CalendarPage(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: WeeklyViewPage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const WeeklyViewPage(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: MonthlyViewPage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const MonthlyViewPage(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: MailboxesPage.id,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const MailboxesPage(),
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
