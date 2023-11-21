import 'package:ebps/ebps.dart';
import 'package:flutter/material.dart';

class PluginScreen extends StatefulWidget {
  String apiData;
  PluginScreen({Key? key, required this.apiData}) : super(key: key);

  @override
  State<PluginScreen> createState() => _PluginScreenState();
}

class _PluginScreenState extends State<PluginScreen> {
  @override
  Widget build(BuildContext context) {
    String? apiData = widget.apiData;
    return Scaffold(
      body: Center(child: EbpsScreen(apiData: apiData)),
    );
  }
}
