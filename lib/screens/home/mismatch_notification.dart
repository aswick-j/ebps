import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MismatchNotification extends StatefulWidget {
  List<AllConfigurationsData>? allautoPayData;
  List<PARAMETERS> savedinput = [];
  BuildContext context;
  MismatchNotification({super.key, this.allautoPayData, required this.context});

  @override
  State<MismatchNotification> createState() => _MismatchNotificationState();
}

class _MismatchNotificationState extends State<MismatchNotification> {
  final controller = PageController(
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 24.h),
      child: Center(
        child: Column(children: [
          Container(
            height: 370.h,
            margin: EdgeInsets.fromLTRB(0, 120.h, 0, 10.h),
            child: PageView.builder(
              controller: controller,
              itemCount: widget.allautoPayData!.length,
              itemBuilder: (_, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0.r),
                    color: Colors.white,
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 30.h, 0, 20.h),
                          child: SvgPicture.asset(
                            ICON_ERROR,
                            height: 45.h,
                            width: 45.w,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                          child: Text(
                            widget.allautoPayData![index].rESETDATE == 1
                                ? "Auto Pay Date not in between the Bill Generation and Bill Due date, please update accordingly."
                                : "Auto Pay Limit lesser than the Bill Due Amount,\ndo you wish to revise it.",
                            // "Auto Pay ${widget.allautoPayData![index].rESETDATE == 1 ? "Date" : "Limit"} Seems to be Mismatch",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff000000),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
                          child: SvgPicture.asset(
                            LOGO_BBPS,
                            height: 35.h,
                            width: 35.w,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                          child: Text(
                            "${widget.allautoPayData![index].bILLNAME} - ${widget.allautoPayData![index].bILLERNAME}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: CLR_PRIMARY,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GridView.count(
                            shrinkWrap: true,
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 0,
                            crossAxisCount: 2,
                            childAspectRatio: 4 / 2,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              8.w, 10.h, 0, 0),
                                          child: Text(
                                            widget.allautoPayData![index]
                                                        .rESETDATE ==
                                                    1
                                                ? "Due Date"
                                                : "Due Amount",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff808080),
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              8.w, 10.h, 0, 0),
                                          child: Text(
                                            widget.allautoPayData![index]
                                                        .rESETDATE ==
                                                    1
                                                ? widget.allautoPayData![index]
                                                    .dUEDATE
                                                    .toString()
                                                : widget.allautoPayData![index]
                                                    .dUEAMOUNT
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff1b438b),
                                            ),
                                            textAlign: TextAlign.left,
                                          ))
                                    ],
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              8.w, 10.h, 0, 0),
                                          child: Text(
                                            widget.allautoPayData![index]
                                                        .rESETDATE ==
                                                    1
                                                ? "Auto Pay Date"
                                                : "Auto Pay Limit",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff808080),
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              8.w, 10.h, 0, 0),
                                          child: Text(
                                            widget.allautoPayData![index]
                                                        .rESETDATE ==
                                                    1
                                                ? widget.allautoPayData![index]
                                                    .pAYMENTDATE
                                                    .toString()
                                                : widget.allautoPayData![index]
                                                    .mAXIMUMAMOUNT
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff1b438b),
                                            ),
                                            textAlign: TextAlign.left,
                                          ))
                                    ],
                                  ))
                            ]),
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
                                    buttonText: "Later",
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
                                      await setSharedNotificationValue(
                                          "NOTIFICATION", false);

                                      goBack(context);
                                      goToData(
                                          widget.context, eDITAUTOPAYROUTE, {
                                        "billerName": widget
                                            .allautoPayData![index].bILLERNAME,
                                        "categoryName": "sss",
                                        "lastPaidAmount": widget
                                            .allautoPayData![index].dUEAMOUNT,
                                        "billName": widget
                                            .allautoPayData![index].bILLNAME,
                                        "customerBillID": widget
                                            .allautoPayData![index]
                                            .cUSTOMERBILLID
                                            .toString(),
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
                                    },
                                    buttonText: "Proceed",
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
