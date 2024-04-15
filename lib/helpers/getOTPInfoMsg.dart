import 'package:ebps/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

final TextStyle normalStyle = TextStyle(
    decoration: TextDecoration.none,
    color: CLR_BLUE_LITE,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500);
final TextStyle boldStyle = TextStyle(
    decoration: TextDecoration.none,
    color: CLR_PRIMARY,
    fontSize: 10.sp,
    fontWeight: FontWeight.bold);
final TextStyle italicNormalStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: CLR_PRIMARY,
  fontStyle: FontStyle.italic,
  fontSize: 10.sp,
);

TextSpan getOTPInfoMsg(
    String otpFor, String Amount, String BillerName, String BillName) {
  print(otpFor);
  switch (otpFor) {
    case "confirm-payment":
      return TextSpan(
        children: <TextSpan>[
          TextSpan(style: normalStyle, text: "OTP to Payment "),
          TextSpan(
            text:
                " ₹ ${NumberFormat('#,##,##0.00').format(double.parse(Amount.toString()))}",
            style: boldStyle,
          ),
          TextSpan(style: normalStyle, text: " for "),
          TextSpan(
            text: BillName,
            style: boldStyle,
          ),
          TextSpan(
            text: " ( ${BillerName} )",
            style: normalStyle,
          ),
        ],
      );
    case "edit-auto-pay":
      return TextSpan(
        children: <TextSpan>[
          TextSpan(style: normalStyle, text: "OTP to Update the Autopay for "),
          TextSpan(
            text: BillName,
            style: boldStyle,
          ),
          TextSpan(
            text: " ( ${BillerName} )",
            style: normalStyle,
          ),
        ],
      );
    case "create-auto-pay":
      return TextSpan(
        children: <TextSpan>[
          TextSpan(style: normalStyle, text: "OTP to Create the Autopay for "),
          TextSpan(
            text: BillName,
            style: boldStyle,
          ),
          TextSpan(
            text: " ( ${BillerName} )",
            style: normalStyle,
          ),
        ],
      );
    case "disable-auto-pay":
      return TextSpan(
        children: <TextSpan>[
          TextSpan(style: normalStyle, text: "OTP to Pause the Autopay for "),
          TextSpan(
            text: BillName,
            style: boldStyle,
          ),
          TextSpan(
            text: " ( ${BillerName} )",
            style: normalStyle,
          ),
        ],
      );
    case "enable-auto-pay":
      return TextSpan(
        children: <TextSpan>[
          TextSpan(style: normalStyle, text: "OTP to Resume the Autopay for "),
          TextSpan(
            text: BillName,
            style: boldStyle,
          ),
          TextSpan(
            text: " ( ${BillerName} )",
            style: normalStyle,
          ),
        ],
      );
    case "delete-biller-otp":
      return TextSpan(
        children: <TextSpan>[
          TextSpan(style: normalStyle, text: "OTP to Delete the Biller "),
          TextSpan(
            text: BillName,
            style: boldStyle,
          ),
          TextSpan(
            text: " ( ${BillerName} )",
            style: normalStyle,
          ),
        ],
      );
    case "delete-auto-pay":
      return TextSpan(
        children: <TextSpan>[
          TextSpan(style: normalStyle, text: "OTP to Delete the Autopay for "),
          TextSpan(
            text: BillName,
            style: boldStyle,
          ),
          TextSpan(
            text: " ( ${BillerName} )",
            style: normalStyle,
          ),
        ],
      );

    default:
      return TextSpan(text: "Something Went Wrong", style: normalStyle);
  }
}
