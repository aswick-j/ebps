import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/biller_details_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getDecodedAccount.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:ebps/models/account_info_model.dart';
import 'package:ebps/models/add_biller_model.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/confirm_fetch_bill_model.dart';
import 'package:ebps/models/prepaid_fetch_plans_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/centralized_grid_view.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:ebps/widget/getAccountInfoCard.dart';
import 'package:ebps/widget/get_biller_detail.dart';
import 'package:ebps/widget/loader_overlay.dart';
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
  PrepaidPlansData? planDetails;
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
      this.billerInputSign,
      this.planDetails})
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
  final bool _otherAmount = false;
  dynamic selectedAcc;
  bool accError = false;

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getAccountInfo(myAccounts);

    super.initState();
  }

  handleSubmit() {
    if (widget.validateBill!["validateBill"]) {
      // var billDetail = {};
      // billDetail["validateBill"] = widget.validateBill!["validateBill"];
      // billDetail["billerID"] = widget.billerData!.bILLERID;
      // billDetail["billerParams"] = widget.billerInputSign;
      // billDetail["quickPay"] = widget.validateBill!["quickPay"];
      // billDetail["quickPayAmount"] = widget.amount.toString();
      // billDetail["billName"] = widget.billName;

      Map<String, dynamic> payload = {
        "validateBill": (widget.isSavedBill
                ? widget.savedBillersData!.cATEGORYNAME!.toLowerCase() ==
                    "mobile prepaid"
                : widget.billerData!.cATEGORYNAME!.toLowerCase() ==
                    "mobile prepaid")
            ? true
            : widget.validateBill!["validateBill"],
        "billerID": widget.isSavedBill
            ? widget.savedBillersData!.bILLERID
            : widget.billerData!.bILLERID,
        "billerParams": widget.billerInputSign,
        "quickPay": (widget.isSavedBill
                ? widget.savedBillersData!.cATEGORYNAME!.toLowerCase() ==
                    "mobile prepaid"
                : widget.billerData!.cATEGORYNAME!.toLowerCase() ==
                    "mobile prepaid")
            ? false
            : widget.validateBill!["quickPay"],
        "quickPayAmount": widget.amount.toString(),
        "billName": widget.billName,
        "forChannel": (widget.isSavedBill
                ? widget.savedBillersData!.cATEGORYNAME!.toLowerCase() ==
                    "mobile prepaid"
                : widget.billerData!.cATEGORYNAME!.toLowerCase() ==
                    "mobile prepaid")
            ? "prepaid"
            : ""
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
                "context": context,
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
                  "savedBillersData": widget.savedBillersData,
                  "isSavedBill": widget.isSavedBill
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
              logger.d("VALIDATE  API CALLING ===>");

              isValidateBillLoading = true;
              LoaderOverlay.of(context).show();
            } else if (state is ValidateBillSuccess) {
              logger.d("VALIDATE  API SUCCESS ===>");
              //   "validateBill": false,
              // "billerID": widget.isSavedBill
              //     ? widget.savedBillerData!.bILLERID
              //     : widget.billerID,
              // "billerParams": widget.billerParams,
              // "quickPay": widget.validate_bill!["quickPay"],
              // "quickPayAmount": txtAmountController.text,
              // "forChannel": "prepaid",
              // "adHocBillValidationRefKey": state.bbpsTranlogId,
              // "planid": widget.selectedPrepaidPlan!.billerPlanId,
              // "supportplan": "MANDATORY",
              // "plantype": widget.selectedPrepaidPlan!.planAdditionalInfo!.Type

              BlocProvider.of<HomeCubit>(context).confirmFetchBill(
                billerID: widget.isSavedBill
                    ? widget.savedBillersData!.bILLERID
                    : widget.billerData!.bILLERID,
                quickPay: widget.validateBill!["quickPay"],
                quickPayAmount: widget.amount.toString(),
                adHocBillValidationRefKey: state.bbpsTranlogId,
                validateBill: widget.validateBill!["validateBill"],
                billerParams: widget.billerInputSign,
                billName: widget.billName,
                forChannel: (widget.isSavedBill
                        ? widget.savedBillersData!.cATEGORYNAME!
                                .toLowerCase() ==
                            "mobile prepaid"
                        : widget.billerData!.cATEGORYNAME!.toLowerCase() ==
                            "mobile prepaid")
                    ? "Prepaid"
                    : "",
                planId: widget.planDetails!.billerPlanId,
                planType: "CURATED",
                // planType: widget.planDetails!.planAdditionalInfo!.Type,
                supportPlan: "MANDATORY",
              );
              isValidateBillLoading = false;
              LoaderOverlay.of(context).hide();
            } else if (state is ValidateBillFailed) {
              isValidateBillLoading = false;
              LoaderOverlay.of(context).hide();
            } else if (state is ValidateBillError) {
              isValidateBillLoading = false;
              LoaderOverlay.of(context).hide();
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
                                stops: const [0.001, 19],
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
                            icon: BILLER_LOGO(widget.billerName.toString()),
                            billerName: widget.billerName.toString(),
                            categoryName: widget.categoryName.toString(),
                          ),
                          if (widget.SavedinputParameters != null ||
                              widget.inputParameters != null)
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
                            setState(() {
                              selectedAcc = null;
                              accError = false;
                            });
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
                        height: 100.h,
                        child: FlickrLoader(),
                      ),
                    ),
                  if (!isAccLoading && myAccounts!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          GridView.builder(
                              shrinkWrap: true,
                              itemCount: accountInfo!.length,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                // itemCount: accountInfo!.length,

                                childAspectRatio: 4 / 2,
                                mainAxisSpacing: 10.h,
                                // mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return AccountInfoCard(
                                  accountNumber: accountInfo![index]
                                      .accountNumber
                                      .toString(),
                                  balance:
                                      accountInfo![index].balance.toString(),
                                  onAccSelected: (Date) {
                                    setState(() {
                                      selectedAcc = index;
                                    });
                                    if (accountInfo![index].balance ==
                                            "Unable to fetch balance" ||
                                        double.parse(accountInfo![index]
                                                .balance
                                                .toString()) <
                                            double.parse(
                                                widget.amount.toString())) {
                                      setState(() {
                                        accError = true;
                                      });
                                    } else {
                                      setState(() {
                                        accError = false;
                                      });
                                    }
                                  },
                                  AccErr: accError,
                                  index: index,
                                  isSelected: selectedAcc,
                                );
                              }),
                          if (accError)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.w, top: 10.h, right: 20.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Insufficient balance in the account',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: CLR_ERROR,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  BbpsLogoContainer(
                    showEquitasLogo: false,
                  ),
                  SizedBox(
                    height: 80.h,
                  )
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
                          if (selectedAcc != null && !accError) {
                            handleSubmit();
                          }
                        },
                        buttonText: "Proceed to Pay",
                        buttonTxtColor: BTN_CLR_ACTIVE,
                        buttonBorderColor: Colors.transparent,
                        buttonColor: selectedAcc != null && !accError
                            ? CLR_PRIMARY
                            : Colors.grey,
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
