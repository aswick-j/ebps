import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/biller_details_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getAmountExact.dart';
import 'package:ebps/helpers/getBillerType.dart';
import 'package:ebps/helpers/getDecimalInputs.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:ebps/models/add_biller_model.dart';
import 'package:ebps/models/bbps_settings_model.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/fetch_bill_model.dart';
import 'package:ebps/models/paymentInformationModel.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/animated_dialog.dart';
import 'package:ebps/widget/centralized_grid_view.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:ebps/widget/get_biller_detail.dart';
import 'package:ebps/widget/no_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
  String? checkBillAmount = "0";
  Map<String, dynamic>? validateBill;
  PaymentInformationData? paymentInform;
  bool isInsufficient = true;
  int ErrIndex = 0;
  int ImgIndex = 0;
  int TitleErrIndex = 0;
  AdditionalInfo? _additionalInfo;
  Map<String, dynamic> billerInputSign = {};
  final txtAmountController = TextEditingController();

  bool isFetchbillLoading = true;
  bool isPaymentInfoLoading = true;
  bool isAmountByDateLoading = true;
  bool isBbpsSettingsLoading = true;

  bool isUnableToFetchBill = true;
  String DailyLimit = '0';
  String PaymentExactErrMsg = "";
  bbpsSettingsData? BbpsSettingInfo;
  bool isBillerDetailsPageError = false;

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
    BlocProvider.of<HomeCubit>(context).getAmountByDate();
    BlocProvider.of<HomeCubit>(context).getBbpsSettings();

    super.initState();
  }

  handleDues() {
    if (widget.isSavedBill) {
      if (widget.savedBillersData!.cUSTOMERBILLID != null) {
        BlocProvider.of<MybillersCubit>(context)
            .deleteUpcomingDue(widget.savedBillersData!.cUSTOMERBILLID);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    handleDialog() {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            content: AnimatedDialog(
                showImgIcon: false,
                title: "Your daily bill payment limit has been exceeded.",
                subTitle:
                    " For additional information, please contact the bank.",
                showSub: true,
                shapeColor: Colors.orange,
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                )),
            actions: <Widget>[
              Align(
                alignment: Alignment.center,
                child: MyAppButton(
                    onPressed: () {
                      goBack(ctx);
                    },
                    buttonText: "Okay",
                    buttonTxtColor: BTN_CLR_ACTIVE,
                    buttonBorderColor: Colors.transparent,
                    buttonColor: CLR_PRIMARY,
                    buttonSizeX: 10,
                    buttonSizeY: 40,
                    buttonTextSize: 14,
                    buttonTextWeight: FontWeight.w500),
              ),
            ],
          );
        },
      );
    }

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
            isBillerDetailsPageError = true;
          } else if (state is PaymentInfoError) {
            isPaymentInfoLoading = false;
            isBillerDetailsPageError = true;
          }

          if (state is AmountByDateLoading) {
            isAmountByDateLoading = true;
          } else if (state is AmountByDateSuccess) {
            isAmountByDateLoading = false;

            setState(() {
              DailyLimit = state.amountByDate!;
            });
          } else if (state is AmountByDateFailed) {
            isAmountByDateLoading = false;
            isBillerDetailsPageError = true;
          } else if (state is AmountByDateError) {
            isAmountByDateLoading = false;
            isBillerDetailsPageError = true;
          }

          if (state is BbpsSettingsLoading) {
            isBbpsSettingsLoading = true;
          } else if (state is BbpsSettingsSuccess) {
            isBbpsSettingsLoading = false;

            setState(() {
              BbpsSettingInfo = state.BbpsSettingsDetail!.data;
            });
          } else if (state is BbpsSettingsFailed) {
            isBillerDetailsPageError = true;

            isBbpsSettingsLoading = false;
          } else if (state is BbpsSettingsError) {
            isBillerDetailsPageError = true;

            isBbpsSettingsLoading = false;
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
            checkBillAmount = _billerResponseData!.amount.toString();
            txtAmountController.text = _billerResponseData!.amount.toString();

            if (double.parse(_billerResponseData!.amount.toString()) == 0 ||
                _billerResponseData!.amount == null ||
                (double.parse(_billerResponseData!.amount.toString()) <
                        double.parse(paymentInform!.mINLIMIT.toString()) ||
                    double.parse(_billerResponseData!.amount.toString()) >
                        double.parse(paymentInform!.mAXLIMIT.toString()))) {
              setState(() {
                isInsufficient = true;
              });
            } else {
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
              setState(() {
                ErrIndex = 0;

                isUnableToFetchBill = true;
              });
            } else if (state.message
                .toString()
                .contains("Something went wrong")) {
              setState(() {
                ErrIndex = 2;
                ImgIndex = 2;
                isUnableToFetchBill = true;
              });
            } else if (state.message
                .toString()
                .toLowerCase()
                .contains("no pending bill")) {
              handleDues();
              setState(() {
                ErrIndex = 4;
                ImgIndex = 4;
                TitleErrIndex = 1;
                isUnableToFetchBill = true;
              });
            } else if (state.message
                .toString()
                .toLowerCase()
                .contains("no bill data")) {
              handleDues();
              setState(() {
                ErrIndex = 5;
                ImgIndex = 3;

                isUnableToFetchBill = true;
              });
            } else {
              setState(() {
                ErrIndex = 6;
                ImgIndex = 2;
                isUnableToFetchBill = true;
              });
            }
            setState(() {
              isFetchbillLoading = false;
            });
          } else if (state is FetchBillError) {
            setState(() {
              ErrIndex = 2;
              ImgIndex = 2;
              isUnableToFetchBill = true;
              isFetchbillLoading = false;
            });
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
                child: !isBillerDetailsPageError
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BillerDetailsContainer(
                            icon: BILLER_LOGO(widget.billerName.toString()),
                            billerName: widget.billerName.toString(),
                            categoryName: widget.categoryName.toString(),
                          ),
                          if (isFetchbillLoading ||
                              isAmountByDateLoading ||
                              isAmountByDateLoading ||
                              isPaymentInfoLoading)
                            Container(
                              height: 200.h,
                              width: 200.w,
                              child: FlickrLoader(),
                            ),
                          if ((!isFetchbillLoading &&
                                  !isAmountByDateLoading &&
                                  !isBbpsSettingsLoading &&
                                  !isPaymentInfoLoading) &&
                              isUnableToFetchBill)
                            Container(
                                width: double.infinity,
                                height: 350.h,
                                child: noResult(
                                  showTitle: true,
                                  ErrIndex: ErrIndex,
                                  ImgIndex: ImgIndex,
                                  TitleErrIndex: TitleErrIndex,
                                )),
                          if (!isFetchbillLoading &&
                              !isUnableToFetchBill &&
                              !isBbpsSettingsLoading &&
                              !isPaymentInfoLoading)
                            if (((_billerResponseData != null)))
                              Container(
                                  // width: double.infinity,
                                  // constraints: BoxConstraints(
                                  //   minHeight: 100.h,
                                  //   maxHeight: 300.h,
                                  // ),
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  child: ListView(
                                    shrinkWrap: true,
                                    // primary: false,
                                    physics: NeverScrollableScrollPhysics(),
                                    // crossAxisSpacing: 10.w,
                                    // mainAxisSpacing: 0,
                                    // crossAxisCount: 2,
                                    // childAspectRatio: 4 / 2,
                                    children: <Widget>[
                                      if (_billerResponseData != null &&
                                          _billerResponseData!.billDate != null)
                                        billerdetail(
                                            "Bill Date",
                                            _billerResponseData!.billDate
                                                .toString(),
                                            context),
                                      if (_billerResponseData != null &&
                                          _billerResponseData!.dueDate != null)
                                        billerdetail(
                                            "Due Date",
                                            _billerResponseData!.dueDate
                                                .toString(),
                                            context),
                                      if (_billerResponseData != null &&
                                          _billerResponseData!.billNumber !=
                                              null)
                                        billerdetail(
                                            "Bill Number",
                                            _billerResponseData!.billNumber
                                                .toString(),
                                            context),
                                      if (_billerResponseData != null &&
                                          _billerResponseData!.billPeriod !=
                                              null)
                                        billerdetail(
                                            "Bill Period",
                                            _billerResponseData!.billPeriod
                                                .toString(),
                                            context),
                                      if (_billerResponseData != null &&
                                          _billerResponseData!.customerName !=
                                              null)
                                        billerdetail(
                                            "Customer Name",
                                            _billerResponseData!.customerName
                                                .toString(),
                                            context),
                                      if (widget.billName != null)
                                        billerdetail(
                                            "Bill Name",
                                            widget.billName.toString(),
                                            context),
                                    ],
                                  )),
                          if (!isFetchbillLoading &&
                              !isUnableToFetchBill &&
                              !isBbpsSettingsLoading &&
                              !isAmountByDateLoading &&
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
                                      padding: EdgeInsets.only(
                                          top: 20.0.h, bottom: 10.h),
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
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _additionalInfo!.tag!.length,
                                        // physics: NeverScrollableScrollPhysics(),
                                        // gridDelegate:
                                        //     SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                                        //   crossAxisCount: 2,
                                        //   childAspectRatio: 4 / 2,
                                        //   mainAxisSpacing: 10.h,
                                        //   itemCount:
                                        //       _additionalInfo!.tag!.length,
                                        // ),
                                        itemBuilder: (context, index) {
                                          return Container(
                                              // margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2.r),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              24.w,
                                                              10.h,
                                                              8.w,
                                                              10.h),
                                                      child: SizedBox(
                                                        width: 110.w,
                                                        child: Text(
                                                          _additionalInfo!
                                                              .tag![index].name
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xff808080),
                                                          ),
                                                          maxLines: 3,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              8.w,
                                                              10.h,
                                                              24.w,
                                                              10.h),
                                                      child: SizedBox(
                                                        width: 130.w,
                                                        child: Text(
                                                          _additionalInfo!
                                                              .tag![index].value
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 13.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff1b438b),
                                                          ),
                                                          maxLines: 3,
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ))
                                                ],
                                              ));
                                        }),
                                  ],
                                ),
                              ),
                          if (!isFetchbillLoading &&
                              !isUnableToFetchBill &&
                              !isAmountByDateLoading &&
                              !isBbpsSettingsLoading &&
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
                                    // style: !validateBill!["amountEditable"]
                                    //     ? null
                                    //     : TextStyle(color: TXT_CLR_LITE),
                                    onFieldSubmitted: (_) {},
                                    onChanged: (val) {
                                      if (val.isNotEmpty &&
                                          val.length == 1 &&
                                          val[0] == ".") {
                                        isInsufficient = true;
                                      } else {
                                        setState(() {
                                          if (val.isEmpty) {
                                            setState(() {
                                              isInsufficient = true;
                                            });
                                          }

                                          if (validateBill!["fetchBill"]) {
                                            PaymentExactErrMsg = checkIsExact(
                                                double.parse(txtAmountController
                                                        .text.isEmpty
                                                    ? "0"
                                                    : txtAmountController.text
                                                        .toString()),
                                                double.parse(
                                                    _billerResponseData!.amount
                                                        .toString()),
                                                widget.isSavedBill
                                                    ? widget.savedBillersData!
                                                        .pAYMENTEXACTNESS
                                                    : widget.billerData!
                                                        .pAYMENTEXACTNESS);
                                          }
                                        });

                                        if (txtAmountController
                                            .text.isNotEmpty) {
                                          if (double.parse(txtAmountController
                                                      .text) <
                                                  double.parse(paymentInform!
                                                      .mINLIMIT
                                                      .toString()) ||
                                              double.parse(txtAmountController
                                                      .text) >
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
                                      }
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(10),
                                      DecimalTextInputFormatter(
                                          decimalRange: 2),
                                      // getInputAmountFormatter(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[0-9]*[.]{0,1}[0-9]*'))
                                      // FilteringTextInputFormatter.allow(
                                      //     RegExp(r'^\d*\.?\d{0,2}')),
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
                                      labelStyle: TextStyle(
                                          color: validateBill!["amountEditable"]
                                              ? Color(0xff1b438b)
                                              : TXT_CLR_LITE),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff1B438B)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff1B438B)),
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
                                      'Payment Amount has to be between ₹ ${NumberFormat('#,##,##0.00').format(double.parse(paymentInform!.mINLIMIT.toString()))} and ₹ ${NumberFormat('#,##,##0.00').format(double.parse(paymentInform!.mAXLIMIT.toString()))}',
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
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.w, bottom: 20.h, right: 20.w),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          LOGO_BBPS_ASSURED,
                                          height: 50.h,
                                          width: 50.w,
                                        ),
                                        Text(
                                          'All billing details are verified by Bharat Billpay',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.normal,
                                            color: TXT_CLR_LITE,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      )
                    : Column(
                        children: [
                          BillerDetailsContainer(
                            icon: BILLER_LOGO(widget.billerName.toString()),
                            billerName: widget.billerName.toString(),
                            categoryName: widget.categoryName.toString(),
                          ),
                          Container(
                              width: double.infinity,
                              height: 350.h,
                              child: noResult(
                                showTitle: false,
                                ErrIndex: 8,
                                ImgIndex: 5,
                                width: 130.h,
                              )),
                        ],
                      ),
              ),
            ],
          ));
        }),
        bottomSheet: !isBillerDetailsPageError &&
                !isFetchbillLoading &&
                !isUnableToFetchBill &&
                !isPaymentInfoLoading &&
                !isAmountByDateLoading &&
                !isBbpsSettingsLoading
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
                              final dailyLimit =
                                  double.parse(DailyLimit.toString());
                              final bankLimit = double.parse(
                                  BbpsSettingInfo!.dAILYLIMIT.toString());

                              if (!isInsufficient &&
                                  PaymentExactErrMsg.isEmpty) {
                                if ((double.parse(txtAmountController.text) >
                                    (bankLimit - dailyLimit))) {
                                  handleDialog();
                                } else {
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
                                    "BbpsSettingInfo": BbpsSettingInfo,
                                    "amount":
                                        double.parse(txtAmountController.text)
                                            .toString(),
                                    "validateBill": validateBill,
                                    "billerInputSign": billerInputSign,
                                    "otherAmount": double.parse(
                                                checkBillAmount.toString()) ==
                                            double.parse(
                                                txtAmountController.text)
                                        ? false
                                        : true
                                  });
                                }
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
