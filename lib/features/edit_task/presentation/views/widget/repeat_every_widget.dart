import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:only_to_do/core/styles/app_text_styles.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class RepeatEveryWidget extends StatefulWidget {
  const RepeatEveryWidget({super.key});

  @override
  State<RepeatEveryWidget> createState() => _RepeatEveryWidgetState();
}

class _RepeatEveryWidgetState extends State<RepeatEveryWidget> {
  int repeatNumber = 2;
  String repeatUnit = 'Weeks';
  final List<String> units = ['Days', 'Weeks', 'Months'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Repeat every',
              style: AppTextStyles.font18Black1Medium,
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorName.purple),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(color: ColorName.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: TextStyle(color: ColorName.white),
                ),
                onChanged: (value) {
                  setState(() {
                    repeatNumber = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            Gap(12.sp),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: repeatUnit,
                  dropdownColor: ColorName.purple,
                  iconEnabledColor: Colors.white,
                  items: units.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      repeatUnit = newValue!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
