import 'package:ebps/ebps.dart';
import 'package:flutter/material.dart';

class PluginScreen extends StatefulWidget {
  const PluginScreen({super.key});

  @override
  State<PluginScreen> createState() => _PluginScreenState();
}

class _PluginScreenState extends State<PluginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: EbpsScreen()),
    );
  }
}
