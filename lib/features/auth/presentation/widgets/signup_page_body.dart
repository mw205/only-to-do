import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:only_to_do/features/auth/presentation/cubit/auth_state.dart';
import 'package:only_to_do/features/auth/presentation/widgets/app_logo.dart';
import 'package:only_to_do/features/auth/presentation/widgets/sign_in_link.dart';
import 'package:only_to_do/features/auth/presentation/widgets/signup_form.dart';
import 'package:only_to_do/features/yourevent/presentation/pages/home_page.dart';

class SignupPageBody extends StatefulWidget {
  const SignupPageBody({super.key});

  @override
  State<SignupPageBody> createState() => _SignupPageBodyState();
}

class _SignupPageBodyState extends State<SignupPageBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed(HomePage.id);
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
                const AppLogo(),
                const Gap(32),
                Text(
                  'Create a new account',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const Gap(32),
                SignupForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  isLoading: state.isLoading,
                  onSignUp: _handleSignUp,
                ),
                const Gap(16),
                const SignInLink(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }
}
