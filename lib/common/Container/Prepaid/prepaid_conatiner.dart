import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/prepaid_fetch_plans_model.dart';
import 'package:ebps/widget/dash_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PrepaidPlansContainer extends StatefulWidget {
  PrepaidPlansData? prepaidPlans;
  BillersData? billerData;
  final VoidCallback onPressed;

  PrepaidPlansContainer(
      {super.key,
      required this.prepaidPlans,
      this.billerData,
      required this.onPressed});

  @override
  State<PrepaidPlansContainer> createState() => _PrepaidPlansContainerState();
}

class _PrepaidPlansContainerState extends State<PrepaidPlansContainer> {
  bool isShowMore = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin:
          EdgeInsets.only(left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.r),
        border: Border.all(
          color: Color(0xFFD1D9E8),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    widget.prepaidPlans!.planAdditionalInfo!.data.toString() ==
                            '0'
                        ? "Talktime"
                        : "Data",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff808080),
                    ),
                  ),
                  Text(
                    widget.prepaidPlans!.planAdditionalInfo!.data.toString() ==
                            '0'
                        ? widget.prepaidPlans!.planAdditionalInfo!.talktime
                            .toString()
                        : widget.prepaidPlans!.planAdditionalInfo!.data
                            .toString(),
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: TXT_CLR_DEFAULT,
                        overflow: TextOverflow.fade),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Validity",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff808080),
                    ),
                  ),
                  Text(
                    widget.prepaidPlans!.planAdditionalInfo!.validity
                        .toString(),
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: TXT_CLR_DEFAULT,
                        overflow: TextOverflow.fade),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.r, 0.r, 0.r, 0.r),
                child: Text(
                  "₹ ${NumberFormat('#,##,##0').format(double.parse(widget.prepaidPlans!.amount.toString()))}",
                  style: TextStyle(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1b438b),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0.r, 16.r, 16.r, 8.r),
            child: DashLine(
              fillRate: 0.8,
              dashHeight: 0.7.h,
              dashColor: CLR_GREY,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0.r, 8.r, 16.r, 8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 210.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prepaidPlans!.planAdditionalInfo!
                                    .additionalBenefits !=
                                null
                            ? widget.prepaidPlans!.planAdditionalInfo!
                                .additionalBenefits
                                .toString()
                            : widget.prepaidPlans!.planDesc.toString(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: CLR_SECONDARY,
                        ),
                        maxLines: isShowMore ? 10 : 2,
                        textAlign: TextAlign.justify,
                      ),
                      if (widget.prepaidPlans!.planAdditionalInfo!
                                  .additionalBenefits !=
                              null
                          ? widget.prepaidPlans!.planAdditionalInfo!
                                  .additionalBenefits
                                  .toString()
                                  .length >
                              70
                          : widget.prepaidPlans!.planDesc.toString().length >
                              70)
                        InkWell(
                          onTap: () {
                            setState(() {
                              isShowMore = !isShowMore;
                            });
                          },
                          child: Text(
                            isShowMore ? "Show less" : "Show more",
                            style: TextStyle(
                                color: TXT_CLR_DEFAULT,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp),
                          ),
                        ),
                    ],
                  ),
                ),
                MyAppButton(
                    onPressed: () {
                      widget.onPressed();
                    },
                    buttonText: "Pay",
                    buttonTxtColor: BTN_CLR_ACTIVE,
                    buttonBorderColor: Colors.transparent,
                    buttonColor: CLR_PRIMARY,
                    buttonSizeX: 10.h,
                    buttonSizeY: 30.w,
                    buttonTextSize: 14.sp,
                    buttonTextWeight: FontWeight.w500),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
