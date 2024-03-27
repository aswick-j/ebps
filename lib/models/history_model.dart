import 'dart:convert';

HistoryModal historyModalFromJson(String str) =>
    HistoryModal.fromJson(json.decode(str));

String historyModalToJson(HistoryModal data) => json.encode(data.toJson());

class HistoryModal {
  int? status;
  String? message;
  List<HistoryData>? data;

  HistoryModal({
    this.status,
    this.message,
    this.data,
  });

  factory HistoryModal.fromJson(Map<String, dynamic> json) => HistoryModal(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<HistoryData>.from(
                json["data"]!.map((x) => HistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HistoryData {
  int? transactionId;
  String? customerId;
  String? transactionReferenceId;
  double? billAmount;
  DateTime? completionDate;
  String? transactionStatus;
  String? billerId;
  String? paymentChannel;
  String? paymentMode;
  String? accountNumber;
  String? mobileNumber;
  String? customerName;
  String? approvalRefNo;
  String? fee;
  String? billNumber;
  String? equitasTransactionId;
  String? billerName;
  String? categoryName;
  String? categoryId;
  int? customerBillId;
  String? billName;
  String? billerAcceptsAdhoc;
  String? parameterName;
  String? parameterValue;
  int? autopayId;
  int? autoPay;
  int? rowNumber;
  int? totalPages;
  int? startPosition;
  int? endPosition;
  int? pageSize;
  List<HistoryParameter>? parameters;
  List<TransactionStep>? transactionSteps;

  HistoryData({
    this.transactionId,
    this.customerId,
    this.transactionReferenceId,
    this.billAmount,
    this.completionDate,
    this.transactionStatus,
    this.billerId,
    this.paymentChannel,
    this.paymentMode,
    this.accountNumber,
    this.mobileNumber,
    this.customerName,
    this.approvalRefNo,
    this.fee,
    this.billNumber,
    this.equitasTransactionId,
    this.billerName,
    this.categoryName,
    this.categoryId,
    this.customerBillId,
    this.billName,
    this.billerAcceptsAdhoc,
    this.parameterName,
    this.parameterValue,
    this.autopayId,
    this.autoPay,
    this.rowNumber,
    this.totalPages,
    this.startPosition,
    this.endPosition,
    this.pageSize,
    this.parameters,
    this.transactionSteps,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
        transactionId: json["TRANSACTION_ID"],
        customerId: json["CUSTOMER_ID"],
        transactionReferenceId: json["TRANSACTION_REFERENCE_ID"],
        billAmount: json["BILL_AMOUNT"]?.toDouble(),
        completionDate: json["COMPLETION_DATE"] == null
            ? null
            : DateTime.parse(json["COMPLETION_DATE"]),
        transactionStatus: json["TRANSACTION_STATUS"],
        billerId: json["BILLER_ID"],
        paymentChannel: json["PAYMENT_CHANNEL"],
        paymentMode: json["PAYMENT_MODE"],
        accountNumber: json["ACCOUNT_NUMBER"],
        mobileNumber: json["MOBILE_NUMBER"],
        customerName: json["CUSTOMER_NAME"],
        approvalRefNo: json["APPROVAL_REF_NO"],
        fee: json["FEE"],
        billNumber: json["BILL_NUMBER"],
        equitasTransactionId: json["EQUITAS_TRANSACTION_ID"],
        billerName: json["BILLER_NAME"],
        categoryName: json["CATEGORY_NAME"],
        categoryId: json["CATEGORY_ID"],
        customerBillId: json["CUSTOMER_BILL_ID"],
        billName: json["BILL_NAME"],
        billerAcceptsAdhoc: json["BILLER_ACCEPTS_ADHOC"],
        parameterName: json["PARAMETER_NAME"],
        parameterValue: json["PARAMETER_VALUE"],
        autopayId: json["AUTOPAY_ID"],
        autoPay: json["AUTO_PAY"],
        rowNumber: json["ROW_NUMBER"],
        totalPages: json["TOTAL_PAGES"],
        startPosition: json["START_POSITION"],
        endPosition: json["END_POSITION"],
        pageSize: json["PAGE_SIZE"],
        parameters: json["PARAMETERS"] == null
            ? []
            : List<HistoryParameter>.from(
                json["PARAMETERS"]!.map((x) => HistoryParameter.fromJson(x))),
        transactionSteps: json["TransactionSteps"] == null
            ? []
            : List<TransactionStep>.from(json["TransactionSteps"]!
                .map((x) => TransactionStep.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TRANSACTION_ID": transactionId,
        "CUSTOMER_ID": customerId,
        "TRANSACTION_REFERENCE_ID": transactionReferenceId,
        "BILL_AMOUNT": billAmount,
        "COMPLETION_DATE": completionDate?.toIso8601String(),
        "TRANSACTION_STATUS": transactionStatus,
        "BILLER_ID": billerId,
        "PAYMENT_CHANNEL": paymentChannel,
        "PAYMENT_MODE": paymentMode,
        "ACCOUNT_NUMBER": accountNumber,
        "MOBILE_NUMBER": mobileNumber,
        "CUSTOMER_NAME": customerName,
        "APPROVAL_REF_NO": approvalRefNo,
        "FEE": fee,
        "BILL_NUMBER": billNumber,
        "EQUITAS_TRANSACTION_ID": equitasTransactionId,
        "BILLER_NAME": billerName,
        "CATEGORY_NAME": categoryName,
        "CATEGORY_ID": categoryId,
        "CUSTOMER_BILL_ID": customerBillId,
        "BILL_NAME": billName,
        "BILLER_ACCEPTS_ADHOC": billerAcceptsAdhoc,
        "PARAMETER_NAME": parameterName,
        "PARAMETER_VALUE": parameterValue,
        "AUTOPAY_ID": autopayId,
        "AUTO_PAY": autoPay,
        "ROW_NUMBER": rowNumber,
        "TOTAL_PAGES": totalPages,
        "START_POSITION": startPosition,
        "END_POSITION": endPosition,
        "PAGE_SIZE": pageSize,
        "PARAMETERS": parameters == null
            ? []
            : List<dynamic>.from(parameters!.map((x) => x.toJson())),
        "TransactionSteps": transactionSteps == null
            ? []
            : List<dynamic>.from(transactionSteps!.map((x) => x.toJson())),
      };
}

class HistoryParameter {
  String? parameterName;
  String? parameterValue;

  HistoryParameter({
    this.parameterName,
    this.parameterValue,
  });

  factory HistoryParameter.fromJson(Map<String, dynamic> json) =>
      HistoryParameter(
        parameterName: json["PARAMETER_NAME"],
        parameterValue: json["PARAMETER_VALUE"],
      );

  Map<String, dynamic> toJson() => {
        "PARAMETER_NAME": parameterName,
        "PARAMETER_VALUE": parameterValue,
      };
}

class TransactionStep {
  String? description;
  bool? flag;
  bool? pending;

  TransactionStep({
    this.description,
    this.flag,
    this.pending,
  });

  factory TransactionStep.fromJson(Map<String, dynamic> json) =>
      TransactionStep(
        description: json["description"],
        flag: json["flag"],
        pending: json["pending"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "flag": flag,
        "pending": pending,
      };
}
