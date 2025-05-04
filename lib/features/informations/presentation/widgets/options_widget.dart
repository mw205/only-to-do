import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:only_to_do/features/informations/data/option_model.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({
    super.key,
    required this.options,
    required this.onSelectOption,
  });

  final List<OptionModel> options;
  final void Function(OptionModel) onSelectOption;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 8.h),
            child: GestureDetector(
              onTap: () {
                onSelectOption(options[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff222239),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          top: 14.h,
                          bottom: 10.h,
                          start: 15.w,
                        ),
                        child: SizedBox(
                          width: 28.w,
                          height: 28.h,
                          child: options[index].image,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          options[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorName.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
