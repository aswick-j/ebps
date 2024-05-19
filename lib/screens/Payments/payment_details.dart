import 'dart:ui';

import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/biller_details_container.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getDecodedAccount.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:ebps/models/account_info_model.dart';
import 'package:ebps/models/add_biller_model.dart';
import 'package:ebps/models/bbps_settings_model.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/fetch_bill_model.dart';
import 'package:ebps/models/prepaid_fetch_plans_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/animated_dialog.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/custom_dialog.dart';
import 'package:ebps/widget/loader.dart';
import 'package:ebps/widget/getAccountInfoCard.dart';
import 'package:ebps/widget/get_biller_detail.dart';
import 'package:ebps/widget/loader_overlay.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
  bbpsSettingsData? BbpsSettingInfo;
  List<AddbillerpayloadModel>? inputParameters;
  List<PARAMETERS>? SavedinputParameters;
  Map<String, dynamic>? validateBill;
  Map<String, dynamic>? billerInputSign;
  PrepaidPlansData? planDetails;
  bool otherAmount;
  billerResponseData? fetchBillerResponse;
  String? consumerName;

  PaymentDetails(
      {Key? key,
      required this.billID,
      required this.billerName,
      required this.isSavedBill,
      required this.otherAmount,
      this.billName,
      this.savedBillersData,
      this.billerData,
      this.inputParameters,
      required this.SavedinputParameters,
      required this.BbpsSettingInfo,
      this.categoryName,
      this.consumerName,
      this.amount,
      this.validateBill,
      this.billerInputSign,
      this.fetchBillerResponse,
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
  billerResponseData? fetchbillerResData;
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
            : "",
      };
      BlocProvider.of<HomeCubit>(context).fetchValidateBill(payload);
    } else if (widget.validateBill!["billerType"] == "instant" ||
        widget.validateBill!["billerType"] == "adhoc") {
      BlocProvider.of<HomeCubit>(context).fetchBill(
          billerID: widget.isSavedBill
              ? widget.savedBillersData!.bILLERID
              : widget.billerData!.bILLERID,
          quickPay: widget.validateBill!["quickPay"],
          quickPayAmount: widget.amount.toString(),
          adHocBillValidationRefKey: "",
          validateBill: widget.validateBill!["validateBill"],
          billerParams: widget.billerInputSign,
          billName: widget.billName,
          customerBillId: widget.isSavedBill
              ? widget.savedBillersData!.cUSTOMERBILLID
              : null);
    } else {
      goToData(context, oTPPAGEROUTE, {
        "from": pAYMENTCONFIRMROUTE,
        "templateName": "confirm-payment",
        "context": context,
        "BillerName": widget.billerName,
        "BillName": widget.billName,
        "data": {
          "billerID": widget.isSavedBill
              ? widget.savedBillersData!.bILLERID
              : widget.billerData!.bILLERID,
          "billerName": widget.billerName,
          "billName": widget.billName,
          "categoryName": widget.categoryName,
          "acNo": accountInfo![selectedAcc].accountNumber,
          "billAmount": widget.amount.toString(),
          "customerBillID": widget.fetchBillerResponse!.customerbillId,
          "tnxRefKey": widget.fetchBillerResponse!.txnRefKey,
          "quickPay": widget.validateBill!["quickPay"],
          "inputSignature": widget.inputParameters,
          "SavedinputParameters": widget.SavedinputParameters,
          "otherAmount": widget.otherAmount,
          "autoPayStatus": '',
          "billerData": widget.billerData,
          "savedBillersData": widget.savedBillersData,
          "isSavedBill": widget.isSavedBill
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    handleDialog() {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: CustomDialog(
                actions: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: MyAppButton(
                        onPressed: () {
                          goBack(context);
                        },
                        buttonText: "Okay",
                        buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                        buttonBorderColor: Colors.transparent,
                        buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
                        buttonSizeX: 10.h,
                        buttonSizeY: 40.w,
                        buttonTextSize: 14.sp,
                        buttonTextWeight: FontWeight.w500),
                  ),
                ],
                showActions: true,
                child: AnimatedDialog(
                    showImgIcon: false,
                    title: "Unable to Process Payment",
                    subTitle:
                        "We're sorry.We were unable to process your payment.Please try again later",
                    showSub: true,
                    shapeColor: AppColors.CLR_ERROR,
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                    )),
              ));
        },
      );
    }

    return LoaderOverlay(
      child: Scaffold(
          backgroundColor: AppColors.CLR_BACKGROUND,
          appBar: MyAppBar(
            context: context,
            title: widget.categoryName.toString(),
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
            } else if (state is AccountInfoError) {
              isAccLoading = false;
            }

            if (state is FetchBillLoading) {
              LoaderOverlay.of(context).show();

              isFetchbillLoading = true;
            } else if (state is FetchBillSuccess) {
              fetchbillerResData = state.fetchBillResponse;
              //  _otherAmount = !(!widget.billerData!.pAYMENTEXACTNESS!.isNotEmpty ||
              //             widget.billerData!.pAYMENTEXACTNESS == "Exact" ||
              //             userAmount == billAmount);
              LoaderOverlay.of(context).hide();

              goToData(context, oTPPAGEROUTE, {
                "from": pAYMENTCONFIRMROUTE,
                "templateName": "confirm-payment",
                "context": context,
                "BillerName": widget.billerName,
                "BillName": widget.billName,
                "data": {
                  "billerID": widget.isSavedBill
                      ? widget.savedBillersData!.bILLERID
                      : widget.billerData!.bILLERID,
                  "billerName": widget.billerName,
                  "billName": widget.billName,
                  "categoryName": widget.categoryName,
                  "acNo": accountInfo![selectedAcc].accountNumber,
                  "billAmount": widget.amount.toString(),
                  "customerBillID": fetchbillerResData!.customerbillId,
                  "tnxRefKey": fetchbillerResData!.txnRefKey,
                  "quickPay": widget.validateBill!["quickPay"],
                  "inputSignature": widget.inputParameters,
                  "SavedinputParameters": widget.SavedinputParameters,
                  "otherAmount": widget.otherAmount,
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
              LoaderOverlay.of(context).hide();
            } else if (state is FetchBillFailed) {
              handleDialog();
              LoaderOverlay.of(context).hide();

              isFetchbillLoading = false;
            } else if (state is FetchBillError) {
              handleDialog();
              LoaderOverlay.of(context).hide();

              isFetchbillLoading = false;
            }

            if (state is ValidateBillLoading) {
              logger.d("VALIDATE  API CALLING ===>");

              isValidateBillLoading = true;
              LoaderOverlay.of(context).show();
            } else if (state is ValidateBillSuccess) {
              logger.d("VALIDATE  API SUCCESS ===>");

              BlocProvider.of<HomeCubit>(context).fetchBill(
                billerID: widget.isSavedBill
                    ? widget.savedBillersData!.bILLERID
                    : widget.billerData!.bILLERID,
                quickPay: widget.validateBill!["quickPay"],
                quickPayAmount: widget.amount.toString(),
                adHocBillValidationRefKey: state.bbpsTranlogId,
                validateBill: widget.validateBill!["validateBill"],
                billerParams: widget.billerInputSign,
                billName: widget.billName,
                customerBillId: widget.isSavedBill
                    ? widget.savedBillersData!.cUSTOMERBILLID
                    : null,
                forChannel: (widget.isSavedBill
                        ? widget.savedBillersData!.cATEGORYNAME!
                                .toLowerCase() ==
                            "mobile prepaid"
                        : widget.billerData!.cATEGORYNAME!.toLowerCase() ==
                            "mobile prepaid")
                    ? "Prepaid"
                    : "",
                planId: (widget.isSavedBill
                        ? widget.savedBillersData!.cATEGORYNAME!
                                .toLowerCase() ==
                            "mobile prepaid"
                        : widget.billerData!.cATEGORYNAME!.toLowerCase() ==
                            "mobile prepaid")
                    ? widget.planDetails!.billerPlanId
                    : "",
                planType: "CURATED",
                // planType: widget.planDetails!.planAdditionalInfo!.Type,
                supportPlan: "MANDATORY",
              );
              isValidateBillLoading = false;
              LoaderOverlay.of(context).hide();
            } else if (state is ValidateBillFailed) {
              handleDialog();
              isValidateBillLoading = false;
              LoaderOverlay.of(context).hide();
            } else if (state is ValidateBillError) {
              handleDialog();

              isValidateBillLoading = false;
              LoaderOverlay.of(context).hide();
            }
          }, builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableContainer(
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
                              AppColors.CLR_GRD_1.withOpacity(.7),
                              AppColors.CLR_GRD_2.withOpacity(.7),
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
                        title: widget.billerName.toString(),
                        subTitle: widget.isSavedBill
                            ? widget.savedBillersData!.bILLERCOVERAGE.toString()
                            : widget.billerData!.bILLERCOVERAGE.toString(),
                      ),
                      if (widget.SavedinputParameters != null ||
                          widget.inputParameters != null)
                        Container(
                            width: double.infinity,
                            // constraints: BoxConstraints(
                            //   minHeight: 80.h,
                            //   maxHeight: 300.h,
                            // ),
                            // height: 0.h,
                            // color: Colors.white,
                            child: Column(
                              // crossAxisSpacing: 10.h,
                              // crossAxisCount: 2,
                              // childAspectRatio: 4 / 2,
                              // mainAxisSpacing: 10.h,
                              children: [
                                billerdetail(
                                    widget.isSavedBill
                                        ? widget.categoryName.toString().toLowerCase() ==
                                                "mobile prepaid"
                                            ? "Mobile Number"
                                            : widget.SavedinputParameters![0]
                                                .pARAMETERNAME
                                        : widget.categoryName.toString().toLowerCase() ==
                                                "mobile prepaid"
                                            ? "Mobile Number"
                                            : widget.inputParameters![0]
                                                .pARAMETERNAME,
                                    widget.isSavedBill
                                        ? widget.categoryName.toString().toLowerCase() ==
                                                "mobile prepaid"
                                            ? widget.SavedinputParameters!
                                                .firstWhere((params) => params.pARAMETERNAME == null
                                                    ? params.pARAMETERNAME ==
                                                        null
                                                    : params.pARAMETERNAME.toString().toLowerCase() ==
                                                            "mobile number" ||
                                                        params.pARAMETERNAME
                                                                .toString()
                                                                .toLowerCase() ==
                                                            "customer mobile number")
                                                .pARAMETERVALUE
                                                .toString()
                                            : widget.SavedinputParameters![0]
                                                .pARAMETERVALUE
                                        : widget.categoryName.toString().toLowerCase() ==
                                                "mobile prepaid"
                                            ? widget.inputParameters!
                                                .firstWhere((params) => params.pARAMETERNAME == null
                                                    ? params.pARAMETERNAME == null
                                                    : params.pARAMETERNAME.toString().toLowerCase() == "mobile number" || params.pARAMETERNAME.toString().toLowerCase() == "customer mobile number")
                                                .pARAMETERVALUE
                                                .toString()
                                            : widget.inputParameters![0].pARAMETERVALUE.toString(),
                                    context),
                                billerdetail("Bill Name",
                                    widget.billName.toString(), context),
                                if (widget.consumerName != null)
                                  billerdetail("Consumer Name",
                                      widget.consumerName.toString(), context),
                              ],
                            )),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0.h),
                        child: Divider(
                          color: AppColors.CLR_CON_BORDER,
                          height: 0.1.h,
                          thickness: 0.50,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.CLR_PRIMARY_LITE,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.amount.toString()))}",
                              // "₹ ${widget.amount}",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.TXT_CLR_PRIMARY,
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
                        left: 18.0.w, right: 18.w, top: 18.w, bottom: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Payment Account",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.TXT_CLR_PRIMARY,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          child: SvgPicture.asset(ICON_REFRESH),
                          onTap: () {
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
                    Container(
                      height: 100.h,
                      child: Center(child: Loader()),
                    ),
                  if (!isAccLoading)
                    Container(
                      width: double.infinity,
                      // color: Colors.white,
                      child: myAccounts!.isNotEmpty
                          ? Column(
                              children: [
                                GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: accountInfo!.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      // itemCount: accountInfo!.length,
                                      childAspectRatio: 5 / 3.1,
                                      mainAxisSpacing: 10.h,
                                      // mainAxisSpacing: 10,
                                    ),
                                    itemBuilder: (context, index) {
                                      return AccountInfoCard(
                                        showAccDetails: true,
                                        accountNumber: accountInfo![index]
                                            .accountNumber
                                            .toString(),
                                        balance: accountInfo![index].balance,
                                        onAccSelected: (Date) {
                                          setState(() {
                                            selectedAcc = index;
                                          });
                                          if (accountInfo![index].balance ==
                                                  "Unable to fetch balance" ||
                                              double.parse(accountInfo![index]
                                                      .balance
                                                      .toString()) <
                                                  double.parse(widget.amount
                                                      .toString())) {
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
                              ],
                            )
                          : SizedBox(
                              height: 60.h,
                              child: Center(
                                child: Text(
                                  "No Accounts Available",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.CLR_GREY,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 18.0.w, right: 18.w, top: 20.h, bottom: 0.h),
                    decoration: BoxDecoration(
                      color: AppColors.CLR_GREY.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.0.r + 2.r),
                      border: Border.all(
                        color: AppColors.CLR_CON_BORDER,
                        width: 0.50,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                top: 10.h, left: 14.w, bottom: 0.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.TXT_CLR_PRIMARY,
                                  size: 15.r,
                                ),
                                Text(
                                  "  Message from Biller",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.TXT_CLR_PRIMARY,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.h, left: 34.w, bottom: 10.h),
                          child: Text(
                            "It might take upto 72 hours to complete this transaction based on the biller bank availability in case of any network or technical failure.",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.CLR_BLUE_LITE,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          color: AppColors.TXT_CLR_DEFAULT,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.TXT_CLR_DEFAULT,
                                  fontWeight: FontWeight.w500),
                              text: "By continuing, you agree to accept our "),
                          TextSpan(
                            text: "Terms and Conditions.",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                goToData(context, tERMANDCONDITIONSROUTE, {
                                  "BbpsSettingInfo": widget.BbpsSettingInfo
                                });
                              },
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.TXT_CLR_PRIMARY,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
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
                color: AppColors.CLR_BACKGROUND,
                border: Border(
                    top: BorderSide(
                        color: AppColors.CLR_CON_BORDER_LITE, width: 1))),
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
                        buttonTxtColor: selectedAcc != null && !accError
                            ? AppColors.BTN_CLR_ACTIVE_ALTER_TEXT
                            : AppColors.BTN_CLR_DISABLE_TEXT,
                        buttonBorderColor: Colors.transparent,
                        buttonColor: selectedAcc != null && !accError
                            ? AppColors.BTN_CLR_ACTIVE_ALTER
                            : AppColors.BTN_CLR_DISABLE,
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
