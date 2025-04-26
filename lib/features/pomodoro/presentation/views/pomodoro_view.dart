import 'package:flutter/material.dart';
import 'package:only_to_do/core/widgets/custom_app_bar.dart';
import 'package:only_to_do/features/pomodoro/presentation/views/widgets/pomodoro_view_body.dart';

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key});
  static String id = "/pomodoro";

  @override
  State<PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: "Pomodoro", scaffoldKey: _scaffoldKey),
      body: PomodoroViewBody(),
    );
  }
}
