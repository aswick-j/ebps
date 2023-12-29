import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedDialog extends StatefulWidget {
  final String title;
  final String subTitle;
  final Widget child;
  final Color shapeColor;
  const AnimatedDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.child,
    required this.shapeColor,
  });

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _containerScaleAnimation;
  late Animation<Offset> _yAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _yAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.23),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _iconScaleAnimation = Tween<double>(
      begin: 7,
      end: 6,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _containerScaleAnimation = Tween<double>(
      begin: 2.0,
      end: 0.4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller
      ..reset()
      ..forward();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: CLR_PRIMARY,
                      ),
                    ),
                    if (widget.title == "Your Payment is Pending")
                      SizedBox(height: 10.h),
                    if (widget.title == "Your Payment is Pending")
                      Text(
                        widget.subTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: CLR_BLUE_LITE,
                        ),
                      ),
                  ],
                ),
              ),
              Positioned.fill(
                child: SlideTransition(
                  position: _yAnimation,
                  child: ScaleTransition(
                    scale: _containerScaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.shapeColor,
                      ),
                      child: ScaleTransition(
                        scale: _iconScaleAnimation,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
