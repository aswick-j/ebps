import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTime?> DatePicker(
    BuildContext context, String? fromDate, DateTime? toFirstDate) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: toFirstDate ?? DateTime(1900),
    lastDate: DateTime.now(),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.TXT_CLR_PRIMARY,
            onPrimary: AppColors.CLR_BACKGROUND,
            onSurface: AppColors.TXT_CLR_PRIMARY,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.TXT_CLR_PRIMARY,
            ),
          ),
          dialogBackgroundColor: AppColors.CLR_BACKGROUND,
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
    return pickedDate;
  } else {
    return null;
  }
}
