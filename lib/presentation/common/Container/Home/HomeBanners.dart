import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/presentation/common/Text/MyAppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class HomeBanners extends StatefulWidget {
  const HomeBanners({super.key});

  @override
  State<HomeBanners> createState() => _HomeBannersState();
}

class _HomeBannersState extends State<HomeBanners>
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin:
          EdgeInsets.only(left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.r),
        border: Border.all(
          color: Color(0xffD1D9E8),
          width: 2.0,
        ),
      ),
      child: Container(
        margin:
            EdgeInsets.only(left: 18.0.w, right: 18.w, top: 0.h, bottom: 0.h),
        height: 100.h,
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                MyAppText(
                  data: "Recharge and Pay bills\nsafely from home !",
                  size: 12.0.sp,
                  color: CLR_PRIMARY,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  height: 5.h,
                ),
                MyAppText(
                    data:
                        "Help your family and friends make\nsafe payments with Equitas Bharat Bill Pay",
                    size: 7.0.sp,
                    color: CLR_PRIMARY,
                    weight: FontWeight.w500,
                    maxline: 3),
              ],
            ),
            Container(
              height: 130.h,
              width: 130.w,
              child: Lottie.asset(
                JSON_BILLPAY,
                controller: _controller,
                repeat: true,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
