import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/features/sleep_tracking/sleep_home_page/presentation/cubit/sleep_home_cubit.dart';
import 'package:only_to_do/features/sleep_tracking/sleep_home_page/presentation/widgets/info_column.dart';
import 'package:only_to_do/features/sleep_tracking/sleep_home_page/presentation/widgets/sleep_cycle.dart';
import 'package:only_to_do/features/sleep_tracking/sleep_home_page/presentation/widgets/user_info_bar.dart';
import 'package:only_to_do/features/sleep_tracking/sleep_home_page/presentation/widgets/user_info_bar_skeleton.dart';

import '../../../../../gen/colors.gen.dart';

class SleepScreenBody extends StatelessWidget {
  const SleepScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoBlocConsumer(),
            const Gap(30),

            // Sleep Cycle Display
            SleepCycle(),
            const Gap(25),

            // Start Sleep Button
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6750A4), // Lighter purple
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Start sleep',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const Gap(30),

            // Bed time, Alarm, Siesta Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(
                    15.h,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoColumn(
                      icon: Icons.king_bed_outlined,
                      title: 'Bed time',
                      subtitle: '22:00',
                      iconColor: const Color(0xFFE063FF),
                    ),
                    VerticalDivider(
                      color: Colors.black.withValues(alpha: 0.7),
                      thickness: 5,
                      width: 50.sp,
                    ),
                    InfoColumn(
                      icon: Icons.alarm,
                      title: 'Alarm',
                      subtitle: '7:00 Am',
                      iconColor: const Color(0xFFE063FF),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(30),

            // Sleeping Tips Section
            const Text(
              'Sleeping Tips',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  15.h,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage stress: Find healthy ways to cope with stress, such as meditation or deep breathing exercises.',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorName.purple,
                            height: 1.4,
                          ),
                        ),
                        const Gap(10),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  ColorName.purple.withValues(alpha: 0.7),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text(
                            'Find out',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  // Placeholder for the image in the card
                  // In a real app, you'd use an Image.asset or Image.network
                  // For simplicity, using a colored container or an icon
                  Opacity(
                    opacity: 0.7, // Making the placeholder image a bit subtle
                    child: Image.network(
                      'https://placehold.co/80x80/FFC0CB/000000?text=Tip&font=Inter', // Placeholder pinkish image
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.lightbulb_outline,
                          size: 50,
                          color: Color(0xFFE063FF)),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(), // Pushes bottom nav to the bottom
          ],
        ),
      ),
    );
  }
}

class UserInfoBlocConsumer extends StatelessWidget {
  const UserInfoBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SleepHomeCubit, SleepHomeState>(
      listenWhen: (previous, current) => current is UserInfoLoading,
      listener: (context, state) {
        if (state is UserInfoFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is UserInfoFetched) {
          return UserInfoBar(userModel: state.user);
        } else {
          return UserInfoBarSkeleton();
        }
      },
    );
  }
}
