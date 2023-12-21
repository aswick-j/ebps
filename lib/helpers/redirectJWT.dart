import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/screens/session_expired.dart';
import 'package:ebps/services/api.dart';
import 'package:flutter/material.dart';
import 'package:jwt_io/jwt_io.dart';

Future<void> validateSession(BuildContext context) async {
  try {
    var token = await getSharedValue(TOKEN);
    bool hasExpired = JwtToken.isExpired(token);

    if (!hasExpired) {
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SessionExpired()),
        );
      });
    }
  } catch (error) {
    print('Error during token validation: $error');
  }
}
