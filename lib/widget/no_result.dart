import 'dart:ui';

import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/ebps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class noResult extends StatefulWidget {
  final int ErrIndex;
  final int ImgIndex;
  final int? TitleErrIndex;
  final double? width;
  final bool? showTitle;
  const noResult(
      {Key? key,
      required this.ErrIndex,
      required this.ImgIndex,
      this.width,
      required this.showTitle,
      this.TitleErrIndex})
      : super(key: key);

  @override
  State<noResult> createState() => _noResultState();
}

class _noResultState extends State<noResult> {
  List ErrorMessage = [
    "It seems there is a problem fetching the\nbill at the moment. Kindly try again later.",
    "It seems there is a problem fetching the\nplans at the moment. Kindly try again later.",
    "The bank is experiencing some issues right now. Kindly try again later.",
    "No Plans Found for this Operator.\nPlease Choose a different Operator.",
    "You have no pending bill.\nPlease contact biller for more information.",
    "No bill data available at the moment.\nPlease contact biller for more information.",
    "Something Went Wrong.\nPlease contact bank for more information.",
    "We're unable to proceed your autopay\nsetup. Kindly try again later.",
    "Something Went Wrong. Kindly try again later.",
    "We're unable to proceed your autopay\nedit. Kindly try again later.",
    "Unable to Show Saved Bill Details.\nPlease try again later."
  ];

  List TitlExpMsg = [
    "Oops! ",
    "Hurray! ",
  ];

  List Image = [
    IMG_NOTFOUND,
    IMG_NODATA,
    IMG_SERVERDOWN,
    IMG_NOPLANS,
    IMG_PENDINGDUES,
    IMG_SMTWR
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            color: Colors.transparent,
            child: InternetCheck.isConnected
                ? Column(
                    children: [
                      Container(
                        width: widget.width ?? 100.w,
                        height: 200.h,
                        child: SvgPicture.asset(
                          Image[widget.ImgIndex],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(20.0.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(height: 80.h),
                              if (widget.showTitle == true)
                                MyAppText(
                                    data: TitlExpMsg[widget.TitleErrIndex ?? 0],
                                    size: 18.0.sp,
                                    color: AppColors.CLR_PRIMARY,
                                    weight: FontWeight.bold,
                                    maxline: 2),
                              SizedBox(height: 20.h),
                              FittedBox(
                                fit: BoxFit.contain,
                                child: MyAppText(
                                    data: ErrorMessage[widget.ErrIndex],
                                    size: 13.0.sp,
                                    color: AppColors.CLR_PRIMARY,
                                    weight: FontWeight.w500,
                                    maxline: 6,
                                    textAlign: TextAlign.justify),
                              )

                              // SizedBox(height: 80.h),
                            ],
                          )),
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        width: 150.w,
                        height: 190.h,
                        // child: Icon(Icons.wifi_off_outlined,
                        //     size: 200.r, color: CLR_SECONDARY)
                        child: SvgPicture.asset(
                          IMG_NOINTERNET,
                          fit: BoxFit.fitWidth,
                          colorFilter:
                              ColorFilter.mode(CLR_PRIMARY, BlendMode.srcIn),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(20.0.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 50.h),
                              MyAppText(
                                  data: 'Whoops !',
                                  size: 18.0.sp,
                                  color: CLR_PRIMARY,
                                  weight: FontWeight.bold,
                                  maxline: 2),
                              SizedBox(height: 10.h),
                              MyAppText(
                                  data:
                                      "You're disconnected.Check your internet connection and try again.",
                                  size: 13.0.sp,
                                  color: CLR_PRIMARY,
                                  weight: FontWeight.w500,
                                  maxline: 6,
                                  textAlign: TextAlign.center),
                            ],
                          )),
                    ],
                  )));
  }
}
