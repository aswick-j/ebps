import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:ebps/bloc/complaint/complaint_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/Home/biller_details_container.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getComplaintStatus.dart';
import 'package:ebps/models/complaints_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ComplaintDetails extends StatefulWidget {
  ComplaintsData complaintData;
  final void Function(String?, String?, String?, String?) handleStatus;
  ComplaintDetails(
      {super.key, required this.complaintData, required this.handleStatus});

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  bool isCmpStatusLoading = true;
  @override
  void initState() {
    if (widget.complaintData.sTATUS.toString().toLowerCase() == "resolved" ||
        widget.complaintData.sTATUS.toString().toLowerCase() == "unresolved") {
      isCmpStatusLoading = false;
    } else {
      Map<String, dynamic> payload = {
        "type": "transaction",
        "complaintID": widget.complaintData.cOMPLAINTID.toString(),
        "currentStatus": widget.complaintData.sTATUS.toString()
      };
      BlocProvider.of<ComplaintCubit>(context).updateCmpStatus(payload);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget CmpDetails(
        {String title = "", String subTitle = "", clipBoard = false}) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.TXT_CLR_LITE,
                height: 23 / 14,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: clipBoard ? null : 270.w,
                      child: Text(
                        subTitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.CLR_PRIMARY,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    if (clipBoard != false) SizedBox(width: 10.w),
                    if (clipBoard != false)
                      GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: subTitle))
                                .then((_) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  '$title copied to clipboard',
                                  style: TextStyle(
                                      color: AppColors.CLR_BACKGROUND,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: AppColors.CLR_PRIMARY,
                              ));
                            });
                          },
                          child: Icon(Icons.copy,
                              color: AppColors.CLR_PRIMARY, size: 20))
                  ],
                ),
              ],
            )
          ],
        ),
      );
    }

    var colorizeTextStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: Color(0xff1b438b),
    );

    const colorizeColors = [
      Colors.red,
      Colors.orange,
      Colors.orange,
      Colors.red,
    ];

    void showToast() {
      return DelightToastBar(
        autoDismiss: true,
        animationDuration: Duration(milliseconds: 300),
        builder: (context) => ToastCard(
          color: AppColors.CLR_BACKGROUND,
          shadowColor: Colors.grey.withOpacity(0.2),
          leading: Icon(Icons.cancel_outlined,
              size: 28.r, color: AppColors.CLR_ERROR),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Oops !",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.TXT_CLR_DEFAULT,
                ),
                textAlign: TextAlign.left,
                maxLines: 2,
              ),
              Text(
                "Unable to Refresh the Complaint Status. Please try again.",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.CLR_PRIMARY,
                ),
                textAlign: TextAlign.left,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ).show(context);
    }

    return Scaffold(
        backgroundColor: AppColors.CLR_BACKGROUND,
        appBar: MyAppBar(
          context: context,
          title: 'Complaint Details',
          actions: [],
          onLeadingTap: () => Navigator.pop(context),
          showActions: true,
          onSearchTap: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: BlocConsumer<ComplaintCubit, ComplaintState>(
              listener: (context, state) {
                if (state is CmpStatusUpdateLoading) {
                  isCmpStatusLoading = true;
                } else if (state is CmpStatusUpdateSuccess) {
                  if (state.CmpStatusUpdateDetails?.data?.responseReason !=
                      "Complaint not found") {
                    widget.handleStatus(
                        state.CmpStatusUpdateDetails!.data!.complaintStatus
                            .toString(),
                        widget.complaintData.cOMPLAINTID,
                        state.CmpStatusUpdateDetails!.data!.remarks.toString(),
                        state.CmpStatusUpdateDetails!.data!.assigned
                            .toString());
                  } else {
                    showToast();
                  }
                  isCmpStatusLoading = false;
                } else if (state is CmpStatusUpdateFailed) {
                  isCmpStatusLoading = false;
                  showToast();
                } else if (state is CmpStatusUpdateError) {
                  isCmpStatusLoading = false;
                  showToast();
                }
              },
              builder: (context, state) {
                return ReusableContainer(
                    bottomMargin: 20.h,
                    child: Column(
                      children: [
                        BillerDetailsContainer(
                          icon: BILLER_LOGO(
                              widget.complaintData.bILLERNAME.toString()),
                          title: widget.complaintData.bILLERNAME.toString(),
                          subTitle:
                              widget.complaintData.cATEGORYNAME.toString(),
                          subTitle2: "",
                        ),
                        Divider(
                          color: AppColors.CLR_DIVIDER_LITE,
                          height: 1.h,
                          thickness: 0.50,
                          // indent: 10.w,
                          // endIndent: 10.w,
                        ),
                        // CmpDetails(
                        //     title: "Status",
                        //     subTitle:
                        //         widget.complaintData.sTATUS.toString(),
                        //     showStatus: true),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0.w, vertical: 8.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.TXT_CLR_LITE,
                                  height: 23 / 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            !isCmpStatusLoading ? null : 270.w,
                                        child: !isCmpStatusLoading
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0.w,
                                                    vertical: 4.w),

                                                decoration: BoxDecoration(
                                                    // border: Border.all(
                                                    //     color: widget.buttonTxtColor
                                                    //         .withOpacity(0.5)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        getComplaintStatusColors(
                                                                widget
                                                                    .complaintData
                                                                    .sTATUS
                                                                    .toString())
                                                            .withOpacity(0.5),
                                                        // Color(0xff0373c4),
                                                        Color.fromARGB(
                                                            255, 212, 223, 231)
                                                      ],
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                    )),
                                                // decoration: BoxDecoration(
                                                //   border:
                                                //       Border.all(color: widget.buttonTxtColor),
                                                //   borderRadius: BorderRadius.circular(12.0.r),
                                                // ),
                                                child: Text(
                                                  getComplaintStatusValue(widget
                                                      .complaintData.sTATUS
                                                      .toString()),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9.0.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            : Row(
                                                children: [
                                                  AnimatedTextKit(
                                                    repeatForever: true,
                                                    isRepeatingAnimation: true,
                                                    animatedTexts: [
                                                      ColorizeAnimatedText(
                                                        'Checking Complaint Status',
                                                        textStyle:
                                                            colorizeTextStyle,
                                                        colors: colorizeColors,
                                                      ),
                                                    ],
                                                  ),
                                                  AnimatedTextKit(
                                                      repeatForever: true,
                                                      isRepeatingAnimation:
                                                          true,
                                                      animatedTexts: [
                                                        TyperAnimatedText(
                                                            ' . . .',
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            speed: Duration(
                                                                milliseconds:
                                                                    100)),
                                                      ]),
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        CmpDetails(
                          title: "Assigned to",
                          subTitle: widget.complaintData.aSSIGNED.toString(),
                        ),
                        CmpDetails(
                          title: "Complaint ID",
                          subTitle: widget.complaintData.cOMPLAINTID.toString(),
                          clipBoard: true,
                        ),
                        CmpDetails(
                          title: "Transaction ID",
                          clipBoard: true,
                          subTitle:
                              widget.complaintData.tRANSACTIONID.toString(),
                        ),
                        CmpDetails(
                          title: "Reason",
                          subTitle:
                              widget.complaintData.cOMPLAINTREASON.toString(),
                        ),
                        CmpDetails(
                          title: "Issued Date",
                          subTitle: DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(
                                      widget.complaintData.cREATEDON.toString())
                                  .toLocal()),
                        ),
                        CmpDetails(
                          title: "Type",
                          subTitle: "Transaction - Based",
                        ),
                        CmpDetails(
                          title: "Description",
                          subTitle: widget.complaintData.dESCRIPTION.toString(),
                        ),
                        if (widget.complaintData.rEMARKS != null)
                          CmpDetails(
                            title: "Remarks",
                            subTitle: widget.complaintData.rEMARKS.toString(),
                          ),
                      ],
                    ));
                // : Container(
                //     height: 560.h,
                //     child: Loader(),
                //   ));
              },
            )));
  }
}
