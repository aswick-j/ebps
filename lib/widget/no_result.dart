import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class noResult extends StatefulWidget {
  final int ErrIndex;
  final int ImgIndex;
  final int? TitleErrIndex;
  final double? width;
  const noResult(
      {Key? key,
      required this.ErrIndex,
      required this.ImgIndex,
      this.width,
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
    "We're unable to proceed your autopay\nsetup. Kindly try again later."
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
        body: Container(
      child: Column(
        children: [
          Container(
            width: widget.width ?? 100.w,
            height: 200.h,
            child:
                SvgPicture.asset(Image[widget.ImgIndex], fit: BoxFit.fitWidth),
          ),
          Padding(
              padding: EdgeInsets.all(20.0.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: 80.h),
                  MyAppText(
                      data: TitlExpMsg[widget.TitleErrIndex ?? 0],
                      size: 18.0.sp,
                      color: CLR_PRIMARY,
                      weight: FontWeight.bold,
                      maxline: 2),
                  SizedBox(height: 20.h),
                  MyAppText(
                      data: ErrorMessage[widget.ErrIndex],
                      size: 13.0.sp,
                      color: CLR_PRIMARY,
                      weight: FontWeight.w500,
                      maxline: 6,
                      textAlign: TextAlign.justify),
                  // SizedBox(height: 80.h),
                ],
              )),
        ],
      ),
    ));
  }
}
