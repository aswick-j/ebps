import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateDialog extends StatefulWidget {
  final Function(String) onDateSelected;
  String? defaultDate;

  DateDialog({super.key, required this.onDateSelected, this.defaultDate});

  @override
  _DateDialogState createState() => _DateDialogState();
}

class _DateDialogState extends State<DateDialog> {
  late String selectedDate;

  @override
  void initState() {
    selectedDate = widget.defaultDate.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.CLR_BACKGROUND,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0.r))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            width: double.infinity,
            // height: height(context) * 0.,
            margin: EdgeInsets.only(
                left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
            decoration: BoxDecoration(
              color: AppColors.TXT_CLR_PRIMARY,
              borderRadius: BorderRadius.circular(6.0.r + 2.r),
              border: Border.all(
                color: AppColors.CLR_CON_BORDER,
                width: 0.50,
              ),
            ),
            padding: EdgeInsets.all(12.0.r),
            child: Center(
              child: Text(
                'Select Date',
                style: TextStyle(
                  color: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0).r,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedDate = '${index + 1}';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedDate == '${index + 1}'
                          ? AppColors.TXT_CLR_PRIMARY
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.CLR_CON_BORDER,
                        width: 0.50,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: selectedDate == '${index + 1}'
                              ? AppColors.BTN_CLR_ACTIVE_ALTER_TEXT
                              : AppColors.TXT_CLR_PRIMARY,
                          fontSize: 14.0.sp,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            color: AppColors.CLR_DIVIDER_LITE,
            height: 10.0,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: MyAppButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      buttonText: "Cancel",
                      buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT_C,
                      buttonBorderColor: AppColors.BTN_CLR_ACTIVE_BORDER,
                      buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER_C,
                      buttonSizeX: 8.h,
                      buttonSizeY: 35.w,
                      buttonTextSize: 12.sp,
                      buttonTextWeight: FontWeight.w500),
                ),
                SizedBox(width: 10.w),
                Align(
                  alignment: Alignment.center,
                  child: MyAppButton(
                      onPressed: () {
                        widget.onDateSelected(selectedDate);
                        Navigator.of(context).pop();
                      },
                      buttonText: "Okay",
                      buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
                      buttonSizeX: 8.h,
                      buttonSizeY: 35.w,
                      buttonTextSize: 12.sp,
                      buttonTextWeight: FontWeight.w500),
                ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: Text(
                //     "Cancel",
                //     style: TextStyle(
                //       fontSize: 12.0,
                //       fontWeight: FontWeight.w400,
                //       color: Color(0xff1b438b),
                //     ),
                //     textAlign: TextAlign.left,
                //   ),
                // ),
                // SizedBox(
                //   width: 20.0,
                // ),
                // TextButton(
                //   onPressed: () {
                //     widget.onDateSelected(selectedDate);
                //     Navigator.of(context).pop();
                //   },
                //   child: Text(
                //     "Ok",
                //     style: TextStyle(
                //       fontSize: 12.0,
                //       fontWeight: FontWeight.w400,
                //       color: Color(0xff1b438b),
                //     ),
                //     textAlign: TextAlign.left,
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
