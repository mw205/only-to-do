import 'package:flutter/material.dart';
import 'package:only_to_do/core/widgets/drawer_body.dart';
import 'package:only_to_do/features/home/presentation/views/widget/home_view_body.dart';

import '../../../../core/widgets/custom_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String id = "/home";

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: "Tasks",
        scaffoldKey: scaffoldKey,
      ),
      drawer: Drawer(
        child: DrawerBody(),
      ),
      body: HomeViewBody(),
    );
  }
}
