import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LottieAnimation extends StatefulWidget {
  final int aniJsonIndex;
  final int titleIndex;
  final int secondaryIndex;
  final bool showTitle;
  const LottieAnimation(
      {super.key,
      required this.aniJsonIndex,
      required this.titleIndex,
      required this.secondaryIndex,
      required this.showTitle});

  @override
  State<LottieAnimation> createState() => _LottieAnimationState();
}

class _LottieAnimationState extends State<LottieAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List AniJson = [ANIM_NODATA, ANIM_NOSEARCH];

  List TitleText = ["Oops!", "Hurray!"];

  List SecondaryText = ["No Billers Found"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500.h,
        width: 250.w,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                AniJson[widget.aniJsonIndex],
                fit: BoxFit.cover,
                repeat: true,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
              Padding(
                  padding: EdgeInsets.all(20.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.showTitle) SizedBox(height: 80.h),
                      if (widget.showTitle)
                        MyAppText(
                          data: TitleText[widget.titleIndex],
                          size: 18.0.sp,
                          color: AppColors.CLR_PRIMARY,
                          weight: FontWeight.bold,
                        ),
                      SizedBox(height: 20.h),
                      MyAppText(
                          data: SecondaryText[widget.secondaryIndex],
                          size: 13.0.sp,
                          color: AppColors.CLR_PRIMARY,
                          weight: FontWeight.bold,
                          textAlign: TextAlign.justify),
                      // SizedBox(height: 80.h),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
