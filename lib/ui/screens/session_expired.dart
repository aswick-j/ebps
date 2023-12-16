import 'package:ebps/shared/common/Button/MyAppButton.dart';
import 'package:ebps/shared/common/Text/MyAppText.dart';
import 'package:ebps/shared/constants/assets.dart';
import 'package:ebps/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SessionExpired extends StatefulWidget {
  const SessionExpired({super.key});

  @override
  State<SessionExpired> createState() => _SessionExpiredState();
}

class _SessionExpiredState extends State<SessionExpired> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        // image: const DecorationImage(
        //   image: AssetImage(SPLASH_BAG),
        //   fit: BoxFit.fill,
        // ),
        borderRadius: BorderRadius.circular(2.0),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            CLR_BLUESHADE,
            Colors.white,
          ],
          stops: const [
            0,
            0.2,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              IMG_NOTFOUND,
              height: 160,
              width: 164,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              MyAppText(
                data: 'Oh!',
                size: 14.0,
                color: CLR_PRIMARY,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              MyAppText(
                data: 'Your Session is Expired. Please log in again',
                size: 14.0,
                color: CLR_PRIMARY,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 80),
              MyAppButton(
                  onPressed: () {},
                  buttonText: "Go Back",
                  buttonTxtColor: BTN_CLR_ACTIVE,
                  buttonBorderColor: Colors.transparent,
                  buttonColor: CLR_PRIMARY,
                  buttonSizeX: 10.h,
                  buttonSizeY: 40.w,
                  buttonTextSize: 14.sp,
                  buttonTextWeight: FontWeight.w500),
            ],
          )
        ],
      ),
    ));
  }
}
