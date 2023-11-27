import 'package:ebps/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BillerDetailsContainer extends StatelessWidget {
  String icon;
  String billerName;
  String categoryName;
  BillerDetailsContainer(
      {super.key,
      required this.icon,
      required this.billerName,
      required this.categoryName});

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
            child: SvgPicture.asset(icon),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          billerName,
          style: TextStyle(
            fontSize: TXT_SIZE_XL(context),
            fontWeight: FontWeight.bold,
            color: Color(0xff1b438b),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          categoryName,
          style: TextStyle(
            fontSize: TXT_SIZE_LARGE(context),
            fontWeight: FontWeight.bold,
            color: Color(0xff808080),
            height: 26 / 16,
          ),
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
