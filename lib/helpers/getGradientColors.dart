import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';

List<Color> getStatusGradientColors(transactionStatus) {
  return transactionStatus == 'success'
      ? [
          Color(0xff99DDB4).withOpacity(.7),
          Color(0xff31637D).withOpacity(.7),
        ]
      : (transactionStatus == 'bbps-timeout' ||
              transactionStatus == 'bbps-in-progress' ||
              transactionStatus == 'pending')
          ? [
              Color.fromRGBO(115, 59, 89, 1).withOpacity(.7),
              CLR_ASTRIX.withOpacity(.7),
            ]
          : [
              Color(0xff982F67).withOpacity(.7),
              Color.fromARGB(255, 141, 58, 58).withOpacity(.7),
            ];
}
