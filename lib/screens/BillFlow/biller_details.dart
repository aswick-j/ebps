import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/biller_details_container.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
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
import 'package:ebps/widget/custom_dialog.dart';
import 'package:ebps/widget/get_biller_detail.dart';
import 'package:ebps/widget/loader.dart';
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
  billerResponseData? fetchBillerResponseData;
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
          billName: widget.billName,
          customerBillId: widget.isSavedBill
              ? widget.savedBillersData!.cUSTOMERBILLID
              : null);
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
          return CustomDialog(
              showActions: true,
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: MyAppButton(
                      onPressed: () {
                        GoBack(ctx);
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
              child: AnimatedDialog(
                  showImgIcon: false,
                  title: "Your daily bill payment limit has been exceeded.",
                  subTitle:
                      " For additional information, please contact the bank.",
                  showSub: true,
                  shapeColor: AppColors.CLR_ORANGE,
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.white,
                  )));
        },
      );
    }

    bool isValidDate(String input) {
      try {
        final date = DateTime.parse(input);
        return true;
      } catch (e) {
        return false;
      }
    }

    return Scaffold(
        backgroundColor: AppColors.CLR_BACKGROUND,
        appBar: MyAppBar(
          context: context,
          title: "Billing Summary",
          onLeadingTap: () => GoBack(context),
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
            fetchBillerResponseData = state.fetchBillResponse;
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
            // BlocProvider.of<MybillersCubit>(context).getAddUpdateUpcomingDue(
            //     customerBillID: widget.isSavedBill
            //         ? widget.savedBillersData!.cUSTOMERBILLID
            //         : _customerBIllID,
            //     dueAmount: _billerResponseData!.amount,
            //     dueDate: _billerResponseData!.dueDate,
            //     billDate: _billerResponseData!.billDate,
            //     billPeriod: _billerResponseData!.billPeriod);
          } else if (state is FetchBillFailed) {
            // BlocProvider.of<MybillersCubit>(context).getAddUpdateUpcomingDue();
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
              ReusableContainer(
                bottomMargin: 80.h,
                child: !isBillerDetailsPageError
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BillerDetailsContainer(
                            icon: BILLER_LOGO(widget.billerName.toString()),
                            title: widget.billerName.toString(),
                            // categoryName: widget.categoryName.toString(),
                            subTitle: widget.isSavedBill
                                ? widget.savedBillersData!.cATEGORYNAME!
                                    .toString()
                                : widget.billerData!.cATEGORYNAME.toString(),
                            subTitle2: widget.isSavedBill
                                ? widget.savedBillersData!.bILLERCOVERAGE!
                                    .toString()
                                : widget.billerData!.bILLERCOVERAGE.toString(),
                          ),
                          Divider(
                            color: AppColors.CLR_DIVIDER_LITE,
                            height: 1.h,
                            thickness: 0.50,
                            // indent: 10.w,
                            // endIndent: 10.w,
                          ),
                          if (isFetchbillLoading ||
                              isAmountByDateLoading ||
                              isAmountByDateLoading ||
                              isPaymentInfoLoading)
                            Container(
                              height: 200.h,
                              child: Center(child: Loader()),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 24.w, top: 20.0.h, bottom: 10.h),
                                    child: Text(
                                      "Bill Details",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.CLR_PRIMARY,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                      // width: double.infinity,
                                      // constraints: BoxConstraints(
                                      //   minHeight: 100.h,
                                      //   maxHeight: 300.h,
                                      // ),
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
                                            isValidDate(_billerResponseData!
                                                    .billDate
                                                    .toString())
                                                ? DateFormat.yMMMMd('en_US')
                                                    .format(DateTime.parse(
                                                            _billerResponseData!
                                                                .billDate
                                                                .toString())
                                                        .toLocal())
                                                : _billerResponseData!.billDate
                                                    .toString(),
                                            context),
                                      if (_billerResponseData != null &&
                                          _billerResponseData!.dueDate != null)
                                        billerdetail(
                                            "Due Date",
                                            isValidDate(_billerResponseData!
                                                    .dueDate
                                                    .toString())
                                                ? DateFormat.yMMMMd('en_US')
                                                    .format(DateTime.parse(
                                                            _billerResponseData!
                                                                .dueDate
                                                                .toString())
                                                        .toLocal())
                                                : _billerResponseData!.dueDate
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
                                            "Consumer Name",
                                            _billerResponseData!.customerName
                                                .toString(),
                                            context),
                                      if (widget.billName != null)
                                        billerdetail(
                                            "Bill Name",
                                            widget.billName.toString(),
                                            context),
                                      if ((!(_billerResponseData == null ||
                                          _billerResponseData!.tag!.isEmpty)))
                                        ListView.builder(
                                            itemCount: _billerResponseData!
                                                .tag!.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                Column(
                                                  children: [
                                                    billerdetail(
                                                      _billerResponseData!
                                                          .tag![index].name
                                                          .toString(),
                                                      _billerResponseData!
                                                          .tag![index].value
                                                          .toString(),
                                                      context,
                                                    ),
                                                  ],
                                                )),
                                    ],
                                  )),
                                ],
                              ),
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

                                // color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 24.w,
                                          top: 20.0.h,
                                          bottom: 10.h),
                                      child: Text(
                                        "Additional Info",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.CLR_PRIMARY,
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
                                                            color: AppColors
                                                                .TXT_CLR_LITE,
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
                                                            color: AppColors
                                                                .TXT_CLR_PRIMARY,
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
                                    style: !validateBill!["amountEditable"]
                                        ? TextStyle(
                                            color: AppColors.TXT_CLR_LITE)
                                        : TextStyle(
                                            color: AppColors.TXT_CLR_DEFAULT),
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
                                      prefixStyle: TextStyle(
                                          color: AppColors.TXT_CLR_DEFAULT),
                                      hintStyle: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold),
                                      fillColor: validateBill!["amountEditable"]
                                          ? AppColors.CLR_INPUT_FILL
                                          : AppColors.TXT_CLR_GREY
                                              .withOpacity(0.1),
                                      filled: true,
                                      labelStyle: TextStyle(
                                          color: validateBill!["amountEditable"]
                                              ? AppColors.CLR_PRIMARY
                                              : AppColors.TXT_CLR_LITE),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.TXT_CLR_PRIMARY),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.TXT_CLR_PRIMARY),
                                      ),
                                      border: UnderlineInputBorder(),
                                      labelText: 'Amount',
                                      prefixText: '₹  ',
                                    ),
                                  ),
                                ),
                                if (isInsufficient)
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
                                              ? AppColors.CLR_ERROR
                                              : AppColors.TXT_CLR_PRIMARY,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (PaymentExactErrMsg.isNotEmpty)
                                  // Padding(
                                  //   padding: EdgeInsets.only(
                                  //       left: 20.w, bottom: 20.h, right: 20.w),
                                  //   child: Align(
                                  //     alignment: Alignment.center,
                                  //     child: Text(
                                  //       PaymentExactErrMsg,
                                  //       textAlign: TextAlign.left,
                                  //       style: TextStyle(
                                  //         fontSize: 12.sp,
                                  //         fontWeight: FontWeight.normal,
                                  //         color: AppColors.CLR_ERROR,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        left: 18.0.w,
                                        right: 18.w,
                                        top: 0.h,
                                        bottom: 10.h),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.CLR_ERROR.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(6.0.r + 2.r),
                                      border: Border.all(
                                        color: AppColors.CLR_ERROR,
                                        width: 0.50,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.h,
                                                left: 14.w,
                                                bottom: 0.h),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.info_outline_rounded,
                                                  color: AppColors.CLR_ERROR,
                                                  size: 15.r,
                                                ),
                                                Text(
                                                  "  Message from Biller",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.CLR_ERROR,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.h,
                                              left: 34.w,
                                              right: 2.w,
                                              bottom: 10.h),
                                          child: Text(
                                            PaymentExactErrMsg,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.CLR_ERROR,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        )
                                      ],
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
                                            color: AppColors.TXT_CLR_LITE,
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
                            title: widget.billerName.toString(),
                            // categoryName: widget.categoryName.toString(),
                            subTitle: widget.isSavedBill
                                ? widget.savedBillersData!.cATEGORYNAME!
                                    .toString()
                                : widget.billerData!.cATEGORYNAME.toString(),
                            subTitle2: widget.isSavedBill
                                ? widget.savedBillersData!.bILLERCOVERAGE!
                                    .toString()
                                : widget.billerData!.bILLERCOVERAGE.toString(),
                          ),
                          Divider(
                            color: AppColors.CLR_DIVIDER_LITE,
                            height: 1.h,
                            thickness: 0.50,
                            // indent: 10.w,
                            // endIndent: 10.w,
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
                    color: AppColors.CLR_BACKGROUND,
                    border: Border(
                        top: BorderSide(
                            color: AppColors.CLR_CON_BORDER_LITE,
                            width: 0.50))),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: MyAppButton(
                            onPressed: () {
                              GoBack(context);
                            },
                            buttonText: "Cancel",
                            buttonTxtColor:
                                AppColors.BTN_CLR_ACTIVE_ALTER_TEXT_C,
                            buttonBorderColor: AppColors.BTN_CLR_ACTIVE_BORDER,
                            buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER_C,
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
                                  GoToData(context, pAYMENTCONFIRMROUTE, {
                                    "name": widget.isSavedBill
                                        ? widget.savedBillersData!.bILLERNAME
                                        : widget.billerData!.bILLERNAME,
                                    "billName": widget.billName,
                                    "consumerName": _billerResponseData !=
                                                null &&
                                            _billerResponseData!.customerName !=
                                                null
                                        ? _billerResponseData!.customerName
                                        : null,
                                    "billerData": widget.billerData,
                                    "fetchBillerResponse":
                                        fetchBillerResponseData,
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
                            buttonTxtColor:
                                isInsufficient || PaymentExactErrMsg.isNotEmpty
                                    ? AppColors.BTN_CLR_DISABLE_TEXT
                                    : AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                            buttonBorderColor: Colors.transparent,
                            buttonColor:
                                isInsufficient || PaymentExactErrMsg.isNotEmpty
                                    ? AppColors.BTN_CLR_DISABLE
                                    : AppColors.BTN_CLR_ACTIVE_ALTER,
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
                    color: AppColors.CLR_BACKGROUND,
                    border: Border(
                        top: BorderSide(
                            color: AppColors.CLR_CON_BORDER_LITE,
                            width: 0.50))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: MyAppButton(
                            onPressed: () {
                              GoBack(context);
                            },
                            buttonText: "Go Back",
                            buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                            buttonBorderColor: Colors.transparent,
                            buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
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
