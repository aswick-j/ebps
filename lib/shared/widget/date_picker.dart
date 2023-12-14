import 'package:ebps/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTime?> DatePicker(BuildContext context, String? fromDate) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: TXT_CLR_PRIMARY,
            onPrimary: Colors.white,
            onSurface: TXT_CLR_PRIMARY,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: TXT_CLR_PRIMARY,
            ),
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    print(pickedDate);
    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
    print(formattedDate);
    return pickedDate;
  } else {
    return null;
  }
}
