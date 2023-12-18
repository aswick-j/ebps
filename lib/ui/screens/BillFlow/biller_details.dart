import 'package:ebps/domain/models/add_biller_model.dart';
import 'package:ebps/domain/models/billers_model.dart';
import 'package:ebps/domain/models/fetch_bill_model.dart';
import 'package:ebps/domain/models/paymentInformationModel.dart';
import 'package:ebps/domain/models/saved_biller_model.dart';
import 'package:ebps/shared/constants/assets.dart';
import 'package:ebps/shared/constants/colors.dart';
import 'package:ebps/shared/constants/routes.dart';

import 'package:ebps/shared/helpers/getAmountExact.dart';
import 'package:ebps/shared/helpers/getBillerType.dart';
import 'package:ebps/shared/helpers/getNavigators.dart';
import 'package:ebps/shared/helpers/logger.dart';
import 'package:ebps/shared/common/AppBar/MyAppBar.dart';
import 'package:ebps/shared/common/Button/MyAppButton.dart';
import 'package:ebps/shared/common/Container/Home/biller_details_container.dart';
import 'package:ebps/shared/widget/centralized_grid_view.dart';
import 'package:ebps/shared/widget/flickr_loader.dart';
import 'package:ebps/shared/widget/get_biller_detail.dart';
import 'package:ebps/shared/widget/no_result.dart';
import 'package:ebps/ui/controllers/bloc/home/home_cubit.dart';
import 'package:ebps/ui/controllers/bloc/myBillers/mybillers_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillerDetails extends StatefulWidget {
  int? billID;
  String? billerName;
  String? billName;
  String? categoryName;
  bool isSavedBill;
  BillersData? billerData;
  SavedBillersData? savedBillersData;
  List<PARAMETERS>? SavedinputParameters;
  List<AddbillerpayloadModel>? inputParameters;

  BillerDetails(
      {Key? key,
      required this.billID,
      required this.billerName,
      required this.isSavedBill,
      this.billName,
      this.billerData,
      this.savedBillersData,
      this.inputParameters,
      this.SavedinputParameters,
      this.categoryName})
      : super(key: key);
  @override
  State<BillerDetails> createState() => _BillerDetailsState();
}

class _BillerDetailsState extends State<BillerDetails> {
  BillerResponse? _billerResponseData;
  int? _customerBIllID;
  int billAmount = 0;
  Map<String, dynamic>? validateBill;
  PaymentInformationData? paymentInform;
  bool isInsufficient = true;

  AdditionalInfo? _additionalInfo;
  Map<String, dynamic> billerInputSign = {};
  final txtAmountController = TextEditingController();

  bool isFetchbillLoading = true;
  bool isPaymentInfoLoading = true;

  bool isUnableToFetchBill = true;

  String PaymentExactErrMsg = "";

  void initialFetch() {
    txtAmountController.text = billAmount.toString();
    if (widget.isSavedBill) {
      setState(() {
        validateBill = getBillerType(
            widget.savedBillersData!.fETCHREQUIREMENT,
            widget.savedBillersData!.bILLERACCEPTSADHOC,
            widget.savedBillersData!.sUPPORTBILLVALIDATION,
            widget.savedBillersData!.pAYMENTEXACTNESS);
      });
    } else {
      setState(() {
        validateBill = getBillerType(
            widget.billerData!.fETCHREQUIREMENT,
            widget.billerData!.bILLERACCEPTSADHOC,
            widget.billerData!.sUPPORTBILLVALIDATION,
            widget.billerData!.pAYMENTEXACTNESS);
      });
    }

    if (widget.isSavedBill) {
      if (widget.SavedinputParameters != null) {
        for (var element in widget.SavedinputParameters!) {
          billerInputSign[element.pARAMETERNAME.toString()] =
              element.pARAMETERVALUE.toString();
        }
      }
    } else {
      if (widget.inputParameters != null) {
        for (var element in widget.inputParameters!) {
          billerInputSign[element.pARAMETERNAME.toString()] =
              element.pARAMETERVALUE.toString();
        }
      }
    }

    if (validateBill!["fetchBill"]) {
      logger.i("FETCH BILL API CALLING ==== >");

      BlocProvider.of<HomeCubit>(context).fetchBill(
          billerID:
              widget.billerData?.bILLERID ?? widget.savedBillersData?.bILLERID,
          quickPay: false,
          quickPayAmount: "0",
          adHocBillValidationRefKey: null,
          validateBill: validateBill!["validateBill"],
          billerParams: billerInputSign,
          billName: widget.billName);
    } else {
      isFetchbillLoading = false;
      isUnableToFetchBill = false;
    }
  }

  @override
  void initState() {
    initialFetch();

    BlocProvider.of<HomeCubit>(context).getPaymentInformation(
        widget.billerData?.bILLERID ?? widget.savedBillersData?.bILLERID);
    // BlocProvider.of<MybillersCubit>(context).getAddUpdateUpcomingDue(
    //     customerBillID: widget.isSavedBill
    //         ? widget.savedBillersData!.cUSTOMERBILLID
    //         : _customerBIllID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: widget.billerName,
          onLeadingTap: () => goBack(context),
          showActions: false,
        ),
        body: BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
          //PAYMENT-INFO

          if (state is PaymentInfoLoading) {
            isPaymentInfoLoading = true;
          } else if (state is PaymentInfoSuccess) {
            paymentInform = state.PaymentInfoDetail!.data;
            isPaymentInfoLoading = false;
          } else if (state is PaymentInfoFailed) {
            isPaymentInfoLoading = false;
          } else if (state is PaymentInfoError) {
            isPaymentInfoLoading = false;
          }

          //FETCH BILL

          if (state is FetchBillLoading) {
            isFetchbillLoading = true;
          } else if (state is FetchBillSuccess) {
            _billerResponseData =
                state.fetchBillResponse!.data!.data!.billerResponse;
            _customerBIllID = state.fetchBillResponse!.customerbillId;
            _additionalInfo =
                state.fetchBillResponse!.data!.data!.additionalInfo;
            txtAmountController.text = _billerResponseData!.amount.toString();
            if (double.parse(_billerResponseData!.amount.toString()) > 0) {
              setState(() {
                isInsufficient = false;
              });
            }
            setState(() {
              isFetchbillLoading = false;
              isUnableToFetchBill = false;
            });
            BlocProvider.of<MybillersCubit>(context).getAddUpdateUpcomingDue(
                customerBillID: widget.isSavedBill
                    ? widget.savedBillersData!.cUSTOMERBILLID
                    : _customerBIllID,
                dueAmount: _billerResponseData!.amount,
                dueDate: _billerResponseData!.dueDate,
                billDate: _billerResponseData!.billDate,
                billPeriod: _billerResponseData!.billPeriod);
          } else if (state is FetchBillFailed) {
            BlocProvider.of<MybillersCubit>(context).getAddUpdateUpcomingDue();
            if (state.message.toString().contains("Unable to fetch")) {
              isUnableToFetchBill = true;
            }
            isFetchbillLoading = false;
          } else if (state is FetchBillError) {
            isFetchbillLoading = false;
            isUnableToFetchBill = false;
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 18.0.w, right: 18.w, top: 10.h, bottom: 80.h),
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
                        BillerDetailsContainer(
                          icon: LOGO_BBPS,
                          billerName: widget.billerName.toString(),
                          categoryName: widget.categoryName.toString(),
                        ),
                        if (isFetchbillLoading)
                          Container(
                            height: 200,
                            width: 200,
                            child: FlickrLoader(),
                          ),
                        if (!isFetchbillLoading && isUnableToFetchBill)
                          Container(
                              width: double.infinity,
                              height: 500,
                              child: const noResult()),
                        if (!isFetchbillLoading &&
                            !isUnableToFetchBill &&
                            !isPaymentInfoLoading)
                          if (((_billerResponseData == null ||
                              _billerResponseData!.tag!.isEmpty)))
                            Container(
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  minHeight: 100.h,
                                  maxHeight: 300.h,
                                ),
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisSpacing: 10.w,
                                  mainAxisSpacing: 0,
                                  crossAxisCount: 2,
                                  childAspectRatio: 4 / 2,
                                  children: <Widget>[
                                    if (_billerResponseData != null &&
                                        _billerResponseData!.billDate != null)
                                      billerDetail(
                                          "Bill Date",
                                          _billerResponseData!.billDate
                                              .toString(),
                                          context),
                                    if (_billerResponseData != null &&
                                        _billerResponseData!.dueDate != null)
                                      billerDetail(
                                          "Due Date",
                                          _billerResponseData!.dueDate
                                              .toString(),
                                          context),
                                    if (_billerResponseData != null &&
                                        _billerResponseData!.billNumber != null)
                                      billerDetail(
                                          "Bill Number",
                                          _billerResponseData!.billNumber
                                              .toString(),
                                          context),
                                    if (_billerResponseData != null &&
                                        _billerResponseData!.billPeriod != null)
                                      billerDetail(
                                          "Bill Period",
                                          _billerResponseData!.billPeriod
                                              .toString(),
                                          context),
                                    if (_billerResponseData != null &&
                                        _billerResponseData!.customerName !=
                                            null)
                                      billerDetail(
                                          "Customer Name",
                                          _billerResponseData!.customerName
                                              .toString(),
                                          context),
                                    if (widget.billName != null)
                                      billerDetail("Bill Name",
                                          widget.billName.toString(), context),
                                  ],
                                )),
                        if (!isFetchbillLoading &&
                            !isUnableToFetchBill &&
                            !isPaymentInfoLoading)
                          if ((!(_additionalInfo == null ||
                              _additionalInfo!.tag!.isEmpty)))
                            Container(
                              width: double.infinity,
                              // height: 300,

                              color: Colors.white,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.0.h),
                                    child: Text(
                                      "Additional Info",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff1b438b),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: _additionalInfo!.tag!.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                                        crossAxisCount: 2,
                                        childAspectRatio: 4 / 2,
                                        mainAxisSpacing: 10.h,
                                        itemCount: _additionalInfo!.tag!.length,
                                      ),
                                      itemBuilder: (context, index) {
                                        return Container(
                                            // margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.r),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            8.w, 10.h, 0, 0),
                                                    child: Text(
                                                      _additionalInfo!
                                                          .tag![index].name
                                                          .toString(),
                                                      // "Subscriber ID",
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff808080),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            8.w, 10.h, 0, 0),
                                                    child: Text(
                                                      _additionalInfo!
                                                          .tag![index].value
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff1b438b),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ))
                                              ],
                                            ));
                                      }),
                                ],
                              ),
                            ),
                        if (!isFetchbillLoading &&
                            !isUnableToFetchBill &&
                            !isPaymentInfoLoading)
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 16.w,
                                    right: 16.w,
                                    top: 16.h,
                                    bottom: 16.h),
                                child: TextFormField(
                                  controller: txtAmountController,
                                  enabled: validateBill!["amountEditable"],
                                  onFieldSubmitted: (_) {},
                                  onChanged: (val) {
                                    setState(() {
                                      if (validateBill!["fetchBill"]) {
                                        PaymentExactErrMsg = checkIsExact(
                                            double.parse(val.toString()),
                                            double.parse(_billerResponseData!
                                                .amount
                                                .toString()),
                                            widget.isSavedBill
                                                ? widget.savedBillersData!
                                                    .pAYMENTEXACTNESS
                                                : widget.billerData!
                                                    .pAYMENTEXACTNESS);
                                      }
                                    });

                                    if (txtAmountController.text.isNotEmpty) {
                                      if (double.parse(
                                                  txtAmountController.text) <
                                              double.parse(paymentInform!
                                                  .mINLIMIT
                                                  .toString()) ||
                                          double.parse(
                                                  txtAmountController.text) >
                                              double.parse(paymentInform!
                                                  .mAXLIMIT
                                                  .toString())) {
                                        setState(() {
                                          isInsufficient = true;
                                        });
                                      } else {
                                        setState(() {
                                          isInsufficient = false;
                                        });
                                      }
                                      setState(() {
                                        // isInsufficient = true;
                                      });
                                    }
                                  },
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}')),
                                  ],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                    fillColor: validateBill!["amountEditable"]
                                        ? Color(0xffD1D9E8).withOpacity(0.2)
                                        : Color(0xffD1D9E8).withOpacity(0.5),
                                    filled: true,
                                    labelStyle:
                                        TextStyle(color: Color(0xff1b438b)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff1B438B)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff1B438B)),
                                    ),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Amount',
                                    prefixText: '₹  ',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20.w, bottom: 20.h, right: 20.w),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Payment Amount has to be between ₹ ${paymentInform?.mINLIMIT.toString()} and ₹ ${paymentInform?.mAXLIMIT.toString()}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.normal,
                                      color: isInsufficient
                                          ? CLR_ERROR
                                          : TXT_CLR_PRIMARY,
                                    ),
                                  ),
                                ),
                              ),
                              if (PaymentExactErrMsg.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.w, bottom: 20.h, right: 20.w),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      PaymentExactErrMsg,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                        color: CLR_ERROR,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    )),
              ],
            ),
          );
        }),
        bottomSheet: !isFetchbillLoading && !isUnableToFetchBill
            ? Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: MyAppButton(
                            onPressed: () {
                              goBack(context);
                            },
                            buttonText: "Cancel",
                            buttonTxtColor: CLR_PRIMARY,
                            buttonBorderColor: Colors.transparent,
                            buttonColor: BTN_CLR_ACTIVE,
                            buttonSizeX: 10.h,
                            buttonSizeY: 40.w,
                            buttonTextSize: 14.sp,
                            buttonTextWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 40.w,
                      ),
                      Expanded(
                        child: MyAppButton(
                            onPressed: () {
                              if (!isInsufficient &&
                                  PaymentExactErrMsg.isEmpty) {
                                goToData(context, pAYMENTCONFIRMROUTE, {
                                  "name": widget.isSavedBill
                                      ? widget.savedBillersData!.bILLERNAME
                                      : widget.billerData!.bILLERNAME,
                                  "billName": widget.billName,
                                  "billerData": widget.billerData,
                                  "savedBillersData": widget.savedBillersData,
                                  "inputParameters": widget.inputParameters,
                                  "SavedinputParameters":
                                      widget.SavedinputParameters,
                                  "categoryName": widget.isSavedBill
                                      ? widget.savedBillersData!.cATEGORYNAME
                                      : widget.billerData!.cATEGORYNAME,
                                  "isSavedBill": widget.isSavedBill,
                                  "amount": txtAmountController.text,
                                  "validateBill": validateBill,
                                  "billerInputSign": billerInputSign
                                });
                              }
                            },
                            buttonText: "Pay Now",
                            buttonTxtColor: BTN_CLR_ACTIVE,
                            buttonBorderColor: Colors.transparent,
                            buttonColor:
                                isInsufficient || PaymentExactErrMsg.isNotEmpty
                                    ? Colors.grey
                                    : CLR_PRIMARY,
                            buttonSizeX: 10.h,
                            buttonSizeY: 40.w,
                            buttonTextSize: 14.sp,
                            buttonTextWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Color(0xffE8ECF3), width: 1))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: MyAppButton(
                            onPressed: () {
                              goBack(context);
                            },
                            buttonText: "Go Back",
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
