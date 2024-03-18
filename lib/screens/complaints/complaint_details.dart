import 'package:ebps/bloc/complaint/complaint_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/Home/biller_details_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/helpers/getComplaintStatus.dart';
import 'package:ebps/models/complaints_model.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ComplaintDetails extends StatefulWidget {
  ComplaintsData complaintData;
  final void Function(String?, String?) handleStatus;
  ComplaintDetails(
      {super.key, required this.complaintData, required this.handleStatus});

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  bool isCmpStatusLoading = true;
  @override
  void initState() {
    Map<String, dynamic> payload = {
      "type": "transaction",
      "complaintID": widget.complaintData.cOMPLAINTID.toString(),
      "currentStatus": widget.complaintData.sTATUS.toString()
    };
    BlocProvider.of<ComplaintCubit>(context).updateCmpStatus(payload);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget CmpDetails(
        {String title = "",
        String subTitle = "",
        required bool showStatus,
        clipBoard = false}) {
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
                color: Color(0xff808080),
                height: 23 / 14,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                if (showStatus)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: getComplaintStatusColors(subTitle.toString())),
                      borderRadius: BorderRadius.circular(12.0.r),
                    ),
                    child: Text(
                      getComplaintStatusValue(subTitle.toString()),
                      style: TextStyle(
                        color: getComplaintStatusColors(subTitle.toString()),
                        fontSize: 10.0.sp,
                      ),
                    ),
                  ),
                if (!showStatus)
                  Row(
                    children: [
                      SizedBox(
                        width: showStatus || clipBoard ? null : 270.w,
                        child: Text(
                          subTitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1b438b),
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '$title copied to clipboard')));
                              });
                            },
                            child: Icon(Icons.copy,
                                color: Color(0xff1b438b), size: 20))
                    ],
                  ),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
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
                  widget.handleStatus(
                      state.CmpStatusUpdateDetails!.data.toString(),
                      widget.complaintData.cOMPLAINTID);
                  isCmpStatusLoading = false;
                } else if (state is CmpStatusUpdateFailed) {
                  isCmpStatusLoading = false;
                } else if (state is CmpStatusUpdateError) {
                  isCmpStatusLoading = false;
                }
              },
              builder: (context, state) {
                return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 18.0.w, right: 18.w, top: 10.h, bottom: 20.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0.r),
                      border: Border.all(
                        color: Color(0xFFD1D9E8),
                        width: 2.0,
                      ),
                    ),
                    child: !isCmpStatusLoading
                        ? Column(
                            children: [
                              BillerDetailsContainer(
                                  icon: BILLER_LOGO(widget
                                      .complaintData.bILLERNAME
                                      .toString()),
                                  billerName: widget.complaintData.bILLERNAME
                                      .toString(),
                                  categoryName: widget
                                      .complaintData.cATEGORYNAME
                                      .toString()),
                              CmpDetails(
                                  title: "Status",
                                  subTitle:
                                      widget.complaintData.sTATUS.toString(),
                                  showStatus: true),
                              CmpDetails(
                                  title: "Assigned to",
                                  subTitle:
                                      widget.complaintData.sTATUS.toString(),
                                  showStatus: false),
                              if (widget.complaintData.rEMARKS != null)
                                CmpDetails(
                                    title: "Remarks",
                                    subTitle:
                                        widget.complaintData.rEMARKS.toString(),
                                    showStatus: false),
                              CmpDetails(
                                  title: "Complaint ID",
                                  subTitle: widget.complaintData.cOMPLAINTID
                                      .toString(),
                                  clipBoard: true,
                                  showStatus: false),
                              CmpDetails(
                                  title: "Transaction ID",
                                  clipBoard: true,
                                  subTitle: widget.complaintData.tRANSACTIONID
                                      .toString(),
                                  showStatus: false),
                              CmpDetails(
                                  title: "Reason",
                                  subTitle: widget.complaintData.cOMPLAINTREASON
                                      .toString(),
                                  showStatus: false),
                              CmpDetails(
                                  title: "Issued Date",
                                  subTitle: DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(widget
                                              .complaintData.cREATEDON
                                              .toString())
                                          .toLocal()),
                                  showStatus: false),
                              CmpDetails(
                                  title: "Type",
                                  subTitle: "Transaction",
                                  showStatus: false),
                              CmpDetails(
                                  title: "Description",
                                  subTitle: widget.complaintData.dESCRIPTION
                                      .toString(),
                                  showStatus: false),
                            ],
                          )
                        : Container(
                            height: 560.h,
                            child: FlickrLoader(),
                          ));
              },
            )));
  }
}
