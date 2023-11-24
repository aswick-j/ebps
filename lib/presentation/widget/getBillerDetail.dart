import 'package:flutter/material.dart';

billerDetail(pARAMETERNAME, pARAMETERVALUE) {
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
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff808080),
                ),
                textAlign: TextAlign.center,
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
              child: Text(
                pARAMETERVALUE,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1b438b),
                ),
                textAlign: TextAlign.left,
              ))
        ],
      ));
}
