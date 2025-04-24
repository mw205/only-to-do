import 'package:flutter/material.dart';
import 'package:only_to_do/core/styles/app_text_styles.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class PrioritySelector extends StatefulWidget {
  const PrioritySelector({super.key});

  @override
  _PrioritySelectorState createState() => _PrioritySelectorState();
}

class _PrioritySelectorState extends State<PrioritySelector> {
  String selectedPriority = 'Low';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Priority',
          style: AppTextStyles.font18Black1Medium,
        ),
        ChoiceChip(
          label: Text('Low'),
          selected: selectedPriority == 'Low',
          selectedColor: ColorName.white,
          labelStyle: TextStyle(
            color: ColorName.green,
          ),
          side: BorderSide(color: ColorName.green),
          onSelected: (bool selected) {
            setState(() {
              selectedPriority = 'Low';
            });
          },
        ),
        ChoiceChip(
          label: Text('Medium'),
          selected: selectedPriority == 'Medium',
          selectedColor: ColorName.white,
          labelStyle: TextStyle(
            color: ColorName.yellow,
          ),
          side: BorderSide(color: ColorName.yellow),
          onSelected: (bool selected) {
            setState(() {
              selectedPriority = 'Medium';
            });
          },
        ),
        ChoiceChip(
          label: Text('High'),
          selected: selectedPriority == 'High',
          selectedColor: ColorName.white,
          labelStyle: TextStyle(
            color: ColorName.red,
          ),
          side: BorderSide(color: ColorName.red),
          onSelected: (bool selected) {
            setState(() {
              selectedPriority = 'High';
            });
          },
        ),
      ],
    );
  }
}
