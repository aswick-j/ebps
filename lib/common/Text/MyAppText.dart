import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

MyAppText(
    {@required data,
    color,
    @required size,
    weight,
    decorate,
    align,
    maxline,
    lineHeight,
    flowType,
    fntStyle,
    textAlign}) {
  return Text(
    data ?? '',
    softWrap: false,
    overflow: flowType ?? TextOverflow.ellipsis,
    textAlign: align ?? TextAlign.left,
    maxLines: maxline ?? 2,
    style: TextStyle(
      color: color ?? AppColors.CLR_PRIMARY,
      fontSize: size ?? 23.sp,
      height: lineHeight ?? 0,
      fontWeight: weight ?? FontWeight.normal,
      decoration: decorate ?? TextDecoration.none,
      fontStyle: fntStyle ?? FontStyle.normal,
    ),
  );
}
