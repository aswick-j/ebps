import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MainContainer extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String subtitleText2;
  final String dateText;
  final String buttonText;
  final String amount;
  final String iconPath;
  final Color containerBorderColor;
  final Color buttonColor;
  final Color buttonTxtColor;
  final FontWeight buttonTextWeight;
  final Color? buttonBorderColor;
  final VoidCallback onPressed;

  const MainContainer({
    required this.titleText,
    required this.subtitleText,
    required this.subtitleText2,
    required this.dateText,
    required this.buttonText,
    required this.amount,
    required this.iconPath,
    required this.containerBorderColor,
    required this.buttonColor,
    required this.buttonTxtColor,
    required this.buttonBorderColor,
    required this.buttonTextWeight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin:
            EdgeInsets.only(left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0.r),
          border: Border.all(
            color: Color(0xFFD1D9E8),
            width: 2.0,
          ),
        ),
        child: Column(children: [
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
              child: Text(
                titleText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff191919),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitleText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff808080),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  subtitleText2,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff808080),
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.delete_outlined,
              color: TXT_CLR_PRIMARY,
            ),
          ),
          Divider(
            height: 10.h,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 6.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1b438b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(ICON_CALENDAR),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          dateText,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff808080),
                            height: 20 / 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    MyAppButton(
                        onPressed: () {
                          onPressed();
                        },
                        buttonText: buttonText,
                        buttonTxtColor: buttonTxtColor,
                        buttonBorderColor: buttonBorderColor,
                        buttonColor: buttonColor,
                        buttonSizeX: 10.h,
                        buttonSizeY: 27.w,
                        buttonTextSize: 10.sp,
                        buttonTextWeight: FontWeight.w500),
                  ],
                ),
              ],
            ),
          ),
        ]));
  }
}
