import 'dart:convert';

ComplaintStatusUpdateModel complaintStatusUpdateModelFromJson(String str) =>
    ComplaintStatusUpdateModel.fromJson(json.decode(str));

String complaintStatusUpdateModelToJson(ComplaintStatusUpdateModel data) =>
    json.encode(data.toJson());

class ComplaintStatusUpdateModel {
  int? status;
  String? message;
  Data? data;

  ComplaintStatusUpdateModel({
    this.status,
    this.message,
    this.data,
  });

  factory ComplaintStatusUpdateModel.fromJson(Map<String, dynamic> json) =>
      ComplaintStatusUpdateModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  String? responseReason;
  String? complaintStatus;
  String? complaintId;
  String? msgId;
  String? assigned;
  String? remarks;
  String? responseCode;

  Data({
    this.responseReason,
    this.complaintStatus,
    this.complaintId,
    this.msgId,
    this.assigned,
    this.remarks,
    this.responseCode,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseReason: json["responseReason"],
        complaintStatus: json["complaintStatus"],
        complaintId: json["complaintId"],
        msgId: json["msgId"],
        assigned: json["assigned"],
        remarks: json["remarks"],
        responseCode: json["responseCode"],
      );

  Map<String, dynamic> toJson() => {
        "responseReason": responseReason,
        "complaintStatus": complaintStatus,
        "complaintId": complaintId,
        "msgId": msgId,
        "assigned": assigned,
        "remarks": remarks,
        "responseCode": responseCode,
      };
}
