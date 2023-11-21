import 'package:ebps/constants/colors.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:ebps/presentation/common/Container/Home/BillerDetailsContainer.dart';
import 'package:ebps/presentation/screens/otp/OtpScreen.dart';
import 'package:flutter/material.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Container(
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
                              "Payment Details",
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
                      BillerDetailsContainer(
                        icon: '',
                        billerName: '',
                        categoryName: '',
                      ),
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
                      Divider(
                        height: 10,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff808080),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "₹ 650.00",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1b438b),
                              ),
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Text(
                  "Select Payment Account",
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1b438b),
                    height: 23 / 14,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 2,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                  child: Text(
                                    "1006983669872341",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff808080),
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                  child: Text(
                                    "Balance Amount",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff808080),
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                  child: Text(
                                    "₹ 35000",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff0e2146),
                                    ),
                                    textAlign: TextAlign.left,
                                  ))
                            ],
                          ));
                    }),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: MyAppButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OtpScreen()));
                      },
                      buttonText: "Proceed to Pay",
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
