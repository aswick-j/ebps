import 'package:ebps/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlickrLoader extends StatelessWidget {
  const FlickrLoader({super.key});

  @override
  Widget build(BuildContext context) {
    // return LoadingAnimationWidget.flickr(
    //   leftDotColor: const Color(0xFF0063DC),
    //   rightDotColor: const Color(0xFFFF0084),
    //   size: 50,
    // );
    return Center(
      child: Image.asset(
        LOADER_V3,
        height: 50.h,
        width: 50.w,
      ),
    );
    // return Center(
    //   child: CircularProgressIndicator(color: CLR_PRIMARY),
    // );
  }
}
