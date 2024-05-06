import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReusableContainer extends StatelessWidget {
  final Widget child;
  final double? leftMargin;
  final double? rightMargin;
  final double? topMargin;
  final double? bottomMargin;

  const ReusableContainer({
    super.key,
    required this.child,
    this.leftMargin,
    this.rightMargin,
    this.topMargin,
    this.bottomMargin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: double.infinity,
      margin: EdgeInsets.only(
        left: leftMargin ?? 18.0.w,
        right: rightMargin ?? 18.w,
        top: topMargin ?? 10.h,
        bottom: bottomMargin ?? 10.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.r),
        border: Border.all(
          color: AppColors.CLR_CON_BORDER,
          width: 0.50,
        ),
      ),
      child: child,
    );
  }
}
