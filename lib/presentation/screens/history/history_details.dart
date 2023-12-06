import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/data/models/billers_model.dart';
import 'package:ebps/data/models/confirm_done_model.dart';
import 'package:ebps/data/models/history_model.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryDetails extends StatefulWidget {
  bool? isSavedBill;
  String billName;
  String categoryName;
  String billerName;
  HistoryData historyData;
  HistoryDetails({
    super.key,
    required this.billName,
    required this.billerName,
    required this.categoryName,
    required this.isSavedBill,
    required this.historyData,
  });

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  confirmDoneData? tnxResponse;
  var billData;
  BillersData? billerTypeData;

  Map<String, dynamic>? paymentDetails;
  Map<String, dynamic>? billerTypeResult;

  @override
  void initState() {
    super.initState();
  }

  Widget TxnDetails(
      {String title = "", String subTitle = "", bool? clipBoard}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff808080),
              height: 23 / 14,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1b438b),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(width: 10.w),
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
          title: 'Payment Details',
          onLeadingTap: () => {
            goBack(context),
          },
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
                      left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0.r + 2.r),
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
                        height: 33.0.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            stops: [0.001, 19],
                            colors: [
                              widget.historyData.tRANSACTIONSTATUS == 'success'
                                  ? Color(0xff99DDB4).withOpacity(.7)
                                  : widget.historyData.tRANSACTIONSTATUS ==
                                          'bbpsTimeout'
                                      ? Color(0xff99DDB4).withOpacity(.7)
                                      : Color(0xff982F67).withOpacity(.7),
                              widget.historyData.tRANSACTIONSTATUS == 'success'
                                  ? Color(0xff31637D).withOpacity(.7)
                                  : widget.historyData.tRANSACTIONSTATUS ==
                                          'bbpsTimeout'
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
                              widget.historyData.tRANSACTIONSTATUS == 'success'
                                  ? "Transaction Details"
                                  : widget.historyData.tRANSACTIONSTATUS ==
                                          'bbpsTimeout'
                                      ? "Transaction Pending"
                                      : "Transaction Failure",
                              style: TextStyle(
                                fontSize: 16.sp,
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
                            EdgeInsets.only(left: 30.w, right: 6.w, top: 6.h),
                        // leading: Container(
                        //   width: 50,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: SvgPicture.asset(
                        //         "packages/ebps/assets/icon/icon_jio.svg"),
                        //   ),
                        // ),
                        title: Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_upward,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      '₹ ${widget.historyData.bILLAMOUNT}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff1b438b),
                                        height: 33 / 20,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  // DateFormat("dd/MM/yy | hh:mm a")
                                  //     .format(widget.historyData.cOMPLETIONDATE)
                                  //     .toString(),
                                  widget.historyData.cOMPLETIONDATE.toString(),
                                  // "01/08/2023 | 12:48 PM",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff808080),
                                  ),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            )),
                      ),
                      Divider(
                        height: 10.h,
                        thickness: 1,
                      ),
                      TxnDetails(
                          title: "Sent From",
                          subTitle:
                              'EQUITAS BANK - ${widget.historyData.aCCOUNTNUMBER.toString()}',
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
                          subTitle: widget.historyData.aCCOUNTNUMBER.toString(),
                          clipBoard: false),
                      TxnDetails(
                          title: "Bank Reference Number ",
                          subTitle: widget.historyData.tRANSACTIONID.toString(),
                          clipBoard: true),
                      if (widget.historyData.tRANSACTIONSTATUS == 'success')
                        TxnDetails(
                            title: "Transaction ID",
                            subTitle: widget.historyData.tRANSACTIONREFERENCEID
                                .toString(),
                            clipBoard: true),
                      if (widget.historyData.tRANSACTIONSTATUS == 'success')
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
              SizedBox(
                height: 70.h,
              )
            ],
          ),
        ),
        bottomSheet: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: MyAppButton(
                      onPressed: () {
                        goToData(context, cOMPLAINTREGISTERROUTE,
                            {"historyData": widget.historyData});
                      },
                      buttonText: "Raise For Complaint",
                      buttonTxtColor: BTN_CLR_ACTIVE,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: CLR_PRIMARY,
                      buttonSizeX: 10.h,
                      buttonSizeY: 40.w,
                      buttonTextSize: 14.sp,
                      buttonTextWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ));
  }
}
