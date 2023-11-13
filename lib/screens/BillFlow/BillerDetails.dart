import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/BillerDetailsContainer.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/screens/Payments/PaymentDetails.dart';
import 'package:flutter/material.dart';

class BillerDetails extends StatefulWidget {
  const BillerDetails({super.key});

  @override
  State<BillerDetails> createState() => _BillerDetailsState();
}

class _BillerDetailsState extends State<BillerDetails> {
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
                  margin: EdgeInsets.only(
                      left: 20.0, right: 20, top: 20, bottom: 0),
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
                      Container(
                        width: double.infinity,
                        height: 80,
                        color: Colors.white,
                        child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: 2,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              // mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              print(index);
                              return Container(
                                  // margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 10, 0, 0),
                                          child: Text(
                                            "Subscriber ID",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff808080),
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 10, 0, 0),
                                          child: Text(
                                            "1155552343",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff1b438b),
                                            ),
                                            textAlign: TextAlign.left,
                                          ))
                                    ],
                                  ));
                            }),
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
                            labelText: 'Amount',
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
                            builder: (context) => PaymentDetails()));
                      },
                      buttonText: "Pay Now",
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
        ));
  }
}
