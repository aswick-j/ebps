import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AccountInfoCard extends StatelessWidget {
  String accountNumber;
  dynamic balance;
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
                        ? AppColors.CLR_GREEN
                        : AppColors.CLR_CON_BORDER,
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
                          ? AppColors.CLR_ERROR
                          : isSelected == index
                              ? AppColors.CLR_GREEN
                              : AppColors.TXT_CLR_GREY,
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
                        color: AppColors.TXT_CLR_LITE_V3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (showAccDetails == true)
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0.w, 5.h, 5.w, 9.h),
                    child: FittedBox(
                      child: Text(
                        balance.runtimeType == double ||
                                balance.runtimeType == int
                            ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(balance.toString()))}"
                            : balance.toString(),
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          fontWeight: FontWeight.w600,
                          color: AccErr == true &&
                                  isSelected == index &&
                                  (balance.runtimeType != double ||
                                      balance.runtimeType == int)
                              ? AppColors.CLR_ERROR
                              : AppColors.TXT_CLR_PRIMARY,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
          ),
          if (isSelected == index &&
              AccErr == true &&
              balance != "Unable to fetch balance")
            Positioned(
              top: 70.h,
              left: 20.w,
              right: 0.w,
              child: Padding(
                padding: EdgeInsets.only(left: 0.w, top: 10.h, right: 10.w),
                child: SizedBox(
                  height: 10.h,
                  width: 200.w,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Insufficient balance in the account',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.CLR_ERROR,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (isSelected == index)
            Positioned(
              top: 0,
              right: 17.w,
              child: CircleAvatar(
                backgroundColor: isSelected == index && AccErr == true
                    ? AppColors.CLR_ERROR
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
