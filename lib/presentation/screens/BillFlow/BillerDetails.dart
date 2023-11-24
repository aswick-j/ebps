import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/data/models/add_biller_model.dart';
import 'package:ebps/data/models/billers_model.dart';
import 'package:ebps/data/models/fetch_bill_model.dart';
import 'package:ebps/data/models/paymentInformationModel.dart';
import 'package:ebps/helpers/getBillerType.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:ebps/presentation/common/Container/Home/BillerDetailsContainer.dart';
import 'package:ebps/presentation/widget/getBillerDetail.dart';
import 'package:ebps/presentation/widget/noResult.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillerDetails extends StatefulWidget {
  int? billID;
  String? billerName;
  String? billName;
  String? categoryName;
  bool isSavedBill;
  BillersData? billerData;
  List<AddbillerpayloadModel>? inputParameters;

  BillerDetails(
      {Key? key,
      required this.billID,
      required this.billerName,
      required this.isSavedBill,
      this.billName,
      this.billerData,
      this.inputParameters,
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

  void initialFetch() {
    txtAmountController.text = billAmount.toString();
    setState(() {
      validateBill = getBillerType(
          widget.billerData!.fETCHREQUIREMENT,
          widget.billerData!.bILLERACCEPTSADHOC,
          widget.billerData!.sUPPORTBILLVALIDATION,
          widget.billerData!.pAYMENTEXACTNESS);
    });
    for (var element in widget.inputParameters!) {
      billerInputSign[element.pARAMETERNAME.toString()] =
          element.pARAMETERVALUE.toString();
    }
    if (validateBill!["fetchBill"]) {
      logger.i("FETCH BILL API CALLING ==== >");
      BlocProvider.of<HomeCubit>(context).fetchBill(
          billerID: widget.billerData!.bILLERID,
          quickPay: false,
          quickPayAmount: "0",
          adHocBillValidationRefKey: null,
          validateBill: validateBill!["validateBill"],
          billerParams: billerInputSign,
          billName: widget.isSavedBill ? null : widget!.billName);
    } else {
      isFetchbillLoading = false;
      isUnableToFetchBill = false;
    }
  }

  @override
  void initState() {
    initialFetch();

    BlocProvider.of<HomeCubit>(context)
        .getPaymentInformation(widget.billerData!.bILLERID);

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
          } else if (state is FetchBillFailed) {
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
                        left: 20.0, right: 20, top: 20, bottom: 100),
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
                        BillerDetailsContainer(
                          icon: 'packages/ebps/assets/icon/logo_bbps.svg',
                          billerName: widget.billerName.toString(),
                          categoryName: widget.categoryName.toString(),
                        ),
                        if (isFetchbillLoading) Text("Fetch Bill Loading..."),
                        if (!isFetchbillLoading && isUnableToFetchBill)
                          Container(
                              width: double.infinity,
                              height: 500,
                              child: const noResult()),
                        if (!isFetchbillLoading &&
                            !isUnableToFetchBill &&
                            !isPaymentInfoLoading)
                          if (((_billerResponseData != null ||
                              _billerResponseData!.tag!.isEmpty)))
                            Container(
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  minHeight: 100,
                                  maxHeight: 300,
                                ),
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 0,
                                  crossAxisCount: 2,
                                  childAspectRatio: 4 / 2,
                                  children: <Widget>[
                                    if (_billerResponseData != null &&
                                        _billerResponseData!.billDate != null)
                                      billerDetail(
                                          "Bill Date",
                                          _billerResponseData!.billDate
                                              .toString()),
                                    if (_billerResponseData != null &&
                                        _billerResponseData!.dueDate != null)
                                      billerDetail(
                                          "Due Date",
                                          _billerResponseData!.dueDate
                                              .toString()),
                                    if (_billerResponseData != null &&
                                        _billerResponseData!.billNumber != null)
                                      billerDetail(
                                          "Bill Number",
                                          _billerResponseData!.billNumber
                                              .toString()),
                                    if (_billerResponseData != null &&
                                        _billerResponseData!.billPeriod != null)
                                      billerDetail(
                                          "Bill Period",
                                          _billerResponseData!.billPeriod
                                              .toString()),
                                    if (_billerResponseData != null &&
                                        _billerResponseData!.customerName !=
                                            null)
                                      billerDetail(
                                          "Customer Name",
                                          _billerResponseData!.customerName
                                              .toString()),
                                    if (widget!.billName != null)
                                      billerDetail("Bill Name",
                                          widget!.billName.toString()),
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
                                        EdgeInsets.symmetric(vertical: 24.0),
                                    child: Text(
                                      "Additional Info",
                                      style: TextStyle(
                                        fontSize: 18,
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
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 4 / 2,
                                        mainAxisSpacing: 10,
                                      ),
                                      itemBuilder: (context, index) {
                                        return Container(
                                            // margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 10, 0, 0),
                                                    child: Text(
                                                      _additionalInfo!
                                                          .tag![index].name
                                                          .toString(),
                                                      // "Subscriber ID",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff808080),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 10, 0, 0),
                                                    child: Text(
                                                      _additionalInfo!
                                                          .tag![index].value
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
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
                                    left: 16, right: 16, top: 16, bottom: 16),
                                child: TextFormField(
                                  controller: txtAmountController,
                                  enabled: validateBill!["amountEditable"],
                                  onFieldSubmitted: (_) {},
                                  onChanged: (val) {
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
                                    left: 20, bottom: 20, right: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Payment Amount has to be between ₹ ${paymentInform?.mINLIMIT.toString()} and ₹ ${paymentInform?.mAXLIMIT.toString()}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: isInsufficient
                                          ? CLR_ERROR
                                          : TXT_CLR_PRIMARY,
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
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: MyAppButton(
                            onPressed: () {
                              goBack(context);
                            },
                            buttonText: "Cancel",
                            buttonTXT_CLR_DEFAULT: CLR_PRIMARY,
                            buttonBorderColor: Colors.transparent,
                            buttonColor: BTN_CLR_ACTIVE,
                            buttonSizeX: 10,
                            buttonSizeY: 40,
                            buttonTextSize: 14,
                            buttonTextWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        child: MyAppButton(
                            onPressed: () {
                              goToData(context, pAYMENTCONFIRMROUTE, {
                                "name": widget.billerData!.bILLERNAME,
                                "billName": widget.billName,
                                "billerData": widget.billerData,
                                "inputParameters": widget.inputParameters,
                                "categoryName": widget.billerData!.cATEGORYNAME,
                                "isSavedBill": false,
                                "amount": txtAmountController.text
                              });
                            },
                            buttonText: "Pay Now",
                            buttonTXT_CLR_DEFAULT: BTN_CLR_ACTIVE,
                            buttonBorderColor: Colors.transparent,
                            buttonColor:
                                isInsufficient ? Colors.grey : CLR_PRIMARY,
                            buttonSizeX: 10,
                            buttonSizeY: 40,
                            buttonTextSize: 14,
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
