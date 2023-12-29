import 'package:flutter/material.dart';

List<Color> getStatusGradientColors(transactionStatus) {
  return transactionStatus == 'success'
      ? [
          Color(0xff99DDB4).withOpacity(.7),
          Color(0xff31637D).withOpacity(.7),
        ]
      : transactionStatus == 'bbpsTimeout'
          ? [
              Color(0xff99DDB4).withOpacity(.7),
              Color(0xff31637D).withOpacity(.7),
            ]
          : [
              Color(0xff982F67).withOpacity(.7),
              Color.fromARGB(255, 141, 58, 58).withOpacity(.7),
            ];
}
