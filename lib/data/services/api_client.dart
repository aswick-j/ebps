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
}
