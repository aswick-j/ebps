import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BillerDetailsContainer extends StatelessWidget {
  const BillerDetailsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Column(children: [
        Container(
          width: 50,
          height: 50,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: SvgPicture.asset("packages/ebps/assets/icon/icon_jio.svg"),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Airtel Digital TV",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff1b438b),
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "DTH",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff808080),
            height: 26 / 16,
          ),
          textAlign: TextAlign.left,
        )
      ]),
    );
  }
}
