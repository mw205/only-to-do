import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/core/widgets/custom_button.dart';

import 'in_app_purchase_screen.dart';

class NonPremiumView extends StatelessWidget {
  const NonPremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Subscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Unlock Premium Features',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            const Text(
              'Get access to advanced sleep tracking and personalized insights for just \$5!',
              textAlign: TextAlign.center,
            ),
            const Gap(32),
            CustomButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return InAppPurchaseBottomSheet();
                  },
                );
              },
              buttonText: 'Upgrade for \$5',
            )
          ],
        ),
      ),
    );
  }
}
