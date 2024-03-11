import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/refresh_dues.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getBillerType.dart';
import 'package:ebps/models/saved_biller_model.dart';
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

  UpcomingDuesContainer(
      {super.key,
      required this.dateText,
      required this.buttonText,
      required this.amount,
      required this.iconPath,
      required this.containerBorderColor,
      required this.buttonColor,
      required this.buttonTxtColor,
      required this.buttonBorderColor,
      required this.buttonTextWeight,
      required this.savedBillersData,
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

          margin: EdgeInsets.only(
              left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0.r),
            side: BorderSide(
              color: widget.containerBorderColor,
              width: 2.0,
            ),
          ),
          child: !isFetchbillLoading
              ? Column(
                  children: [
                    ListTile(
                      contentPadding:
                          EdgeInsets.only(left: 8.w, right: 15.w, top: 4.h),
                      leading: Container(
                        width: 45.w,
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: SvgPicture.asset(widget.iconPath),
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.only(bottom: 5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.savedBillersData!.bILLNAME.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: TXT_CLR_PRIMARY,
                              ),
                              textAlign: TextAlign.left,
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
                                                leading: Container(
                                                  width: 45.w,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.r),
                                                    child: SvgPicture.asset(
                                                        widget.iconPath),
                                                  ),
                                                ),
                                                title: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5.h),
                                                  child: Text(
                                                    widget.savedBillersData!
                                                        .bILLNAME
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff191919),
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
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff808080),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Text(
                                                      widget.savedBillersData!
                                                          .pARAMETERVALUE
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff808080),
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
                                                            .withOpacity(0.5),
                                                        spreadRadius: 0.6,
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2)),
                                                  ],
                                                ),
                                                child: Divider(
                                                  height: 1.h,
                                                  thickness: 1,
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              RefreshDues(
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
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: TXT_CLR_DEFAULT,
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
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff808080),
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                widget.amount,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1b438b),
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
                      thickness: 1,
                      indent: 10.w,
                      endIndent: 10.w,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 15.w, right: 15.w, bottom: 0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                ICON_CALENDAR,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                widget.dateText,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff808080),
                                ),
                              ),
                            ],
                          ),
                          MyAppButton(
                              onPressed: () {
                                widget.onPressed();
                              },
                              buttonText: widget.buttonText,
                              buttonTxtColor: widget.buttonTxtColor,
                              buttonBorderColor: widget.buttonBorderColor,
                              buttonColor: widget.buttonColor,
                              buttonSizeX: 10.h,
                              buttonSizeY: 25.w,
                              buttonTextSize: 10.sp,
                              buttonTextWeight: FontWeight.w500),
                        ],
                      ),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}
