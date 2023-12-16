import 'package:ebps/shared/common/Button/MyAppButton.dart';
import 'package:ebps/shared/constants/assets.dart';
import 'package:ebps/shared/constants/colors.dart';
import 'package:ebps/shared/helpers/getNavigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MismatchNotification extends StatefulWidget {
  const MismatchNotification({super.key});

  @override
  State<MismatchNotification> createState() => _MismatchNotificationState();
}

class _MismatchNotificationState extends State<MismatchNotification> {
  final controller = PageController(
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        6,
        (index) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 20),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30.h, 0, 20.h),
                      child: SvgPicture.asset(
                        ICON_ERROR,
                        height: 45.h,
                        width: 45.w,
                      ),
                    ),
                    Text(
                      "Auto Pay Date Seems to be Mismatch",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
                      child: SvgPicture.asset(
                        LOGO_BBPS,
                        height: 35.h,
                        width: 35.w,
                      ),
                    ),
                    Text(
                      "Biller Name - Bill Name",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 0,
                        crossAxisCount: 2,
                        childAspectRatio: 4 / 2,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(8.w, 10.h, 0, 0),
                                      child: Text(
                                        "Due Date",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff808080),
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(8.w, 10.h, 0, 0),
                                      child: Text(
                                        "14/12/2023",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff1b438b),
                                        ),
                                        textAlign: TextAlign.left,
                                      ))
                                ],
                              )),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(8.w, 10.h, 0, 0),
                                      child: Text(
                                        "Auto Pay Date",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff808080),
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(8.w, 10.h, 0, 0),
                                      child: Text(
                                        "15/12/2023",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff1b438b),
                                        ),
                                        textAlign: TextAlign.left,
                                      ))
                                ],
                              ))
                        ]),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0.w, vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: MyAppButton(
                                onPressed: () {
                                  goBack(context);
                                },
                                buttonText: "Later",
                                buttonTxtColor: CLR_PRIMARY,
                                buttonBorderColor: CLR_PRIMARY,
                                buttonColor: BTN_CLR_ACTIVE,
                                buttonSizeX: 10.h,
                                buttonSizeY: 40.w,
                                buttonTextSize: 14.sp,
                                buttonTextWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                            child: MyAppButton(
                                onPressed: () async {},
                                buttonText: "Proceed",
                                buttonTxtColor: BTN_CLR_ACTIVE,
                                buttonBorderColor: Colors.transparent,
                                buttonColor: CLR_PRIMARY,
                                buttonSizeX: 10.h,
                                buttonSizeY: 40.w,
                                buttonTextSize: 14.sp,
                                buttonTextWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 24.h),
      child: Center(
        child: Column(children: [
          Container(
            height: 390.h,
            margin: EdgeInsets.fromLTRB(0, 70.h, 0, 0),
            child: PageView.builder(
              controller: controller,
              // itemCount: pages.length,
              itemBuilder: (_, index) {
                return pages[index % pages.length];
              },
            ),
          ),
          SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: ScrollingDotsEffect(
                  activeStrokeWidth: 2.6,
                  activeDotScale: 1.3,
                  maxVisibleDots: 5,
                  radius: 8,
                  spacing: 10,
                  dotHeight: 12,
                  dotWidth: 12,
                  strokeWidth: 2,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.white)),
        ]),
      ),
    );
  }
}
