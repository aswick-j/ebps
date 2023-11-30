import 'package:ebps/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BillerDetailsContainer extends StatelessWidget {
  String icon;
  String billerName;
  String categoryName;
  BillerDetailsContainer(
      {super.key,
      required this.icon,
      required this.billerName,
      required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0.h),
      child: Column(children: [
        Container(
          width: 40.w,
          height: 40.h,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: SvgPicture.asset(icon),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          billerName,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xff1b438b),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          categoryName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xff808080),
            height: 26 / 16,
          ),
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
