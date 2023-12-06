import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MyBillersContainer extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String dateText;
  final String? buttonText;
  final String amount;
  final String iconPath;
  final String? upcomingText;
  final Color? upcomingTXT_CLR_DEFAULT;
  final Color containerBorderColor;
  final Color? buttonColor;
  final Color? buttonTxtColor;
  final FontWeight? buttonTextWeight;
  final Color buttonBorderColor;
  final bool? warningBtn;
  const MyBillersContainer({
    required this.titleText,
    required this.subtitleText,
    required this.dateText,
    this.buttonText,
    required this.amount,
    required this.iconPath,
    this.upcomingText,
    this.upcomingTXT_CLR_DEFAULT,
    required this.containerBorderColor,
    this.buttonColor,
    this.buttonTxtColor,
    required this.buttonBorderColor,
    this.buttonTextWeight,
    this.warningBtn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin:
            EdgeInsets.only(left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0.r),
          border: Border.all(
            color: Color(0xFFD1D9E8),
            width: 2.0,
          ),
        ),
        child: Column(children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 8.w, right: 15.w, top: 4.h),
            leading: Container(
              width: 45.w,
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(iconPath),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: Text(
                titleText,
                style: TextStyle(
                  fontSize: 14.sp,
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
                    fontSize: 14.sp,
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.0.r),
                      ),
                    ),
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.only(
                                left: 8.w, right: 15.w, top: 4.h),
                            leading: Container(
                              width: 45.w,
                              child: Padding(
                                padding: EdgeInsets.all(8.r),
                                child: SvgPicture.asset(iconPath),
                              ),
                            ),
                            title: Padding(
                              padding: EdgeInsets.only(bottom: 5.h),
                              child: Text(
                                titleText,
                                style: TextStyle(
                                  fontSize: 16.sp,
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
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff808080),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Autopay Enabled",
                                  style: TextStyle(
                                    fontSize: 14.sp,
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
                              height: 1.h,
                              thickness: 1,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 48.0.h, bottom: 16.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyAppButton(
                                    onPressed: () {},
                                    buttonText: "Cancel",
                                    buttonTxtColor: CLR_PRIMARY,
                                    buttonBorderColor: Color(0xff768EB9),
                                    buttonColor: buttonColor,
                                    buttonSizeX: 10.h,
                                    buttonSizeY: 37.w,
                                    buttonTextSize: 14.sp,
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
              padding: EdgeInsets.symmetric(horizontal: 70.0.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    // MyAppButton(
                    //     onPressed: () {
                    //       showModalBottomSheet(
                    //           context: context,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.vertical(
                    //               top: Radius.circular(16.0.r),
                    //             ),
                    //           ),
                    //           builder: (context) {
                    //             return Column(
                    //               mainAxisSize: MainAxisSize.min,
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: <Widget>[
                    //                 ListTile(
                    //                   contentPadding: EdgeInsets.only(
                    //                       left: 8.w, right: 15.w, top: 4.h),
                    //                   leading: Container(
                    //                     width: 45.w,
                    //                     child: Padding(
                    //                       padding: EdgeInsets.all(8.r),
                    //                       child: SvgPicture.asset(iconPath),
                    //                     ),
                    //                   ),
                    //                   title: Padding(
                    //                     padding: EdgeInsets.only(bottom: 5.h),
                    //                     child: Text(
                    //                       titleText,
                    //                       style: TextStyle(
                    //                         fontSize: 16.sp,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Color(0xff191919),
                    //                       ),
                    //                       textAlign: TextAlign.left,
                    //                     ),
                    //                   ),
                    //                   subtitle: Column(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Text(
                    //                         subtitleText,
                    //                         style: TextStyle(
                    //                           fontSize: 14.sp,
                    //                           fontWeight: FontWeight.w400,
                    //                           color: Color(0xff808080),
                    //                         ),
                    //                       ),
                    //                       SizedBox(
                    //                         height: 10.h,
                    //                       ),
                    //                       Text(
                    //                         "Autopay Enabled",
                    //                         style: TextStyle(
                    //                           fontSize: 14.sp,
                    //                           fontWeight: FontWeight.w500,
                    //                           color: Color(0xff00ab44),
                    //                         ),
                    //                         textAlign: TextAlign.center,
                    //                       )
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   decoration: BoxDecoration(
                    //                     boxShadow: [
                    //                       BoxShadow(
                    //                           color:
                    //                               Colors.grey.withOpacity(0.5),
                    //                           spreadRadius: 0.6,
                    //                           blurRadius: 4,
                    //                           offset: Offset(0, 2)),
                    //                     ],
                    //                   ),
                    //                   child: Divider(
                    //                     height: 1.h,
                    //                     thickness: 1,
                    //                     color: Colors.grey.withOpacity(0.1),
                    //                   ),
                    //                 ),
                    //                 SizedBox(
                    //                   height: 10.h,
                    //                 ),
                    //                 ModalText(
                    //                     title: "Last Bill Amount",
                    //                     subTitle: "₹ 500.00",
                    //                     context: context),
                    //                 ModalText(
                    //                     title: "Due Amount",
                    //                     subTitle: "₹ 500.00",
                    //                     context: context),
                    //                 ModalText(
                    //                     title: "Due Date",
                    //                     subTitle: "20/09/2023",
                    //                     context: context),
                    //                 ModalText(
                    //                     title: "Autopay Date",
                    //                     subTitle: "20/09/2023",
                    //                     context: context),
                    //                 ModalText(
                    //                     title: "Debit Account",
                    //                     subTitle: "100766546787",
                    //                     context: context),
                    //                 ModalText(
                    //                     title: "Debit Limit",
                    //                     subTitle: "₹ 500.00",
                    //                     context: context),
                    //                 Padding(
                    //                   padding: EdgeInsets.only(
                    //                       top: 48.0.h, bottom: 16.h),
                    //                   child: Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     children: [
                    //                       MyAppButton(
                    //                           onPressed: () =>
                    //                               Navigator.of(context).pop(),
                    //                           buttonText: "Cancel",
                    //                           buttonTxtColor: CLR_PRIMARY,
                    //                           buttonBorderColor:
                    //                               Color(0xff768EB9),
                    //                           buttonColor: buttonColor,
                    //                           buttonSizeX: 10.h,
                    //                           buttonSizeY: 37.w,
                    //                           buttonTextSize: 14.sp,
                    //                           buttonTextWeight:
                    //                               FontWeight.w500),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             );
                    //           });
                    //     },
                    //     buttonText: buttonText,
                    //     buttonTxtColor: buttonTxtColor,
                    //     buttonBorderColor: buttonBorderColor,
                    //     buttonColor: buttonColor,
                    //     buttonSizeX: 10.h,
                    //     buttonSizeY: 27.w,
                    //     buttonTextSize: 10.sp,
                    //     buttonTextWeight: FontWeight.w500),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.0.w, vertical: 4.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: buttonBorderColor),
                        borderRadius: BorderRadius.circular(12.0.r),
                      ),
                      child: Text(
                        buttonText.toString(),
                        style: TextStyle(
                          color: buttonTxtColor,
                          fontSize: 10.0.sp,
                        ),
                      ),
                    ),

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
            height: 10.h,
            thickness: 1,
            indent: 10.h,
            endIndent: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 6.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(ICON_CALENDAR),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          dateText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff808080),
                            height: 20 / 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    if (upcomingText != null)
                      Text(
                        upcomingText!,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: upcomingTXT_CLR_DEFAULT,
                        ),
                        textAlign: TextAlign.center,
                      )
                  ],
                ),
                Text(
                  "₹ 589.00",
                  style: TextStyle(
                    fontSize: 14.sp,
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

Widget ModalText(
    {String? title, String? subTitle, required BuildContext context}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title!,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff808080),
          ),
          textAlign: TextAlign.left,
        ),
        Text(
          subTitle!,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xff1b438b),
          ),
          textAlign: TextAlign.left,
        )
      ],
    ),
  );
}
