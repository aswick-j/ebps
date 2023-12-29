import 'package:ebps/constants/assets.dart';
import 'package:ebps/helpers/getGradientColors.dart';
import 'package:ebps/helpers/getTransactionStatusText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenshotContainer extends StatelessWidget {
  final String BillName;
  final String BillerName;
  final String BillerId;
  final String BillNumber;
  final String TransactionID;
  final String fromAccount;
  final String billAmount;
  final String status;
  final String TransactionDate;

  const ScreenshotContainer({
    required this.BillerName,
    required this.BillName,
    required this.billAmount,
    required this.BillerId,
    required this.BillNumber,
    required this.TransactionID,
    required this.fromAccount,
    required this.status,
    required this.TransactionDate,
  });

  Widget txnDetails({
    required String title,
    required String subTitle,
    bool clipBoard = false,
    bool showLogo = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff808080),
              height: 23 / 14,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              if (showLogo)
                Image.asset(LOGO_EQUITAS_E, height: 40.h, width: 40.w),
              if (showLogo) SizedBox(width: 10.w),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1b438b),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        height: double.infinity,
        margin:
            EdgeInsets.only(left: 18.0.w, right: 18.w, top: 10.h, bottom: 10.h),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(LOGO_BBPS_ASSURED),
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.9),
              BlendMode.screen,
            ),
          ),
          border: Border.all(
            color: Color(0xffD1D9E8),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              height: 33.0.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  stops: const [0.001, 19],
                  colors: getStatusGradientColors(status),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getTransactionStatusText(status),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffffffff),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(ICON_ARROW_UP, height: 20.h),
                          Text(
                            billAmount,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1b438b),
                              height: 33 / 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0.w),
                    child: Text(
                      TransactionDate,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff808080),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 10.h,
              thickness: 1,
            ),
            txnDetails(
              title: "Sent From",
              subTitle: 'EQUITAS BANK - $fromAccount',
              clipBoard: false,
            ),
            txnDetails(
              title: "Sent To",
              subTitle: BillerName,
              clipBoard: false,
            ),
            Divider(
              height: 10.h,
              thickness: 1,
            ),
            txnDetails(
              title: "Bill Number",
              subTitle: BillNumber,
              clipBoard: false,
            ),
            if (status == 'success')
              txnDetails(
                title: "Transaction ID",
                subTitle: TransactionID,
                clipBoard: false,
              ),
            txnDetails(
                title: "Status",
                subTitle: status == 'success'
                    ? "Transaction Success"
                    : status == 'bbpsTimeout'
                        ? 'Transaction Pending'
                        : status == 'failed'
                            ? "Transaction Failed"
                            : "Transaction Failed",
                clipBoard: false),
            txnDetails(
                title: "Payment Channel",
                subTitle: "Equitas - Mobile Banking",
                clipBoard: false,
                showLogo: true),
            Center(
              child: Container(
                height: 80.h,
                width: 80.w,
                child: Image.asset(
                  LOGO_EQUITAS,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
