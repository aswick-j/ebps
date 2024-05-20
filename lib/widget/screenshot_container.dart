import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getGradientColors.dart';
import 'package:ebps/helpers/getTransactionStatusReason.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenshotContainer extends StatelessWidget {
  final String BillName;
  final String BillerName;
  final String BillerId;
  final String ParamName;
  final String ParamValue;

  final String TransactionID;
  final String fromAccount;
  final String billAmount;
  final String status;
  final String trasactionStatus;
  final String TransactionDate;
  final String channel;
  final String ConsumerName;
  final String billNumber;

  const ScreenshotContainer({
    required this.BillerName,
    required this.BillName,
    required this.billAmount,
    required this.BillerId,
    required this.channel,
    required this.ParamName,
    required this.ParamValue,
    required this.TransactionID,
    required this.fromAccount,
    required this.status,
    required this.trasactionStatus,
    required this.TransactionDate,
    required this.ConsumerName,
    required this.billNumber,
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
              color: AppColors.TXT_CLR_LITE,
              height: 23 / 14,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              if (showLogo)
                Image.asset(LOGO_EQUITAS_PNG, height: 40.h, width: 40.w),
              if (showLogo) SizedBox(width: 10.w),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.TXT_CLR_PRIMARY,
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
      color: AppColors.CLR_BACKGROUND,
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
            opacity: 0.1,
            colorFilter: ColorFilter.mode(AppColors.CLR_ICON, BlendMode.srcIn),
          ),
          border: Border.all(
            color: AppColors.CLR_CON_BORDER,
            width: 0.5,
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
                  colors: getStatusGradientColors(
                      status.toLowerCase() == "success"
                          ? "success"
                          : status.toLowerCase() == "bbps-in-progress" ||
                                  status.toLowerCase() == "bbps-timeout"
                              ? "pending"
                              : "failed"),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    status.toLowerCase() == "success"
                        ? "Transaction Success"
                        : status.toLowerCase() == "bbps-in-progress" ||
                                status.toLowerCase() == "bbps-timeout"
                            ? "Transaction Pending "
                            : "Transaction Failure",
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
                              color: AppColors.CLR_PRIMARY,
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
                        color: AppColors.TXT_CLR_LITE,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColors.CLR_CON_BORDER,
              height: 10.h,
              thickness: 1,
            ),
            txnDetails(
              title: "Account",
              subTitle: 'EQUITAS BANK - $fromAccount',
              clipBoard: false,
            ),
            if (ConsumerName != null &&
                ConsumerName != "NA" &&
                ConsumerName != "null" &&
                ConsumerName != "-")
              txnDetails(
                  title: "Consumer Name",
                  subTitle: ConsumerName.toString(),
                  clipBoard: false),
            txnDetails(
              title: "Biller Name",
              subTitle: BillerName,
              clipBoard: false,
            ),
            Divider(
              color: AppColors.CLR_CON_BORDER,
              height: 10.h,
              thickness: 1,
            ),
            if (billNumber != "NA" &&
                billNumber != "null" &&
                billNumber != ParamValue)
              txnDetails(
                title: "Bill Number",
                subTitle: billNumber,
                clipBoard: false,
              ),
            if (ParamName != "null" || ParamValue != "null")
              txnDetails(
                title: ParamName,
                subTitle: ParamValue,
                clipBoard: false,
              ),
            if (TransactionID != "" && TransactionID != "null")
              txnDetails(
                title: "Transaction ID",
                subTitle: TransactionID,
                clipBoard: false,
              ),
            txnDetails(
                title: "Status",
                subTitle: status.toLowerCase() == "success"
                    ? "Transaction Success"
                    : status.toLowerCase() == "bbps-in-progress" ||
                            status.toLowerCase() == "bbps-timeout"
                        ? "Transaction Pending "
                        : "Transaction Failure",
                clipBoard: false),
            if (status.toLowerCase() != "success")
              txnDetails(
                  title: "Reason",
                  subTitle: getTransactionReason(trasactionStatus),
                  clipBoard: false),
            txnDetails(
                title: "Payment Channel",
                subTitle: channel,
                clipBoard: false,
                showLogo: true),
            // Center(
            //   child: Container(
            //     height: 80.h,
            //     width: 80.w,
            //     child: Image.asset(
            //       LOGO_EQUITAS,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
