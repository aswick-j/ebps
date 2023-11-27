import 'package:ebps/presentation/common/Text/MyAppText.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';

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
    toolbarHeight: 80.0,
    backgroundColor: Colors.white,
    elevation: 0.0,
    leading: IconButton(
      onPressed: onLeadingTap ?? () => Navigator.pop(context),
      icon: const Icon(
        Icons.arrow_back,
        size: 30.46,
        color: CLR_GREY,
      ),
    ),
    actions: showActions ? actions : null,
  );
}
