import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
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
    return ReusableContainer(
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
                      color: AppColors.TXT_CLR_LITE,
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
                        color: AppColors.TXT_CLR_BLACK_W,
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
                      color: AppColors.TXT_CLR_LITE,
                    ),
                  ),
                  Text(
                    widget.prepaidPlans!.planAdditionalInfo!.validity
                        .toString(),
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.TXT_CLR_BLACK_W,
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
                    color: AppColors.CLR_PRIMARY,
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
              dashColor: AppColors.CLR_GREY,
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
                          color: AppColors.CLR_BLUE_LITE,
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
                                color: AppColors.TXT_CLR_BLACK_W,
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
                    buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                    buttonBorderColor: Colors.transparent,
                    buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
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
