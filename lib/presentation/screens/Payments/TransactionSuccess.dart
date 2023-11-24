import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/sizes.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionSuccess extends StatefulWidget {
  const TransactionSuccess({super.key});

  @override
  State<TransactionSuccess> createState() => _TransactionSuccessState();
}

class _TransactionSuccessState extends State<TransactionSuccess> {
  Widget TxnDetails(
      {String title = "", String subTitle = "", bool? clipBoard}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: TXT_SIZE_LARGE(context),
              fontWeight: FontWeight.w400,
              color: Color(0xff808080),
              height: 23 / 14,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: TXT_SIZE_LARGE(context),
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1b438b),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(width: 10),
              if (clipBoard != false)
                Icon(Icons.copy, color: Color(0xff1b438b), size: 20)
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: 'Go to Home',
          onLeadingTap: () => Navigator.pop(context),
          showActions: false,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              Color(0xff99DDB4).withOpacity(.7),
                              Color(0xff31637D).withOpacity(.7),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Transaction Details",
                              style: TextStyle(
                                fontSize: TXT_SIZE_LARGE(context),
                                fontWeight: FontWeight.w600,
                                color: Color(0xffffffff),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.only(left: 30, right: 6, top: 6),
                        // leading: Container(
                        //   width: 50,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: SvgPicture.asset(
                        //         "packages/ebps/assets/icon/icon_jio.svg"),
                        //   ),
                        // ),
                        title: Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color: Colors.red,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "₹ 650.00",
                                      style: TextStyle(
                                        fontSize: TXT_SIZE_XXL(context),
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff1b438b),
                                        height: 33 / 20,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "01/08/2023 | 12:48 PM",
                                      style: TextStyle(
                                        fontSize: TXT_SIZE_LARGE(context),
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff808080),
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        height: 10,
                        thickness: 1,
                      ),
                      TxnDetails(
                          title: "Sent From",
                          subTitle: "PWWECX(1000 2323 1956 67)",
                          clipBoard: false),
                      TxnDetails(
                          title: "Sent To",
                          subTitle: "HDFC BANK - 1065 8777 8765 98",
                          clipBoard: false),
                      TxnDetails(
                          title: "Payee Note",
                          subTitle: "Loream Loream",
                          clipBoard: false),
                      Divider(
                        height: 10,
                        thickness: 1,
                      ),
                      TxnDetails(
                          title: "From Account",
                          subTitle: "1000 8787 13232",
                          clipBoard: false),
                      TxnDetails(
                          title: "Bank Reference Number ",
                          subTitle: "TRAN552045566",
                          clipBoard: true),
                      TxnDetails(
                          title: "Transaction ID",
                          subTitle: "N285230146108657",
                          clipBoard: true),
                      TxnDetails(
                          title: "Payee Note",
                          subTitle: "Loream Loream",
                          clipBoard: false),
                      TxnDetails(
                          title: "Transfer Type",
                          subTitle: "Equitas Mobile Banking",
                          clipBoard: false),
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
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: MyAppButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TransactionSuccess()));
                      },
                      buttonText: "Raise For Complaint",
                      buttonTXT_CLR_DEFAULT: BTN_CLR_ACTIVE,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: CLR_PRIMARY,
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
