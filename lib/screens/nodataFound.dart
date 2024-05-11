import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NoDataFound extends StatefulWidget {
  final String message;
  final bool? showRichText;
  final String? message1;
  final String? message2;

  const NoDataFound(
      {super.key,
      required this.message,
      this.showRichText,
      this.message1,
      this.message2});

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
                if (widget.showRichText == true)
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          color: AppColors.TXT_CLR_DEFAULT,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.TXT_CLR_PRIMARY,
                                  fontWeight: FontWeight.w500),
                              text: widget.message),
                          TextSpan(
                            text: " ' ${widget.message1} ' ",
                            recognizer: TapGestureRecognizer()..onTap = () {},
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color: AppColors.TXT_CLR_DEFAULT,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.TXT_CLR_PRIMARY,
                                  fontWeight: FontWeight.w500),
                              text: widget.message2),
                        ],
                      ),
                    ),
                  )
                else
                  MyAppText(
                    data: widget.message,
                    size: 14.0,
                    color: AppColors.CLR_PRIMARY,
                    weight: FontWeight.bold,
                  ),
                SizedBox(height: 80),
              ],
            )
          ]),
    );
  }
}
