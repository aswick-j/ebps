import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getBillPaymentDetails.dart';
import 'package:ebps/helpers/getBillerType.dart';
import 'package:ebps/helpers/getGradientColors.dart';
import 'package:ebps/helpers/getTransactionStatusReason.dart';
import 'package:ebps/helpers/getTransactionStatusText.dart';
import 'package:ebps/models/add_biller_model.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/confirm_done_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/generate_pdf.dart';
import 'package:ebps/widget/screenshot_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

class TransactionScreen extends StatefulWidget {
  bool isSavedBill;
  Map<String, dynamic>? billerData;
  String billName;
  String categoryName;
  String billerName;
  List<AddbillerpayloadModel>? inputParameters;
  List<PARAMETERS>? SavedinputParameters;
  TransactionScreen(
      {super.key,
      required this.billName,
      required this.billerName,
      required this.categoryName,
      required this.isSavedBill,
      required this.billerData,
      required this.inputParameters,
      required this.SavedinputParameters});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  confirmDoneData? tnxResponse;
  // var billData;
  BillersData? billerTypeData;
  SavedBillersData? savedBillerTypeData;

  Map<String, dynamic>? paymentDetails;
  Map<String, dynamic>? billerTypeResult;
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
    tnxResponse = confirmDoneData.fromJson(widget.billerData!['res']);
    // billData = jsonDecode(tnxResponse!.paymentDetails!.tran!.bill.toString());

    if (widget.isSavedBill) {
      savedBillerTypeData = widget.billerData!['billerData'];
      billerTypeResult = getBillerType(
          savedBillerTypeData!.fETCHREQUIREMENT,
          savedBillerTypeData!.bILLERACCEPTSADHOC,
          savedBillerTypeData!.sUPPORTBILLVALIDATION,
          savedBillerTypeData!.pAYMENTEXACTNESS);
    } else {
      billerTypeData = widget.billerData!['billerData'];
      billerTypeResult = getBillerType(
          billerTypeData!.fETCHREQUIREMENT,
          billerTypeData!.bILLERACCEPTSADHOC,
          billerTypeData!.sUPPORTBILLVALIDATION,
          billerTypeData!.pAYMENTEXACTNESS);
    }

    paymentDetails = getBillPaymentDetails(tnxResponse!.paymentDetails,
        billerTypeResult!['isAdhoc'], tnxResponse!.equitasTransactionId);

    if (paymentDetails!['success']) {
      BlocProvider.of<MybillersCubit>(context)
          .deleteUpcomingDue(widget.billerData!["customerBillID"]);
    } else {
      BlocProvider.of<MybillersCubit>(context).getAddUpdateUpcomingDue();
    }
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
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1b438b),
                ),
                textAlign: TextAlign.left,
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
        title: 'Go to Home',
        onLeadingTap: () => {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => BottomNavBar(
                        SelectedIndex: 0,
                      )),
              (Route<dynamic> route) => false,
            );
          }),
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
                            colors: getStatusGradientColors(tnxResponse!
                                        .paymentDetails!.success ==
                                    true
                                ? "success"
                                : tnxResponse!.paymentDetails!.failed == true ||
                                        tnxResponse!.paymentDetails!.success ==
                                            false
                                    ? 'failed'
                                    : "pending"),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              getTransactionStatusText(
                                  tnxResponse!.paymentDetails!.success == true
                                      ? "success"
                                      : tnxResponse!.paymentDetails!.failed ==
                                                  true ||
                                              tnxResponse!.paymentDetails!
                                                      .success ==
                                                  false
                                          ? 'failed'
                                          : "pending"),
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
                                          "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.billerData!['billAmount'].toString()))}",
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
                                                              channel: "Equitas - Mobile Banking",
                                                              BillerName: widget.billerName.toString(),
                                                              BillerId: widget.isSavedBill ? savedBillerTypeData!.bILLERID.toString() : billerTypeData!.bILLERID.toString(),
                                                              BillName: widget.isSavedBill ? savedBillerTypeData!.bILLNAME.toString() : billerTypeData!.bILLNAME.toString(),
                                                              ParamName: widget.billerData!["inputSignature"][0].pARAMETERNAME,
                                                              ParamValue: widget.billerData!["inputSignature"][0].pARAMETERVALUE,
                                                              TransactionID: tnxResponse!.paymentDetails!.success == true ? tnxResponse!.paymentDetails!.bbpsResponse!.data!.txnReferenceId.toString() : "",
                                                              fromAccount: widget.billerData!['acNo'].toString(),
                                                              billAmount: "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.billerData!['billAmount']))}",
                                                              trasactionStatus: tnxResponse!.reason.toString(),
                                                              status: tnxResponse!.paymentDetails!.success == true
                                                                  ? "success"
                                                                  : tnxResponse!.paymentDetails!.failed == true || tnxResponse!.paymentDetails!.success == false
                                                                      ? "failed"
                                                                      : tnxResponse!.paymentDetails!.failed == true
                                                                          ? "bbps-timeout"
                                                                          : "failed",
                                                              TransactionDate: DateFormat("dd/MM/yyyy | hh:mm a").format(DateTime.now()).toString()))),
                                                  delay: Duration(seconds: 0));

                                              final result =
                                                  await Printing.sharePdf(
                                                bytes: capturedImage,
                                                filename:
                                                    '${widget.billerName}.jpeg',
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
                                                name: widget.billerName,
                                                onLayout: (PdfPageFormat format) async =>
                                                    generatePdf(
                                                        format,
                                                        widget.billerName
                                                            .toString(),
                                                        widget.isSavedBill
                                                            ? savedBillerTypeData!
                                                                .bILLERID
                                                                .toString()
                                                            : billerTypeData!.bILLERID
                                                                .toString(),
                                                        widget.isSavedBill
                                                            ? savedBillerTypeData!
                                                                .bILLNAME
                                                                .toString()
                                                            : billerTypeData!
                                                                .bILLNAME
                                                                .toString(),
                                                        widget
                                                            .billerData!["inputSignature"]
                                                                [0]
                                                            .pARAMETERNAME,
                                                        widget
                                                            .billerData!["inputSignature"]
                                                                [0]
                                                            .pARAMETERVALUE,
                                                        tnxResponse!.paymentDetails!.success == true
                                                            ? tnxResponse!
                                                                .paymentDetails!
                                                                .bbpsResponse!
                                                                .data!
                                                                .txnReferenceId
                                                                .toString()
                                                            : "-",
                                                        widget.billerData!['acNo']
                                                            .toString(),
                                                        "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.billerData!['billAmount'].toString()))}",
                                                        tnxResponse!.paymentDetails!.success ==
                                                                true
                                                            ? "Transaction Success"
                                                            : tnxResponse!.paymentDetails!.failed == true ||
                                                                    tnxResponse!.paymentDetails!.success == false
                                                                ? 'Transaction Failure'
                                                                : "Transaction Pending",
                                                        "Equitas - Mobile banking",
                                                        DateFormat("dd/MM/yyyy | hh:mm a").format(DateTime.now()).toString(),
                                                        tnxResponse!.reason.toString(),
                                                        tnxResponse!.paymentDetails!.bbpsResponse!.data!.billerResponse != null ? tnxResponse!.paymentDetails!.bbpsResponse!.data!.billerResponse!.customerName.toString() : "NA",
                                                        tnxResponse!.paymentDetails!.bbpsResponse!.data!.billerResponse != null ? tnxResponse!.paymentDetails!.bbpsResponse!.data!.billerResponse!.billNumber.toString() : "NA"),
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
                                    DateFormat("dd/MM/yyyy | hh:mm a")
                                        .format(DateTime.now())
                                        .toString(),
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
                              'EQUITAS BANK - ${widget.billerData!['acNo']}',
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

                      TxnDetails(
                          title: widget
                              .billerData!["inputSignature"][0].pARAMETERNAME,
                          subTitle: widget
                              .billerData!["inputSignature"][0].pARAMETERVALUE,
                          clipBoard: false),
                      // if (widget.historyData.tRANSACTIONSTATUS == 'success')
                      if (tnxResponse!.paymentDetails!.success == true)
                        TxnDetails(
                            title: "Transaction ID",
                            subTitle: tnxResponse!.paymentDetails!.bbpsResponse!
                                .data!.txnReferenceId
                                .toString(),
                            clipBoard: true),

                      TxnDetails(
                          title: "Status",
                          subTitle: tnxResponse!.paymentDetails!.success == true
                              ? "Transaction Success"
                              : tnxResponse!.paymentDetails!.failed == true ||
                                      tnxResponse!.paymentDetails!.success ==
                                          false
                                  ? 'Transaction Failure'
                                  : "Transaction pending",
                          clipBoard: false),
                      if (tnxResponse!.paymentDetails!.success != true)
                        TxnDetails(
                            title: "Reason",
                            subTitle: getTransactionReason(
                                tnxResponse!.reason.toString()),
                            clipBoard: false),
                      TxnDetails(
                          title: "Payment Channel",
                          subTitle: "Equitas - Mobile Banking",
                          clipBoard: false,
                          showLogo: true),
                    ],
                  )),
              BbpsLogoContainer(showEquitasLogo: true),
              SizedBox(
                height: 70.h,
              )
            ],
          ),
        ),
      ),
      // bottomSheet: !paymentDetails!['success']
      //     ? null
      //     : Container(
      //         decoration: BoxDecoration(
      //             border: Border(
      //                 top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
      //         child: Padding(
      //           padding:
      //               EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
      //             children: [
      //               Expanded(
      //                 child: MyAppButton(
      //                     onPressed: () {
      //                       goToData(context, cOMPLAINTREGISTERROUTE, {
      //                         "txnRefID": paymentDetails!['txnReferenceId']
      //                             .toString(),
      //                         "BillerName": widget.billerName.toString(),
      //                         "CategoryName": widget.categoryName,
      //                       });
      //                     },
      //                     buttonText: "Raise a Complaint",
      //                     buttonTxtColor: BTN_CLR_ACTIVE,
      //                     buttonBorderColor: Colors.transparent,
      //                     buttonColor: CLR_PRIMARY,
      //                     buttonSizeX: 10.h,
      //                     buttonSizeY: 40.w,
      //                     buttonTextSize: 14.sp,
      //                     buttonTextWeight: FontWeight.w500),
      //               ),
      //             ],
      //           ),
      //         ),
      //       )
    );
  }
}
