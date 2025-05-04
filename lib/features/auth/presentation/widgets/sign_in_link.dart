import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInLink extends StatelessWidget {
  const SignInLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
