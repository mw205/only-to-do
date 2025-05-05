import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/core/widgets/custom_button.dart';
import 'package:only_to_do/core/widgets/custom_text_form_field.dart';

import '../../../gen/colors.gen.dart';
import '../utils/age_formatter.dart';

class UserHealthForm extends StatefulWidget {
  const UserHealthForm({super.key});

  static const String id = "/user_health_form";

  @override
  UserHealthFormState createState() => UserHealthFormState();
}

class UserHealthFormState extends State<UserHealthForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController ageController = TextEditingController();
  TextEditingController heartRateController = TextEditingController();
  TextEditingController dailyStepsController = TextEditingController();
  TextEditingController systolicBPController = TextEditingController();
  TextEditingController diastolicBPController = TextEditingController();

  int? age;
  String? gender;
  double sleepDuration = 7.0;
  double physicalActivityLevel = 2.0;
  double stressLevel = 3.0;
  String? bmiCategory;
  int? heartRate;
  int minDailySteps = 500;
  int maxDailySteps = 1000;
  bool hasSleepDisorder = false;
  int? systolicBP;
  int? diastolicBP;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Health Form')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          children: [
            const SizedBox(height: 16),

            // Age
            CustomTextFormField(
              labelText: 'Age',
              prefixIcon: Icons.calendar_today,
              controller: ageController,
              keyboardType: TextInputType.number,
              formatters: [AgeFormatter()],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }

                if (int.tryParse(value) != null && int.parse(value) < 8) {
                  return 'Anyone over 8 years old please enter your age';
                }
                return null;
              },
            ),

            CustomDropDownFormButton<String>(
              label: "Gender",
              items: ['Male', 'Female'],
              onChanged: (value) => gender = value,
              prefixIcon: Icon(Icons.person),
              validator: (value) =>
                  value == null ? 'Please select your gender' : null,
            ),
            const SizedBox(height: 16),

            // Physical Activity Level

            // BMI Category
            CustomDropDownFormButton<String>(
              label: 'BMI Category',
              items: ['Underweight', 'Normal', 'Overweight', 'Obese'],
              onChanged: (value) => gender = value,
              prefixIcon: Icon(Icons.scale),
              validator: (value) =>
                  value == null ? 'Please select your BMI category' : null,
            ),

            const SizedBox(height: 16),

            CustomTextFormField(
              prefixIcon: Icons.favorite,
              controller: heartRateController,
              labelText: "Heart Rate (bpm)",
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Heart rate is required';
                }
                final hr = int.tryParse(value);
                if (hr == null) return 'Invalid number';
                if (hr < 30 || hr > 200) {
                  return 'Heart rate should be between 30 and 200';
                }
                return null;
              },
            ),
            CustomTextFormField(
              controller: systolicBPController,
              labelText: 'Systolic BP (mmHg)',
              prefixIcon: Icons.bloodtype,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Systolic BP is required';
                }
                final sbp = int.tryParse(value);
                if (sbp == null) return 'Invalid number';
                if (sbp < 70 || sbp > 250) {
                  return 'Enter a value between 70 and 250';
                }
                return null;
              },
            ),
            CustomTextFormField(
              controller: systolicBPController,
              labelText: 'Diastolic BP (mmHg)',
              prefixIcon: Icons.bloodtype,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Diastolic BP is required';
                }
                final dbp = int.tryParse(value);
                if (dbp == null) return 'Invalid number';
                if (dbp < 40 || dbp > 150) {
                  return 'Enter a value between 40 and 150';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text('Daily Steps range: '),
            RangeSlider(
              values: RangeValues(
                  minDailySteps.toDouble(), maxDailySteps.toDouble()),
              min: 500,
              max: 10000,
              divisions: 10,
              labels: RangeLabels(
                  minDailySteps.toString(), maxDailySteps.toString()),
              onChanged: (value) => setState(() {
                minDailySteps = value.start.ceil();
                maxDailySteps = value.end.ceil();
              }),
            ),
            // Blood Pressure
            const SizedBox(height: 16),

            Text(
                'Physical Activity Level: ${physicalActivityLevel.toStringAsFixed(1)}'),
            Slider(
              value: physicalActivityLevel,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              inactiveColor: ColorName.purple.withValues(alpha: 0.2),
              label: physicalActivityLevel.toStringAsFixed(1),
              onChanged: (value) =>
                  setState(() => physicalActivityLevel = value),
            ),
            const SizedBox(height: 16),

            // Stress Level
            Text('Stress Level: ${stressLevel.toStringAsFixed(1)}'),
            Slider(
              inactiveColor: ColorName.purple.withValues(alpha: 0.2),
              value: stressLevel,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              label: stressLevel.toStringAsFixed(1),
              onChanged: (value) => setState(() => stressLevel = value),
            ),
            const SizedBox(height: 16),

            CustomButton(
              onPressed: _submitForm,
              buttonText: 'Submit',
            )
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Process the collected data
      log(
        {
          'Age': age,
          'Gender': gender,
          'Sleep Duration': sleepDuration,
          'Physical Activity Level': physicalActivityLevel,
          'Stress Level': stressLevel,
          'BMI Category': bmiCategory,
          'Heart Rate': heartRate,
          'Daily Steps': minDailySteps,
          'Sleep Disorder': hasSleepDisorder,
          'Systolic BP': systolicBP,
          'Diastolic BP': diastolicBP,
        }.toString(),
      );
    }
  }
}

class CustomDropDownFormButton<T> extends StatelessWidget {
  const CustomDropDownFormButton({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.items,
    this.onChanged,
    this.validator,
  });
  final String label;
  final Widget prefixIcon;

  final List<T> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorName.greyBar,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 0),
          labelText: label,
          border: InputBorder.none,
          prefixIcon: prefixIcon,
        ),
        icon: Padding(
          padding: EdgeInsetsDirectional.only(
            bottom: 24,
            end: 16,
            top: 0,
          ),
          child: const Icon(Icons.keyboard_arrow_down_outlined),
        ),
        items: items
            .map((value) => DropdownMenuItem<T>(
                  value: value,
                  child: Text(value.toString()),
                ))
            .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
