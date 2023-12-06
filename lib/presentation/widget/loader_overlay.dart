import 'package:ebps/presentation/widget/flickr_loader.dart';
import 'package:flutter/material.dart';

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
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (_isLoading)
          Center(
            child: Container(height: 200, width: 200, child: FlickrLoader()),
          ),
      ],
    );
  }
}
