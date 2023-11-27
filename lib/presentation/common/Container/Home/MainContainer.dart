import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/sizes.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainContainer extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String subtitleText2;
  final String dateText;
  final String buttonText;
  final String amount;
  final String iconPath;
  final Color containerBorderColor;
  final Color buttonColor;
  final Color buttonTXT_CLR_DEFAULT;
  final FontWeight buttonTextWeight;
  final Color? buttonBorderColor;
  const MainContainer({
    required this.titleText,
    required this.subtitleText,
    required this.subtitleText2,
    required this.dateText,
    required this.buttonText,
    required this.amount,
    required this.iconPath,
    required this.containerBorderColor,
    required this.buttonColor,
    required this.buttonTXT_CLR_DEFAULT,
    required this.buttonBorderColor,
    required this.buttonTextWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Color(0xFFD1D9E8),
            width: 2.0,
          ),
        ),
        child: Column(children: [
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
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                titleText,
                style: TextStyle(
                  fontSize: TXT_SIZE_LARGE(context),
                  fontWeight: FontWeight.bold,
                  color: Color(0xff191919),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitleText,
                  style: TextStyle(
                    fontSize: TXT_SIZE_LARGE(context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xff808080),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  subtitleText2,
                  style: TextStyle(
                    fontSize: TXT_SIZE_LARGE(context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xff808080),
                  ),
                ),
              ],
            ),
            trailing: Icon(Icons.delete),
          ),
          Divider(
            height: 10,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: TXT_SIZE_LARGE(context),
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1b438b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(ICON_CALENDAR),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          dateText,
                          style: TextStyle(
                            fontSize: TXT_SIZE_NORMAL(context),
                            fontWeight: FontWeight.w400,
                            color: Color(0xff808080),
                            height: 20 / 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    MyAppButton(
                        onPressed: () {},
                        buttonText: buttonText,
                        buttonTXT_CLR_DEFAULT: buttonTXT_CLR_DEFAULT,
                        buttonBorderColor: buttonBorderColor,
                        buttonColor: buttonColor,
                        buttonSizeX: 10,
                        buttonSizeY: 27,
                        buttonTextSize: 10,
                        buttonTextWeight: FontWeight.w500),
                  ],
                ),
              ],
            ),
          ),
        ]));
  }
}
