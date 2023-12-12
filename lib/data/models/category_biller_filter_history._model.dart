class CategoryBillerHistoryFilter {
  int? status;
  String? message;
  List<Data>? data;

  CategoryBillerHistoryFilter({this.status, this.message, this.data});

  CategoryBillerHistoryFilter.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? bILLERID;
  String? bILLERNAME;

  Data({this.bILLERID, this.bILLERNAME});

  Data.fromJson(Map<String, dynamic> json) {
    bILLERID = json['BILLER_ID'];
    bILLERNAME = json['BILLER_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BILLER_ID'] = this.bILLERID;
    data['BILLER_NAME'] = this.bILLERNAME;
    return data;
  }
}
