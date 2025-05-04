import 'package:flutter/material.dart';
import 'package:only_to_do/features/auth/presentation/widgets/login_page_body.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPageBody(),
    );
  }
}
