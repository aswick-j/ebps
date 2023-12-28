import 'dart:convert';

import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/confirm_done_model.dart';
import 'package:ebps/models/history_model.dart';
import 'package:ebps/screens/base64.dart';
import 'package:ebps/screens/pdf_reciept.dart';
import 'package:ebps/widget/bbps_logo.dart';
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

  Widget ScreenshotContainer() {
    return Container(
      color: Colors.white,
      height: double.infinity,
      child: Container(
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.only(
              left: 18.0.w, right: 18.w, top: 10.h, bottom: 10.h),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                LOGO_BBPS_ASSURED,
              ),
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.9), BlendMode.screen),
            ),
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
                    colors: [
                      widget.historyData.tRANSACTIONSTATUS == 'success'
                          ? Color(0xff99DDB4).withOpacity(.7)
                          : widget.historyData.tRANSACTIONSTATUS ==
                                  'bbpsTimeout'
                              ? Color(0xff99DDB4).withOpacity(.7)
                              : Color(0xff982F67).withOpacity(.7),
                      widget.historyData.tRANSACTIONSTATUS == 'success'
                          ? Color(0xff31637D).withOpacity(.7)
                          : widget.historyData.tRANSACTIONSTATUS ==
                                  'bbpsTimeout'
                              ? Color(0xff31637D).withOpacity(.7)
                              : Color(0xff463A8D).withOpacity(.7)
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.historyData.tRANSACTIONSTATUS == 'success'
                          ? "Transaction Details"
                          : widget.historyData.tRANSACTIONSTATUS ==
                                  'bbpsTimeout'
                              ? "Transaction Pending"
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
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset(ICON_ARROW_UP, height: 20.h),
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
                            ]),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0.w),
                      child: Text(
                        // DateFormat("dd/MM/yy | hh:mm a")
                        //     .format(widget.historyData.cOMPLETIONDATE)
                        //     .toString(),
                        widget.historyData.cOMPLETIONDATE.toString(),
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
                ),
              ),
              Divider(
                height: 10.h,
                thickness: 1,
              ),
              TxnDetails(
                  title: "Sent From",
                  subTitle:
                      'EQUITAS BANK - ${widget.historyData.aCCOUNTNUMBER.toString()}',
                  clipBoard: false),
              TxnDetails(
                  title: "Sent To",
                  subTitle: widget.billerName,
                  clipBoard: false),
              TxnDetails(
                  title: "Payee Note", subTitle: "Nil", clipBoard: false),
              // Divider(
              //   height: 10,
              //   thickness: 1,
              // ),
              TxnDetails(
                  title: "From Account",
                  subTitle: widget.historyData.aCCOUNTNUMBER.toString(),
                  clipBoard: false),
              TxnDetails(
                  title: "Bank Reference Number ",
                  subTitle: widget.historyData.aPPROVALREFNO.toString(),
                  clipBoard: false),
              if (widget.historyData.tRANSACTIONSTATUS == 'success')
                TxnDetails(
                    title: "Transaction ID",
                    subTitle:
                        widget.historyData.tRANSACTIONREFERENCEID.toString(),
                    clipBoard: false),
              // if (widget.historyData.tRANSACTIONSTATUS == 'success')
              //   TxnDetails(
              //       title: "Payee Note", subTitle: "Nil", clipBoard: false),
              TxnDetails(
                  title: "Transfer Type",
                  subTitle: "Equitas Digital Banking",
                  clipBoard: false,
                  showLogo: true),
              // Divider(
              //   height: 10,
              //   thickness: 1,
              // ),
              Center(
                child: Container(
                  height: 80.h,
                  width: 80.w,
                  child: Image.asset(
                    LOGO_EQUITAS,
                  ),
                ),
              ),
            ],
          )),
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
                              colors: [
                                widget.historyData.tRANSACTIONSTATUS ==
                                        'success'
                                    ? Color(0xff99DDB4).withOpacity(.7)
                                    : widget.historyData.tRANSACTIONSTATUS ==
                                            'bbpsTimeout'
                                        ? Color(0xff99DDB4).withOpacity(.7)
                                        : Color(0xff982F67).withOpacity(.7),
                                widget.historyData.tRANSACTIONSTATUS ==
                                        'success'
                                    ? Color(0xff31637D).withOpacity(.7)
                                    : widget.historyData.tRANSACTIONSTATUS ==
                                            'bbpsTimeout'
                                        ? Color(0xff31637D).withOpacity(.7)
                                        : Color(0xff463A8D).withOpacity(.7)
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.historyData.tRANSACTIONSTATUS ==
                                        'success'
                                    ? "Transaction Details"
                                    : widget.historyData.tRANSACTIONSTATUS ==
                                            'bbpsTimeout'
                                        ? "Transaction Pending"
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

                                          // GestureDetector(
                                          //   onTap: () {
                                          //     goToData(context, cREATEAUTOPAYROUTE, {
                                          //       "billerName":
                                          //           widget.historyData.bILLERNAME,
                                          //       "categoryName":
                                          //           widget.historyData.cATEGORYNAME,
                                          //       "billName":
                                          //           widget.historyData.bILLNAME,
                                          //       "customerBillID":
                                          //           widget.historyData.cUSTOMERBILLID,
                                          //       "savedInputSignatures":
                                          //           widget.historyData.pARAMETERS,
                                          //     });
                                          //   },
                                          //   child: Container(
                                          //     padding: EdgeInsets.symmetric(
                                          //         horizontal: 8.0.w, vertical: 4.w),
                                          //     decoration: BoxDecoration(
                                          //       color: TXT_CLR_PRIMARY,
                                          //       border: Border.all(
                                          //           color: TXT_CLR_PRIMARY),
                                          //       borderRadius:
                                          //           BorderRadius.circular(12.0.r),
                                          //     ),
                                          //     child: Text(
                                          //       "Setup Autopay",
                                          //       style: TextStyle(
                                          //         color: Colors.white,
                                          //         fontSize: 10.0.sp,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                Uint8List? capturedImage =
                                                    await screenshotController
                                                        .captureFromWidget(
                                                            InheritedTheme
                                                                .captureAll(
                                                                    context,
                                                                    Material(
                                                                        child:
                                                                            ScreenshotContainer())),
                                                            delay: Duration(
                                                                seconds: 0));

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
                                                  name: "Transaction Receipt",
                                                  onLayout: (PdfPageFormat
                                                          format) async =>
                                                      _generatePdf(format),
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
                                      // DateFormat("dd/MM/yy | hh:mm a")
                                      //     .format(widget.historyData.cOMPLETIONDATE)
                                      //     .toString(),
                                      widget.historyData.cOMPLETIONDATE
                                          .toString(),
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
                            title: "Sent From",
                            subTitle:
                                'EQUITAS BANK - ${widget.historyData.aCCOUNTNUMBER.toString()}',
                            clipBoard: false),
                        TxnDetails(
                            title: "Sent To",
                            subTitle: widget.billerName,
                            clipBoard: false),
                        TxnDetails(
                            title: "Payee Note",
                            subTitle: "Nil",
                            clipBoard: false),
                        Divider(
                          height: 10,
                          thickness: 1,
                        ),
                        TxnDetails(
                            title: "From Account",
                            subTitle:
                                widget.historyData.aCCOUNTNUMBER.toString(),
                            clipBoard: false),
                        TxnDetails(
                            title: "Bank Reference Number ",
                            subTitle:
                                widget.historyData.aPPROVALREFNO.toString(),
                            clipBoard: true),
                        if (widget.historyData.tRANSACTIONSTATUS == 'success')
                          TxnDetails(
                              title: "Transaction ID",
                              subTitle: widget
                                  .historyData.tRANSACTIONREFERENCEID
                                  .toString(),
                              clipBoard: true),
                        if (widget.historyData.tRANSACTIONSTATUS == 'success')
                          TxnDetails(
                              title: "Payee Note",
                              subTitle: "Nil",
                              clipBoard: false),
                        TxnDetails(
                            title: "Transfer Type",
                            subTitle: "Equitas Digital Banking",
                            clipBoard: false,
                            showLogo: true),
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
        bottomSheet: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: MyAppButton(
                      onPressed: () {
                        goToData(context, cOMPLAINTREGISTERROUTE, {
                          "txnRefID": widget.historyData.tRANSACTIONREFERENCEID
                              .toString()
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

Future<Uint8List> _generatePdf(PdfPageFormat format) async {
  final pdf = pw.Document(
    version: PdfVersion.pdf_1_5,
    compress: true,
  );
  final font = await PdfGoogleFonts.poppinsBlack();

  final ByteData bbpsbytes = await rootBundle.load(LOGO_BBPS_FULL_PNG);
  Uint8List bbpsbyteList = bbpsbytes.buffer.asUint8List();
  final ByteData equitasbytes = await rootBundle.load(LOGO_EQUITAS);
  Uint8List equitasList = equitasbytes.buffer.asUint8List();
  final ByteData bbpsAssuredbytes = await rootBundle.load(LOGO_BBPS_ASSURED_BW);
  Uint8List bbpsAssuredList = bbpsAssuredbytes.buffer.asUint8List();
  final ByteData equitasFooterbytes = await rootBundle.load(EQUITAS_FOOTER);
  Uint8List equitasFooterList = equitasFooterbytes.buffer.asUint8List();

  final PdfColor primaryColor = PdfColor.fromHex('#a9bbdb');
  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
            // padding: pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              image: pw.DecorationImage(
                image: pw.MemoryImage(bbpsAssuredList),

                fit: pw.BoxFit.contain,

                // colorFilter: ColorFilter.mode(
                //     Colors.white.withOpacity(0.9), BlendMode.screen),
              ),
              border: pw.Border.all(color: primaryColor, width: 1),
            ),
            // decoration: pw.BoxDecoration(
            //   border: pw.Border.all(color: primaryColor, width: 1),

            //   // borderRadius: pw.BorderRadius.circular(5),
            // ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  // height: 20,
                  // margin: pw.EdgeInsets.only(
                  //     left: 18.0, right: 18, top: 10, bottom: 10),
                  color: primaryColor,
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Image(pw.MemoryImage(equitasList),
                          height: 70, width: 70),
                      pw.Image(pw.MemoryImage(bbpsbyteList),
                          height: 70, width: 70),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(
                      left: 20, top: 25.0, bottom: 10.0),
                  child: pw.Text(
                    'Payment Receipt',
                    style: pw.TextStyle(
                      fontSize: 24.0,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("#1B438B"),
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(
                      left: 20, top: 5.0, bottom: 10.0, right: 20),
                  child: pw.Text(
                    'Thank you for payment through Equitas Small Finance Bank.\nPlease quote your Transaction Reference ID below for payment queries',
                    style: pw.TextStyle(
                      fontSize: 12.0,
                      color: PdfColor.fromHex("#1B438B"),
                    ),
                  ),
                ),
                pw.Padding(
                    padding: const pw.EdgeInsets.only(
                        left: 20, top: 5.0, bottom: 10.0),
                    child: pw.Row(children: [
                      pw.Text(
                        'Bill Name :',
                        style: pw.TextStyle(
                          fontSize: 16.0,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex("#1B438B"),
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        'Airtel Postpaid',
                        style: pw.TextStyle(
                          fontSize: 16.0,
                          fontWeight: pw.FontWeight.normal,
                          color: PdfColor.fromHex("#1B438B"),
                        ),
                      ),
                    ])),
                // pw.Padding(
                //     padding: const pw.EdgeInsets.only(
                //         left: 20, top: 5.0, bottom: 10.0),
                //     child: pw.Row(children: [
                //       pw.Text(
                //         'Transaction Time :',
                //         style: pw.TextStyle(
                //           fontSize: 16.0,
                //           fontWeight: pw.FontWeight.bold,
                //           color: PdfColor.fromHex("#1B438B"),
                //         ),
                //       ),
                //       pw.SizedBox(width: 10),
                //       pw.Text(
                //         '10-MAR-2015 6.20 PM',
                //         style: pw.TextStyle(
                //           fontSize: 16.0,
                //           fontWeight: pw.FontWeight.normal,
                //           color: PdfColor.fromHex("#1B438B"),
                //         ),
                //       ),
                //     ])),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(
                      left: 20, right: 20.0, bottom: 10.0, top: 20.0),
                  child: pw.TableHelper.fromTextArray(
                      context: context,
                      headers: <dynamic>['Transaction Details', ""],
                      border: pw.TableBorder.all(color: primaryColor, width: 1),
                      // rowDecoration:
                      //     pw.BoxDecoration(color: PdfColor.fromHex("f0f7ff")),
                      cellStyle: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          color: PdfColor.fromHex("#1B438B")),
                      headerStyle: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex("#1B438B")),
                      // headerDecoration:
                      //     pw.BoxDecoration(color: PdfColor.fromHex("f0f7ff")),

                      data: <List>[
                        [
                          'Name of the Biller',
                          'Airtel Postpaid',
                        ],
                        [
                          'Biller Id',
                          "AE56679G88938",
                        ],
                        ['Mobile Number', "9777777777"],
                        [
                          'Bill Number',
                          "387378",
                        ],
                        [
                          'Transaction Reference Id',
                          "EQ949849",
                        ],
                        [
                          'CBS Transaction Ref Number',
                          "447477474",
                        ],
                        [
                          'Registered Mobile Number',
                          "93736737333",
                        ],
                        [
                          'Payment Mode',
                          "MB",
                        ],
                        [
                          'Payment Channel ',
                          "Cash",
                        ],
                        [
                          'Amount Debited From',
                          "10039393",
                        ],
                        ['Bill Amount', "288.00"],
                        [
                          'Customer Convenience Fee',
                          "-",
                        ],
                        [
                          'Total Amount',
                          "288.00",
                        ],
                        [
                          'Transaction Date and Time',
                          "18-MAR-2015 6.45PM",
                        ],
                        [
                          'Status',
                          "Success",
                        ],
                        ['Reason', "-"]
                      ]),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 20),
                  child: pw.Image(pw.MemoryImage(equitasFooterList)),
                )
              ],
            ));
      }));

  return pdf.save();
}
