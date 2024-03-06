import 'dart:convert';

import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getGradientColors.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getTransactionStatusReason.dart';
import 'package:ebps/helpers/getTransactionStatusText.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/confirm_done_model.dart';
import 'package:ebps/models/history_model.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/generate_pdf.dart';
import 'package:ebps/widget/screenshot_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

class HistoryDetails extends StatefulWidget {
  bool? isSavedBill;
  String billName;
  String categoryName;
  String billerName;
  HistoryData historyData;
  HistoryDetails({
    super.key,
    required this.billName,
    required this.billerName,
    required this.categoryName,
    required this.isSavedBill,
    required this.historyData,
  });

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  confirmDoneData? tnxResponse;
  var billData;
  BillersData? billerTypeData;

  Map<String, dynamic>? paymentDetails;
  Map<String, dynamic>? billerTypeResult;
  ScreenshotController screenshotController = ScreenshotController();
  // Uint8List? capturedImage;
  @override
  void initState() {
    super.initState();
  }

  Widget TxnDetails(
      {String title = "",
      String subTitle = "",
      bool? clipBoard,
      bool? showLogo}) {
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
              if (showLogo == true)
                Image.asset(LOGO_EQUITAS_E, height: 40.h, width: 40.w),
              if (showLogo == true) SizedBox(width: 10.w),
              SizedBox(
                width: showLogo == true || clipBoard != false ? null : 250.w,
                child: Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1b438b),
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                ),
              ),
              SizedBox(width: 10.w),
              if (clipBoard != false)
                GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: subTitle))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('$title copied to clipboard')));
                      });
                    },
                    child: Icon(Icons.copy, color: Color(0xff1b438b), size: 20))
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: 'Payment Details',
          onLeadingTap: () => {
            goBack(context),
          },
          showActions: false,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Screenshot(
            controller: screenshotController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0.r + 2.r),
                      border: Border.all(
                        color: Color(0xffD1D9E8),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          height: 33.0.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              stops: const [0.001, 19],
                              colors: getStatusGradientColors(widget
                                          .historyData.tRANSACTIONSTATUS
                                          .toString()
                                          .toLowerCase() ==
                                      "success"
                                  ? "success"
                                  : widget.historyData.tRANSACTIONSTATUS
                                                  .toString()
                                                  .toLowerCase() ==
                                              "bbps-in-progress" ||
                                          widget.historyData.tRANSACTIONSTATUS
                                                  .toString()
                                                  .toLowerCase() ==
                                              "bbps-timeout"
                                      ? "pending"
                                      : "failed"),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.historyData.tRANSACTIONSTATUS
                                            .toString()
                                            .toLowerCase() ==
                                        "success"
                                    ? "Transaction Success"
                                    : widget.historyData.tRANSACTIONSTATUS
                                                    .toString()
                                                    .toLowerCase() ==
                                                "bbps-in-progress" ||
                                            widget.historyData.tRANSACTIONSTATUS
                                                    .toString()
                                                    .toLowerCase() ==
                                                "bbps-timeout"
                                        ? "Transaction Pending "
                                        : "Transaction Failure",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffffffff),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          contentPadding:
                              EdgeInsets.only(left: 30.w, right: 6.w, top: 6.h),
                          title: Padding(
                              padding: EdgeInsets.only(bottom: 5.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset(ICON_ARROW_UP,
                                              height: 20.h),
                                          Text(
                                            "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.historyData.bILLAMOUNT.toString()))}",
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff1b438b),
                                              height: 33 / 20,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                Uint8List? capturedImage = await screenshotController.captureFromWidget(
                                                    InheritedTheme.captureAll(
                                                        context,
                                                        Material(
                                                            child: ScreenshotContainer(
                                                                channel: widget.historyData.pAYMENTCHANNEL == 'IB'
                                                                    ? "Equitas - Internet Banking"
                                                                    : "Equitas - Mobile Banking",
                                                                BillerName: widget
                                                                    .billerName
                                                                    .toString(),
                                                                BillerId: widget
                                                                    .historyData
                                                                    .bILLERID
                                                                    .toString(),
                                                                BillName: widget
                                                                    .historyData
                                                                    .bILLNAME
                                                                    .toString(),
                                                                ParamName: widget
                                                                        .historyData
                                                                        .cATEGORYNAME
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains("mobile prepaid")
                                                                    ? widget.historyData.pARAMETERS!.firstWhere((params) => params.pARAMETERNAME == null ? params.pARAMETERNAME == null : params.pARAMETERNAME.toString().toLowerCase() == "mobile number").pARAMETERNAME.toString()
                                                                    : widget.historyData.pARAMETERS![0].pARAMETERNAME.toString(),
                                                                ParamValue: widget.historyData.cATEGORYNAME.toString().toLowerCase().contains("mobile prepaid") ? widget.historyData.pARAMETERS!.firstWhere((params) => params.pARAMETERNAME == null ? params.pARAMETERNAME == null : params.pARAMETERNAME.toString().toLowerCase() == "mobile number").pARAMETERVALUE.toString() : widget.historyData.pARAMETERS![0].pARAMETERVALUE.toString(),
                                                                TransactionID: widget.historyData.tRANSACTIONREFERENCEID.toString(),
                                                                fromAccount: widget.historyData.aCCOUNTNUMBER.toString(),
                                                                billAmount: "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.historyData.bILLAMOUNT.toString()))}",
                                                                trasactionStatus: widget.historyData.tRANSACTIONSTATUS.toString(),
                                                                status: widget.historyData.tRANSACTIONSTATUS.toString(),
                                                                TransactionDate: DateFormat('dd/MM/yy | hh:mm a').format(DateTime.parse(widget.historyData.cOMPLETIONDATE.toString()).toLocal())))),
                                                    delay: Duration(seconds: 0));

                                                final result =
                                                    await Printing.sharePdf(
                                                  bytes: capturedImage,
                                                  filename:
                                                      '${widget.historyData.bILLERNAME}.jpeg',
                                                );
                                                if (result) {
                                                  print('Shared');
                                                }
                                              },
                                              icon: Icon(Icons.share_outlined,
                                                  color: CLR_PRIMARY)),
                                          IconButton(
                                              onPressed: () {
                                                Printing.layoutPdf(
                                                  name: widget
                                                      .historyData.bILLERNAME
                                                      .toString(),
                                                  onLayout: (PdfPageFormat format) async =>
                                                      generatePdf(
                                                          format,
                                                          widget.billerName
                                                              .toString(),
                                                          widget.historyData
                                                              .bILLERID
                                                              .toString(),
                                                          widget.billName
                                                              .toString(),
                                                          widget.historyData.cATEGORYNAME.toString().toLowerCase().contains("mobile prepaid")
                                                              ? widget
                                                                  .historyData
                                                                  .pARAMETERS!
                                                                  .firstWhere((params) => params.pARAMETERNAME == null
                                                                      ? params.pARAMETERNAME ==
                                                                          null
                                                                      : params.pARAMETERNAME.toString().toLowerCase() ==
                                                                          "mobile number")
                                                                  .pARAMETERNAME
                                                                  .toString()
                                                              : widget.historyData.pARAMETERS![0].pARAMETERNAME
                                                                  .toString(),
                                                          widget.historyData.cATEGORYNAME.toString().toLowerCase().contains("mobile prepaid")
                                                              ? widget
                                                                  .historyData
                                                                  .pARAMETERS!
                                                                  .firstWhere((params) => params.pARAMETERNAME == null ? params.pARAMETERNAME == null : params.pARAMETERNAME.toString().toLowerCase() == "mobile number")
                                                                  .pARAMETERVALUE
                                                                  .toString()
                                                              : widget.historyData.pARAMETERS![0].pARAMETERVALUE.toString(),
                                                          widget.historyData.tRANSACTIONREFERENCEID.toString(),
                                                          widget.historyData.aCCOUNTNUMBER.toString(),
                                                          "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.historyData.bILLAMOUNT.toString()))}",
                                                          widget.historyData.tRANSACTIONSTATUS.toString().toLowerCase() == "success"
                                                              ? "Transaction Success"
                                                              : widget.historyData.tRANSACTIONSTATUS.toString().toLowerCase() == "bbps-in-progress" || widget.historyData.tRANSACTIONSTATUS.toString().toLowerCase() == "bbps-timeout"
                                                                  ? "Transaction Pending"
                                                                  : "Transaction Failure",
                                                          widget.historyData.pAYMENTCHANNEL == 'IB' ? "Equitas - Internet Banking" : "Equitas - Mobile Banking",
                                                          DateFormat('dd/MM/yy | hh:mm a').format(DateTime.parse(widget.historyData.cOMPLETIONDATE.toString()).toLocal()),
                                                          widget.historyData.tRANSACTIONSTATUS.toString()),
                                                );
                                                // Future.microtask(() =>
                                                //     Navigator.push(
                                                //         context,
                                                //         MaterialPageRoute(
                                                //             builder: (context) =>
                                                //                 pdfReciept())));
                                              },
                                              icon: Icon(
                                                  Icons.file_download_outlined,
                                                  color: CLR_PRIMARY)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.0.w),
                                    child: Text(
                                      DateFormat('dd/MM/yy | hh:mm a').format(
                                          DateTime.parse(widget
                                                  .historyData.cOMPLETIONDATE
                                                  .toString())
                                              .toLocal()),
                                      // DateFormat("dd/MM/yy | hh:mm a")
                                      //     .format(widget.historyData.cOMPLETIONDATE.toString())
                                      //   ,
                                      // widget.historyData.cOMPLETIONDATE
                                      //     .toString(),
                                      // "01/08/2023 | 12:48 PM",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff808080),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  )
                                ],
                              )),
                        ),
                        Divider(
                          height: 10.h,
                          thickness: 1,
                        ),
                        TxnDetails(
                            title: "Account",
                            subTitle:
                                'Equitas Bank - ${widget.historyData.aCCOUNTNUMBER.toString()}',
                            clipBoard: false),
                        TxnDetails(
                            title: "Biller Name",
                            subTitle: widget.billerName,
                            clipBoard: false),
                        // TxnDetails(
                        //     title: "Payee Note",
                        //     subTitle: "Nil",
                        //     clipBoard: false),
                        Divider(
                          height: 10,
                          thickness: 1,
                        ),
                        // TxnDetails(
                        //     title: "From Account",
                        //     subTitle:
                        //         widget.historyData.aCCOUNTNUMBER.toString(),
                        //     clipBoard: false),
                        // TxnDetails(
                        //     title: "Bank Reference Number ",
                        //     subTitle:
                        //         widget.historyData.aPPROVALREFNO.toString(),
                        //     clipBoard: true),
                        TxnDetails(
                            title: widget.historyData.cATEGORYNAME
                                    .toString()
                                    .toLowerCase()
                                    .contains("mobile prepaid")
                                ? "Mobile Number"
                                : widget
                                    .historyData.pARAMETERS![0].pARAMETERNAME
                                    .toString(),
                            subTitle: widget.historyData.cATEGORYNAME
                                    .toString()
                                    .toLowerCase()
                                    .contains("mobile prepaid")
                                ? widget.historyData.pARAMETERS!
                                    .firstWhere(
                                        (params) =>
                                            params.pARAMETERNAME == null
                                                ? params.pARAMETERNAME == null
                                                : params.pARAMETERNAME
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "mobile number")
                                    .pARAMETERVALUE
                                    .toString()
                                : widget
                                    .historyData.pARAMETERS![0].pARAMETERVALUE
                                    .toString(),
                            clipBoard: false),
                        if (widget.historyData.tRANSACTIONSTATUS == 'success')
                          TxnDetails(
                              title: "Transaction ID",
                              subTitle: widget
                                  .historyData.tRANSACTIONREFERENCEID
                                  .toString(),
                              clipBoard: true),

                        TxnDetails(
                            title: "Status",
                            subTitle: widget.historyData.tRANSACTIONSTATUS
                                        .toString()
                                        .toLowerCase() ==
                                    "success"
                                ? "Transaction Success"
                                : widget.historyData.tRANSACTIONSTATUS
                                                .toString()
                                                .toLowerCase() ==
                                            "bbps-in-progress" ||
                                        widget.historyData.tRANSACTIONSTATUS
                                                .toString()
                                                .toLowerCase() ==
                                            "bbps-timeout"
                                    ? "Transaction Pending"
                                    : "Transaction Failure",
                            clipBoard: false),
                        if (widget.historyData.tRANSACTIONSTATUS
                                .toString()
                                .toLowerCase() !=
                            "success")
                          TxnDetails(
                              title: "Reason",
                              subTitle: getTransactionReason(widget
                                  .historyData.tRANSACTIONSTATUS
                                  .toString()),
                              clipBoard: false),
                        TxnDetails(
                            title: "Payment Channel",
                            subTitle: widget.historyData.pAYMENTCHANNEL == 'IB'
                                ? "Equitas - Internet Banking"
                                : "Equitas - Mobile Banking",
                            clipBoard: false,
                            showLogo: true),
                        // if (widget.historyData.tRANSACTIONSTATUS == 'success')
                        //   TxnDetails(
                        //       title: "Payee Note",
                        //       subTitle: "Nil",
                        //       clipBoard: false),
                        // Divider(
                        //   height: 10,
                        //   thickness: 1,
                        // ),
                        // TxnDetails(
                        //     title: "Transfer Type",
                        //     subTitle: "Equitas Digital Banking",
                        //     clipBoard: false,
                        //     showLogo: true),
                      ],
                    )),
                // if (widget.historyData.tRANSACTIONSTATUS != 'success')
                BbpsLogoContainer(showEquitasLogo: true),
                SizedBox(
                  height: 70.h,
                )
              ],
            ),
          ),
        ),
        bottomSheet: widget.historyData.tRANSACTIONSTATUS != 'success'
            ? null
            : Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: MyAppButton(
                            onPressed: () {
                              goToData(context, cOMPLAINTREGISTERROUTE, {
                                "Date": widget.historyData.cOMPLETIONDATE,
                                "txnRefID": widget
                                    .historyData.tRANSACTIONREFERENCEID
                                    .toString(),
                                "BillerName":
                                    widget.historyData.bILLERNAME.toString(),
                                "CategoryName":
                                    widget.historyData.cATEGORYNAME.toString(),
                              });
                            },
                            buttonText: "Raise a Complaint",
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
              ));
  }
}
