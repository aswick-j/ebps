import 'package:ebps/constants/assets.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpcomingDuesContainer extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String dateText;
  final String buttonText;
  final String amount;
  final String iconPath;
  final Color containerBorderColor;
  final Color buttonColor;
  final Color buttonTxtColor;
  final FontWeight buttonTextWeight;
  final Color? buttonBorderColor;

  UpcomingDuesContainer({
    required this.titleText,
    required this.subtitleText,
    required this.dateText,
    required this.buttonText,
    required this.amount,
    required this.iconPath,
    required this.containerBorderColor,
    required this.buttonColor,
    required this.buttonTxtColor,
    required this.buttonBorderColor,
    required this.buttonTextWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // width: double.infinity,
      elevation: 0.0,

      margin:
          EdgeInsets.only(left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(8.0.r),

      //   border: Border.all(
      //     color: containerBorderColor,
      //     width: 2.0,
      //   ),
      // ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.r),
        side: BorderSide(
          color: containerBorderColor,
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 8.w, right: 15.w, top: 4.h),
            leading: Container(
              width: 45.w,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: SvgPicture.asset(iconPath),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleText,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff191919),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SvgPicture.asset(ICON_REFRESH),
                ],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          subtitleText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff808080),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1b438b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 10.h,
            thickness: 1,
            indent: 10.w,
            endIndent: 10.w,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      ICON_CALENDAR,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      dateText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff808080),
                      ),
                    ),
                  ],
                ),
                MyAppButton(
                    onPressed: () {},
                    buttonText: buttonText,
                    buttonTxtColor: buttonTxtColor,
                    buttonBorderColor: buttonBorderColor,
                    buttonColor: buttonColor,
                    buttonSizeX: 10.h,
                    buttonSizeY: 25.w,
                    buttonTextSize: 10.sp,
                    buttonTextWeight: FontWeight.w500),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
