import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/core/widgets/custom_button.dart';
import 'package:only_to_do/core/widgets/custom_text_form_field.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/presentation/widgets/custom_drop_down_form_button.dart';
import 'package:only_to_do/features/sleep_tracking/core/cubit/sleep_tracking_cubit.dart';

import '../data/models/predict_sleep_quality_request_body.dart';
// (Keep your AgeFormatter if you use it)
import '../utils/age_formatter.dart';
import '../utils/sleep_data_utils.dart';
import 'sleep_prediction_result_page.dart'; // Import the utils

class UserHealthForm extends StatefulWidget {
  const UserHealthForm({super.key});
  static const String id = "/user_health_form";

  @override
  UserHealthFormState createState() => UserHealthFormState();
}

class UserHealthFormState extends State<UserHealthForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  late TextEditingController ageController;
  late TextEditingController physicalActivityController; // For minutes
  late TextEditingController heartRateController;
  late TextEditingController dailyStepsController;
  late TextEditingController systolicBPController;
  late TextEditingController diastolicBPController;

  // State variables for dropdowns and sliders
  String? genderValue; // 'Male' or 'Female'
  String? bmiCategoryValue; // 'Underweight', 'Normal', etc.

  PredictSleepQualityRequestBody? _initialRequestBody;

  @override
  void initState() {
    super.initState();
    ageController = TextEditingController();
    physicalActivityController = TextEditingController();
    heartRateController = TextEditingController();
    dailyStepsController = TextEditingController();
    systolicBPController = TextEditingController();
    diastolicBPController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SleepTrackingCubit>();
      if (cubit.requestBody != null) {
        setState(() {
          _initialRequestBody = cubit.requestBody;
        });
      } else {
        _initialRequestBody = PredictSleepQualityRequestBody(
            age: 0,
            gender: 0,
            sleepDuration: 0,
            physicalActivityLevel: 0,
            stressLevel: 5,
            bmiCategory: 1,
            heartRate: 0,
            dailySteps: 0,
            sleepDisorder: 0,
            systolicBP: 0,
            diastolicBP: 0); // Create a default to prevent null errors
      }
    });
  }

  @override
  void dispose() {
    ageController.dispose();
    physicalActivityController.dispose();
    heartRateController.dispose();
    dailyStepsController.dispose();
    systolicBPController.dispose();
    diastolicBPController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Important if using FormField onSaved

      if (_initialRequestBody == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Error: Cannot submit form. Please restart the flow.')),
        );
        return;
      }

      final cubit = context.read<SleepTrackingCubit>();

      final updatedRequestBody = _initialRequestBody!.copyWith(
        age: int.tryParse(ageController.text) ?? _initialRequestBody!.age,
        gender: SleepDataUtils.mapGenderStringToInt(genderValue),
        physicalActivityLevel:
            double.tryParse(physicalActivityController.text) ??
                _initialRequestBody!.physicalActivityLevel,
        bmiCategory: SleepDataUtils.mapBmiCategoryStringToInt(bmiCategoryValue),
        heartRate: int.tryParse(heartRateController.text) ??
            _initialRequestBody!.heartRate,
        dailySteps: int.tryParse(dailyStepsController.text) ??
            _initialRequestBody!.dailySteps,
        systolicBP: int.tryParse(systolicBPController.text) ??
            _initialRequestBody!.systolicBP,
        diastolicBP: int.tryParse(diastolicBPController.text) ??
            _initialRequestBody!.diastolicBP,
      );

      cubit.updateRequestBody(updatedRequestBody);
      cubit.predictSleepQuality();

      log('Final Request Body: ${updatedRequestBody.toJson()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Health data submitted! Predicting quality...')),
      );
      context.push(SleepPredictionResultPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Health Details')),
      body: _initialRequestBody == null
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading if initial data not ready
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                children: [
                  CustomTextFormField(
                    labelText: 'Age',
                    prefixIcon: Icons.calendar_today,
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    formatters: [
                      AgeFormatter(),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      final age = int.tryParse(value);
                      if (age == null) return 'Invalid age';
                      if (age < 8 || age > 120) {
                        return 'Age must be between 8 and 120';
                      }
                      return null;
                    },
                  ),
                  Gap(16.h),
                  CustomDropDownFormButton<String>(
                    label: "Gender",
                    value: genderValue,
                    items: const ['Male', 'Female'],
                    onChanged: (value) => setState(() => genderValue = value),
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) =>
                        value == null ? 'Please select your gender' : null,
                  ),
                  Gap(16.h),
                  CustomTextFormField(
                    labelText: 'Physical Activity Level (minutes/day)',
                    prefixIcon: Icons.fitness_center,
                    controller: physicalActivityController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    formatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,1}'))
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      final level = double.tryParse(value);
                      if (level == null) return 'Invalid number';
                      if (level < 0 || level > 1440) {
                        return 'Minutes must be 0-1440'; // Max 24 hours
                      }
                      return null;
                    },
                  ),
                  Gap(16.h),
                  CustomDropDownFormButton<String>(
                    label: 'BMI Category',
                    value: bmiCategoryValue,
                    items: const [
                      'Underweight',
                      'Normal',
                      'Overweight',
                      'Obese'
                    ],
                    onChanged: (value) =>
                        setState(() => bmiCategoryValue = value),
                    prefixIcon: const Icon(Icons.scale),
                    validator: (value) => value == null
                        ? 'Please select your BMI category'
                        : null,
                  ),
                  Gap(16.h),
                  CustomTextFormField(
                    prefixIcon: Icons.favorite,
                    controller: heartRateController,
                    labelText: "Heart Rate (bpm)",
                    keyboardType: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Heart rate is required';
                      }
                      final hr = int.tryParse(value);
                      if (hr == null) return 'Invalid number';
                      if (hr < 30 || hr > 220) {
                        return 'Heart rate should be 30-220';
                      }
                      return null;
                    },
                  ),
                  Gap(16.h),
                  CustomTextFormField(
                    labelText: 'Daily Steps',
                    prefixIcon: Icons.directions_walk,
                    controller: dailyStepsController,
                    keyboardType: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Daily steps are required';
                      }
                      final steps = int.tryParse(value);
                      if (steps == null) return 'Invalid number';
                      if (steps < 0 || steps > 50000) {
                        return 'Steps should be 0-50000';
                      }
                      return null;
                    },
                  ),
                  Gap(16.h),
                  CustomTextFormField(
                    controller: systolicBPController,
                    labelText: 'Systolic BP (mmHg)',
                    prefixIcon: Icons.bloodtype,
                    keyboardType: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
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
                  Gap(16.h),
                  CustomTextFormField(
                    controller: diastolicBPController, // Corrected controller
                    labelText: 'Diastolic BP (mmHg)',
                    prefixIcon: Icons.bloodtype_outlined,
                    keyboardType: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
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
                  Gap(24.h),
                  CustomButton(
                    onPressed: _submitForm,
                    buttonText: 'Get Sleep Quality Prediction',
                  ),
                  Gap(20.h),
                ],
              ),
            ),
    );
  }
}
