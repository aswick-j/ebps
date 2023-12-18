import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController!, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return Container(
          width: 50.0.w,
          height: 25.0.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0.r),
            border: Border.all(
              color: CLR_PRIMARY,
              width: 2.0,
            ),
            color: _circleAnimation!.value == Alignment.centerLeft
                ? CLR_PRIMARY
                : Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 2.0.h, bottom: 2.0.w, right: 2.0.w, left: 2.0.w),
            child: Container(
              alignment: widget.value
                  ? ((Directionality.of(context) == TextDirection.rtl)
                      ? Alignment.centerRight
                      : Alignment.centerLeft)
                  : ((Directionality.of(context) == TextDirection.rtl)
                      ? Alignment.centerLeft
                      : Alignment.centerRight),
              child: Container(
                width: 20.0.w,
                height: 20.0.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _circleAnimation!.value == Alignment.centerLeft
                        ? Colors.white
                        : CLR_PRIMARY),
                child: _circleAnimation!.value == Alignment.centerLeft
                    ? Icon(
                        Icons.check,
                        size: 13.r,
                        color: CLR_PRIMARY,
                      )
                    : Icon(Icons.close, size: 13.r, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
