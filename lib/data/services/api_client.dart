import 'dart:convert';

import 'package:ebps/constants/api.dart';
import 'package:ebps/data/repository/api_repository.dart';
import 'package:ebps/data/services/api.dart';

class ApiClient implements Repository {
  //LOGIN_REPOSITORY
  @override
  Future login(id, hash) async {
    try {
      Map<String, dynamic>? requestBody = {
        "hash": hash,
      };

      var response = await api(
          method: "post",
          url: BASE_URL + LOGIN_URL + id,
          body: requestBody,
          token: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {}
  }

  //CATEGOEY_REPOSITORY

  @override
  Future getCategories() async {
    try {
      var response = await api(
          method: "get",
          url: BASE_URL + CATEGORIES_URL,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {
      return {"status": 500, "message": "Request Timed Out", "data": "Error"};
    }
  }

  //BILLERS

  @override
  Future getBillers(
    categoryId,
    pageNumber,
  ) async {
    try {
      Map<String, dynamic> body = {
        "categoryId": categoryId,
        "pageNumber": pageNumber
      };
      var response = await api(
          method: "post",
          url: BASE_URL + BILLER_URL,
          body: body,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {
      return {"status": 500, "message": "Request Timed Out", "data": "Error"};
    }
  }

  //BILLER INPUT SIGN

  @override
  Future getInputSignature(id) async {
    try {
      var response = await api(
          method: "get",
          url: BASE_URL + INPUT_SIGN_URL + id.toString(),
          token: true,
          checkSum: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  //FETCH BILL

  @override
  Future fetchBill(validateBill, billerID, billerParams, quickPay,
      quickPayAmount, adHocBillValidationRefKey, billName) async {
    Map<String, dynamic> body = {
      "validateBill": validateBill,
      "billerID": billerID,
      "billerParams": billerParams,
      "quickPay": quickPay,
      "quickPayAmount": quickPayAmount,
      "adHocBillValidationRefKey": adHocBillValidationRefKey,
      "billName": billName
    };
    try {
      var response = await api(
          method: "post",
          url: BASE_URL + FETCH_BILL_URL,
          body: body,
          token: true,
          checkSum: false);

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {
      return {"status": 500, "message": "Request Timed Out", "data": "Error"};
    }
  }

  @override
  Future getAccountInfo(account) async {
    /*
     {"message":"Successfully retrieved the account Info","status":200,"data":[{"accountNumber":"100003504880","balance":236655}]}
     */

    try {
      Map<String, dynamic> body = {"accountInfo": account};

      var response = await api(
          method: "post",
          url: BASE_URL + ACCOUNT_INFO_URL,
          body: body,
          token: true,
          checkSum: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  //PAYMENT INFO

  @override
  Future getPaymentInformation(id) async {
    try {
      /**
      {"status":200,"message":"Fetch Payment Modes and Channels","data":{"BILLER_ID":"OTO125007XXA63","PAYMENT_MODE":"Internet Banking","MODE_MIN_LIMIT":1,"MODE_MAX_LIMIT":9999999,"PAYMENT_CHANNEL":"INTB","MIN_LIMIT":"0.01","MAX_LIMIT":"99999.99"}}
       */
      var response = await api(
          method: "get",
          url: BASE_URL + PAYMENT_INFO_URL + id.toString(),
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      // debugLog(decodedResponse, "getPaymentInformation", response);
      // return decodedResponse;
      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        return decodedResponse;
      } else {
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  //Validate-bill

  @override
  Future validateBill(payload) async {
    try {
      var response = await api(
          method: "post",
          url: BASE_URL + VALIDATE_BILL_URL,
          token: true,
          body: payload,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  //GEN-OTP

  @override
  Future generateOtp({templateName, billerName}) async {
    try {
      Map<String, dynamic> body = {
        "template": templateName,
        "templateVariables": {
          templateName != "confirm-payment" ? "billerName" : "billAmount":
              billerName
        }
      };
      var response = await api(
          method: "post",
          url: BASE_URL + GEN_OTP_URL,
          body: body,
          token: true,
          checkSum: false);

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {}
  }

  //VAL-OTP

  @override
  Future validateOtp(otp) async {
    try {
      Map<String, dynamic> body = {"otp": otp};
      var response = await api(
          method: 'post',
          body: body,
          url: BASE_URL + VALIDATE_OTP_URL,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {}
  }

  //PAY-BILL

  @override
  Future payBill(
      String billerID,
      String acNo,
      String billAmount,
      int customerBillID,
      String tnxRefKey,
      bool quickPay,
      dynamic inputSignature,
      bool otherAmount,
      String otp) async {
    try {
      Map<String, dynamic> body = {};
      if (customerBillID == 0) {
        body = {
          "billerId": billerID,
          "accountNumber": acNo,
          "billAmount": billAmount,
          "transactionReferenceKey": tnxRefKey,
          "quickPay": quickPay,
          "inputSignatures": inputSignature,
          "otherAmount": otherAmount,
          "otp": otp
        };
      } else {
        body = {
          "billerId": billerID,
          "accountNumber": acNo,
          "billAmount": billAmount,
          "customerBillId": customerBillID,
          "transactionReferenceKey": tnxRefKey,
          "quickPay": quickPay,
          "inputSignatures": inputSignature,
          "otherAmount": otherAmount,
          "otp": otp
        };
      }

      var response = await api(
          method: "post",
          url: BASE_URL + PAY_BILL_URL,
          body: body,
          token: true,
          checkSum: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;

        // DONOT DELETE - paybill fail case response
        // return {
        //   "message": "Bill Payment failed for a transaction",
        //   "status": 500
        // };

        //{"message":"Bill Payment failed for a transaction","data":{"paymentDetails":{"created":"2023-02-15T07:09:24.880Z","failed":true},"transactionSteps":[{"description":"Transaction Initiated","flag":true,"pending":false},{"description":"Fund Transfer Initiated by Bank","flag":false,"pending":false},{"description":"Bill processed by Biller","flag":false,"pending":false},{"description":"Bill Payment Completed","flag":false,"pending":false}],"reason":"fund transfer failure","equitasTransactionId":"-"},"status":500}
      } else {
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  //SEARCH

  @override
  Future getSearchedBillers(String searchString, String? category,
      String? location, int? pageNumber) async {
    try {
      //{"searchString":"test","category":"All","location":"All","pageNumber":1}

      Map<String, dynamic> requestPayload = {
        "searchString": searchString,
        "category": category ?? "All",
        "location": location ?? "All",
        "pageNumber": pageNumber ?? 1
      };
      var response = await api(
          method: "post",
          url: BASE_URL + SEARCH_URL,
          body: requestPayload,
          token: true,
          checkSum: false);
      var decodedResponse = await jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {
      return null;
    }
  }

  //HISTORY

  Future<dynamic> getHistory(payload) async {
    Map<String, dynamic> body = payload;

    try {
      var response = await api(
          method: "post",
          url: BASE_URL + HISTORY_URL,
          body: body,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {}
  }

  //COMPLAINT LIST

  @override
  Future getComplaints() async {
    try {
      var response = await api(
          method: "get",
          url: BASE_URL + COMLPAINT_URL,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      return decodedResponse;
    } catch (e) {}
  }

  //COMPLAINT CONFIG

  @override
  Future getComplaintConfig() async {
    try {
      var response = await api(
          method: "get",
          url: BASE_URL + COMLPAINT_CONFIG_URL,
          token: true,
          checkSum: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  //COMPLAINT SUBMIT

  @override
  Future submitComplaint(complaint) async {
    try {
      var response = await api(
          method: "post",
          url: BASE_URL + COMLPAINT_URL,
          body: complaint,
          token: true,
          checkSum: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  //AUTOPAY MAX AMOUNY

  @override
  Future getAutoPayMaxAmount() async {
    try {
      var response = await api(
          method: "get",
          url: BASE_URL + GET_AUTOPAY_MAXAMOUNT_URL,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      return decodedResponse;
    } catch (e) {}
  }

  //GET ALL UPCOMING DUES

  @override
  Future getAllUpcomingDues() async {
    try {
      var response = await api(
          method: "get",
          url: BASE_URL + GET_ALL_UPCOMING_URL,
          token: true,
          checkSum: false);
      var decodedResponse = await jsonDecode(utf8.decode(response.bodyBytes));

      return decodedResponse;
    } catch (e) {
      return null;
    }
  }

  //GET ALL AUTOPAY

  @override
  Future getAutoPay() async {
    try {
      var response = await api(
          method: "get",
          url: BASE_URL + GET_AUTOPAY_URL,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      return decodedResponse;
    } catch (e) {}
  }

  //GET ALL SAVED BILLERS

  @override
  Future getSavedBillers() async {
    try {
      var response = await api(
        method: "get",
        url: BASE_URL + GET_SAVED_BILLERS_URL,
        token: true,
        checkSum: false,
      );
      var decodedResponse = await jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {
      return {"status": 500, "message": "Request Timed Out", "data": "Error"};
    }
  }

  //GET EDIT SAVED BILLER

  @override
  Future getEditSavedBillDetails(id) async {
    try {
      var response = await api(
          method: "get",
          url: BASE_URL + GET_EDIT_SAVED_URL + id.toString(),
          token: true,
          checkSum: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  //UPDATE EDIT  BILLER

  @override
  Future updateBillDetails(dynamic updateBillPayload) async {
    try {
      Map<String, dynamic> body = updateBillPayload;

      var response = await api(
          method: "put",
          url: BASE_URL + UPDATE_BILL_URL,
          body: body,
          token: true,
          checkSum: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse;
      } else {
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future deleteBiller(cid, cusId, otp) async {
    try {
      Map<String, dynamic> body = {
        "customerBillId": cid,
        "customerId": cusId,
        "otp": otp
      };
      var response = await api(
          method: "post",
          url: BASE_URL + DELETE_BILLER_URL,
          body: body,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      return decodedResponse;
    } catch (e) {}
  }
}
