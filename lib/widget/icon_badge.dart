import 'package:ebps/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconBadge extends StatelessWidget {
  final VoidCallback? onTap;
  final int notificationCount;

  const IconBadge({
    Key? key,
    this.onTap,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50.w,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              ICON_NOTI,
              fit: BoxFit.contain,
            ),
            Positioned(
              top: 20.h,
              right: 5.w,
              child: Container(
                padding: EdgeInsets.all(1.r),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                constraints: BoxConstraints(
                  minWidth: 12.w,
                  minHeight: 12.h,
                ),
                child: Text(
                  notificationCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
