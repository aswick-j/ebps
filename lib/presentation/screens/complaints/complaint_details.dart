import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/data/models/complaints_model.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Container/Home/biller_details_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ComplaintDetails extends StatefulWidget {
  ComplaintsData complaintData;
  ComplaintDetails({
    super.key,
    required this.complaintData,
  });

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  @override
  Widget build(BuildContext context) {
    Widget CmpDetails(
        {String title = "", String subTitle = "", required bool showStatus}) {
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
                      border: Border.all(color: CLR_ERROR),
                      borderRadius: BorderRadius.circular(12.0.r),
                    ),
                    child: Text(
                      subTitle.toString(),
                      style: TextStyle(
                        color: CLR_ERROR,
                        fontSize: 10.0.sp,
                      ),
                    ),
                  ),
                if (!showStatus)
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1b438b),
                    ),
                    textAlign: TextAlign.left,
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
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0.r),
                  border: Border.all(
                    color: Color(0xFFD1D9E8),
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    BillerDetailsContainer(
                        icon: LOGO_BBPS,
                        billerName: "biller Name",
                        categoryName: "categoryName"),
                    CmpDetails(
                        title: "Status",
                        subTitle: widget.complaintData.sTATUS.toString(),
                        showStatus: true),
                    CmpDetails(
                        title: "Complaint ID",
                        subTitle: widget.complaintData.cOMPLAINTID.toString(),
                        showStatus: false),
                    CmpDetails(
                        title: "Reason",
                        subTitle:
                            widget.complaintData.cOMPLAINTREASON.toString(),
                        showStatus: false),
                    CmpDetails(
                        title: "Issued Date",
                        subTitle: DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(
                                    widget.complaintData.cREATEDON.toString())
                                .toLocal()),
                        showStatus: false),
                    CmpDetails(
                        title: "Type",
                        subTitle: widget.complaintData.tRANSACTIONID.toString(),
                        showStatus: false),
                    CmpDetails(
                        title: "Description",
                        subTitle: widget.complaintData.dESCRIPTION.toString(),
                        showStatus: false),
                  ],
                ))));
  }
}
