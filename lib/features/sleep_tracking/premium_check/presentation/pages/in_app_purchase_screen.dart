import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/core/widgets/custom_button.dart';
import 'package:only_to_do/features/yourevent/services/firebase_service.dart';

import '../../../../../gen/assets.gen.dart';

class InAppPurchaseBottomSheet extends StatelessWidget {
  static const String id = '/in_app_purchase_screen';
  const InAppPurchaseBottomSheet({super.key});
  Future<void> _simulatePurchase() async {
    FirebaseService service = FirebaseService();

    final userId = service.currentUserId;
    if (userId != null) {
      service.firestore
          .collection('users')
          .doc(userId)
          .update({'isPremium': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Assets.animation.upgrade.lottie(
              height: 200,
            ),
            const Gap(32),
            const Text(
              'Get access to advanced sleep tracking and personalized insights for just \$5!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const Gap(32),
            CustomButton(
              onPressed: () async {
                await _simulatePurchase();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Premium activated!'),
                    ),
                  );
                  context.pop();

                  // Return to the previous screen
                }
              },
              buttonText: 'Activate Premium',
            ),
          ],
        ),
      ),
    );
  }
}
