// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/features/sleep_tracking/premium_check/presentation/pages/non_premium_view.dart';
import 'package:only_to_do/features/sleep_tracking/sleep_home_page/presentation/views/sleep_page.dart';
import 'package:only_to_do/features/yourevent/services/storage_service.dart';

import '../../../collect_informations/presentation/informations_view.dart';

class PremiumCheckScreen extends StatefulWidget {
  final bool isPremium;

  static const String id = "/premuim_check";

  const PremiumCheckScreen({
    super.key,
    required this.isPremium,
  });

  @override
  State<PremiumCheckScreen> createState() => _PremiumCheckScreenState();
}

class _PremiumCheckScreenState extends State<PremiumCheckScreen> {
  @override
  void didChangeDependencies() async {
    if (await goToSleepScreen()) {
      context.pushReplacement(SleepScreen.id);
    }
    super.didChangeDependencies();
  }

  Future<bool> goToSleepScreen() async {
    StorageService storageService = StorageService();
    return storageService.sleepDataExists();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isPremium ? const SleepQuestionsFlow() : NonPremiumView();
  }
}
