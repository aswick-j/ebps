import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyBillersContainer extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String dateText;
  final String? buttonText;
  final String amount;
  final String iconPath;
  final String? upcomingText;
  final Color? upcomingTextColor;
  final Color containerBorderColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final FontWeight? buttonTextWeight;
  final Color? buttonBorderColor;
  final bool? warningBtn;
  const MyBillersContainer({
    required this.titleText,
    required this.subtitleText,
    required this.dateText,
    this.buttonText,
    required this.amount,
    required this.iconPath,
    this.upcomingText,
    this.upcomingTextColor,
    required this.containerBorderColor,
    this.buttonColor,
    this.buttonTextColor,
    this.buttonBorderColor,
    this.buttonTextWeight,
    this.warningBtn,
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
                style: const TextStyle(
                  fontSize: 14,
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff808080),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                    ),
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.only(
                                left: 16, right: 16, top: 16, bottom: 16),
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
                                style: const TextStyle(
                                  fontSize: 14,
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
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff808080),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Autopay Enabled",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff00ab44),
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.6,
                                    blurRadius: 4,
                                    offset: Offset(0, 2)),
                              ],
                            ),
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 48.0, bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyAppButton(
                                    onPressed: () {},
                                    buttonText: "Cancel",
                                    buttonTextColor: primaryColor,
                                    buttonBorderColor: Color(0xff768EB9),
                                    buttonColor: buttonColor,
                                    buttonSizeX: 10,
                                    buttonSizeY: 37,
                                    buttonTextSize: 14,
                                    buttonTextWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
          if (buttonText != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    MyAppButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.0),
                                ),
                              ),
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 16,
                                          bottom: 16),
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
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff191919),
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subtitleText,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff808080),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Autopay Enabled",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff00ab44),
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.6,
                                              blurRadius: 4,
                                              offset: Offset(0, 2)),
                                        ],
                                      ),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ModalText(
                                        title: "Last Bill Amount",
                                        subTitle: "₹ 500.00"),
                                    ModalText(
                                        title: "Due Amount",
                                        subTitle: "₹ 500.00"),
                                    ModalText(
                                        title: "Due Date",
                                        subTitle: "20/09/2023"),
                                    ModalText(
                                        title: "Autopay Date",
                                        subTitle: "20/09/2023"),
                                    ModalText(
                                        title: "Debit Account",
                                        subTitle: "100766546787"),
                                    ModalText(
                                        title: "Debit Limit",
                                        subTitle: "₹ 500.00"),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 48.0, bottom: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MyAppButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              buttonText: "Cancel",
                                              buttonTextColor: primaryColor,
                                              buttonBorderColor:
                                                  Color(0xff768EB9),
                                              buttonColor: buttonColor,
                                              buttonSizeX: 10,
                                              buttonSizeY: 37,
                                              buttonTextSize: 14,
                                              buttonTextWeight:
                                                  FontWeight.w500),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        buttonText: buttonText,
                        buttonTextColor: buttonTextColor,
                        buttonBorderColor: buttonBorderColor,
                        buttonColor: buttonColor,
                        buttonSizeX: 10,
                        buttonSizeY: 27,
                        buttonTextSize: 10,
                        buttonTextWeight: FontWeight.w500),

                    // InkWell(
                    //     onTap: () => {},
                    //     child: Column(
                    //       children: [
                    //         Container(
                    //             margin: EdgeInsets.all(10),
                    //             decoration: BoxDecoration(
                    //               shape: BoxShape.circle,
                    //               border: Border.all(
                    //                 color: Color(0xffCF1E2F),
                    //                 width: 2.0,
                    //               ),
                    //             ),
                    //             child: Container(
                    //               margin: EdgeInsets.all(3),
                    //               child: Icon(Icons.warning,
                    //                   color: Color(0xffCF1E2F)),
                    //             )),
                    //       ],
                    //     ))
                  ],
                ),
              ),
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
                    Row(
                      children: [
                        Icon(Icons.calendar_month,
                            color: Color(0xff808080), size: 15),
                        SizedBox(
                          width: 5,
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
                    SizedBox(
                      height: 3,
                    ),
                    if (upcomingText != null)
                      Text(
                        upcomingText!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: upcomingTextColor,
                        ),
                        textAlign: TextAlign.center,
                      )
                  ],
                ),
                Text(
                  "₹ 589.00",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1b438b),
                    height: 26 / 16,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
        ]));
  }
}

Widget ModalText({String? title, String? subTitle}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title!,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff808080),
          ),
          textAlign: TextAlign.left,
        ),
        Text(
          subTitle!,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff1b438b),
          ),
          textAlign: TextAlign.left,
        )
      ],
    ),
  );
}
