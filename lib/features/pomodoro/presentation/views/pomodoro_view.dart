import 'package:flutter/material.dart';
import 'package:only_to_do/core/widgets/custom_app_bar.dart';
import 'package:only_to_do/features/pomodoro/presentation/views/widgets/pomodoro_view_body.dart';

class PomodoroView extends StatelessWidget {
  const PomodoroView({super.key});
  static String id = "/pomodoro";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Pomodoro"),
      body: PomodoroViewBody(),
    );
  }
}
