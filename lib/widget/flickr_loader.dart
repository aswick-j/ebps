import 'package:ebps/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class FlickrLoader extends StatefulWidget {
  const FlickrLoader({super.key});

  @override
  State<FlickrLoader> createState() => _FlickrLoaderState();
}

class _FlickrLoaderState extends State<FlickrLoader>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    // return Container(
    //   height: 70.h,
    //   width: 70.w,
    //   child: Center(
    //     child: Column(
    //       children: [
    //         Lottie.asset(
    //           COIN_LOADER,
    //           fit: BoxFit.cover,
    //           repeat: true,
    //           onLoaded: (composition) {
    //             _controller
    //               ..duration = composition.duration
    //               ..forward();
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
