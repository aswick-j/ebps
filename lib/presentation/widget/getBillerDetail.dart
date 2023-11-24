import 'package:ebps/constants/sizes.dart';
import 'package:flutter/material.dart';

billerDetail(pARAMETERNAME, pARAMETERVALUE, context) {
  return Container(
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
              child: Text(
                pARAMETERNAME,
                // "Subscriber ID",
                style: TextStyle(
                  fontSize: TXT_SIZE_NORMAL(context),
                  fontWeight: FontWeight.w400,
                  color: Color(0xff808080),
                ),
                textAlign: TextAlign.center,
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(8, 10, 0, 0),
              child: Text(
                pARAMETERVALUE,
                style: TextStyle(
                  fontSize: TXT_SIZE_LARGE(context),
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1b438b),
                ),
                textAlign: TextAlign.left,
              ))
        ],
      ));
}
