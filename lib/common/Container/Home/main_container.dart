import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MainContainer extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String subtitleText2;
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
  final VoidCallback onDeleteUpPressed;
  final String customerBillID;
  final BuildContext ctx;
  final List<AllConfigurations>? autopayData;

  const MainContainer({
    super.key,
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
    required this.onDeleteUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    getAllAutopayList(customerBILLID) {
      try {
        List<AllConfigurationsData>? autopayDATA = [];
        for (int i = 0; i < autopayData!.length; i++) {
          for (int j = 0; j < autopayData![i].data!.length; j++) {
            autopayDATA.add(autopayData![i].data![j]);
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
        Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                left: 18.0.w, right: 18.w, top: 10.h, bottom: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0.r),
              border: Border.all(
                color: Color(0xFFD1D9E8),
                width: 2.0,
              ),
            ),
            child: Column(children: [
              ListTile(
                contentPadding:
                    EdgeInsets.only(left: 8.w, right: 15.w, top: 4.h),
                leading: Container(
                  width: 45.w,
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: SvgPicture.asset(iconPath),
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: Text(
                    titleText,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff191919),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitleText,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff808080),
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      subtitleText2,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff808080),
                      ),
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
                height: 10.h,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 6.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          amount,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1b438b),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(ICON_CALENDAR),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              dateText,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff808080),
                                height: 20 / 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        MyAppButton(
                            onPressed: () {
                              onPressed();
                            },
                            buttonText: buttonText,
                            buttonTxtColor: buttonTxtColor,
                            buttonBorderColor: buttonBorderColor,
                            buttonColor: buttonColor,
                            buttonSizeX: 10.h,
                            buttonSizeY: 27.w,
                            buttonTextSize: 10.sp,
                            buttonTextWeight: FontWeight.w500),
                      ],
                    ),
                  ],
                ),
              ),
            ])),
        // if (buttonText != "Upcoming Auto Payment")
        Positioned(
          top: 0,
          right: 17.w,
          child: InkWell(
            onTap: () {
              if (buttonText == "Upcoming Auto Payment") {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0.r)),
                        child: Container(
                          height: 200.h,
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
                                    color: Color(0xff000000),
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
                                              goBack(context);
                                            },
                                            buttonText: "Cancel",
                                            buttonTxtColor: CLR_PRIMARY,
                                            buttonBorderColor: CLR_PRIMARY,
                                            buttonColor: BTN_CLR_ACTIVE,
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
                                                  getAllAutopayList(
                                                          customerBillID)!
                                                      .pAYMENTDATE
                                                      .toString()) {
                                                showDialog(
                                                    context: context,
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
                                                                              goBack(context);
                                                                            },
                                                                            buttonText: "Okay",
                                                                            buttonTxtColor: BTN_CLR_ACTIVE,
                                                                            buttonBorderColor: Colors.transparent,
                                                                            buttonColor: CLR_PRIMARY,
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
                                                goBack(context);
                                                goToData(ctx, oTPPAGEROUTE, {
                                                  "from": 'delete-auto-pay',
                                                  "templateName":
                                                      "delete-auto-pay",
                                                  "autopayData":
                                                      getAllAutopayList(
                                                          customerBillID),
                                                  "context": ctx,
                                                  "data": {
                                                    "billerName": subtitleText,
                                                    "cUSTOMERBILLID":
                                                        customerBillID,
                                                  }
                                                });
                                              }
                                            },
                                            buttonText: "Delete",
                                            buttonTxtColor: BTN_CLR_ACTIVE,
                                            buttonBorderColor:
                                                Colors.transparent,
                                            buttonColor: CLR_PRIMARY,
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
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0.r)),
                        child: Container(
                          height: 200.h,
                          child: Padding(
                            padding: EdgeInsets.all(12.0.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(ICON_DELETE_RED,
                                    height: 50.h, width: 50.w),
                                Text(
                                  "Are You Sure You Want To Delete the Due ?",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff000000),
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
                                              goBack(context);
                                            },
                                            buttonText: "Cancel",
                                            buttonTxtColor: CLR_PRIMARY,
                                            buttonBorderColor: CLR_PRIMARY,
                                            buttonColor: BTN_CLR_ACTIVE,
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
                                              onDeleteUpPressed();
                                              goBack(context);
                                            },
                                            buttonText: "Delete",
                                            buttonTxtColor: BTN_CLR_ACTIVE,
                                            buttonBorderColor:
                                                Colors.transparent,
                                            buttonColor: CLR_PRIMARY,
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
              }
            },
            child: CircleAvatar(
              backgroundColor: Color(0xFFD1D9E8),
              radius: 13.5.r,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 12.r,
                child: SvgPicture.asset(ICON_DELETE, height: 12.h, width: 12.w),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
