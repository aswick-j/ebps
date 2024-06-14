import 'package:ebps/common/Container/ImageTile.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillerDetailsContainer extends StatelessWidget {
  String icon;
  String title;
  String subTitle;
  String subTitle2;
  BillerDetailsContainer(
      {super.key,
      required this.icon,
      required this.title,
      required this.subTitle,
      required this.subTitle2});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          EdgeInsets.only(left: 8.w, right: 15.w, top: 10.h, bottom: 10.h),
      leading: ImageTileContainer(iconPath: icon),
      title: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 240.w,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.TXT_CLR_PRIMARY,
                ),
                textAlign: TextAlign.left,
                maxLines: 4,
              ),
            ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
              color: AppColors.TXT_CLR_SECONDARY,
            ),
            textAlign: TextAlign.left,
          ),
          if (subTitle2 != "")
            SizedBox(
              height: 5.h,
            ),
          if (subTitle2 != "")
            Text(
              subTitle2,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.TXT_CLR_LITE,
              ),
            ),
        ],
      ),
    );

    // Padding(
    //   padding: EdgeInsets.symmetric(vertical: 20.0.h),
    //   child: Column(children: [
    //     Container(
    //       width: 40.w,
    //       height: 40.h,
    //       child: Padding(
    //         padding: EdgeInsets.all(0),
    //         child: SvgPicture.asset(icon),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 10.h,
    //     ),
    //     Text(
    //       title,
    //       style: TextStyle(
    //         fontSize: 14.sp,
    //         fontWeight: FontWeight.bold,
    //         color: AppColors.CLR_PRIMARY,
    //       ),
    //       textAlign: TextAlign.center,
    //     ),
    //     SizedBox(
    //       height: 10.h,
    //     ),
    //     Text(
    //       subTitle,
    //       style: TextStyle(
    //         fontSize: 14.sp,
    //         fontWeight: FontWeight.w500,
    //         color: AppColors.TXT_CLR_DEFAULT,
    //         height: 26 / 16,
    //       ),
    //       textAlign: TextAlign.center,
    //     )
    //   ]),
    // );
  }
}
