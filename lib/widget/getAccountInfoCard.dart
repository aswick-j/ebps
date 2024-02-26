import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AccountInfoCard extends StatelessWidget {
  String accountNumber;
  String balance;
  int? isSelected;
  int index;
  bool? AccErr;
  bool? showAccDetails;
  Function onAccSelected;

  AccountInfoCard(
      {super.key,
      required this.accountNumber,
      required this.onAccSelected,
      required this.balance,
      required this.isSelected,
      required this.index,
      this.showAccDetails,
      this.AccErr});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onAccSelected(index);
      },
      child: Stack(
        children: [
          Container(
            height: showAccDetails == true ? null : 40.h,
            clipBehavior: Clip.hardEdge,
            width: double.infinity,
            margin: EdgeInsets.only(
                left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: isSelected == index && AccErr == true
                    ? CLR_ERROR
                    : isSelected == index
                        ? Colors.green
                        : Color(0xffD1D9E8),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0.w, 10.0.h, 0, 0),
                  child: Text(
                    accountNumber,
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected == index && AccErr == true
                          ? CLR_ERROR
                          : isSelected == index
                              ? Colors.green
                              : Color(0xff808080),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (showAccDetails == true)
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0.w, 4.0.h, 0, 0),
                    child: Text(
                      "Balance Amount",
                      style: TextStyle(
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff808080),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (showAccDetails == true)
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0.w, 0, 0, 10.h),
                    child: Text(
                      balance != "Unable to fetch balance"
                          ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(balance))}"
                          : "-",
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0e2146),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
              ],
            ),
          ),
          if (isSelected == index)
            Positioned(
              top: 0,
              right: 17.w,
              child: CircleAvatar(
                backgroundColor: isSelected == index && AccErr == true
                    ? CLR_ERROR
                    : Colors.green,
                radius: 10.r,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                      isSelected == index && AccErr == true
                          ? Icons.close
                          : Icons.check,
                      size: 15.r),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
        ],
      ),
    );
  }
}
