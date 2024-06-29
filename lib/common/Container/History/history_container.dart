import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ebps/common/Container/ImageTile.dart';
import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/history_model.dart';
import 'package:ebps/widget/marquee_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryContainer extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String dateText;
  final String? statusText;
  final String amount;
  final String iconPath;
  final Color containerBorderColor;
  HistoryData historyData;
  final void Function(String?, int?) handleStatus;

  HistoryContainer(
      {super.key,
      required this.titleText,
      required this.subtitleText,
      required this.dateText,
      this.statusText,
      required this.amount,
      required this.iconPath,
      required this.containerBorderColor,
      required this.historyData,
      required this.handleStatus});
  var colorizeColors4 = [
    AppColors.TXT_CLR_PRIMARY,
    AppColors.TXT_CLR_PRIMARY,
    AppColors.TXT_CLR_PRIMARY,
    AppColors.TXT_CLR_PRIMARY,
  ];
  var colorizeColors = [
    AppColors.CLR_GREEN,
    Colors.lightGreen,
    Colors.lightGreen,
    AppColors.CLR_GREEN
  ];
  var colorizeColors2 = [
    AppColors.CLR_ERROR,
    AppColors.CLR_ORANGE,
    AppColors.CLR_ORANGE,
    AppColors.CLR_ERROR,
  ];
  var colorizeColors3 = [
    AppColors.CLR_ORANGE,
    AppColors.CLR_ERROR,
    AppColors.CLR_ERROR,
    AppColors.CLR_ORANGE,
  ];
  @override
  Widget build(BuildContext context) {
    handleClick() {
      goToData(context, hISTORYDETAILSROUTE, {
        "billName": historyData.billName ?? "-",
        "billerName": historyData.billerName,
        "categoryName": historyData.categoryName,
        "isSavedBill": false,
        "historyData": historyData,
        "handleStatus": handleStatus
      });
    }

    String capitalizeFirstWord(String value) {
      var result = value[0].toUpperCase();
      for (int i = 1; i < value.length; i++) {
        if (value[i - 1] == " ") {
          result = result + value[i].toUpperCase();
        } else {
          result = result + value[i];
        }
      }
      return result;
    }

    var colorizeTextStyle =
        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: () {
        handleClick();
      },
      child: Container(
        width: double.infinity,
        margin:
            EdgeInsets.only(left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
        decoration: BoxDecoration(
          //   image: titleText == "Auto Pay"
          //       ? DecorationImage(
          //           image: AssetImage(LOGO_BBPS_ASSURED),
          //           fit: BoxFit.contain,
          //           colorFilter: ColorFilter.mode(
          //               Colors.white.withOpacity(0.9), BlendMode.screen))
          //       : null,

          borderRadius: BorderRadius.circular(8.0.r),
          border: Border.all(
            color: containerBorderColor,
            width: 0.50,
          ),
        ),
        child: Column(
          children: [
            // ListTile(
            //   contentPadding: EdgeInsets.only(left: 6.w, right: 6.w, top: 0.h),
            //   leading: Container(
            //     width: 45.w,
            //     child: Padding(
            //       padding: EdgeInsets.all(8.w),
            //       child: SvgPicture.asset(iconPath),
            //     ),
            //   ),
            //   title: Padding(
            //     padding: EdgeInsets.only(bottom: 5.h),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         if (titleText == "Auto Payment")
            //           // AnimatedTextKit(
            //           //   totalRepeatCount: 100,
            //           //   animatedTexts: [
            //           //     ColorizeAnimatedText(
            //           //       'Auto Payment',
            //           //       textStyle: TextStyle(
            //           //         fontSize: 14.sp,
            //           //       ),
            //           //       colors: statusText == "Pending"
            //           //           ? [
            //           //               CLR_ORANGE,
            //           //               CLR_ORANGESHADE,
            //           //             ]
            //           //           : statusText == "Failed"
            //           //               ? [
            //           //                   CLR_ERROR,
            //           //                   CLR_REDSHADE,
            //           //                 ]
            //           //               : [
            //           //                   CLR_GREEN,
            //           //                   CLR_GREENSHADE,
            //           //                 ],
            //           //     ),
            //           //     ColorizeAnimatedText(
            //           //       'Paid to',
            //           //       textStyle: TextStyle(
            //           //           fontSize: 14.sp, fontWeight: FontWeight.bold),
            //           //       colors: statusText == "Pending"
            //           //           ? [
            //           //               CLR_ORANGE,
            //           //               CLR_ORANGESHADE,
            //           //             ]
            //           //           : statusText == "Failed"
            //           //               ? [
            //           //                   CLR_ERROR,
            //           //                   CLR_REDSHADE,
            //           //                 ]
            //           //               : [
            //           //                   CLR_GREEN,
            //           //                   CLR_GREENSHADE,
            //           //                 ],
            //           //     ),
            //           //   ],
            //           //   isRepeatingAnimation: true,
            //           //   onTap: () {},
            //           // ),
            //           if (titleText == "Auto Payment")
            //             // AnimatedTextKit(
            //             //   isRepeatingAnimation: true,
            //             //   animatedTexts: [
            //             //     FadeAnimatedText('do IT!'),
            //             //     FadeAnimatedText('do it RIGHT!!'),
            //             //     FadeAnimatedText('do it RIGHT NOW!!!'),
            //             //   ],
            //             //   onTap: () {
            //             //     print("Tap Event");
            //             //   },
            //             // ),
            //             MyAppText(
            //                 data: titleText,
            //                 size: 14.0.sp,
            //                 color: statusText == "Pending"
            //                     ? CLR_ORANGE
            //                     : statusText == "Failed"
            //                         ? CLR_ERROR
            //                         : CLR_GREEN,
            //                 weight: FontWeight.normal,
            //                 fntStyle: FontStyle.normal),
            //         if (titleText != "Auto Payment")
            //           MyAppText(
            //             data: titleText,
            //             size: 14.0.sp,
            //             color: TXT_CLR_LITE,
            //             weight: FontWeight.w500,
            //           ),
            //         MyAppText(
            //           data: amount,
            //           size: 14.0.sp,
            //           color: CLR_PRIMARY,
            //           weight: FontWeight.bold,
            //         ),
            //       ],
            //     ),
            //   ),
            //   subtitle: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           SizedBox(
            //             width: 220.w,
            //             child: MyAppText(
            //                 data: subtitleText,
            //                 size: 13.0.sp,
            //                 color: TXT_CLR_DEFAULT,
            //                 weight: FontWeight.w500,
            //                 maxline: 1),
            //           )
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            ListTile(
              contentPadding: EdgeInsets.only(
                  left: 8.w, right: 15.w, top: 4.h, bottom: 3.h),
              leading: ImageTileContainer(iconPath: iconPath),

              title: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (titleText == "Auto Payment")
                      AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            "Paid to",
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors4,
                          ),
                          ColorizeAnimatedText(
                            titleText,
                            textStyle: colorizeTextStyle,
                            colors: statusText == "Pending"
                                ? colorizeColors3
                                : statusText == "Failed"
                                    ? colorizeColors2
                                    : colorizeColors,
                          ),
                        ],
                        repeatForever: true,
                        isRepeatingAnimation: true,
                        onTap: () {},
                      ),
                    // MyAppText(
                    //     data: titleText,
                    //     size: 13.0.sp,
                    //     color: statusText == "Pending"
                    //         ? CLR_ORANGE
                    //         : statusText == "Failed"
                    //             ? CLR_ERROR
                    //             : CLR_GREEN,
                    //     weight: FontWeight.bold,
                    //     fntStyle: FontStyle.normal),
                    if (titleText != "Auto Payment")
                      Text(
                        titleText,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.TXT_CLR_PRIMARY,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    MyAppText(
                      data: amount,
                      size: 13.0.sp,
                      color: AppColors.TXT_CLR_PRIMARY,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarqueeWidget(
                    direction: Axis.horizontal,
                    // reverse: true,
                    child: Row(
                      children: [
                        Text(
                          historyData.billName == null
                              ? "NA"
                              : historyData.billName.toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: AppColors.TXT_CLR_SECONDARY,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        if (historyData.customerName != null &&
                            historyData.customerName != "NA")
                          Text(
                            "( ${historyData.customerName.toString()} )",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.CLR_BLUE_LITE,
                            ),
                            textAlign: TextAlign.left,
                          ),
                      ],
                    ),
                  ),
                  // FittedBox(
                  //   fit: BoxFit.contain,
                  //   child: RichText(
                  //     maxLines: 1,
                  //     text: TextSpan(
                  //       style: TextStyle(
                  //         fontSize: 13.0.sp,
                  //         color: Colors.black,
                  //       ),
                  //       children: <TextSpan>[
                  //         TextSpan(
                  //             style: TextStyle(
                  //                 fontSize: 13.sp,
                  //                 color: TXT_CLR_DEFAULT,
                  //                 fontWeight: FontWeight.w500),
                  //             text: "${historyData.billName}  "),
                  //         if (historyData.customerName != null)
                  //           TextSpan(
                  //             text: "( ${historyData.customerName} )",
                  //             recognizer: TapGestureRecognizer()
                  //               ..onTap = () {},
                  //             style: TextStyle(
                  //                 decoration: TextDecoration.none,
                  //                 color: TXT_CLR_PRIMARY,
                  //                 fontSize: 11.sp,
                  //                 fontWeight: FontWeight.w500),
                  //           ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // if (historyData.billName != null ||
                  //     historyData.customerName != null)
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    historyData.billerName.toString(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.TXT_CLR_LITE,
                    ),
                  ),
                ],
              ),
              // trailing: GestureDetector(
              //   onTap: () {

              //     // final state = context.<MybillersCubit>().state;
              //   },
              //   child: SvgPicture.asset(ICON_DELETE),
              // ),
            ),
            Divider(
              color: AppColors.CLR_DIVIDER_LITE,
              height: 1.h,
              thickness: 0.50,
              // indent: 10.w,
              // endIndent: 10.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(ICON_CALENDAR,
                          colorFilter: ColorFilter.mode(
                              AppColors.CLR_PRIMARY_LITE, BlendMode.srcIn)),
                      SizedBox(
                        width: 5.h,
                      ),
                      MyAppText(
                        data: dateText,
                        size: 11.0.sp,
                        color: AppColors.CLR_PRIMARY_LITE,
                        weight: FontWeight.w400,
                      ),
                    ],
                  ),
                  Row(children: [
                    Container(
                        margin: EdgeInsets.all(5.r),
                        // decoration: BoxDecoration(
                        //   shape: BoxShape.circle,
                        //   color: statusText == "PENDING"
                        //       ? CLR_ASTRIX
                        //       : CLR_ERROR,
                        //   border: Border.all(
                        //     color: statusText == "PENDING"
                        //         ? CLR_ASTRIX
                        //         : CLR_ERROR,
                        //     width: 2.0,
                        //   ),
                        // ),
                        child: Container(
                            child: statusText == "Pending"
                                ? Icon(
                                    Icons.hourglass_bottom_outlined,
                                    size: 11.r,
                                    color: Color.fromARGB(255, 218, 124, 47),
                                  )
                                : statusText == "Success"
                                    ? SvgPicture.asset(
                                        ICON_SUCCESS,
                                        height: 10.h,
                                      )
                                    : SvgPicture.asset(ICON_FAILED))),
                    Text(
                      statusText!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: statusText == "Pending"
                            ? Color.fromARGB(255, 218, 124, 47)
                            : statusText == "Success"
                                ? AppColors.CLR_GREEN
                                : AppColors.CLR_ERROR,
                        height: 20 / 12,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      size: 18.r,
                      Icons.arrow_forward_rounded,
                      color: AppColors.CLR_BLUE_LITE,
                    )
                    // IconButton(
                    //   onPressed: () {
                    //     handleClick();
                    //   },
                    //   icon: Icon(Icons.arrow_forward),
                    //   color: TXT_CLR_LITE,
                    // )
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
