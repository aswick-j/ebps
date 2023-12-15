import 'package:ebps/shared/common/Text/MyAppText.dart';
import 'package:ebps/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

MyAppBar({
  @required context,
  @required title,
  List<Widget>? actions,
  backgroundColor,
  onLeadingTap,
  showActions,
  onSearchTap,
}) {
  return AppBar(
    title: MyAppText(
        data: title, color: CLR_PRIMARY, weight: FontWeight.bold, maxline: 1),
    toolbarHeight: 62.0.h,
    backgroundColor: Colors.white,
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
