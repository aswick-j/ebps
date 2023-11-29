import 'dart:convert';

import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/constants/sizes.dart';
import 'package:ebps/data/models/add_biller_model.dart';
import 'package:ebps/data/models/billers_model.dart';
import 'package:ebps/data/models/confirm_done_model.dart';
import 'package:ebps/helpers/getBillPaymentDetails.dart';
import 'package:ebps/helpers/getBillerType.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  bool? isSavedBill;
  Map<String, dynamic> billerData;
  String billName;
  String categoryName;
  String billerName;
  List<AddbillerpayloadModel> inputParameters;
  TransactionScreen(
      {super.key,
      required this.billName,
      required this.billerName,
      required this.categoryName,
      required this.isSavedBill,
      required this.billerData,
      required this.inputParameters});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  confirmDoneData? tnxResponse;
  var billData;
  BillersData? billerTypeData;

  Map<String, dynamic>? paymentDetails;
  Map<String, dynamic>? billerTypeResult;

  @override
  void initState() {
    super.initState();
    tnxResponse = confirmDoneData.fromJson(widget.billerData['res']);
    billData = jsonDecode(tnxResponse!.paymentDetails!.tran!.bill.toString());
    billerTypeData = widget.billerData['billerData'];
    billerTypeResult = getBillerType(
        billerTypeData!.fETCHREQUIREMENT,
        billerTypeData!.bILLERACCEPTSADHOC,
        billerTypeData!.sUPPORTBILLVALIDATION,
        billerTypeData!.pAYMENTEXACTNESS);
    paymentDetails = getBillPaymentDetails(tnxResponse!.paymentDetails,
        billerTypeResult!['isAdhoc'], tnxResponse!.equitasTransactionId);
  }

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
                GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: subTitle))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${title} copied to clipboard')));
                      });
                    },
                    child: Icon(Icons.copy, color: Color(0xff1b438b), size: 20))
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
          onLeadingTap: () => goToUntil(context, hOMEROUTE),
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
                              paymentDetails!['success']
                                  ? Color(0xff99DDB4).withOpacity(.7)
                                  : paymentDetails!['bbpsTimeout']
                                      ? Color(0xff99DDB4).withOpacity(.7)
                                      : Color(0xff982F67).withOpacity(.7),
                              paymentDetails!['success']
                                  ? Color(0xff31637D).withOpacity(.7)
                                  : paymentDetails!['bbpsTimeout']
                                      ? Color(0xff31637D).withOpacity(.7)
                                      : Color(0xff463A8D).withOpacity(.7)
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              paymentDetails!['success']
                                  ? "Transaction Details"
                                  : paymentDetails!['bbpsTimeout']
                                      ? "Transaction Pending"
                                      : "Transaction Failure",
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
                                      '₹ ${widget.billerData['billAmount']}',
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
                                      DateFormat("dd/MM/yy | hh:mm a")
                                          .format(DateTime.now())
                                          .toString(),
                                      // "01/08/2023 | 12:48 PM",
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
                          subTitle:
                              'EQUITAS BANK - ${widget.billerData['acNo']}',
                          clipBoard: false),
                      TxnDetails(
                          title: "Sent To",
                          subTitle: widget.billerName,
                          clipBoard: false),
                      TxnDetails(
                          title: "Payee Note",
                          subTitle: "Nil",
                          clipBoard: false),
                      Divider(
                        height: 10,
                        thickness: 1,
                      ),
                      TxnDetails(
                          title: "From Account",
                          subTitle: widget.billerData['acNo'],
                          clipBoard: false),
                      TxnDetails(
                          title: "Bank Reference Number ",
                          subTitle:
                              tnxResponse!.paymentDetails?.toJson().length !=
                                      null
                                  ? paymentDetails!['txnReferenceId'].toString()
                                  : "-",
                          clipBoard: true),
                      if (paymentDetails!['success'])
                        TxnDetails(
                            title: "Transaction ID",
                            subTitle: tnxResponse!.paymentDetails
                                        ?.toJson()
                                        .length !=
                                    null
                                ? paymentDetails!['txnReferenceId'].toString()
                                : "-",
                            clipBoard: true),
                      if (paymentDetails!['success'])
                        TxnDetails(
                            title: "Payee Note",
                            subTitle: "Nil",
                            clipBoard: false),
                      TxnDetails(
                          title: "Transfer Type",
                          subTitle: "Equitas Digital Banking",
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
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => TransactionScreen()));
                      },
                      buttonText: "Raise For Complaint",
                      buttonTxtColor: BTN_CLR_ACTIVE,
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
