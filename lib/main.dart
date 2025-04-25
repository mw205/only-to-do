import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:only_to_do/core/routes/app_router.dart';
import 'package:only_to_do/gen/colors.gen.dart';

import 'features/yourevent/data/repositories/auth_repository.dart';
import 'features/yourevent/data/repositories/dashboard_repository.dart';
import 'features/yourevent/data/repositories/event_repository.dart';
import 'features/yourevent/presentation/cubits/auth/auth_cubit.dart';
import 'features/yourevent/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'features/yourevent/presentation/cubits/events/events_cubit.dart';
import 'features/yourevent/presentation/cubits/pomodoro/pomodoro_cubit.dart';
import 'features/yourevent/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize notification services
  await NotificationService().init();
  runApp(const OnlyToDo());
}

class OnlyToDo extends StatelessWidget {
  const OnlyToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(authRepository: AuthRepository())..checkAuth(),
        ),
        BlocProvider(
          create: (context) => EventsCubit(eventRepository: EventRepository()),
        ),
        BlocProvider(create: (context) => PomodoroCubit()),
        BlocProvider(
          create: (context) => DashboardCubit(
            dashboardRepository: DashboardRepository(),
            eventRepository: EventRepository(),
          ),
        ),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        designSize: Size(393, 852),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          title: 'Only To do',
          theme: ThemeData(
            scaffoldBackgroundColor: ColorName.white,
            colorScheme: ColorScheme.light(
              primary: ColorName.purple,
              secondary: ColorName.lightPurple,
            ),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
