import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/refresh_dues.dart';
import 'package:ebps/common/Container/ImageTile.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/checkDateExpiry.dart';
import 'package:ebps/helpers/getBillerType.dart';
import 'package:ebps/helpers/getDateBetweenTwoDates.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/marquee_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpcomingDuesContainer extends StatefulWidget {
  SavedBillersData? savedBillersData;

  final String dateText;
  final String buttonText;
  final String amount;
  final String iconPath;
  final Color containerBorderColor;
  final Color buttonColor;
  final Color buttonTxtColor;
  final FontWeight buttonTextWeight;
  final Color? buttonBorderColor;
  final VoidCallback onPressed;
  final int dueStatus;
  final dynamic dueDate;

  UpcomingDuesContainer(
      {super.key,
      required this.dateText,
      required this.dueDate,
      required this.buttonText,
      required this.amount,
      required this.iconPath,
      required this.containerBorderColor,
      required this.buttonColor,
      required this.buttonTxtColor,
      required this.buttonBorderColor,
      required this.buttonTextWeight,
      required this.savedBillersData,
      required this.dueStatus,
      required this.onPressed});

  @override
  State<UpcomingDuesContainer> createState() => _UpcomingDuesContainerState();
}

class _UpcomingDuesContainerState extends State<UpcomingDuesContainer> {
  @override
  Widget build(BuildContext context) {
    bool isFetchbillLoading = false;

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is FetchBillLoading) {
          isFetchbillLoading = true;
        } else if (state is FetchBillSuccess) {
          setState(() {
            isFetchbillLoading = false;
          });
        } else if (state is FetchBillFailed) {
          isFetchbillLoading = false;
        } else if (state is FetchBillError) {
          isFetchbillLoading = false;
        }
      },
      builder: (context, state) {
        return Card(
          // width: double.infinity,
          elevation: 0.0,
          color: AppColors.CLR_BACKGROUND,
          clipBehavior: Clip.hardEdge,

          margin: EdgeInsets.only(
              left: 18.0.w, right: 18.w, top: 10.h, bottom: 5.h),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.r),
            side: BorderSide(
              color: widget.containerBorderColor,
              width: 0.50,
            ),
          ),
          child: !isFetchbillLoading
              ? Column(
                  children: [
                    ListTile(
                      contentPadding:
                          EdgeInsets.only(left: 8.w, right: 15.w, top: 4.h),
                      leading: ImageTileContainer(iconPath: widget.iconPath),
                      title: Padding(
                        padding: EdgeInsets.only(bottom: 5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 210.w,
                              child: MarqueeWidget(
                                direction: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      widget.savedBillersData!.bILLNAME
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.TXT_CLR_PRIMARY,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    // Text(
                                    //   "( ${widget.savedBillersData!.bILLNAME.toString()} )",
                                    //   style: TextStyle(
                                    //     fontSize: 10.sp,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: CLR_BLUE_LITE,
                                    //   ),
                                    //   textAlign: TextAlign.left,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Map<String, dynamic> billerInputSign = {};

                                  if (widget.savedBillersData!.pARAMETERS !=
                                      null) {
                                    for (var element in widget
                                        .savedBillersData!.pARAMETERS!) {
                                      billerInputSign[element.pARAMETERNAME
                                              .toString()] =
                                          element.pARAMETERVALUE.toString();
                                    }
                                  }
                                  Map<String, dynamic>? validateBill;

                                  setState(() {
                                    validateBill = getBillerType(
                                        widget
                                            .savedBillersData!.fETCHREQUIREMENT,
                                        widget.savedBillersData!
                                            .bILLERACCEPTSADHOC,
                                        widget.savedBillersData!
                                            .sUPPORTBILLVALIDATION,
                                        widget.savedBillersData!
                                            .pAYMENTEXACTNESS);
                                  });

                                  showModalBottomSheet(
                                      isDismissible: false,
                                      context: context,
                                      backgroundColor: AppColors.CLR_BACKGROUND,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.0.r),
                                        ),
                                      ),
                                      builder: (context) {
                                        return StatefulBuilder(builder:
                                            (context, StateSetter setState) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ListTile(
                                                contentPadding: EdgeInsets.only(
                                                    left: 8.w,
                                                    right: 15.w,
                                                    top: 4.h),
                                                leading: ImageTileContainer(
                                                    iconPath: widget.iconPath),
                                                title: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5.h),
                                                  child: Text(
                                                    widget.savedBillersData!
                                                        .bILLNAME
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .TXT_CLR_BLACK_W,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.savedBillersData!
                                                          .bILLERNAME
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .TXT_CLR_LITE_V2,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      widget.savedBillersData!
                                                          .pARAMETERVALUE
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .TXT_CLR_LITE,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.2),
                                                        spreadRadius: 0.2,
                                                        blurRadius: 2,
                                                        offset: Offset(0, 2)),
                                                  ],
                                                ),
                                                child: Divider(
                                                  height: 0.4.h,
                                                  thickness: 1,
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              RefreshDues(
                                                  customerBillID: widget
                                                      .savedBillersData!
                                                      .cUSTOMERBILLID,
                                                  billerID: widget
                                                      .savedBillersData!
                                                      .bILLERID,
                                                  quickPay: false,
                                                  quickPayAmount: "0",
                                                  adHocBillValidationRefKey:
                                                      null,
                                                  validateBill: validateBill![
                                                      "validateBill"],
                                                  billerParams: billerInputSign,
                                                  billName: widget
                                                      .savedBillersData!
                                                      .bILLNAME)
                                            ],
                                          );
                                        });
                                      });
                                },
                                child: SvgPicture.asset(ICON_REFRESH)),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: 150.w,
                                    child: Text(
                                      widget.savedBillersData!.bILLERNAME
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.TXT_CLR_DEFAULT,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  SizedBox(
                                    width: 150.w,
                                    child: Text(
                                      widget.savedBillersData!.pARAMETERVALUE
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.TXT_CLR_LITE,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.amount != "-")
                                Text(
                                  widget.amount,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.TXT_CLR_PRIMARY,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      thickness: 0.50,
                      // indent: 10.w,
                      // endIndent: 10.w,
                      color: AppColors.CLR_CON_BORDER,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 15.w, right: 15.w, bottom: 0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.dueStatus != 0)
                            if (widget.dateText != "-")
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    ICON_CALENDAR,
                                    colorFilter: ColorFilter.mode(
                                        AppColors.CLR_PRIMARY_LITE,
                                        BlendMode.srcIn),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    widget.dateText,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.CLR_PRIMARY_LITE,
                                    ),
                                  ),
                                ],
                              )
                            else
                              SizedBox(
                                width: 10.w,
                              )
                          else
                            SizedBox(
                              width: 10.w,
                            ),

                          GestureDetector(
                            onTap: () {
                              widget.onPressed();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0.w, vertical: 4.w),
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                  // border: Border.all(
                                  //     color: widget.buttonTxtColor
                                  //         .withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10.r),
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.buttonTxtColor.withOpacity(0.5),
                                      // Color(0xff0373c4),
                                      Color.fromARGB(255, 212, 223, 231)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  )),
                              // decoration: BoxDecoration(
                              //   border:
                              //       Border.all(color: widget.buttonTxtColor),
                              //   borderRadius: BorderRadius.circular(12.0.r),
                              // ),
                              child: Text(
                                widget.buttonText.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.0.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // MyAppButton(
                          //     onPressed: () {
                          //       widget.onPressed();
                          //     },
                          //     buttonText: widget.buttonText,
                          //     buttonTxtColor: widget.buttonTxtColor,
                          //     buttonBorderColor: widget.buttonBorderColor,
                          //     buttonColor: widget.buttonColor,
                          //     buttonSizeX: 10.h,
                          //     buttonSizeY: 25.w,
                          //     buttonTextSize: 8.sp,
                          //     buttonTextWeight: FontWeight.w500),
                        ],
                      ),
                    ),
                    if (widget.dueStatus != 0)
                      if (widget.dueDate != "-")
                        if (checkDateExpiry(widget.dueDate.toString()))
                          Container(
                              width: double.infinity,
                              height: 15.h,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  // color: AppColors.CLR_ERROR,
                                  gradient: LinearGradient(
                                colors: [
                                  AppColors.CLR_ERROR.withOpacity(0.5),
                                  // Color(0xff0373c4),
                                  Color.fromARGB(255, 231, 212, 212)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                // border: Border.all(
                                //   color: AppColors.CLR_ERROR.withOpacity(0.5),
                                // ),
                              )),
                              child: Center(
                                child: Text(
                                    "Overdue by ${daysBetween((DateTime.parse(widget.dueDate!.toString()).add(Duration(days: 1))), DateTime.now())} ${daysBetween((DateTime.parse(widget.dueDate!.toString()).add(Duration(days: 1))), DateTime.now()) == 1 ? "Day" : "Days"}",
                                    style: TextStyle(
                                        fontSize: 7.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              )),
                  ],
                )
              : null,
        );
      },
    );
  }
}
