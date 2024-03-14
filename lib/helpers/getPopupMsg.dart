// ignore_for_file: unnecessary_string_interpolations

import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final TextStyle boldStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: CLR_PRIMARY,
  fontSize: 15.sp,
);
final TextStyle normalStyle = TextStyle(
  fontWeight: FontWeight.w400,
  color: CLR_PRIMARY,
  fontSize: 15.sp,
);
final TextStyle italicNormalStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: CLR_PRIMARY,
  fontStyle: FontStyle.italic,
  fontSize: 15.sp,
);
TextSpan getPopupSuccessMsg(int index, String BillerName, String BillName) {
  switch (index) {
    case 0:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
          TextSpan(text: " Has Been Deleted Successfully", style: normalStyle),
        ],
      );
    case 1:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "Autopay for ",
            style: normalStyle,
          ),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
          TextSpan(text: " Has Been Created", style: normalStyle),
        ],
      );
    case 2:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Autopay for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
          TextSpan(text: " Has Been Updated", style: normalStyle),
        ],
      );
    case 3:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Autopay for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
          TextSpan(text: " Has Been Deleted", style: normalStyle),
        ],
      );
    case 4:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Autopay for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
          TextSpan(text: " Has Been Paused", style: normalStyle),
        ],
      );
    case 5:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Autopay for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
          TextSpan(text: " Has Been Resumed", style: normalStyle),
        ],
      );
    case 6:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Due Deleted Successfully for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
        ],
      );
    case 7:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Bill Name for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
          TextSpan(text: " Has Been Updated", style: normalStyle),
        ],
      );
    default:
      return TextSpan(text: "Something Went Wrong", style: normalStyle);
  }
}

TextSpan getPopupFailedMsg(int index, String BillerName, String BillName) {
  switch (index) {
    case 0:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
          TextSpan(text: " Has Been Updated", style: normalStyle),
        ],
      );
    case 1:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Autopay Create Failed for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(
              text: "($BillerName)",
              style:
                  italicNormalStyle), // TextSpan(text: "", style: normalStyle),
        ],
      );
    case 2:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Autopay Update Failed for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
        ],
      );
    case 3:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Autopay Delete Failed for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
        ],
      );
    case 4:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Autopay Pause Failed for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
        ],
      );
    case 5:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Autopay Resume Failed for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
        ],
      );
    case 6:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Due Deletion Failed for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
        ],
      );
    case 7:
      return TextSpan(
        children: <TextSpan>[
          TextSpan(text: "Bill Name Update Failed for ", style: normalStyle),
          TextSpan(text: "$BillName ", style: boldStyle),
          TextSpan(text: "($BillerName)", style: italicNormalStyle),
        ],
      );
    default:
      return TextSpan(text: "Something Went Wrong", style: normalStyle);
  }
}
