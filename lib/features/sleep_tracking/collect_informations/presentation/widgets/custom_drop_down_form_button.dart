import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class CustomDropDownFormButton<T> extends StatelessWidget {
  const CustomDropDownFormButton({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.items,
    this.value, // Add this
    this.onChanged,
    this.validator,
  });
  final String label;
  final Widget prefixIcon;
  final T? value; // Add this
  final List<T> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h), // To manage spacing and error text
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: _buildBorder(),
          enabledBorder: _buildBorder(),
          prefixIcon: prefixIcon,
          filled: true,
          fillColor: ColorName.greyBar,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        ),
        icon: const Icon(Icons.keyboard_arrow_down_outlined),
        items: items
            .map((itemValue) => DropdownMenuItem<T>(
                  value: itemValue,
                  child: Text(itemValue.toString()),
                ))
            .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none);
  }
}
