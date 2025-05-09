import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class InfoColumn extends StatelessWidget {
  const InfoColumn({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    this.iconText,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final String? iconText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (iconText != null)
              Text(iconText!,
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold))
            else
              Icon(icon, color: iconColor, size: 20),
            const Gap(5),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: ColorName.purple.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const Gap(4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorName.purple,
          ),
        ),
      ],
    );
  }
}
