import 'package:ebps/presentation/common/Text/MyAppText.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryContainer extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String dateText;
  final String? statusText;
  final String amount;
  final String iconPath;
  final Color containerBorderColor;

  HistoryContainer({
    required this.titleText,
    required this.subtitleText,
    required this.dateText,
    this.statusText,
    required this.amount,
    required this.iconPath,
    required this.containerBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
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
                padding: EdgeInsets.all(8.0),
                child: SvgPicture.asset(iconPath),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyAppText(
                    data: titleText,
                    size: 14.0,
                    color: TXT_CLR_LITE,
                    weight: FontWeight.w500,
                  ),
                  MyAppText(
                    data: amount,
                    size: 14.0,
                    color: CLR_PRIMARY,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyAppText(
                      data: subtitleText,
                      size: 14.0,
                      color: TXT_CLR_DEFAULT,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 10,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: TXT_CLR_LITE, size: 15),
                    SizedBox(
                      width: 5,
                    ),
                    MyAppText(
                      data: dateText,
                      size: 12.0,
                      color: TXT_CLR_LITE,
                      weight: FontWeight.w400,
                    ),
                  ],
                ),
                InkWell(
                    onTap: () {},
                    child: Row(children: [
                      if (statusText != null)
                        Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusText == "PENDING"
                                  ? CLR_ASTRIX
                                  : CLR_ERROR,
                              border: Border.all(
                                color: statusText == "PENDING"
                                    ? CLR_ASTRIX
                                    : CLR_ERROR,
                                width: 2.0,
                              ),
                            ),
                            child: Container(
                              child: statusText == "PENDING"
                                  ? Icon(Icons.hourglass_bottom_rounded,
                                      size: 10,
                                      color: Color.fromARGB(255, 255, 255, 255))
                                  : Icon(Icons.warning_sharp,
                                      size: 10,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                            )),
                      if (statusText != null)
                        Text(
                          statusText!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusText == "PENDING"
                                ? CLR_ASTRIX
                                : CLR_ERROR,
                            height: 20 / 12,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward,
                        color: TXT_CLR_LITE,
                      )
                    ]))
              ],
            ),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
