import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/BillerDetailsContainer.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/screens/BillFlow/BillerDetails.dart';
import 'package:flutter/material.dart';

class BillParameters extends StatefulWidget {
  const BillParameters({super.key});

  @override
  State<BillParameters> createState() => _BillParametersState();
}

class _BillParametersState extends State<BillParameters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Biller Name',
        onLeadingTap: () => Navigator.pop(context),
        showActions: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                clipBehavior: Clip.hardEdge,
                width: double.infinity,
                margin:
                    EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0 + 2),
                  border: Border.all(
                    color: Color(0xffD1D9E8),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BillerDetailsContainer(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Color(0xff1b438b)),
                          fillColor: Color(0xffD1D9E8).withOpacity(0.2),
                          filled: true,
                          // hintStyle: TextStyle(color:  Color(0xff1b438b),
                          // labelStyle: TextStyle(color:  Color(0xff1b438b),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff1B438B)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff1B438B)),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: 'Subscriber Id/Registered Mobile Number',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Enter your registered Mobile no. With Tata Sky or a valid Subscriber ID which starts with 1 nd 10 digits long. To locate your subscriber ID, Press the home button on remote.",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff808080),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Color(0xffD1D9E8).withOpacity(0.2),
                          filled: true,
                          labelStyle: TextStyle(color: Color(0xff1b438b)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff1B438B)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff1B438B)),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: 'Bill Name (Nick Name)',
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: MyAppButton(
                    onPressed: () {},
                    buttonText: "Cancel",
                    buttonTextColor: primaryColor,
                    buttonBorderColor: Colors.transparent,
                    buttonColor: buttonActiveColor,
                    buttonSizeX: 10,
                    buttonSizeY: 40,
                    buttonTextSize: 14,
                    buttonTextWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 40,
              ),
              Expanded(
                child: MyAppButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BillerDetails()));
                    },
                    buttonText: "Confirm",
                    buttonTextColor: buttonActiveColor,
                    buttonBorderColor: Colors.transparent,
                    buttonColor: primaryColor,
                    buttonSizeX: 10,
                    buttonSizeY: 40,
                    buttonTextSize: 14,
                    buttonTextWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
