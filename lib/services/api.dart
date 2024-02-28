import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:ebps/constants/api.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/NavigationService.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:ebps/models/decoded_model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
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
  return jsonDecode(decodedToken);
}

api(
    {@required String? method,
    @required String? url,
    Map<String, dynamic>? body,
    token,
    checkSum}) async {
  late String bodyPayload;

  if (url.toString().contains("/auth/redirect") ||
      url.toString().contains(LOGIN_URL)) {
    bodyPayload = json.encode(body);
  } else if (method!.toLowerCase().contains("put") ||
      method.toLowerCase().contains("post")) {
    var publicKey = await getSharedValue(ENCRYPTION_KEY);

    final rsaencryption = encrypt.Encrypter(
      encrypt.RSA(
          publicKey: CryptoUtils.rsaPublicKeyFromPem(publicKey),
          encoding: encrypt.RSAEncoding.OAEP),
    );

    List<String> splitByLength(String value, int length) {
      List<String> SplitDatas = [];

      for (int i = 0; i < value.length; i += length) {
        int offset = i + length;
        SplitDatas.add(
            value.substring(i, offset >= value.length ? value.length : offset));
      }
      return SplitDatas;
    }

    final data = splitByLength(jsonEncode(body), 64);

    final iv = encrypt.IV.fromUtf8("1234567890123456");

    List<String> newChunks = [];
    for (var chunk in data) {
      final encryptedChunk = rsaencryption.encrypt(chunk, iv: iv).base64;
      newChunks.add(encryptedChunk);
    }

    final chunksstring = newChunks.join("");

    bodyPayload =
        json.encode({"encryptedData": chunksstring, "fromMobile": true});
  }
  try {
    if (token == true) {
      var token1 = await getSharedValue(TOKEN);
      bool hasExpired = JwtToken.isExpired(token1);

      if (!hasExpired) {
      } else {
        NavigationService.instance.navigateToReplacement(sESSIONEXPIREDROUTE);
      }
    }

    if (method!.toLowerCase().contains("post")) {
      return client
          .post(Uri.parse(url!),
              body: bodyPayload,
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
              body: bodyPayload,
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
