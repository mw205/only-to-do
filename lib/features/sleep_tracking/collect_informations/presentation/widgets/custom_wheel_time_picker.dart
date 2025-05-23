import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wheel_picker/wheel_picker.dart';

import '../../../../../gen/colors.gen.dart';

class CustomWheelTimePicker extends StatefulWidget {
  const CustomWheelTimePicker({super.key, this.onSelectTime});
  final void Function(Duration duration)? onSelectTime;
  @override
  State<CustomWheelTimePicker> createState() => _CustomWheelTimePickerState();
}

class _CustomWheelTimePickerState extends State<CustomWheelTimePicker> {
  final WheelPickerController _minutesWheel = WheelPickerController(
    itemCount: 60,
    initialIndex: 30,
  );
  late final _hoursWheel = WheelPickerController(
    itemCount: 12,
    initialIndex: 8,
  );

  late final _amPmWheel = WheelPickerController(
    itemCount: 2,
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 26.sp,
      height: 1.5,
      color: ColorName.grey2,
    );
    final wheelStyle = WheelPickerStyle(
      itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
      squeeze: 1,
      diameterRatio: .8,
      surroundingOpacity: .25,
      magnification: 1,
    );
    final amPmWheel = Expanded(
      child: WheelPicker(
        selectedIndexColor: Colors.white,
        builder: (context, index) {
          return Text(["AM", "PM"][index], style: textStyle);
        },
        controller: _amPmWheel,
        looping: false,
        onIndexChanged: (index, interactionType) {
          _handleTimeChange();
        },
        style: wheelStyle.copyWith(
          shiftAnimationStyle: const WheelShiftAnimationStyle(
            duration: Duration(seconds: 1),
            curve: Curves.bounceOut,
          ),
        ),
      ),
    );
    Widget hoursBuilder(BuildContext context, int index) {
      return Text("${index + 1}".padLeft(2, '0'), style: textStyle);
    }

    Widget minutesBuilder(BuildContext context, int index) {
      return Text("$index".padLeft(2, '0'), style: textStyle);
    }

    final timeWheels = <Widget>[
      for (final wheelController in [_hoursWheel, _minutesWheel])
        Expanded(
          child: WheelPicker(
            onIndexChanged: (index, WheelPickerInteractionType type) {
              _handleTimeChange();
            },
            builder:
                wheelController == _hoursWheel ? hoursBuilder : minutesBuilder,
            controller: wheelController,
            looping: wheelController == _minutesWheel,
            style: wheelStyle,
            selectedIndexColor: Colors.white,
          ),
        ),
    ];
    timeWheels.insert(
        1, Text(":", style: textStyle.copyWith(color: Colors.white)));
    return Center(
      child: SizedBox(
        width: 200.w,
        height: 200.w,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _centerBar(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  ...timeWheels,
                  const Gap(6.0),
                  amPmWheel,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _centerBar(BuildContext context) {
    return Center(
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: ColorName.purple,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  void _handleTimeChange() {
    int hour = _hoursWheel.selected + 1;
    final int minute = _minutesWheel.selected;
    final bool isAm = _amPmWheel.selected == 0;

    int hour24;
    if (isAm) {
      hour24 = (hour == 12) ? 0 : hour;
    } else {
      // PM
      hour24 = (hour == 12) ? 12 : hour + 12;
    }

    Duration duration = Duration(
      hours: hour24,
      minutes: minute,
    );

    widget.onSelectTime?.call(duration);
  }
}
