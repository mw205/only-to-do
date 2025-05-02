import 'package:flutter/material.dart';

enum CustomButtonType { primary, secondary, outline, text, success, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final CustomButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = CustomButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height = 50,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Determine button style based on type
    ButtonStyle buttonStyle;
    switch (type) {
      case CustomButtonType.primary:
        buttonStyle = ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: colorScheme.primary,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
        break;

      case CustomButtonType.secondary:
        buttonStyle = ElevatedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          backgroundColor: colorScheme.primaryContainer,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
        break;

      case CustomButtonType.outline:
        buttonStyle = OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: padding,
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
        break;

      case CustomButtonType.text:
        buttonStyle = TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
        break;

      case CustomButtonType.success:
        buttonStyle = ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
        break;

      case CustomButtonType.danger:
        buttonStyle = ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
        break;
    }

    // Create button content
    Widget buttonContent;
    if (isLoading) {
      buttonContent = SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color:
              type == CustomButtonType.outline || type == CustomButtonType.text
                  ? colorScheme.primary
                  : Colors.white,
          strokeWidth: 2,
        ),
      );
    } else if (icon != null) {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    } else {
      buttonContent = Text(text, style: textStyle);
    }

    // Create button widget based on type
    Widget button;
    switch (type) {
      case CustomButtonType.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
        break;

      case CustomButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
        break;

      default:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
        break;
    }

    // Apply width constraints
    if (isFullWidth) {
      return SizedBox(width: double.infinity, height: height, child: button);
    } else if (width != null) {
      return SizedBox(width: width, height: height, child: button);
    } else {
      return SizedBox(height: height, child: button);
    }
  }
}
