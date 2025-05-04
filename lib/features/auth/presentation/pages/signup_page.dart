import 'package:flutter/material.dart';
import 'package:only_to_do/features/auth/presentation/widgets/signup_page_body.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static const String id = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: const SignupPageBody(),
    );
  }
}
