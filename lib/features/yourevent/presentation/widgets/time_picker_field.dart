import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerField extends StatelessWidget {
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool enabled;
  final InputDecoration? decoration;

  const TimePickerField({
    super.key,
    required this.selectedTime,
    required this.onTimeChanged,
    this.label = 'Select Time',
    this.hint,
    this.icon = Icons.access_time,
    this.enabled = true,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    // Convert TimeOfDay to formatted string
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    final formattedTime = DateFormat('h:mm a').format(dateTime);

    return InkWell(
      onTap: enabled ? () => _selectTime(context) : null,
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
            Text(formattedTime),
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
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

    if (picked != null && picked != selectedTime) {
      onTimeChanged(picked);
    }
  }
}
