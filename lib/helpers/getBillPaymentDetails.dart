import 'package:ebps/data/models/confirm_done_model.dart';

getBillPaymentDetails(
    PaymentDetails? payBillInfo, bool isAdhoc, String? equitasTransactionId) {
  double? totalAmount = 0;
  String paymentDate = "";
  String? txnReferenceId = "";
  String cbsTransactionReferenceId = "";
  String? paymentMode = "";
  String? paymentChannel = "";
  String? customerName = "";
  String? mobileNumber = "";
  int? fee = 0;
  bool? success = false;
  String? approvalRefNum = "";
  bool isAdhocBIller = false;
  bool failed = false;
  bool bbpsTimeout = false;

  // date formatting options
  // const options = {
  //   weekday: "long",
  //   year: "numeric",
  //   month: "long",
  //   day: "numeric",
  //   hour: "numeric",
  //   minute: "numeric",
  // };

  if (payBillInfo != null) {
    if (payBillInfo.failed == true) {
      paymentDate = payBillInfo.created!;

      // new Intl.("en-IN",)
      //   .format(new Date(payBillInfo.created))
      //   .replace("pm", "PM")
      //   .replace("am", "AM");
      failed = true;
    } else {
      // If the Biller Supports Adhoc then Store the folowing details
      if (isAdhoc) {
        totalAmount = (payBillInfo.tran != null
            ? payBillInfo.tran!.totalAmount!.toDouble()
            : 0);
        paymentDate = payBillInfo.tran!.created.toString();

        txnReferenceId = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse!.data!.txnReferenceId
            : "-";
        cbsTransactionReferenceId = equitasTransactionId!;
        paymentMode =
            (payBillInfo.tran != null ? payBillInfo.tran?.paymentMode : "-");
        paymentChannel =
            (payBillInfo.tran != null ? payBillInfo.tran?.paymentChannel : "-");
        customerName = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.data?.billerResponse!.customerName
            : "-";
        mobileNumber = payBillInfo.tran != null
            ? payBillInfo.tran?.mobile.toString()
            : "-";
        fee = payBillInfo.tran != null ? payBillInfo.tran!.fee : 0;

        approvalRefNum = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.data?.approvalRefNum
            : "-";
        success = payBillInfo.success!;
        isAdhocBIller = true;
        bbpsTimeout = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.response == "CU timed out"
                ? true
                : false
            : false;
      } else {
        // If the Biller does not support adhoc then store this detail
        totalAmount = (payBillInfo.tran != null
            ? payBillInfo.tran?.totalAmount!.toDouble()
            : 0) as double?;
        paymentDate = payBillInfo.tran!.created.toString();

        txnReferenceId = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.data?.txnReferenceId
            : "-";
        cbsTransactionReferenceId = equitasTransactionId!;
        paymentMode =
            payBillInfo.tran != null ? payBillInfo.tran?.paymentMode : "-";
        paymentChannel =
            payBillInfo.tran != null ? payBillInfo.tran?.paymentChannel : "-";
        customerName = (payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.data?.billerResponse?.customerName
            : "-");
        mobileNumber = payBillInfo.tran != null
            ? payBillInfo.tran?.mobile.toString()
            : "-";
        fee = payBillInfo.tran != null ? payBillInfo.tran!.fee : 0;
        success = payBillInfo.success;
        approvalRefNum =
            payBillInfo.tran != null ? payBillInfo.tran?.approvalRefNo : "-";
        bbpsTimeout = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.response == "CU timed out"
                ? true
                : false
            : false;
      }
    }
  }
  // Map<String, dynamic> result = {
  //   totalAmount,
  //   paymentDate,
  //   txnReferenceId,
  //   cbsTransactionReferenceId,
  //   paymentMode,
  //   paymentChannel,
  //   customerName,
  //   mobileNumber,
  //   fee,
  //   success,
  //   approvalRefNum,
  //   failed,
  //   bbpsTimeout,
  // } as Map<String, dynamic>;
  // debugPrint(result);
  return {
    "totalAmount": totalAmount,
    "paymentDate": paymentDate,
    "txnReferenceId": txnReferenceId,
    "cbsTransactionReferenceId": cbsTransactionReferenceId,
    "paymentMode": paymentMode,
    "paymentChannel": paymentChannel,
    "customerName": customerName,
    "mobileNumber": mobileNumber,
    "fee": fee,
    "success": success,
    "approvalRefNum": approvalRefNum,
    "failed": failed,
    "bbpsTimeout": bbpsTimeout,
  };
}
