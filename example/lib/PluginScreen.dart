import 'package:ebps/ebps.dart';
import 'package:flutter/material.dart';

class PluginScreen extends StatefulWidget {
  String apiData;
  String flavor;
  PluginScreen({Key? key, required this.apiData, required this.flavor})
      : super(key: key);

  @override
  State<PluginScreen> createState() => _PluginScreenState();
}

class _PluginScreenState extends State<PluginScreen> {
  @override
  Widget build(BuildContext context) {
    String? apiData = widget.apiData;
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async => false,
          child: Center(
              child: EbpsScreen(
                  apiData: apiData, ctx: context, flavor: widget.flavor))),
    );
  }
}
