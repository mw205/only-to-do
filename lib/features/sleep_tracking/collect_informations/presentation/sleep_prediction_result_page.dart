import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/sleep_tracking/core/cubit/sleep_tracking_cubit.dart';
import 'package:only_to_do/gen/assets.gen.dart';

import 'prediction_result_view.dart';

class SleepPredictionResultPage extends StatelessWidget {
  const SleepPredictionResultPage({super.key});
  static const String id = '/sleep_prediction_result_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SleepTrackingCubit, SleepTrackingState>(
        listener: (context, state) {
          if (state is SleepTrackingSuccess) {
            context.pushReplacement(
              PredictionResultView.id,
              extra: state.result,
            );
          }
          if (state is SleepTrackingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SleepPredictionResultLoading();
        },
      ),
    );
  }
}

class SleepPredictionResultLoading extends StatelessWidget {
  const SleepPredictionResultLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 16.h,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Our AI model is working on your informations 🎉',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Assets.animation.analysis.lottie(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.w),
            child: Text(
              'Please wait a moment while we process your data.',
              style: TextStyle(
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
