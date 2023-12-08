import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/data/models/account_info_model.dart';
import 'package:ebps/data/models/add_biller_model.dart';
import 'package:ebps/data/models/billers_model.dart';
import 'package:ebps/data/models/confirm_fetch_bill_model.dart';
import 'package:ebps/data/models/saved_biller_model.dart';
import 'package:ebps/helpers/getDecodedAccount.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:ebps/presentation/common/Container/Home/biller_details_container.dart';
import 'package:ebps/presentation/widget/bbps_logo.dart';
import 'package:ebps/presentation/widget/getAccountInfoCard.dart';
import 'package:ebps/presentation/widget/loader_overlay.dart';
import 'package:ebps/presentation/widget/flickr_loader.dart';
import 'package:ebps/presentation/widget/get_biller_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PaymentDetails extends StatefulWidget {
  int? billID;
  String? billerName;
  String? billName;
  String? categoryName;
  bool isSavedBill;
  BillersData? billerData;
  SavedBillersData? savedBillersData;
  String? amount;
  List<AddbillerpayloadModel>? inputParameters;
  List<PARAMETERS>? SavedinputParameters;
  Map<String, dynamic>? validateBill;
  Map<String, dynamic>? billerInputSign;

  PaymentDetails(
      {Key? key,
      required this.billID,
      required this.billerName,
      required this.isSavedBill,
      this.billName,
      this.billerData,
      this.savedBillersData,
      this.inputParameters,
      required this.SavedinputParameters,
      this.categoryName,
      this.amount,
      this.validateBill,
      this.billerInputSign})
      : super(key: key);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  bool isAccLoading = true;
  bool isValidateBillLoading = false;
  bool isFetchbillLoading = false;
  List<AccountsData>? accountInfo = [];
  ConfirmFetchBillData? confirmbillerResData;
  bool _otherAmount = false;
  dynamic selectedAcc = null;

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getAccountInfo(myAccounts);

    super.initState();
  }

  handleSubmit() {
    if (widget.validateBill!["validateBill"]) {
      var billDetail = {};
      billDetail["validateBill"] = widget.validateBill!["validateBill"];
      billDetail["billerID"] = widget.billerData!.bILLERID;
      billDetail["billerParams"] = widget.billerInputSign;
      billDetail["quickPay"] = widget.validateBill!["quickPay"];
      billDetail["quickPayAmount"] = widget.amount.toString();
      billDetail["billName"] = widget.billName;

      Map<String, dynamic> payload = {
        "validateBill": widget.validateBill!["validateBill"],
        "billerID": widget.isSavedBill
            ? widget.billerData!.bILLERID
            : widget.billerData!.bILLERID,
        "billerParams": widget.billerInputSign,
        "quickPay": widget.validateBill!["quickPay"],
        "quickPayAmount": widget.amount.toString(),
        "billName": widget.billName,
      };
      BlocProvider.of<HomeCubit>(context).fetchValidateBill(payload);
    } else if (widget.validateBill!["billerType"] == "instant" ||
        widget.validateBill!["billerType"] == "adhoc" ||
        widget.validateBill!["billerType"] == "billFetch") {
      BlocProvider.of<HomeCubit>(context).confirmFetchBill(
        billerID: widget.isSavedBill
            ? widget.savedBillersData!.bILLERID
            : widget.billerData!.bILLERID,
        quickPay: widget.validateBill!["quickPay"],
        quickPayAmount: widget.amount.toString(),
        adHocBillValidationRefKey: "",
        validateBill: widget.validateBill!["validateBill"],
        billerParams: widget.billerInputSign,
        billName: widget.billName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
          appBar: MyAppBar(
            context: context,
            title: widget.billerName.toString(),
            onLeadingTap: () => Navigator.pop(context),
            showActions: false,
          ),
          body: BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
            if (state is AccountInfoLoading) {
              isAccLoading = true;
            } else if (state is AccountInfoSuccess) {
              accountInfo = state.accountInfo;

              isAccLoading = false;
            } else if (state is AccountInfoFailed) {
              isAccLoading = false;
            } else if (state is AccountInfoError) {}

            if (state is ConfirmFetchBillLoading) {
              LoaderOverlay.of(context).show();

              isFetchbillLoading = true;
            } else if (state is ConfirmFetchBillSuccess) {
              confirmbillerResData = state.ConfirmFetchBillResponse;
              //  _otherAmount = !(!widget.billerData!.pAYMENTEXACTNESS!.isNotEmpty ||
              //             widget.billerData!.pAYMENTEXACTNESS == "Exact" ||
              //             userAmount == billAmount);
              LoaderOverlay.of(context).hide();

              goToData(context, oTPPAGEROUTE, {
                "from": pAYMENTCONFIRMROUTE,
                "templateName": "confirm-payment",
                "data": {
                  "billerID": widget.isSavedBill
                      ? widget.savedBillersData!.bILLERID
                      : widget.billerData!.bILLERID,
                  "billerName": widget.billerName,
                  "billName": widget.billName,
                  "categoryName": widget.categoryName,
                  "acNo": accountInfo![selectedAcc].accountNumber,
                  "billAmount": widget.amount.toString(),
                  "customerBillID": confirmbillerResData!.customerbillId,
                  "tnxRefKey": confirmbillerResData!.txnRefKey,
                  "quickPay": widget.validateBill!["quickPay"],
                  "inputSignature": widget.inputParameters,
                  "SavedinputParameters": widget.SavedinputParameters,
                  "otherAmount": _otherAmount,
                  "autoPayStatus": '',
                  "billerData": widget.billerData,
                  "savedBillersData": widget.savedBillersData
                }
                // goToData(context, mPINROUTE, {
                //   "data": {
                //     "billerID": widget.billerData!.bILLERID,
                //     "billerName": widget.billerData!.bILLERNAME,
                //     "billName": widget.billName,
                //     "categoryName": widget.categoryName,
                //     "acNo": accountInfo![selectedAcc].accountNumber,
                //     "billAmount": widget.amount.toString(),
                //     "customerBillID": confirmbillerResData!.customerbillId,
                //     "tnxRefKey": confirmbillerResData!.txnRefKey,
                //     "quickPay": widget.validateBill!["quickPay"],
                //     "inputSignature": widget.inputParameters,
                //     "otherAmount": _otherAmount,
                //     "autoPayStatus": '',
                //     "billerData": widget.billerData
                //   }
              });
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => OtpScreen()));
              isFetchbillLoading = false;
            } else if (state is ConfirmFetchBillFailed) {
              isFetchbillLoading = false;
            } else if (state is ConfirmFetchBillError) {
              isFetchbillLoading = false;
            }

            if (state is ValidateBillLoading) {
              isValidateBillLoading = true;
            } else if (state is ValidateBillSuccess) {
              isValidateBillLoading = false;
            } else if (state is ValidateBillFailed) {
              isValidateBillLoading = false;
            } else if (state is ValidateBillError) {
              isValidateBillLoading = false;
            }
          }, builder: (context, state) {
            return SingleChildScrollView(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xffffffff),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          BillerDetailsContainer(
                            icon: 'packages/ebps/assets/icon/logo_bbps.svg',
                            billerName: widget.billerName.toString(),
                            categoryName: widget.categoryName.toString(),
                          ),
                          Container(
                              width: double.infinity,
                              height: 75.h,
                              color: Colors.white,
                              child: GridView.count(
                                primary: false,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 10.h,
                                crossAxisCount: 2,
                                childAspectRatio: 4 / 2,
                                mainAxisSpacing: 10.h,
                                children: [
                                  billerDetail(
                                      widget.isSavedBill
                                          ? widget.SavedinputParameters![0]
                                              .pARAMETERNAME
                                          : widget.inputParameters![0]
                                              .pARAMETERNAME,
                                      widget.isSavedBill
                                          ? widget.SavedinputParameters![0]
                                              .pARAMETERVALUE
                                          : widget.inputParameters![0]
                                              .pARAMETERVALUE
                                              .toString(),
                                      context),
                                  billerDetail("Bill Name",
                                      widget.billName.toString(), context),
                                ],
                              )),
                          Divider(
                            height: 10.h,
                            thickness: 1,
                            indent: 10.w,
                            endIndent: 10.w,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0.w, vertical: 15.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Amount",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff808080),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.amount.toString()))}",
                                  // "₹ ${widget.amount}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
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
                    padding: EdgeInsets.only(
                        left: 18.0.w, right: 18.w, top: 18.w, bottom: 18.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Payment Account",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1b438b),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.grey),
                          onPressed: () {
                            BlocProvider.of<HomeCubit>(context)
                                .getAccountInfo(myAccounts);
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isAccLoading)
                    Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        child: FlickrLoader(),
                      ),
                    ),
                  if (!isAccLoading && myAccounts!.length > 0)
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: accountInfo!.length,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4 / 2,
                            mainAxisSpacing: 10.h,
                            // mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return AccountInfoCard(
                              accountNumber:
                                  accountInfo![index].accountNumber.toString(),
                              balance: accountInfo![index].balance.toString(),
                              onAccSelected: (Date) {
                                setState(() {
                                  selectedAcc = index;
                                });
                              },
                              index: index,
                              isSelected: selectedAcc,
                            );
                          }),
                    ),
                  BbpsLogoContainer(
                    showEquitasLogo: false,
                  ),
                ],
              ),
            );
          }),
          bottomSheet: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: MyAppButton(
                        onPressed: () {
                          if (selectedAcc != null) {
                            handleSubmit();
                          }
                        },
                        buttonText: "Proceed to Pay",
                        buttonTxtColor: BTN_CLR_ACTIVE,
                        buttonBorderColor: Colors.transparent,
                        buttonColor:
                            selectedAcc != null ? CLR_PRIMARY : Colors.grey,
                        buttonSizeX: 10.h,
                        buttonSizeY: 40.w,
                        buttonTextSize: 14.sp,
                        buttonTextWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
