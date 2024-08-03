import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NotPermittedScreen extends StatefulWidget {
  const NotPermittedScreen({super.key});

  @override
  State<NotPermittedScreen> createState() => _NotPermittedScreenState();
}

class _NotPermittedScreenState extends State<NotPermittedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: '',
          onLeadingTap: () => {
            GoBack(context),
          },
          showActions: false,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.CLR_BACKGROUND,
            // image: const DecorationImage(
            //   image: AssetImage(SPLASH_BAG),
            //   fit: BoxFit.fill,
            // ),
            borderRadius: BorderRadius.circular(2.0),
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     AppColors.CLR_BLUESHADE,
            //     AppColors.CLR_BACKGROUND,
            //   ],
            //   stops: const [
            //     0,
            //     0.2,
            //   ],
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  IMG_AD,
                  height: 140.h,
                  width: 164.w,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80.h),
                  MyAppText(
                    data: "You don't have permission to access this page.",
                    size: 12.0.sp,
                    color: AppColors.CLR_PRIMARY,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(height: 10.h),
                  MyAppText(
                    //data: "you can go back to previous page",
                    data: "Please, Contact Bank for More Information.",
                    size: 12.0.sp,
                    color: AppColors.CLR_PRIMARY,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(height: 40.h),
                  MyAppButton(
                      onPressed: () {
                        GoBack(context);
                      },
                      buttonText: "Go Back",
                      buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
                      buttonSizeX: 10.h,
                      buttonSizeY: 40.w,
                      buttonTextSize: 12.sp,
                      buttonTextWeight: FontWeight.w500),
                ],
              ),
            ],
          ),
        ));
  }
}
