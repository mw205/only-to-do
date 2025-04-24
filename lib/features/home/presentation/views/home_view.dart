import 'package:flutter/material.dart';
import 'package:only_to_do/features/home/presentation/views/widget/home_view_body.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String id = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Tasks",
      ),
      body: HomeViewBody(),
    );
  }
}
