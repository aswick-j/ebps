import 'dart:convert';
import 'dart:io';

import 'package:ebps/domain/models/decoded_model.dart';
import 'package:ebps/shared/helpers/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_io/jwt_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

var client = http.Client();
const requestTimeoutDuration = 120;
const String TOKEN = 'TOKEN';
const String ENCRYPTION_KEY = 'ENCRYPTION_KEY';

setSharedValue(key, value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
  return true;
}

setSharedBoolValue(key, value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
  return true;
}

setSharedNotificationValue(key, value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
  return true;
}

getSharedValue(key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

getSharedBoolValue(key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

getSharedNotificationValue(key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

clearSharedValues() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

validateJWT() async {
  try {
    var token = await getSharedValue(TOKEN);
    bool hasExpired = JwtToken.isExpired(token);
    if (hasExpired != true) {
      var decodedToken = JwtToken.payload(token);
      DecodedModel? model = DecodedModel.fromJson(decodedToken);

      return model;
    } else {
      return 'restart';
    }
  } catch (e) {
    logger.e(error: "JWT ERROR ===> api/validateJWT", e);
  }
}

dynamic getDecodedToken() async {
  var token = await getSharedValue(TOKEN);
  final encodedPayload = token?.split('.')[1];
  dynamic decodedToken =
      utf8.fuse(base64).decode(base64.normalize(encodedPayload));
  print(decodedToken);
  return jsonDecode(decodedToken);
}

api(
    {@required String? method,
    @required String? url,
    Map<String, dynamic>? body,
    token,
    checkSum}) async {
  try {
    if (method!.toLowerCase().contains("post")) {
      return client
          .post(Uri.parse(url!),
              body: json.encode(body),
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : checkSum != null
                      ? {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                          "checksum": checkSum,
                        }
                      : {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                        })
          .timeout(
        Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    } else if (method.toLowerCase().contains("put")) {
      // log(await getSharedBoolValue(TOKEN));
      return client
          .put(Uri.parse(url!),
              body: json.encode(body),
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : checkSum != null
                      ? {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                          "checksum": checkSum,
                        }
                      : {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                        })
          .timeout(
        Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    } else if (method.toLowerCase().contains("get")) {
      return client
          .get(Uri.parse(url!),
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : {
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    })
          .timeout(
        Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    } else if (method.toLowerCase().contains("delete")) {
      return client
          .delete(Uri.parse(url!),
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : {
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    })
          .timeout(
        const Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    }
  } catch (e) {}
}
