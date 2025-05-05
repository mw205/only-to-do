import 'package:flutter/material.dart';

import '../collect_informations/presentation/informations_view.dart';

class PremiumCheckScreen extends StatelessWidget {
  final bool isPremium;

  static const String id = "/premuim_check";

  const PremiumCheckScreen({super.key, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Feature')),
      body: isPremium ? const SleepQuestionsFlow() : _NonPremiumView(),
    );
  }
}

class _NonPremiumView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Unlock Premium Features',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Get access to advanced sleep tracking and personalized insights for just \$5!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate to in-app purchase logic
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const InAppPurchaseScreen(),
              ));
            },
            child: const Text('Upgrade for \$5'),
          ),
        ],
      ),
    );
  }
}

class InAppPurchaseScreen extends StatelessWidget {
  const InAppPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
