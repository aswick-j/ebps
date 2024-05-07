import 'dart:ui';

import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final List<Widget>? actions;
  final bool showActions;

  const CustomDialog(
      {Key? key, required this.child, required this.showActions, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        backgroundColor: AppColors.CLR_BACKGROUND,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(
              color: AppColors.BTN_CLR_ACTIVE_BORDER.withOpacity(0.1)),
        ),
        content: child,
        actions: showActions ? actions : null,
      ),
    );
  }
}
