class complaints_model {
  int? status;
  String? message;
  List<ComplaintsData>? data;

  complaints_model({this.status, this.message, this.data});

  complaints_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ComplaintsData>[];
      json['data'].forEach((v) {
        data!.add(new ComplaintsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ComplaintsData {
  int? iD;
  String? cOMPLAINTID;
  String? dESCRIPTION;
  String? cREATEDON;
  String? tRANSACTIONID;
  String? sTATUS;
  String? cOMPLAINTREASON;
  dynamic bILLAMOUNT;
  String? bILLERNAME;
  String? cATEGORYNAME;
  String? bILLNAME;
  String? rEMARKS;
  String? uPDATEDAT;
  String? aSSIGNED;

  ComplaintsData(
      {this.iD,
      this.cOMPLAINTID,
      this.dESCRIPTION,
      this.cREATEDON,
      this.tRANSACTIONID,
      this.sTATUS,
      this.cOMPLAINTREASON,
      this.bILLAMOUNT,
      this.bILLERNAME,
      this.cATEGORYNAME,
      this.bILLNAME,
      this.rEMARKS,
      this.aSSIGNED,
      this.uPDATEDAT});

  ComplaintsData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    cOMPLAINTID = json['COMPLAINT_ID'];
    dESCRIPTION = json['DESCRIPTION'];
    cREATEDON = json['CREATED_ON'];
    tRANSACTIONID = json['TRANSACTION_ID'];
    sTATUS = json['STATUS'];
    bILLAMOUNT = json['BILL_AMOUNT'];
    bILLERNAME = json['BILLER_NAME'];
    cATEGORYNAME = json['CATEGORY_NAME'];
    bILLNAME = json['BILL_NAME'];
    rEMARKS = json['REMARKS'];
    aSSIGNED = json['ASSIGNED'];
    uPDATEDAT = json['UPDATED_AT'];

    cOMPLAINTREASON = json['COMPLAINT_REASON'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['COMPLAINT_ID'] = this.cOMPLAINTID;
    data['DESCRIPTION'] = this.dESCRIPTION;
    data['CREATED_ON'] = this.cREATEDON;
    data['TRANSACTION_ID'] = this.tRANSACTIONID;
    data['STATUS'] = this.sTATUS;
    data['BILL_AMOUNT'] = bILLAMOUNT;
    data['CATEGORY_NAME'] = cATEGORYNAME;
    data['BILL_NAME'] = bILLNAME;
    data['REMARKS'] = rEMARKS;
    data['BILLER_NAME'] = bILLERNAME;
    data['ASSIGNED'] = aSSIGNED;
    data['UPDATED_AT'] = uPDATEDAT;
    data['COMPLAINT_REASON'] = this.cOMPLAINTREASON;
    return data;
  }
}
