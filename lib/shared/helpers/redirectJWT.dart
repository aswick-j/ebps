import 'package:ebps/domain/services/api.dart';
import 'package:ebps/ui/screens/session_expired.dart';
import 'package:flutter/material.dart';
import 'package:jwt_io/jwt_io.dart';

Future<void> validateJWT(BuildContext context) async {
  try {
    var token = await getSharedValue(TOKEN);
    bool hasExpired = JwtToken.isExpired(token);
    if (!hasExpired) {
    } else {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SessionExpired()),
        );
      });
    }
  } catch (error) {
    print('Error during token validation: $error');
  }
}
