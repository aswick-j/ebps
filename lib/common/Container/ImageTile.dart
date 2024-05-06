import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageTileContainer extends StatelessWidget {
  final String iconPath;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final bool? showGradient;

  const ImageTileContainer(
      {super.key,
      required this.iconPath,
      this.height,
      this.width,
      this.padding,
      this.showGradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40.h,
      padding: padding ?? EdgeInsets.all(9.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80.0.r),
        gradient: showGradient == false
            ? null
            : LinearGradient(
                begin: Alignment.bottomRight,
                stops: const [0.1, 0.9],
                colors: [CLR_BLUE_LITE.withOpacity(.16), Colors.transparent],
              ),
      ),
      width: width ?? 45.w,
      child: SvgPicture.asset(iconPath),
    );
  }
}
