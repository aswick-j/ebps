import 'package:ebps/constants/assets.dart';
import 'package:ebps/ebps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              IsCustomerElite.isCustomerElite
                  ? LOGO_BBPS_FULL_WHITE_PNG
                  : LOGO_BBPS_FULL_PNG,
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
