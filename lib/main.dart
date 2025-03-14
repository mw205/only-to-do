import 'package:flutter/material.dart';
import 'package:only_to_do/core/routes/app_router.dart';
import 'package:only_to_do/gen/colors.gen.dart';

void main() {
  runApp(const OnlyToDo());
}

class OnlyToDo extends StatelessWidget {
  const OnlyToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
    );
  }
}
