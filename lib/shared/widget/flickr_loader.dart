import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FlickrLoader extends StatelessWidget {
  const FlickrLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.flickr(
      leftDotColor: const Color(0xFF0063DC),
      rightDotColor: const Color(0xFFFF0084),
      size: 50,
    );
    // return Center(
    //   child: Image.asset(
    //     LOADER,
    //     height: 50.h,
    //     width: 50.w,
    //   ),
    // );
    // return Center(
    //   child: CircularProgressIndicator(color: CLR_PRIMARY),
    // );
  }
}
