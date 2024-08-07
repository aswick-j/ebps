import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/ImageTile.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/checkDateExpiry.dart';
import 'package:ebps/helpers/getDateBetweenTwoDates.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/widget/marquee_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MainContainer extends StatefulWidget {
  final String titleText;
  final String subtitleText;
  final String subtitleText2;
  final String dateText;
  final String buttonText;
  final String amount;
  final String iconPath;
  final int dueStatus;
  final Color containerBorderColor;
  final Color buttonColor;
  final Color buttonTxtColor;
  final FontWeight buttonTextWeight;
  final Color? buttonBorderColor;
  final VoidCallback onPressed;
  final VoidCallback onDeleteUpPressed;
  final String customerBillID;
  final BuildContext ctx;
  final List<AllConfigurations>? autopayData;
  final dynamic dueDate;

  const MainContainer({
    super.key,
    required this.dueDate,
    required this.titleText,
    required this.autopayData,
    required this.subtitleText,
    required this.subtitleText2,
    required this.dateText,
    required this.buttonText,
    required this.amount,
    required this.ctx,
    required this.customerBillID,
    required this.iconPath,
    required this.containerBorderColor,
    required this.buttonColor,
    required this.buttonTxtColor,
    required this.buttonBorderColor,
    required this.buttonTextWeight,
    required this.onPressed,
    required this.dueStatus,
    required this.onDeleteUpPressed,
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  @override
  Widget build(BuildContext context) {
    getAllAutopayList(customerBILLID) {
      try {
        List<AllConfigurationsData>? autopayDATA = [];
        for (int i = 0; i < widget.autopayData!.length; i++) {
          for (int j = 0; j < widget.autopayData![i].data!.length; j++) {
            autopayDATA.add(widget.autopayData![i].data![j]);
          }
        }

        List<AllConfigurationsData>? find = autopayDATA
            .where((item) => item.cUSTOMERBILLID.toString() == customerBILLID)
            .toList();

        return (find.isNotEmpty ? find[0] : null);
      } catch (e) {}
    }

    return Stack(
      children: [
        ReusableContainer(
            bottomMargin: 10.h,
            child: Column(children: [
              ListTile(
                contentPadding: EdgeInsets.only(
                    left: 8.w, right: 15.w, top: 4.h, bottom: 3.h),
                leading: ImageTileContainer(
                  iconPath: widget.iconPath,
                ),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: MarqueeWidget(
                    direction: Axis.horizontal,
                    // reverse: true,
                    child: Row(
                      children: [
                        Text(
                          widget.titleText,
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
                        //   "( ${widget.titleText} )",
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.subtitleText,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.TXT_CLR_DEFAULT,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.subtitleText2,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.TXT_CLR_LITE,
                          ),
                        ),
                        // if (widget.dueDate != "-")
                        //   if (checkDateExpiry(widget.dueDate.toString()))
                        //     Container(
                        //         decoration: BoxDecoration(
                        //             // color: Colors.red.shade100,
                        //             border: Border.all(
                        //               color:
                        //                   AppColors.CLR_ERROR.withOpacity(0.5),
                        //             ),
                        //             borderRadius: BorderRadius.circular(5.r)),
                        //         child: Padding(
                        //             padding: EdgeInsets.all(4.0.r),
                        //             child: Text(
                        //                 "Overdue by ${daysBetween((DateTime.parse(widget.dueDate!.toString()).add(Duration(days: 1))), DateTime.now())} ${daysBetween((DateTime.parse(widget.dueDate!.toString()).add(Duration(days: 1))), DateTime.now()) == 1 ? "Day" : "Days"}",
                        //                 style: TextStyle(
                        //                     fontSize: 7.sp,
                        //                     fontWeight: FontWeight.w600,
                        //                     color: AppColors.CLR_ERROR)))),
                      ],
                    ),
                  ],
                ),
                // trailing: GestureDetector(
                //   onTap: () {

                //     // final state = context.<MybillersCubit>().state;
                //   },
                //   child: SvgPicture.asset(ICON_DELETE),
                // ),
              ),
              Divider(
                  height: 0.h, thickness: 0.5, color: AppColors.CLR_CON_BORDER),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 3.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.dueStatus != 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.amount != "-")
                            Text(
                              widget.amount,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.TXT_CLR_PRIMARY,
                              ),
                              textAlign: TextAlign.left,
                            ),
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
                                  width: 5,
                                ),
                                Text(
                                  widget.dateText,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.CLR_PRIMARY_LITE,
                                    height: 20 / 12,
                                  ),
                                ),
                              ],
                            )
                          else
                            SizedBox(
                              width: 10.w,
                            ),
                        ],
                      )
                    else
                      SizedBox(
                        width: 10.w,
                      ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.onPressed();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0.w, vertical: 4.w),
                            margin: EdgeInsets.symmetric(vertical: 4.h),
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
                  ],
                ),
              ),
              if (widget.dueDate != "-")
                if (widget.dueStatus != 0)
                  if (checkDateExpiry(widget.dueDate.toString()))
                    Container(
                        width: double.infinity,
                        height: 15.h,
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
            ])),
        // if (buttonText != "Upcoming Auto Payment")
        Positioned(
          top: 0,
          right: 17.w,
          child: InkWell(
            onTap: () {
              if (widget.buttonText != "Pay Now") {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: AppColors.CLR_BACKGROUND,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0.r)),
                        child: Container(
                          height: 300.h,
                          child: Padding(
                            padding: EdgeInsets.all(12.0.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(ICON_DELETE_RED,
                                    height: 50.h, width: 50.w),
                                Text(
                                  "Are You Sure You Want To Delete the Autopay ?",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.CLR_PRIMARY,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "This action is irreversible and will require manual payment for future bills",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.CLR_ERROR,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.0.w, vertical: 10.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: MyAppButton(
                                            onPressed: () async {
                                              GoBack(context);
                                            },
                                            buttonText: "Cancel",
                                            buttonTxtColor: AppColors
                                                .BTN_CLR_ACTIVE_ALTER_TEXT_C,
                                            buttonBorderColor:
                                                AppColors.BTN_CLR_ACTIVE_BORDER,
                                            buttonColor: AppColors
                                                .BTN_CLR_ACTIVE_ALTER_C,
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
                                            onPressed: () async {
                                              var todayDate = DateTime.parse(
                                                      DateTime.now().toString())
                                                  .day
                                                  .toString();
                                              if (todayDate ==
                                                  getAllAutopayList(widget
                                                          .customerBillID)!
                                                      .pAYMENTDATE
                                                      .toString()) {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0.r)),
                                                        child: Container(
                                                          height: 200.h,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    12.0.r),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture.asset(
                                                                    ICON_FAILED,
                                                                    height:
                                                                        50.h,
                                                                    width:
                                                                        50.w),
                                                                Text(
                                                                  "Autopay cannot be deleted as auto pay date is set for today",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color(
                                                                        0xff000000),
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12.0
                                                                              .w,
                                                                      vertical:
                                                                          10.h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Expanded(
                                                                        child: MyAppButton(
                                                                            onPressed: () {
                                                                              GoBack(context);
                                                                            },
                                                                            buttonText: "Okay",
                                                                            buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
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
                                                        ),
                                                      );
                                                    });
                                              } else {
                                                GoBack(context);
                                                GoToData(
                                                    widget.ctx, oTPPAGEROUTE, {
                                                  "from": 'delete-auto-pay',
                                                  "templateName":
                                                      "delete-auto-pay",
                                                  "BillerName":
                                                      widget.subtitleText,
                                                  "BillName": widget.titleText,
                                                  "autopayData":
                                                      getAllAutopayList(widget
                                                          .customerBillID),
                                                  "context": widget.ctx,
                                                  "data": {
                                                    "billerName":
                                                        widget.subtitleText,
                                                    "cUSTOMERBILLID":
                                                        widget.customerBillID,
                                                  }
                                                });
                                              }
                                            },
                                            buttonText: "Delete",
                                            buttonTxtColor: AppColors
                                                .BTN_CLR_ACTIVE_ALTER_TEXT,
                                            buttonBorderColor:
                                                Colors.transparent,
                                            buttonColor:
                                                AppColors.BTN_CLR_ACTIVE_ALTER,
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
                        ),
                      );
                    });
              } else {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: AppColors.CLR_BACKGROUND,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0.r)),
                        child: Container(
                          height: 180.h,
                          margin: EdgeInsets.all(20.r),
                          child: Padding(
                            padding: EdgeInsets.all(12.0.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(ICON_DELETE_RED,
                                    height: 40.h, width: 40.w),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    "Are You Sure You Want To Delete the Due ?",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.TXT_CLR_BLACK_W,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.0.w, vertical: 10.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: MyAppButton(
                                            onPressed: () async {
                                              GoBack(context);
                                            },
                                            buttonText: "Cancel",
                                            buttonTxtColor: AppColors
                                                .BTN_CLR_ACTIVE_ALTER_TEXT_C,
                                            buttonBorderColor:
                                                AppColors.BTN_CLR_ACTIVE_BORDER,
                                            buttonColor: AppColors
                                                .BTN_CLR_ACTIVE_ALTER_C,
                                            buttonSizeX: 10.h,
                                            buttonSizeY: 35.w,
                                            buttonTextSize: 14.sp,
                                            buttonTextWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Expanded(
                                        child: MyAppButton(
                                            onPressed: () async {
                                              widget.onDeleteUpPressed();
                                              GoBack(context);
                                            },
                                            buttonText: "Delete",
                                            buttonTxtColor: AppColors
                                                .BTN_CLR_ACTIVE_ALTER_TEXT,
                                            buttonBorderColor:
                                                Colors.transparent,
                                            buttonColor:
                                                AppColors.BTN_CLR_ACTIVE_ALTER,
                                            buttonSizeX: 10.h,
                                            buttonSizeY: 35.w,
                                            buttonTextSize: 14.sp,
                                            buttonTextWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            },
            child: CircleAvatar(
              backgroundColor: AppColors.CLR_CON_BORDER,
              radius: 12.5.r,
              child: CircleAvatar(
                backgroundColor: AppColors.CLR_BACKGROUND,
                radius: 12.r,
                child: SvgPicture.asset(
                  ICON_DELETE,
                  height: 12.h,
                  width: 12.w,
                  colorFilter:
                      ColorFilter.mode(AppColors.TXT_CLR_LITE, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
