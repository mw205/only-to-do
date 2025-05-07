import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool enabled;
  final InputDecoration? decoration;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? dateFormat;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    this.label = 'Select Date',
    this.hint,
    this.icon = Icons.calendar_today,
    this.enabled = true,
    this.decoration,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    // Format the date
    final formattedDate = DateFormat(
      dateFormat ?? 'MMM dd, yyyy',
    ).format(selectedDate);

    return InkWell(
      onTap: enabled ? () => _selectDate(context) : null,
      child: InputDecorator(
        decoration:
            decoration ??
            InputDecoration(
              labelText: label,
              hintText: hint,
              border: const OutlineInputBorder(),
              prefixIcon: icon != null ? Icon(icon) : null,
              enabled: enabled,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formattedDate),
            if (enabled)
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // Primary colors
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              // Surface colors
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }
}
