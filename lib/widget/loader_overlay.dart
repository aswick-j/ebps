import 'package:ebps/constants/colors.dart';
import 'package:ebps/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoaderOverlay extends StatefulWidget {
  const LoaderOverlay({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static _LoaderOverlayState of(BuildContext context) {
    return context.findAncestorStateOfType<_LoaderOverlayState>()!;
  }

  @override
  State<LoaderOverlay> createState() => _LoaderOverlayState();
}

class _LoaderOverlayState extends State<LoaderOverlay> {
  bool _isLoading = false;

  void show() {
    setState(() {
      _isLoading = true;
    });
  }

  void hide() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isLoading)
          Opacity(
            opacity: 0.8,
            child: ModalBarrier(
                dismissible: false, color: AppColors.TXT_CLR_DEFAULT_LOADER),
          ),
        if (_isLoading)
          Center(
            child: Container(
                height: 200.h, width: 200.w, child: Center(child: Loader())),
          ),
      ],
    );
  }
}
