import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class noResult extends StatelessWidget {
  const noResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 200.h,
            child: SvgPicture.asset(IMG_NOTFOUND, fit: BoxFit.fitWidth),
          ),
          Padding(
              padding: EdgeInsets.all(20.0.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: 80.h),
                  MyAppText(
                    data: 'Oops!',
                    size: 18.0.sp,
                    color: CLR_PRIMARY,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(height: 20.h),
                  MyAppText(
                      data:
                          "It seems there is a problem fetching the\nbill  at the moment. Kindly try again later.",
                      size: 13.0.sp,
                      color: CLR_PRIMARY,
                      weight: FontWeight.bold,
                      textAlign: TextAlign.justify),
                  // SizedBox(height: 80.h),
                ],
              )),
        ],
      ),
    ));
  }
}
