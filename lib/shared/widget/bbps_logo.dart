import 'package:ebps/shared/constants/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BbpsLogoContainer extends StatelessWidget {
  bool showEquitasLogo;
  BbpsLogoContainer({super.key, required this.showEquitasLogo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80.h,
            width: 80.w,
            child: Image.asset(
              LOGO_BBPS_FULL_PNG,
            ),
          ),
          if (showEquitasLogo)
            SizedBox(
              width: 30.w,
            ),
          if (showEquitasLogo)
            Container(
              height: 80.h,
              width: 80.w,
              child: Image.asset(
                LOGO_EQUITAS,
              ),
            ),
        ],
      ),
    );
  }
}
