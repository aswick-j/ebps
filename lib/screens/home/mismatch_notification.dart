import 'dart:ui';

import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/numberPrefixSetter.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/services/api.dart';
import 'package:ebps/widget/animated_dialog.dart';
import 'package:ebps/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MismatchNotification extends StatefulWidget {
  List<AllConfigurationsData>? allautoPayData;
  List<PARAMETERS> savedinput = [];
  BuildContext context;
  List<SavedBillersData>? savedBiller = [];

  MismatchNotification(
      {super.key,
      this.allautoPayData,
      required this.context,
      required this.savedBiller});

  @override
  State<MismatchNotification> createState() => _MismatchNotificationState();
}

class _MismatchNotificationState extends State<MismatchNotification> {
  final controller = PageController(
    keepPage: true,
  );

  getSavedBiller(int index) {
    List<SavedBillersData>? SavedBillerData = widget.savedBiller!
        .where((element) =>
            element.cUSTOMERBILLID.toString().toLowerCase() ==
            widget.allautoPayData![index].cUSTOMERBILLID
                .toString()
                .toLowerCase())
        .toList();
    return SavedBillerData[0];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 24.h),
      child: Center(
        child: Column(children: [
          Container(
            height: 380.h,
            margin: EdgeInsets.fromLTRB(0, 120.h, 0, 10.h),
            child: PageView.builder(
              controller: controller,
              itemCount: widget.allautoPayData!.length,
              itemBuilder: (_, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0.r),
                    color: AppColors.CLR_BACKGROUND,
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 1.0,
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 60.h,
                              width: 328.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.5.r),
                                    topLeft: Radius.circular(10.5.r)),
                                color: AppColors.CLR_ERROR,
                                border: Border.all(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 1.0,
                                ),
                              ),
                              child: SizedBox(
                                width: 280.w,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0.w, vertical: 16.0.h),
                                  child: Text(
                                    widget.allautoPayData![index].rESETDATE == 1
                                        ? "Auto Pay Date not in between the Bill Generation and Bill Due date, please update accordingly."
                                        : "Alert!! We are unable to execute Auto Pay as your set limit is less than the last generated bill amount.",
                                    // "Auto Pay ${widget.allautoPayData![index].rESETDATE == 1 ? "Date" : "Limit"} Seems to be Mismatch",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.fromLTRB(20.w, 30.h, 0, 20.h),
                            //   child: SvgPicture.asset(
                            //     ICON_ERROR,
                            //     height: 25.h,
                            //     width: 45.w,
                            //   ),
                            // ),
                          ],
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20.w, 20.h, 0, 20.h),
                              child: SvgPicture.asset(
                                BILLER_LOGO(widget
                                    .allautoPayData![index].bILLERNAME
                                    .toString()),
                                height: 25.h,
                                width: 35.w,
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.allautoPayData![index].bILLNAME}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.CLR_BLUE_LITE,
                                    ),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                  ),
                                  SizedBox(
                                    width: 255.w,
                                    child: Text(
                                      "${widget.allautoPayData![index].bILLERNAME}",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.CLR_PRIMARY,
                                      ),
                                      textAlign: TextAlign.left,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // SizedBox(
                        //   height: 10.h,
                        // ),
                        Container(
                            height: 40.h,
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 18.0.w,
                                right: 18.w,
                                top: 10.h,
                                bottom: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0.r),
                              border: Border.all(
                                color: AppColors.CLR_CONTAINER_BG,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // if( widget.allautoPayData![index].rESETDATE ==
                                //               1 && )
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10.w, right: 20.w),
                                      width: 35.w,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomRight,
                                              stops: [
                                                0.1,
                                                0.9
                                              ],
                                              colors: [
                                                AppColors.CLR_BLUE_LITE
                                                    .withOpacity(.16),
                                                Colors.transparent
                                              ])),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            widget.allautoPayData![index]
                                                        .rESETDATE ==
                                                    1
                                                ? Icons.receipt_long
                                                : Icons.currency_rupee,
                                            color: AppColors.CLR_BLUE_LITE,
                                          )),
                                    ),
                                    Text(
                                      widget.allautoPayData![index].rESETDATE ==
                                              1
                                          ? "Bill Generation Date "
                                          : "Latest Bill Amount",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.TXT_CLR_LITE,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0.w),
                                  child: Text(
                                    widget.allautoPayData![index].rESETDATE == 1
                                        ? widget.allautoPayData![index]
                                                    .bILLDATE !=
                                                null
                                            ? DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(widget
                                                        .allautoPayData![index]
                                                        .bILLDATE!
                                                        .toString()
                                                        .substring(0, 10))
                                                    .toLocal()
                                                    .add(const Duration(
                                                        days: 1)))
                                            : "-"
                                        : "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.allautoPayData![index].dUEAMOUNT.toString()))}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.TXT_CLR_PRIMARY,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )),

                        Container(
                            height: 40.h,
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 18.0.w,
                                right: 18.w,
                                top: 10.h,
                                bottom: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0.r),
                              border: Border.all(
                                color:
                                    widget.allautoPayData![index].rESETDATE == 1
                                        ? Color(0xFFD1D9E8)
                                        : AppColors.CLR_ERROR,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10.w, right: 20.w),
                                      width: 35.w,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomRight,
                                              stops: [
                                                0.1,
                                                0.9
                                              ],
                                              colors: [
                                                widget.allautoPayData![index]
                                                            .rESETDATE ==
                                                        1
                                                    ? AppColors.CLR_BLUE_LITE
                                                        .withOpacity(.16)
                                                    : Color.fromARGB(
                                                            255, 255, 123, 123)
                                                        .withOpacity(.16),
                                                Colors.transparent
                                              ])),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            widget.allautoPayData![index]
                                                        .rESETDATE ==
                                                    1
                                                ? Icons.calendar_month_outlined
                                                : Icons.account_balance_wallet,
                                            color: widget.allautoPayData![index]
                                                        .rESETDATE ==
                                                    1
                                                ? AppColors.CLR_BLUE_LITE
                                                : AppColors.CLR_ERROR,
                                          )),
                                    ),
                                    Text(
                                      widget.allautoPayData![index].rESETDATE ==
                                              1
                                          ? "Due Date"
                                          : 'Auto Pay - "Set Limit"',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.TXT_CLR_LITE,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0.w),
                                  child: Text(
                                    widget.allautoPayData![index].rESETDATE == 1
                                        ? widget.allautoPayData![index].dUEDATE
                                            .toString()
                                        : widget.allautoPayData![index]
                                                    .mAXIMUMAMOUNT !=
                                                null
                                            ? "₹  ${NumberFormat('#,##,##0.00').format(double.parse(widget.allautoPayData![index].mAXIMUMAMOUNT.toString()))}"
                                            : "₹ 0.00",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.TXT_CLR_PRIMARY,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )),
                        Container(
                            height: 40.h,
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 18.0.w,
                                right: 18.w,
                                top: 10.h,
                                bottom: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0.r),
                              border: Border.all(
                                color:
                                    widget.allautoPayData![index].rESETDATE == 1
                                        ? AppColors.CLR_ERROR
                                        : Color(0xFFD1D9E8),
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10.w, right: 20.w),
                                      width: 35.w,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomRight,
                                              stops: [
                                                0.1,
                                                0.9
                                              ],
                                              colors: [
                                                widget.allautoPayData![index]
                                                            .rESETDATE ==
                                                        1
                                                    ? Color.fromARGB(
                                                            255, 255, 123, 123)
                                                        .withOpacity(.16)
                                                    : AppColors.CLR_PRIMARY
                                                        .withOpacity(.16),
                                                Colors.transparent
                                              ])),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.published_with_changes,
                                            color: widget.allautoPayData![index]
                                                        .rESETDATE ==
                                                    1
                                                ? AppColors.CLR_ERROR
                                                : AppColors.CLR_BLUE_LITE,
                                          )),
                                    ),
                                    Text(
                                      "Autopay Date ",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.TXT_CLR_LITE,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0.w),
                                  child: SizedBox(
                                    width: 110.w,
                                    child: FittedBox(
                                      child: Text(
                                        '${numberPrefixSetter(widget.allautoPayData![index].pAYMENTDATE.toString())}${" of"}${widget.allautoPayData![index].iSBIMONTHLY == 0 ? " every" : " every two"}${" month"}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.TXT_CLR_PRIMARY,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0.w, vertical: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: MyAppButton(
                                    onPressed: () async {
                                      await setSharedNotificationValue(
                                          "NOTIFICATION", false);

                                      goBack(context);
                                    },
                                    buttonText: "Skip",
                                    buttonTxtColor:
                                        AppColors.BTN_CLR_ACTIVE_ALTER_TEXT_C,
                                    buttonBorderColor:
                                        AppColors.BTN_CLR_ACTIVE_BORDER,
                                    buttonColor:
                                        AppColors.BTN_CLR_ACTIVE_ALTER_C,
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
                                    onPressed: () {
                                      setSharedNotificationValue(
                                          "NOTIFICATION", false);

                                      if (widget.allautoPayData![index]
                                                  .pAYMENTDATE ==
                                              DateTime.now().day.toString() ||
                                          widget.allautoPayData![index]
                                                  .iSACTIVE ==
                                              0) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext ctx) {
                                            return WillPopScope(
                                                onWillPop: () async => false,
                                                child: CustomDialog(
                                                  showActions: true,
                                                  actions: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: MyAppButton(
                                                          onPressed: () {
                                                            goBack(ctx);
                                                          },
                                                          buttonText: "Okay",
                                                          buttonTxtColor: AppColors
                                                              .BTN_CLR_ACTIVE_ALTER_TEXT,
                                                          buttonBorderColor:
                                                              Colors
                                                                  .transparent,
                                                          buttonColor: AppColors
                                                              .BTN_CLR_ACTIVE_ALTER,
                                                          buttonSizeX: 10.h,
                                                          buttonSizeY: 40.w,
                                                          buttonTextSize: 14.sp,
                                                          buttonTextWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                  child: AnimatedDialog(
                                                      showImgIcon: false,
                                                      title: widget
                                                                  .allautoPayData![
                                                                      index]
                                                                  .pAYMENTDATE ==
                                                              DateTime.now()
                                                                  .day
                                                                  .toString()
                                                          ? " We are unable to edit your autopay as the autopay is scheduled for today"
                                                          : "We can't edit your Autopay because it's currently paused.",
                                                      subTitle: "",
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                      ),
                                                      showSub: false,
                                                      shapeColor:
                                                          AppColors.CLR_ERROR),
                                                ));
                                          },
                                        );
                                      } else {
                                        goBack(context);
                                        goToData(
                                            widget.context, eDITAUTOPAYROUTE, {
                                          "savedBillerData":
                                              getSavedBiller(index),
                                          "AutoDateMisMatch": widget
                                                      .allautoPayData![index]
                                                      .rESETDATE ==
                                                  1
                                              ? true
                                              : false,
                                          "DebitLimitMisMatch": widget
                                                      .allautoPayData![index]
                                                      .rESETLIMIT ==
                                                  1
                                              ? true
                                              : false,
                                          "autopayData":
                                              widget.allautoPayData![index],
                                        });
                                      }
                                    },
                                    buttonText: "Modify",
                                    buttonTxtColor:
                                        AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                                    buttonBorderColor: Colors.transparent,
                                    buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
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
                );
              },
            ),
          ),
          SmoothPageIndicator(
              controller: controller,
              count: widget.allautoPayData!.length,
              effect: CustomizableEffect(
                dotDecoration: DotDecoration(
                  color: Color(0xFFA4A1A1),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                activeDotDecoration: DotDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  dotBorder: DotBorder(
                    color: Colors.white,
                    width: 2,
                    padding: 3,
                  ),
                ),
              )),
        ]),
      ),
    );
  }
}
