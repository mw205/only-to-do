import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/routes/app_router.dart';
import 'core/data/repositories/auth_repository.dart';
import 'core/data/repositories/dashboard_repository.dart';
import 'core/data/repositories/event_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/yourevent/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'features/yourevent/presentation/cubits/events/events_cubit.dart';
import 'features/pomodoro/presentation/cubit/pomodoro_cubit.dart';
import 'features/yourevent/services/notification_service.dart';
import 'gen/colors.gen.dart';
import 'gen/fonts.gen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive for local storage (needed for Event Countdown app)
  await Hive.initFlutter();

  // Initialize notification services
  await NotificationService().init();

  // Note: We don't need to set up listeners here as they're already set up
  // in the NotificationService class

  // Check which app layout to use by default
  final prefs = await SharedPreferences.getInstance();
  final isOriginalLayout = prefs.getBool('is_original_layout') ?? true;
  runApp(OnlyToDo(isOriginalLayout: isOriginalLayout));
}

class OnlyToDo extends StatefulWidget {
  final bool isOriginalLayout;

  const OnlyToDo({super.key, required this.isOriginalLayout});

  @override
  State<OnlyToDo> createState() => _OnlyToDoState();
}

class _OnlyToDoState extends State<OnlyToDo> {
  late bool _isOriginalLayout;

  @override
  void initState() {
    super.initState();
    _isOriginalLayout = widget.isOriginalLayout;

    // Listen for layout changes
    _listenForLayoutChanges();
  }

  // Set up a listener for layout changes
  void _listenForLayoutChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ValueNotifier<bool> layoutNotifier = ValueNotifier(_isOriginalLayout);
    layoutNotifier.addListener(() {
      final newLayout = layoutNotifier.value;
      if (newLayout != _isOriginalLayout) {
        setState(() {
          _isOriginalLayout = newLayout;
        });
      }
    });

    // Simulate listening for changes in SharedPreferences
    Future.delayed(Duration.zero, () async {
      final newLayout = prefs.getBool('is_original_layout') ?? true;
      layoutNotifier.value = newLayout;
    });
  }

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
        if (_isOriginalLayout) ...[
          BlocProvider(create: (context) => PomodoroCubit()),
          BlocProvider(
            create: (context) => DashboardCubit(
              dashboardRepository: DashboardRepository(),
              eventRepository: EventRepository(),
            ),
          ),
        ],
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        designSize: Size(393, 852),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          title: _isOriginalLayout ? 'Event Countdown' : 'Task Manager',
          theme: ThemeData(
            scaffoldBackgroundColor: ColorName.white,
            colorScheme: ColorScheme.light(
              primary: ColorName.purple,
              secondary: ColorName.lightPurple,
            ),
            fontFamily: FontFamily.dMSans,
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
