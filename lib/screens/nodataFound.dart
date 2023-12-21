import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NoDataFound extends StatefulWidget {
  final String message;
  const NoDataFound({super.key, required this.message});

  @override
  State<NoDataFound> createState() => _NoDataFoundState();
}

class _NoDataFoundState extends State<NoDataFound> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                IMG_NODATA,
                height: 160.h,
                width: 164.w,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                // MyAppText(
                //   data: 'Oh!',
                //   size: 14.0,
                //   color: CLR_PRIMARY,
                //   weight: FontWeight.bold,
                // ),
                SizedBox(height: 20),
                MyAppText(
                  data: widget.message,
                  size: 14.0,
                  color: CLR_PRIMARY,
                  weight: FontWeight.bold,
                ),
                SizedBox(height: 80),
              ],
            )
          ]),
    );
  }
}
