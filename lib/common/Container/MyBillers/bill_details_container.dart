import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class billDetailsContainer extends StatefulWidget {
  String title;
  String subTitle;
  billDetailsContainer(
      {super.key, required this.title, required this.subTitle});

  @override
  State<billDetailsContainer> createState() => _billDetailsContainerState();
}

class _billDetailsContainerState extends State<billDetailsContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff808080),
              height: 23 / 14,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Text(
                widget.subTitle,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1b438b),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(width: 10.w),
            ],
          )
        ],
      ),
    );
  }
}
