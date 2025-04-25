import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth/auth_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showLogoutButton;
  final List<Widget>? actions;
  final double elevation;
  final Color? backgroundColor;
  final Widget? leading;
  final Widget? titleWidget;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showLogoutButton = false,
    this.actions,
    this.elevation = 0,
    this.backgroundColor,
    this.leading,
    this.titleWidget,
    this.bottom,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final combinedActions = <Widget>[];

    if (actions != null) {
      combinedActions.addAll(actions!);
    }

    if (showLogoutButton) {
      combinedActions.add(
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _showLogoutConfirmation(context),
        ),
      );
    }

    return AppBar(
      title: titleWidget ?? Text(title),
      leading:
          showBackButton
              ? leading ??
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).pop(),
                  )
              : null,
      actions: combinedActions,
      elevation: elevation,
      backgroundColor: backgroundColor,
      centerTitle: true,
      bottom: bottom,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthCubit>().signOut();
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    bottom == null
        ? kToolbarHeight
        : kToolbarHeight + bottom!.preferredSize.height,
  );
}
