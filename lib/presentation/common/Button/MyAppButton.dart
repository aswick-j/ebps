import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

MyAppButton({
  required final VoidCallback onPressed,
  final String? buttonText,
  final Color? buttonTxtColor,
  final Color? buttonBorderColor,
  final Color? buttonColor,
  final double? buttonTextSize,
  final double? buttonSizeX,
  final double? buttonSizeY,
  buttonTextWeight,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(
        side: BorderSide(
          width: 1.5,
          color: buttonBorderColor ?? Colors.transparent,
          style: BorderStyle.solid,
        ),
      ),
      backgroundColor: buttonColor,
      minimumSize: Size(buttonSizeX ?? 10.h, buttonSizeY ?? 27.w),
    ),
    child: Text(
      buttonText!,
      style: TextStyle(
        fontSize: buttonTextSize ?? 10.sp,
        fontWeight: buttonTextWeight ?? FontWeight.w500,
        color: buttonTxtColor,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
