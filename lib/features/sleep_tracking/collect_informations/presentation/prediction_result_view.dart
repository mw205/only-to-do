import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/gen/colors.gen.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../sleep_home_page/presentation/views/sleep_page.dart';

class PredictionResultView extends StatefulWidget {
  const PredictionResultView({super.key, required this.predictionValue});
  static const String id = '/prediction_result_view';
  final double predictionValue;
  @override
  State<PredictionResultView> createState() => _PredictionResultViewState();
}

class _PredictionResultViewState extends State<PredictionResultView>
    with SingleTickerProviderStateMixin {
  late AnimationController valueController;

  Animation<double>? valueAnimation;
  @override
  void initState() {
    valueController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    valueAnimation = Tween<double>(
      begin: 0,
      end: widget.predictionValue,
    ).animate(
      CurvedAnimation(parent: valueController, curve: Curves.easeInCubic),
    );
    valueController.forward();

    super.initState();
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Results are here 🎉',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            const Text(
              'Your predicted sleep quality is:',
              style: TextStyle(fontSize: 18),
            ),
            const Gap(24),
            AnimatedBuilder(
              builder: (context, child) {
                return SizedBox(
                  height: 200.h,
                  width: 200.h,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ColorName.purple.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorName.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 185.h,
                            width: 185.h,
                            child: CircularProgressIndicator(
                              value: valueAnimation!.value,
                              strokeWidth: 27.h,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${(valueAnimation!.value * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorName.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              animation: valueController,
            ),
            SizedBox(
              height: 50.h,
            ),
            const Text(
              'we’re ready ro bring you sweet dreams!',
              style: TextStyle(fontSize: 18),
            ),
            Gap(150.h),
            CustomButton(
              onPressed: () {
                context.pushReplacement(SleepScreen.id);
              },
              buttonText: 'Let’s Go !!',
            ),
          ],
        ),
      ),
    );
  }
}
