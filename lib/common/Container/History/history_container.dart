import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/history_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryContainer extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String dateText;
  final String? statusText;
  final String amount;
  final String iconPath;
  final Color containerBorderColor;
  HistoryData historyData;

  HistoryContainer({
    super.key,
    required this.titleText,
    required this.subtitleText,
    required this.dateText,
    this.statusText,
    required this.amount,
    required this.iconPath,
    required this.containerBorderColor,
    required this.historyData,
  });

  @override
  Widget build(BuildContext context) {
    handleClick() {
      goToData(context, hISTORYDETAILSROUTE, {
        "billName": historyData.bILLNAME ?? "-",
        "billerName": historyData.bILLERNAME,
        "categoryName": historyData.cATEGORYNAME,
        "isSavedBill": false,
        "historyData": historyData
      });
    }

    return GestureDetector(
      onTap: () {
        handleClick();
      },
      child: Container(
        width: double.infinity,
        margin:
            EdgeInsets.only(left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0.r),
          border: Border.all(
            color: containerBorderColor,
            width: 2.0,
          ),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 6.w, right: 6.w, top: 6.h),
              leading: Container(
                width: 45.w,
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: SvgPicture.asset(iconPath),
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyAppText(
                      data: titleText,
                      size: 14.0.sp,
                      color: TXT_CLR_LITE,
                      weight: FontWeight.w500,
                    ),
                    MyAppText(
                      data: amount,
                      size: 14.0.sp,
                      color: CLR_PRIMARY,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 220.w,
                        child: MyAppText(
                          data: subtitleText,
                          size: 14.0.sp,
                          color: TXT_CLR_DEFAULT,
                          weight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 10.h,
              thickness: 1,
              indent: 10.w,
              endIndent: 10.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(ICON_CALENDAR),
                      SizedBox(
                        width: 5.h,
                      ),
                      MyAppText(
                        data: dateText,
                        size: 12.0.sp,
                        color: TXT_CLR_LITE,
                        weight: FontWeight.w400,
                      ),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        handleClick();
                      },
                      child: Row(children: [
                        if (statusText != null)
                          Container(
                              margin: EdgeInsets.all(5.r),
                              // decoration: BoxDecoration(
                              //   shape: BoxShape.circle,
                              //   color: statusText == "PENDING"
                              //       ? CLR_ASTRIX
                              //       : CLR_ERROR,
                              //   border: Border.all(
                              //     color: statusText == "PENDING"
                              //         ? CLR_ASTRIX
                              //         : CLR_ERROR,
                              //     width: 2.0,
                              //   ),
                              // ),
                              child: Container(
                                  child: statusText == "PENDING"
                                      ? SvgPicture.asset(ICON_PENDING)
                                      : SvgPicture.asset(ICON_FAILED))),
                        if (statusText != null)
                          Text(
                            statusText!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: statusText == "PENDING"
                                  ? CLR_ASTRIX
                                  : CLR_ERROR,
                              height: 20 / 12,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        SizedBox(width: 10.w),
                        IconButton(
                          onPressed: () {
                            handleClick();
                          },
                          icon: Icon(Icons.arrow_forward),
                          color: TXT_CLR_LITE,
                        )
                      ]))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
