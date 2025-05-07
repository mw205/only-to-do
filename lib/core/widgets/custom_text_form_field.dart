import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final bool obscureText;
  final List<TextInputFormatter>? formatters;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType = TextInputType.text,
    required this.validator,
    this.obscureText = false,
    this.formatters,
  });

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isPasswordVisible = false;
  String? validationMessage = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorName.greyBar,
            borderRadius: BorderRadius.circular(
              16.r,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorName.black.withValues(
                  alpha: 0.05,
                ),
                blurRadius: 2,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: TextFormField(
            inputFormatters: widget.formatters,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 0),
              labelText: widget.labelText,
              border: InputBorder.none,
              prefixIcon: Icon(widget.prefixIcon),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                        widget.onSuffixIconPressed?.call();
                      },
                    )
                  : null,
            ),
            obscureText: widget.obscureText ? !_isPasswordVisible : false,
            validator: (value) {
              setState(() {
                validationMessage = widget.validator(value);
              });
              return validationMessage;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(validationMessage != null ? 0 : 8.0),
          child: Text(
            validationMessage ?? '',
            style: const TextStyle(
              color: ColorName.red,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
