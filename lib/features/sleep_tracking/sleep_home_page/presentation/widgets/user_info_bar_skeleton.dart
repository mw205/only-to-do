import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoBarSkeleton extends StatelessWidget {
  const UserInfoBarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // base color
      highlightColor: Colors.grey[100]!, // highlight color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100, // adjust the width
                height: 20, // adjust the height
                decoration: BoxDecoration(
                  color: Colors.grey[300], // color
                  borderRadius: BorderRadius.circular(5), // border radius
                ),
              ),
              const SizedBox(height: 10), // add some space
              Container(
                width: 150, // adjust the width
                height: 20, // adjust the height
                decoration: BoxDecoration(
                  color: Colors.grey[300], // color
                  borderRadius: BorderRadius.circular(5), // border radius
                ),
              ),
            ],
          ),
          // Add other skeleton elements as needed
        ],
      ),
    );
  }
}