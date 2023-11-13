import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/screens/Payments/TransactionSuccess.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6.0),
                          topLeft: Radius.circular(6.0)),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        height: 40.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            stops: [0.001, 19],
                            colors: [
                              Color(0xff768EB9).withOpacity(.7),
                              Color(0xff463A8D).withOpacity(.7),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "MPIN Verification",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffffffff),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "Enter 4-Digit MPIN",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1b438b),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "MPIN will keep your account secure from unauthorized access. Do not share this PIN with anyone",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff808080),
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ))
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
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TransactionSuccess()));
                    },
                    buttonText: "Verify",
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
