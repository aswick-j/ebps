import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

MyAppBar(
    {@required context,
    @required title,
    List<Widget>? actions,
    backgroundColor,
    onLeadingTap,
    showActions,
    onSearchTap,
    FormField}) {
  return AppBar(
    title: FormField == true
        ? title
        : MyAppText(
            data: title,
            color: AppColors.CLR_PRIMARY,
            weight: FontWeight.bold,
            maxline: 1),
    toolbarHeight: 62.0.h,
    backgroundColor: AppColors.CLR_BACKGROUND,
    elevation: 0.0,
    leading: IconButton(
      onPressed: onLeadingTap ?? () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back,
        size: 30.46.r,
        color: CLR_GREY,
      ),
    ),
    actions: showActions ? actions : null,
  );
}
