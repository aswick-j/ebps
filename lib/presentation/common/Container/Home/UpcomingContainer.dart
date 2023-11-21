import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpcomingDuesContainer extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String dateText;
  final String buttonText;
  final String amount;
  final String iconPath;
  final Color containerBorderColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final FontWeight buttonTextWeight;
  final Color? buttonBorderColor;

  UpcomingDuesContainer({
    required this.titleText,
    required this.subtitleText,
    required this.dateText,
    required this.buttonText,
    required this.amount,
    required this.iconPath,
    required this.containerBorderColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.buttonBorderColor,
    required this.buttonTextWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: containerBorderColor,
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 6, right: 6, top: 6),
            leading: Container(
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(iconPath),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff191919),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SvgPicture.asset(
                      "packages/ebps/assets/icon/icon_refresh.svg"),
                ],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subtitleText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff808080),
                      ),
                    ),
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1b438b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month,
                        color: Color(0xff808080), size: 15),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      dateText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff808080),
                        height: 20 / 12,
                      ),
                    ),
                  ],
                ),
                MyAppButton(
                    onPressed: () {},
                    buttonText: buttonText,
                    buttonTextColor: buttonTextColor,
                    buttonBorderColor: buttonBorderColor,
                    buttonColor: buttonColor,
                    buttonSizeX: 10,
                    buttonSizeY: 27,
                    buttonTextSize: 10,
                    buttonTextWeight: FontWeight.w500),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
