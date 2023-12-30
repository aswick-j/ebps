import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class noResult extends StatefulWidget {
  final int ErrIndex;
  final int ImgIndex;
  const noResult({Key? key, required this.ErrIndex, required this.ImgIndex})
      : super(key: key);

  @override
  State<noResult> createState() => _noResultState();
}

class _noResultState extends State<noResult> {
  List ErrorMessage = [
    "It seems there is a problem fetching the\nbill at the moment. Kindly try again later.",
    "It seems there is a problem fetching the\nplans at the moment. Kindly try again later.",
    "The bank is experiencing some issues right now. Kindly try again later."
  ];

  List Image = [IMG_NOTFOUND, IMG_NODATA, IMG_SERVERDOWN];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            width: 100.w,
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
                    data: 'Oops!',
                    size: 18.0.sp,
                    color: CLR_PRIMARY,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(height: 20.h),
                  MyAppText(
                      data: ErrorMessage[widget.ErrIndex],
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
