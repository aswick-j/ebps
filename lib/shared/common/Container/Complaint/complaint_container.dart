import 'package:ebps/domain/models/complaints_model.dart';
import 'package:ebps/shared/constants/assets.dart';
import 'package:ebps/shared/constants/colors.dart';
import 'package:ebps/shared/constants/routes.dart';
import 'package:ebps/shared/helpers/getNavigators.dart';
import 'package:ebps/shared/common/Text/MyAppText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComplaintContainer extends StatefulWidget {
  final String titleText;
  final String subtitleText;
  final String dateText;
  final String? statusText;
  final String amount;
  final String iconPath;
  final Color containerBorderColor;
  ComplaintsData complaintData;

  ComplaintContainer({
    super.key,
    required this.titleText,
    required this.subtitleText,
    required this.dateText,
    this.statusText,
    required this.amount,
    required this.iconPath,
    required this.containerBorderColor,
    required this.complaintData,
  });
  @override
  State<ComplaintContainer> createState() => _ComplaintContainerState();
}

class _ComplaintContainerState extends State<ComplaintContainer> {
  handleClick() {
    goToData(context, cOMPLAINTDETAILSROUTE,
        {"complaintData": widget.complaintData});
  }

  @override
  Widget build(BuildContext context) {
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
            color: widget.containerBorderColor,
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
                  child: SvgPicture.asset(widget.iconPath),
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150.w,
                      child: MyAppText(
                        // data: "Jio Telecom Services",
                        data: widget.titleText,
                        size: 14.0.sp,
                        color: TXT_CLR_LITE,
                        weight: FontWeight.w500,
                      ),
                    ),
                    MyAppText(
                      data: widget.amount,
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
                  MyAppText(
                    data: "Complaint ID",
                    size: 12.sp,
                    color: Color(0xff7d7d7d),
                    weight: FontWeight.w400,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyAppText(
                        data: widget.subtitleText,
                        size: 14.0.sp,
                        color: TXT_CLR_PRIMARY,
                        weight: FontWeight.w500,
                      ),
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
                        data: widget.dateText,
                        size: 14.0.sp,
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
                        if (widget.statusText != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: CLR_ERROR),
                              borderRadius: BorderRadius.circular(12.0.r),
                            ),
                            child: Text(
                              widget.statusText.toString(),
                              style: TextStyle(
                                color: CLR_ERROR,
                                fontSize: 10.0.sp,
                              ),
                            ),
                          ),
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.arrow_forward,
                          size: 20.r,
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
