import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:only_to_do/features/auth/presentation/cubit/auth_state.dart';
import 'package:only_to_do/features/auth/presentation/widgets/app_logo.dart';
import 'package:only_to_do/features/auth/presentation/widgets/login_form.dart';
import 'package:only_to_do/features/auth/presentation/widgets/sign_up_link.dart';
import 'package:only_to_do/features/auth/presentation/widgets/welcome_text.dart';
import 'package:only_to_do/features/yourevent/presentation/pages/home_page.dart';

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go(HomePage.id);
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App logo
                AppLogo(),
                const Gap(32),
                // Title
                WelcomeText(),
                const Gap(32),
                Text(
                  'Sign in to continue',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Login form
                LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isLoading: state.isLoading,
                  onSignIn: _handleSignIn,
                ),
                Gap(16),
                const SignUpLink(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }
}
