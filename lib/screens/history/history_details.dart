import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/capitalizeByWord.dart';
import 'package:ebps/helpers/getGradientColors.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getTransactionStatusReason.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/confirm_done_model.dart';
import 'package:ebps/models/history_model.dart';
import 'package:ebps/models/transaction_status_model.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/generate_pdf.dart';
import 'package:ebps/widget/screenshot_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

class HistoryDetails extends StatefulWidget {
  bool? isSavedBill;
  String billName;
  String categoryName;
  String billerName;
  HistoryData historyData;
  final void Function(String?, int?) handleStatus;
  HistoryDetails(
      {super.key,
      required this.billName,
      required this.billerName,
      required this.categoryName,
      required this.isSavedBill,
      required this.historyData,
      required this.handleStatus});

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  confirmDoneData? tnxResponse;
  var billData;
  BillersData? billerTypeData;
  bool isTransactionStatusLoading = false;
  bool isTxnUpdateLoading = false;
  String? updateTxnStatus;
  Map<String, dynamic>? paymentDetails;
  Map<String, dynamic>? billerTypeResult;
  ScreenshotController screenshotController = ScreenshotController();
  TransactionStatusClass? TransactionStatusData;
  // Uint8List? capturedImage;
  @override
  void initState() {
    isTransactionStatusLoading =
        widget.historyData.transactionStatus.toString() == "bbps-in-progress" ||
                widget.historyData.transactionStatus.toString() ==
                    "bbps-timeout"
            ? true
            : false;
    if (widget.historyData.transactionStatus.toString() == "bbps-in-progress" ||
        widget.historyData.transactionStatus.toString() == "bbps-timeout") {
      BlocProvider.of<HistoryCubit>(context).getTransactionStatusdetails(
          widget.historyData.transactionReferenceId);
    }

    super.initState();
  }

  var colorizeTextStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Color(0xff1b438b),
  );

  static const colorizeColors = [
    Colors.red,
    Colors.orange,
    Colors.orange,
    Colors.red,
  ];
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
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.TXT_CLR_LITE,
              height: 23 / 14,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              if (showLogo == true)
                Image.asset(LOGO_EQUITAS_PNG, height: 40.h, width: 40.w),
              if (showLogo == true) SizedBox(width: 10.w),
              SizedBox(
                width: showLogo == true || clipBoard != false ? null : 250.w,
                child: Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.TXT_CLR_PRIMARY,
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
                    child:
                        Icon(Icons.copy, color: AppColors.CLR_ICON, size: 20))
            ],
          )
        ],
      ),
    );
  }

  handleTxnApi() {
    Map<String, dynamic> payload = {
      "transactionId": widget.historyData.transactionId,
      "status": updateTxnStatus
    };

    BlocProvider.of<HistoryCubit>(context).updateTxnStatus(payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.CLR_BACKGROUND,
        appBar: MyAppBar(
          context: context,
          title: 'Payment Details',
          onLeadingTap: () => {
            goBack(context),
          },
          showActions: false,
        ),
        body: BlocConsumer<HistoryCubit, HistoryState>(
          listener: (context, state) {
            if (state is TransactionStatusLoading) {
              isTransactionStatusLoading = true;
            } else if (state is TransactionStatusSuccess) {
              isTransactionStatusLoading = false;

              setState(() {
                TransactionStatusData = state
                    .TransactionStatusDetails?.data?.data?.transactionStatus;
                updateTxnStatus = TransactionStatusData
                                ?.response
                                ?.data
                                ?.txnStatusComplainResp
                                ?.txnList
                                ?.txnDetail
                                ?.txnStatus
                                ?.toLowerCase() ==
                            'success' ||
                        TransactionStatusData
                                ?.response
                                ?.data
                                ?.txnStatusComplainResp
                                ?.txnList
                                ?.txnDetail
                                ?.txnStatus
                                ?.toLowerCase() ==
                            'failure'
                    ? TransactionStatusData?.response?.data
                        ?.txnStatusComplainResp?.txnList?.txnDetail?.txnStatus
                        ?.toLowerCase()
                    : widget.historyData.transactionStatus.toString();
              });

              handleTxnApi();
            } else if (state is TransactionStatusFailed) {
              isTransactionStatusLoading = false;
            } else if (state is TransactionStatusError) {
              isTransactionStatusLoading = false;
            }
            if (state is TxnStatusUpdateLoading) {
              isTxnUpdateLoading = true;
            } else if (state is TxnStatusUpdateSuccess) {
              isTxnUpdateLoading = false;

              setState(() {
                updateTxnStatus = TransactionStatusData
                                ?.response
                                ?.data
                                ?.txnStatusComplainResp
                                ?.txnList
                                ?.txnDetail
                                ?.txnStatus
                                ?.toLowerCase() ==
                            'success' ||
                        TransactionStatusData
                                ?.response
                                ?.data
                                ?.txnStatusComplainResp
                                ?.txnList
                                ?.txnDetail
                                ?.txnStatus
                                ?.toLowerCase() ==
                            'failure'
                    ? TransactionStatusData?.response?.data
                        ?.txnStatusComplainResp?.txnList?.txnDetail?.txnStatus
                        ?.toLowerCase()
                    : TransactionStatusData
                            ?.response
                            ?.data
                            ?.txnStatusComplainResp
                            ?.txnList
                            ?.txnDetail
                            ?.txnStatus
                            ?.toLowerCase() ??
                        widget.historyData.transactionStatus.toString();
              });

              if (updateTxnStatus == "success" ||
                  updateTxnStatus == "failure") {
                widget.handleStatus(
                    updateTxnStatus ??
                        widget.historyData.transactionStatus.toString(),
                    widget.historyData.transactionId);
              }
              DelightToastBar(
                autoDismiss: true,
                animationDuration: Duration(milliseconds: 300),
                builder: (context) => ToastCard(
                  shadowColor: Colors.grey.withOpacity(0.4),
                  leading: Icon(
                    updateTxnStatus == "success"
                        ? Icons.check_circle_outline
                        : updateTxnStatus == "failure"
                            ? Icons.cancel_outlined
                            : updateTxnStatus == "in_prog"
                                ? Icons.info_outline
                                : Icons.info_outline,
                    size: 28.r,
                    color: updateTxnStatus == "success"
                        ? Colors.green
                        : updateTxnStatus == "failure"
                            ? Colors.red
                            : updateTxnStatus == "in_prog"
                                ? Colors.orange
                                : Colors.orange,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        updateTxnStatus == "success"
                            ? "Hurray !"
                            : updateTxnStatus == "failure"
                                ? "Oops !"
                                : updateTxnStatus == "in_prog"
                                    ? "Pending"
                                    : "Oops !",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.TXT_CLR_DEFAULT,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                      ),
                      Text(
                        updateTxnStatus == "success"
                            ? "Your Payment has been Successfull"
                            : updateTxnStatus == "failure"
                                ? "Your Payment has been Failed"
                                : updateTxnStatus != null
                                    ? "Waiting Confirmation from Biller"
                                    : "Something Went Wrong",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1b438b),
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ).show(context);
            } else if (state is TxnStatusUpdateFailed) {
              isTxnUpdateLoading = false;
            } else if (state is TxnStatusUpdateError) {
              isTxnUpdateLoading = false;
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Screenshot(
                controller: screenshotController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableContainer(
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
                                          .historyData.transactionStatus
                                          .toString()
                                          .toLowerCase() ==
                                      "success"
                                  ? "success"
                                  : widget.historyData.transactionStatus
                                                  .toString()
                                                  .toLowerCase() ==
                                              "bbps-in-progress" ||
                                          widget.historyData.transactionStatus
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
                                widget.historyData.transactionStatus
                                            .toString()
                                            .toLowerCase() ==
                                        "success"
                                    ? "Transaction Success"
                                    : widget.historyData.transactionStatus
                                                    .toString()
                                                    .toLowerCase() ==
                                                "bbps-in-progress" ||
                                            widget.historyData.transactionStatus
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
                                            "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.historyData.billAmount.toString()))}",
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.CLR_PRIMARY,
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
                                                                channel: widget.historyData.paymentChannel == 'IB'
                                                                    ? "Equitas - Internet Banking"
                                                                    : "Equitas - Mobile Banking",
                                                                BillerName: widget
                                                                    .billerName
                                                                    .toString(),
                                                                BillerId: widget
                                                                    .historyData
                                                                    .billerId
                                                                    .toString(),
                                                                BillName: widget
                                                                    .historyData
                                                                    .billName
                                                                    .toString(),
                                                                ParamName: widget
                                                                        .historyData
                                                                        .categoryName
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains("mobile prepaid")
                                                                    ? widget.historyData.parameters!.firstWhere((params) => params.parameterName == null ? params.parameterValue == null : params.parameterName.toString().toLowerCase() == "mobile number").parameterName.toString()
                                                                    : widget.historyData.parameters![0].parameterName.toString(),
                                                                ParamValue: widget.historyData.categoryName.toString().toLowerCase().contains("mobile prepaid") ? widget.historyData.parameters!.firstWhere((params) => params.parameterName == null ? params.parameterName == null : params.parameterName.toString().toLowerCase() == "mobile number" || params.parameterName.toString().toLowerCase() == "customer mobile number").parameterName.toString() : widget.historyData.parameters![0].parameterValue.toString(),
                                                                TransactionID: widget.historyData.transactionReferenceId.toString(),
                                                                fromAccount: widget.historyData.accountNumber.toString(),
                                                                billAmount: "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.historyData.billAmount.toString()))}",
                                                                trasactionStatus: widget.historyData.transactionStatus.toString(),
                                                                status: widget.historyData.transactionStatus.toString(),
                                                                ConsumerName: widget.historyData.customerName.toString(),
                                                                TransactionDate: DateFormat('dd/MM/yyyy | hh:mm a').format(DateTime.parse(widget.historyData.completionDate.toString()).toLocal())))),
                                                    delay: Duration(seconds: 0));

                                                final result =
                                                    await Printing.sharePdf(
                                                  bytes: capturedImage,
                                                  filename:
                                                      '${widget.historyData.billerName}.jpeg',
                                                );
                                                if (result) {
                                                  print('Shared');
                                                }
                                              },
                                              icon: Icon(Icons.share_outlined,
                                                  color: AppColors.CLR_ICON)),
                                          IconButton(
                                              onPressed: () {
                                                Printing.layoutPdf(
                                                  name: widget
                                                      .historyData.billerName
                                                      .toString(),
                                                  onLayout: (PdfPageFormat format) async =>
                                                      generatePdf(
                                                          format,
                                                          widget.billerName
                                                              .toString(),
                                                          widget.historyData
                                                              .billerId
                                                              .toString(),
                                                          widget.billName
                                                              .toString(),
                                                          widget.historyData.categoryName.toString().toLowerCase().contains("mobile prepaid")
                                                              ? widget
                                                                  .historyData
                                                                  .parameters!
                                                                  .firstWhere((params) => params.parameterName == null
                                                                      ? params.parameterName ==
                                                                          null
                                                                      : params.parameterName.toString().toLowerCase() ==
                                                                          "mobile number")
                                                                  .parameterName
                                                                  .toString()
                                                              : widget.historyData.parameters![0].parameterName
                                                                  .toString(),
                                                          widget.historyData.categoryName.toString().toLowerCase().contains("mobile prepaid")
                                                              ? widget
                                                                  .historyData
                                                                  .parameters!
                                                                  .firstWhere((params) => params.parameterName == null ? params.parameterName == null : params.parameterName.toString().toLowerCase() == "mobile number")
                                                                  .parameterValue
                                                                  .toString()
                                                              : widget.historyData.parameters![0].parameterValue.toString(),
                                                          widget.historyData.transactionReferenceId.toString(),
                                                          widget.historyData.accountNumber.toString(),
                                                          "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.historyData.billAmount.toString()))}",
                                                          widget.historyData.transactionStatus.toString().toLowerCase() == "success"
                                                              ? "Transaction Success"
                                                              : widget.historyData.transactionStatus.toString().toLowerCase() == "bbps-in-progress" || widget.historyData.transactionStatus.toString().toLowerCase() == "bbps-timeout"
                                                                  ? "Transaction Pending"
                                                                  : "Transaction Failure",
                                                          widget.historyData.paymentChannel == 'IB' ? "Equitas - Internet Banking" : "Equitas - Mobile Banking",
                                                          DateFormat('dd/MM/yyyy | hh:mm a').format(DateTime.parse(widget.historyData.completionDate.toString()).toLocal()),
                                                          widget.historyData.transactionStatus.toString(),
                                                          widget.historyData.customerName ?? "-",
                                                          widget.historyData.billNumber ?? "-"),
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
                                                  color: AppColors.CLR_ICON)),
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
                                      DateFormat('dd/MM/yyyy | hh:mm a').format(
                                          DateTime.parse(widget
                                                  .historyData.completionDate
                                                  .toString())
                                              .toLocal()),
                                      // DateFormat("dd/MM/yy | hh:mm a")
                                      //     .format(widget.historyData.cOMPLETIONDATE.toString())
                                      //   ,
                                      // widget.historyData.cOMPLETIONDATE
                                      //     .toString(),
                                      // "01/08/2023 | 12:48 PM",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.TXT_CLR_LITE,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  )
                                ],
                              )),
                        ),
                        Divider(
                          color: AppColors.CLR_CON_BORDER,
                          height: 10.h,
                          thickness: 0.50,
                        ),
                        TxnDetails(
                            title: "Account",
                            subTitle:
                                'Equitas Bank - ${widget.historyData.accountNumber.toString()}',
                            clipBoard: false),
                        if (widget.historyData.customerName != null &&
                            widget.historyData.customerName != "NA")
                          TxnDetails(
                              title: "Consumer Name",
                              subTitle:
                                  widget.historyData.customerName.toString(),
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
                          color: AppColors.CLR_CON_BORDER,
                          height: 10.h,
                          thickness: 0.50,
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
                        if (widget.historyData.parameters![0].parameterName != null ||
                            widget.historyData.parameters![0].parameterValue !=
                                null)
                          TxnDetails(
                              title: widget.historyData.categoryName
                                      .toString()
                                      .toLowerCase()
                                      .contains("mobile prepaid")
                                  ? "Mobile Number"
                                  : widget.historyData.parameters![0].parameterName
                                      .toString(),
                              subTitle: widget.historyData.categoryName
                                      .toString()
                                      .toLowerCase()
                                      .contains("mobile prepaid")
                                  ? widget.historyData.parameters!
                                      .firstWhere((params) => params.parameterName == null
                                          ? params.parameterName == null
                                          : params.parameterName.toString().toLowerCase() == "mobile number" ||
                                              params.parameterName.toString().toLowerCase() ==
                                                  "customer mobile number")
                                      .parameterValue
                                      .toString()
                                  : widget.historyData.parameters![0].parameterValue.toString(),
                              clipBoard: false),
                        if (widget.historyData.transactionReferenceId != null)
                          TxnDetails(
                              title: "Transaction ID",
                              subTitle: widget
                                  .historyData.transactionReferenceId
                                  .toString(),
                              clipBoard: true),
                        if (isTransactionStatusLoading || isTxnUpdateLoading)
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
                                    color: Color(0xff808080),
                                    height: 23 / 14,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 5.h),
                                SizedBox(
                                  width: 250.w,
                                  child: Row(
                                    children: [
                                      AnimatedTextKit(
                                        repeatForever: true,
                                        isRepeatingAnimation: true,
                                        animatedTexts: [
                                          ColorizeAnimatedText(
                                            'Checking Transaction Status',
                                            textStyle: colorizeTextStyle,
                                            colors: colorizeColors,
                                          ),
                                        ],
                                      ),
                                      // Text(
                                      //   "Checking Transaction Status",
                                      //   style: TextStyle(
                                      //     fontSize: 14.sp,
                                      //     fontWeight: FontWeight.w500,
                                      //     color: Color(0xff1b438b),
                                      //   ),
                                      //   textAlign: TextAlign.left,
                                      //   maxLines: 2,
                                      // ),
                                      AnimatedTextKit(
                                          repeatForever: true,
                                          isRepeatingAnimation: true,
                                          animatedTexts: [
                                            TyperAnimatedText(' . . .',
                                                textStyle: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.orange,
                                                ),
                                                speed: Duration(
                                                    milliseconds: 100)),
                                          ]),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          ),
                        if (!isTransactionStatusLoading && !isTxnUpdateLoading)
                          TxnDetails(
                              title: "Status",
                              subTitle: widget.historyData.transactionStatus
                                          .toString()
                                          .toLowerCase() ==
                                      "success"
                                  ? "Transaction Success"
                                  : widget.historyData.transactionStatus
                                                  .toString()
                                                  .toLowerCase() ==
                                              "bbps-in-progress" ||
                                          widget.historyData.transactionStatus
                                                  .toString()
                                                  .toLowerCase() ==
                                              "bbps-timeout"
                                      ? "Transaction Pending"
                                      : "Transaction Failure",
                              clipBoard: false),
                        if (!isTransactionStatusLoading && !isTxnUpdateLoading)
                          if (widget.historyData.transactionStatus
                                  .toString()
                                  .toLowerCase() !=
                              "success")
                            TxnDetails(
                                title: "Reason",
                                subTitle: getTransactionReason(widget
                                    .historyData.transactionStatus
                                    .toString()),
                                clipBoard: false),
                        TxnDetails(
                            title: "Payment Channel",
                            subTitle: widget.historyData.paymentChannel == 'IB'
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
            );
          },
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   backgroundColor: CLR_PRIMARY,
        //   onPressed: () {},
        //   icon: Icon(Icons.refresh),
        //   label: Text("Refresh Status"),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomSheet: widget.historyData.transactionReferenceId == null ||
                (widget.historyData.transactionStatus
                            .toString()
                            .toLowerCase() ==
                        "bbps-in-progress" ||
                    widget.historyData.transactionStatus
                            .toString()
                            .toLowerCase() ==
                        "bbps-timeout")
            ? null
            : Container(
                decoration: BoxDecoration(
                    color: AppColors.CLR_BACKGROUND,
                    border: Border(
                        top: BorderSide(
                            color: AppColors.CLR_CON_BORDER_LITE, width: 1))),
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
                                "Date": widget.historyData.completionDate,
                                "txnRefID": widget
                                    .historyData.transactionReferenceId
                                    .toString(),
                                "BillerName":
                                    widget.historyData.billerName.toString(),
                                "CategoryName":
                                    widget.historyData.categoryName.toString(),
                              });
                            },
                            buttonText: "Raise a Complaint",
                            buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                            buttonBorderColor: Colors.transparent,
                            buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
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
