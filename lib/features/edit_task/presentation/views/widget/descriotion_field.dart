import 'package:flutter/material.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final double height;
  final double width;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.all(18),
      child: TextField(
        expands: true,
        maxLines: null,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: const TextStyle(color: ColorName.grey2),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ColorName.grey1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ColorName.grey1),
          ),
        ),
      ),
    );
  }
}
