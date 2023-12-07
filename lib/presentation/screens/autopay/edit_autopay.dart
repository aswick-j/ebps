import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:flutter/material.dart';

class editAutopay extends StatefulWidget {
  const editAutopay({super.key});

  @override
  State<editAutopay> createState() => _editAutopayState();
}

class _editAutopayState extends State<editAutopay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: "Autopay Edit Biller",
          onLeadingTap: () => goBack(context),
          showActions: false,
        ),
        body: Text("ss"));
  }
}
