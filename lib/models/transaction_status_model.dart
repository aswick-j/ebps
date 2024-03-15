// To parse this JSON data, do
//
//     final transactionStatus = transactionStatusFromJson(jsonString);

import 'dart:convert';

TransactionStatus transactionStatusFromJson(String str) =>
    TransactionStatus.fromJson(json.decode(str));

String transactionStatusToJson(TransactionStatus data) =>
    json.encode(data.toJson());

class TransactionStatus {
  int? status;
  String? message;
  TransactionStatusData? data;

  TransactionStatus({
    this.status,
    this.message,
    this.data,
  });

  factory TransactionStatus.fromJson(Map<String, dynamic> json) =>
      TransactionStatus(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : TransactionStatusData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class TransactionStatusData {
  int? status;
  String? message;
  DataData? data;

  TransactionStatusData({
    this.status,
    this.message,
    this.data,
  });

  factory TransactionStatusData.fromJson(Map<String, dynamic> json) =>
      TransactionStatusData(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataData {
  String? message;
  TransactionStatusClass? transactionStatus;
  bool? success;
  String? rc;

  DataData({
    this.message,
    this.transactionStatus,
    this.success,
    this.rc,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        message: json["message"],
        transactionStatus: json["transactionStatus"] == null
            ? null
            : TransactionStatusClass.fromJson(json["transactionStatus"]),
        success: json["success"],
        rc: json["rc"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "transactionStatus": transactionStatus?.toJson(),
        "success": success,
        "rc": rc,
      };
}

class TransactionStatusClass {
  Response? response;
  int? id;
  Tranlog? tranlog;

  TransactionStatusClass({
    this.response,
    this.id,
    this.tranlog,
  });

  factory TransactionStatusClass.fromJson(Map<String, dynamic> json) =>
      TransactionStatusClass(
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
        id: json["id"],
        tranlog:
            json["tranlog"] == null ? null : Tranlog.fromJson(json["tranlog"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response?.toJson(),
        "id": id,
        "tranlog": tranlog?.toJson(),
      };
}

class Response {
  String? actCode;
  String? response;
  String? bankRrn;
  String? bbpsTranlogId;
  String? extraData;
  String? ssTxnId;
  TxnData? data;

  Response({
    this.actCode,
    this.response,
    this.bankRrn,
    this.bbpsTranlogId,
    this.extraData,
    this.ssTxnId,
    this.data,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        actCode: json["ActCode"],
        response: json["Response"],
        bankRrn: json["BankRRN"],
        bbpsTranlogId: json["BbpsTranlogId"],
        extraData: json["ExtraData"],
        ssTxnId: json["SsTxnId"],
        data: json["Data"] == null ? null : TxnData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "ActCode": actCode,
        "Response": response,
        "BankRRN": bankRrn,
        "BbpsTranlogId": bbpsTranlogId,
        "ExtraData": extraData,
        "SsTxnId": ssTxnId,
        "Data": data?.toJson(),
      };
}

class TxnData {
  TxnStatusComplainResp? txnStatusComplainResp;

  TxnData({
    this.txnStatusComplainResp,
  });

  factory TxnData.fromJson(Map<String, dynamic> json) => TxnData(
        txnStatusComplainResp: json["TxnStatusComplainResp"] == null
            ? null
            : TxnStatusComplainResp.fromJson(json["TxnStatusComplainResp"]),
      );

  Map<String, dynamic> toJson() => {
        "TxnStatusComplainResp": txnStatusComplainResp?.toJson(),
      };
}

class TxnStatusComplainResp {
  String? responseReason;
  String? msgId;
  TxnList? txnList;
  CustomerDetails? customerDetails;
  String? responseCode;

  TxnStatusComplainResp({
    this.responseReason,
    this.msgId,
    this.txnList,
    this.customerDetails,
    this.responseCode,
  });

  factory TxnStatusComplainResp.fromJson(Map<String, dynamic> json) =>
      TxnStatusComplainResp(
        responseReason: json["responseReason"],
        msgId: json["msgId"],
        txnList:
            json["TxnList"] == null ? null : TxnList.fromJson(json["TxnList"]),
        customerDetails: json["CustomerDetails"] == null
            ? null
            : CustomerDetails.fromJson(json["CustomerDetails"]),
        responseCode: json["responseCode"],
      );

  Map<String, dynamic> toJson() => {
        "responseReason": responseReason,
        "msgId": msgId,
        "TxnList": txnList?.toJson(),
        "CustomerDetails": customerDetails?.toJson(),
        "responseCode": responseCode,
      };
}

class CustomerDetails {
  String? mobile;

  CustomerDetails({
    this.mobile,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
      };
}

class TxnList {
  TxnDetail? txnDetail;

  TxnList({
    this.txnDetail,
  });

  factory TxnList.fromJson(Map<String, dynamic> json) => TxnList(
        txnDetail: json["TxnDetail"] == null
            ? null
            : TxnDetail.fromJson(json["TxnDetail"]),
      );

  Map<String, dynamic> toJson() => {
        "TxnDetail": txnDetail?.toJson(),
      };
}

class TxnDetail {
  String? billerId;
  String? agentId;
  String? amount;
  String? complianceReason;
  String? disputeDate;
  String? mti;
  String? caAmount;
  String? disputeType;
  String? complianceRespCd;
  String? caDate;
  String? txnReferenceId;
  String? disputeAmount;
  String? caStatus;
  String? txnStatus;
  String? disputeId;
  String? disputeStatus;
  String? caId;
  String? approvalRefNum;
  String? caPenalty;
  String? billNumber;
  DateTime? txnDate;

  TxnDetail({
    this.billerId,
    this.agentId,
    this.amount,
    this.complianceReason,
    this.disputeDate,
    this.mti,
    this.caAmount,
    this.disputeType,
    this.complianceRespCd,
    this.caDate,
    this.txnReferenceId,
    this.disputeAmount,
    this.caStatus,
    this.txnStatus,
    this.disputeId,
    this.disputeStatus,
    this.caId,
    this.approvalRefNum,
    this.caPenalty,
    this.billNumber,
    this.txnDate,
  });

  factory TxnDetail.fromJson(Map<String, dynamic> json) => TxnDetail(
        billerId: json["billerId"],
        agentId: json["agentId"],
        amount: json["amount"],
        complianceReason: json["complianceReason"],
        disputeDate: json["disputeDate"],
        mti: json["mti"],
        caAmount: json["caAmount"],
        disputeType: json["disputeType"],
        complianceRespCd: json["complianceRespCd"],
        caDate: json["caDate"],
        txnReferenceId: json["txnReferenceId"],
        disputeAmount: json["disputeAmount"],
        caStatus: json["caStatus"],
        txnStatus: json["txnStatus"],
        disputeId: json["disputeId"],
        disputeStatus: json["disputeStatus"],
        caId: json["caId"],
        approvalRefNum: json["approvalRefNum"],
        caPenalty: json["caPenalty"],
        billNumber: json["billNumber"],
        txnDate:
            json["txnDate"] == null ? null : DateTime.parse(json["txnDate"]),
      );

  Map<String, dynamic> toJson() => {
        "billerId": billerId,
        "agentId": agentId,
        "amount": amount,
        "complianceReason": complianceReason,
        "disputeDate": disputeDate,
        "mti": mti,
        "caAmount": caAmount,
        "disputeType": disputeType,
        "complianceRespCd": complianceRespCd,
        "caDate": caDate,
        "txnReferenceId": txnReferenceId,
        "disputeAmount": disputeAmount,
        "caStatus": caStatus,
        "txnStatus": txnStatus,
        "disputeId": disputeId,
        "disputeStatus": disputeStatus,
        "caId": caId,
        "approvalRefNum": approvalRefNum,
        "caPenalty": caPenalty,
        "billNumber": billNumber,
        "txnDate": txnDate?.toIso8601String(),
      };
}

class Tranlog {
  int? id;
  int? instituteId;
  int? userId;
  int? mobile;
  int? amount;
  String? status;
  int? created;
  String? criteria;
  String? switchResponse;
  int? fee;
  int? type;
  int? totalAmount;
  String? quickPay;
  int? ccf1;
  int? ccf2;
  int? ouId;
  int? agentId;
  int? agentGroupId;
  String? switchActCode;
  String? switchRespStatus;

  Tranlog({
    this.id,
    this.instituteId,
    this.userId,
    this.mobile,
    this.amount,
    this.status,
    this.created,
    this.criteria,
    this.switchResponse,
    this.fee,
    this.type,
    this.totalAmount,
    this.quickPay,
    this.ccf1,
    this.ccf2,
    this.ouId,
    this.agentId,
    this.agentGroupId,
    this.switchActCode,
    this.switchRespStatus,
  });

  factory Tranlog.fromJson(Map<String, dynamic> json) => Tranlog(
        id: json["id"],
        instituteId: json["instituteId"],
        userId: json["userId"],
        mobile: json["mobile"],
        amount: json["amount"],
        status: json["status"],
        created: json["created"],
        criteria: json["criteria"],
        switchResponse: json["switchResponse"],
        fee: json["fee"],
        type: json["type"],
        totalAmount: json["totalAmount"],
        quickPay: json["quickPay"],
        ccf1: json["ccf1"],
        ccf2: json["ccf2"],
        ouId: json["ouId"],
        agentId: json["agentId"],
        agentGroupId: json["agentGroupId"],
        switchActCode: json["switchActCode"],
        switchRespStatus: json["switchRespStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "instituteId": instituteId,
        "userId": userId,
        "mobile": mobile,
        "amount": amount,
        "status": status,
        "created": created,
        "criteria": criteria,
        "switchResponse": switchResponse,
        "fee": fee,
        "type": type,
        "totalAmount": totalAmount,
        "quickPay": quickPay,
        "ccf1": ccf1,
        "ccf2": ccf2,
        "ouId": ouId,
        "agentId": agentId,
        "agentGroupId": agentGroupId,
        "switchActCode": switchActCode,
        "switchRespStatus": switchRespStatus,
      };
}
