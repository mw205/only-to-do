import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:only_to_do/core/data/models/user_model.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class UserInfoBar extends StatelessWidget {
  const UserInfoBar({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Good Morning ${userModel.name.split(" ").first}!',
              style: TextStyle(
                fontSize: 16,
                color: ColorName.purple,
              ),
            ),
          ],
        ),
        // Placeholder for profile icon
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                userModel.photoUrl ??
                    'https://placehold.co/50x50/6666FF/FFFFFF?text=L&font=Inter',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ), // Fallback icon
        ),
      ],
    );
  }
}
