import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconBadge extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onTap;
  final int notificationCount;

  const IconBadge({
    Key? key,
    this.onTap,
    required this.iconData,
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
            Icon(iconData, color: CLR_PRIMARY),
            Positioned(
              top: 21.h,
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
