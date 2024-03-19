import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/MyBillers/bill_details_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getDaySuffix.dart';
import 'package:ebps/helpers/getDecodedAccount.dart';
import 'package:ebps/helpers/getMonthName.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/numberPrefixSetter.dart';
import 'package:ebps/models/account_info_model.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/models/bbps_settings_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/services/api.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/date_picker_dialog.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:ebps/widget/getAccountInfoCard.dart';
import 'package:ebps/widget/loader_overlay.dart';
import 'package:ebps/widget/no_result.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class editAutopay extends StatefulWidget {
  AllConfigurationsData? autopayData;
  bool AutoDateMisMatch;
  bool DebitLimitMisMatch;
  SavedBillersData savedBillerData;

  editAutopay({
    super.key,
    required this.AutoDateMisMatch,
    required this.DebitLimitMisMatch,
    this.autopayData,
    required this.savedBillerData,
  });

  @override
  State<editAutopay> createState() => _editAutopayState();
}

class _editAutopayState extends State<editAutopay> {
  int? limitGroupRadio = 0;
  int? billPayGroupRadio = 0;
  String activatesFrom = "Immediately";

  bool isAccLoading = true;
  String? maximumAmount = "0";

  List<AccountsData>? accountInfo = [];
  bool isBbpsSettingsLoading = true;
  bbpsSettingsData? BbpsSettingInfo;
  dynamic maxAmountController = TextEditingController();
  dynamic dateController = TextEditingController();

  String? selectedDate = "1";
  String? lastPaidAmount = "0";
  dynamic selectedAcc = null;
  bool accError = false;
  bool maxAmountError = false;
  bool isAutoPayMaxLoading = true;
  bool isEditAutoPayPageError = false;
  List<String> EffectiveFrom = <String>['Immediately', getMonthName(0)[0]!];

  var todayDate = DateTime.parse(DateTime.now().toString()).day.toString();

  int? isActive = 0;

  @override
  void initState() {
    selectedDate = widget.autopayData!.pAYMENTDATE;
    dateController.text =
        '${widget.autopayData!.pAYMENTDATE.toString()}${getDaySuffix(widget.autopayData!.pAYMENTDATE.toString())}';
    limitGroupRadio = widget.autopayData!.aMOUNTLIMIT ?? 0;
    billPayGroupRadio = widget.autopayData!.iSBIMONTHLY ?? 0;
    maxAmountController.text =
        double.parse(widget.autopayData!.mAXIMUMAMOUNT.toString())
            .toStringAsFixed(2);
    activatesFrom = widget.autopayData!.aCTIVATESFROM != null
        ? widget.autopayData!.aCTIVATESFROM![0].toUpperCase() +
            widget.autopayData!.aCTIVATESFROM!.substring(1)
        : "Immediately";
    isActive = widget.autopayData?.iSACTIVE;
    lastPaidAmount = widget.savedBillerData.bILLAMOUNT != null
        ? widget.savedBillerData.bILLAMOUNT.toString()
        : widget.autopayData!.dUEAMOUNT.toString();
    BlocProvider.of<HomeCubit>(context).getBbpsSettings();

    BlocProvider.of<HomeCubit>(context).getAccountInfo(myAccounts);
    BlocProvider.of<MybillersCubit>(context).getAutoPayMaxAmount();

    super.initState();
  }

  handleButton() {
    bool? HandleActivate;

    if (billPayGroupRadio == widget.autopayData!.iSBIMONTHLY) {
      if ((widget.autopayData!.aCTIVATESFROM ?? "Immediately") ==
          activatesFrom) {
        HandleActivate = true;
      } else {
        HandleActivate = false;
      }
    } else {
      HandleActivate = false;
    }
    // if ((billPayGroupRadio == widget.autopayData!.iSBIMONTHLY ||
    //     ((widget.autopayData!.aCTIVATESFROM ?? "Immediately") ==
    //         activatesFrom))) {
    // } else {
    //   HandleActivate = false;
    // }

    if (selectedAcc == null ||
        selectedAcc == 99 ||
        // accError ||
        widget.autopayData!.pAYMENTDATE.toString() == todayDate ||
        ((widget.autopayData!.pAYMENTDATE == todayDate ||
                selectedDate == todayDate) &&
            activatesFrom == "Immediately") ||
        maxAmountError ||
        ((double.parse(widget.autopayData!.mAXIMUMAMOUNT.toString()) ==
                double.parse(maxAmountController.text.toString())) &&
            widget.autopayData!.pAYMENTDATE.toString() == selectedDate &&
            HandleActivate)) {
      return false;
    } else {
      return true;
    }
  }

  handleAutopayUpdate() async {
    if (handleButton()) {
      Map<String, dynamic> decodedToken = await getDecodedToken();
      List decodedToken2 = decodedToken["accounts"].toList();
      var accID;
      for (var i = 0; i < decodedToken2.length; i++) {
        if (decodedToken2[i]["accountID"] ==
            accountInfo![selectedAcc].accountNumber) {
          setState(() {
            accID = decodedToken2[i]["id"];
          });
        }
      }
      goToData(context, oTPPAGEROUTE, {
        "from": "edit-auto-pay",
        "templateName": "edit-auto-pay",
        "context": context,
        "BillerName": widget.savedBillerData.bILLERNAME,
        "BillName": widget.savedBillerData.bILLNAME,
        "autopayData": widget.autopayData,
        "data": {
          "accountNumber": accID,
          "maximumAmount": maxAmountController.text,
          "paymentDate": selectedDate,
          "isBimonthly": billPayGroupRadio,
          "activatesFrom": activatesFrom == "Immediately"
              ? null
              : activatesFrom.toLowerCase(),
          "isActive": isActive,
          "billID": widget.savedBillerData.cUSTOMERBILLID,
          "billerName": widget.savedBillerData.bILLERNAME,
          "amountLimit": limitGroupRadio,
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: MyAppBar(
            context: context,
            title: "Edit Autopay",
            onLeadingTap: () => goBack(context),
            showActions: true,
            actions: [
              Tooltip(
                textStyle: TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                    color: CLR_BLUE_LITE,
                    borderRadius: BorderRadius.circular(8.0.r)),
                triggerMode: TooltipTriggerMode.tap,
                showDuration: Duration(milliseconds: 20000),
                padding: EdgeInsets.all(20.r),
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                message:
                    "Autopay will be enabled from the 1st of the month you selected while setting up the autopay and payments will be made from the date selected for autopay execution. Until the autopay is enabled, you cannot edit it. To edit the auto pay that is not enabled yet, please wait till the autopay is enabled in the month selected during creation or delete the autopay and create a new one.",
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.info_outline,
                    color: CLR_PRIMARY,
                  ),
                ),
              ),
            ]),
        body: SingleChildScrollView(
          child: MultiBlocListener(
            listeners: [
              BlocListener<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is AccountInfoLoading) {
                    setState(() {
                      isAccLoading = true;
                    });
                  } else if (state is AccountInfoSuccess) {
                    accountInfo = state.accountInfo;

                    for (var i = 0; i < accountInfo!.length; i++) {
                      if (accountInfo![i].accountNumber.toString() ==
                          widget.autopayData!.aCCOUNTNUMBER.toString()) {
                        selectedAcc = i;
                      }
                    }

                    setState(() {
                      isAccLoading = false;
                    });
                  } else if (state is AccountInfoFailed) {
                    setState(() {
                      isAccLoading = false;
                    });
                  } else if (state is AccountInfoError) {}
                  if (state is BbpsSettingsLoading) {
                    isBbpsSettingsLoading = true;
                  } else if (state is BbpsSettingsSuccess) {
                    isBbpsSettingsLoading = false;

                    setState(() {
                      BbpsSettingInfo = state.BbpsSettingsDetail!.data;
                    });
                  } else if (state is BbpsSettingsFailed) {
                    isBbpsSettingsLoading = false;
                  } else if (state is BbpsSettingsError) {
                    isBbpsSettingsLoading = false;
                  }
                },
              ),
              BlocListener<MybillersCubit, MybillersState>(
                listener: (context, state) {
                  if (state is FetchAutoPayMaxAmountLoading) {
                    isAutoPayMaxLoading = true;
                  } else if (state is FetchAutoPayMaxAmountSuccess) {
                    isAutoPayMaxLoading = false;
                    isEditAutoPayPageError = false;
                    setState(() {
                      maximumAmount =
                          state.fetchAutoPayMaxAmountModel!.data.toString();
                    });
                  } else if (state is FetchAutoPayMaxAmountFailed) {
                    isAutoPayMaxLoading = false;
                    isEditAutoPayPageError = true;
                  } else if (state is FetchAutoPayMaxAmountError) {
                    isAutoPayMaxLoading = false;
                    isEditAutoPayPageError = true;
                  }
                },
              ),
            ],
            child: !isEditAutoPayPageError
                ? SizedBox(
                    child: isAutoPayMaxLoading || isBbpsSettingsLoading
                        ? Center(
                            child: Container(
                              height: 500.h,
                              child: FlickrLoader(),
                            ),
                          )
                        : Column(children: [
                            if (widget.AutoDateMisMatch)
                              Container(
                                  clipBehavior: Clip.hardEdge,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      left: 18.0.w,
                                      right: 18.w,
                                      top: 10.h,
                                      bottom: 15.h),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(6.0.r + 2.r),
                                      color: CLR_ERROR
                                      // border: Border.all(
                                      //   color: Color(0xffD1D9E8),
                                      //   width: 1.0,
                                      // ),
                                      ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0.r),
                                    child: Text(
                                      "Autopay date seems to be mismatched with the due date.",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            if (widget.DebitLimitMisMatch)
                              Container(
                                  clipBehavior: Clip.hardEdge,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      left: 18.0.w,
                                      right: 18.w,
                                      top: 10.h,
                                      bottom: 15.h),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(6.0.r + 2.r),
                                      color: CLR_ERROR
                                      // border: Border.all(
                                      //   color: Color(0xffD1D9E8),
                                      //   width: 1.0,
                                      // ),
                                      ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0.r),
                                    child: Text(
                                      "Autopay Amount Limit seems to be mismatched with the due Amount.",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            Container(
                                clipBehavior: Clip.hardEdge,
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: 18.0.w,
                                    right: 18.w,
                                    top: 5.h,
                                    bottom: 15.h),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(6.0.r + 2.r),
                                  border: Border.all(
                                    color: Color(0xffD1D9E8),
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Container(
                                        width: 50.w,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0.r),
                                          child: SvgPicture.asset(BILLER_LOGO(
                                              widget.savedBillerData.bILLERNAME
                                                  .toString())),
                                        ),
                                      ),
                                      title: Text(
                                        widget.savedBillerData.bILLERNAME
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff191919),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      subtitle: Text(
                                        widget.savedBillerData.bILLNAME
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff808080),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Divider(
                                      height: 10.h,
                                      thickness: 1,
                                      indent: 10.w,
                                      endIndent: 10.w,
                                    ),
                                    billDetailsContainer(
                                        title: widget.savedBillerData
                                            .pARAMETERS![0].pARAMETERNAME
                                            .toString(),
                                        subTitle: widget.savedBillerData
                                            .pARAMETERS![0].pARAMETERVALUE
                                            .toString()),
                                    billDetailsContainer(
                                        title: "Bill Name",
                                        subTitle: widget
                                            .savedBillerData.bILLNAME
                                            .toString()),
                                    if (widget.savedBillerData!.bILLDATE !=
                                        null)
                                      billDetailsContainer(
                                          title: "Bill Date",
                                          subTitle: DateFormat('dd/MM/yyyy')
                                              .format(DateTime.parse(widget
                                                      .savedBillerData!
                                                      .bILLDATE!
                                                      .toString()
                                                      .substring(0, 10))
                                                  .toLocal()
                                                  .add(const Duration(
                                                      days: 1)))),
                                    if (widget.savedBillerData!.dUEDATE != null)
                                      billDetailsContainer(
                                          title: "Due Date",
                                          subTitle: DateFormat('dd/MM/yyyy')
                                              .format(DateTime.parse(widget
                                                      .savedBillerData!.dUEDATE!
                                                      .toString()
                                                      .substring(0, 10))
                                                  .toLocal()
                                                  .add(const Duration(
                                                      days: 1)))),
                                  ],
                                )),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 18.0.w, right: 18.w),
                                child: Text(
                                  "Limit: ₹ ${NumberFormat('#,##,##0.00').format(double.parse(maximumAmount.toString()))}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1b438b),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                                clipBehavior: Clip.hardEdge,
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: 18.0.w,
                                    right: 18.w,
                                    top: 5.h,
                                    bottom: 10.h),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(6.0.r + 2.r),
                                  border: Border.all(
                                    color: Color(0xffD1D9E8),
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: RadioListTile(
                                            value: 1,
                                            groupValue: limitGroupRadio,
                                            onChanged: (val) {
                                              setState(() {
                                                maxAmountController.text =
                                                    maximumAmount;
                                                limitGroupRadio = 1;
                                                maxAmountError = false;
                                              });
                                            },
                                            activeColor: TXT_CLR_PRIMARY,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: Text(
                                              "Default Limit",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff313131),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: RadioListTile(
                                            value: 0,
                                            groupValue: limitGroupRadio,
                                            activeColor: TXT_CLR_PRIMARY,
                                            onChanged: (val) {
                                              setState(() {
                                                limitGroupRadio = 0;
                                                if (widget.autopayData!
                                                        .aMOUNTLIMIT ==
                                                    0) {
                                                  maxAmountController.text =
                                                      widget.autopayData!
                                                          .mAXIMUMAMOUNT
                                                          .toStringAsFixed(2);
                                                } else {
                                                  maxAmountController
                                                      .text = (double.parse(
                                                          lastPaidAmount
                                                                      .toString() !=
                                                                  "null"
                                                              ? lastPaidAmount
                                                                  .toString()
                                                              : "10000")
                                                      .toStringAsFixed(2));
                                                }
                                              });
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: Text(
                                              "Set Bill Limit",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff313131),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 16.h),
                                      child: TextFormField(
                                        // maxLength: 20,
                                        controller: maxAmountController,
                                        // key: _billnameKey,
                                        autocorrect: false,
                                        readOnly:
                                            limitGroupRadio == 1 ? true : false,
                                        enableSuggestions: false,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            color: limitGroupRadio == 1
                                                ? TXT_CLR_LITE
                                                : null),

                                        inputFormatters: [
                                          // getInputAmountFormatter(),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^[0-9]*'))
                                        ],
                                        onChanged: (val) {
                                          if (val.isNotEmpty) {
                                            if (double.parse(val.toString()) >
                                                    double.parse(maximumAmount
                                                        .toString()) ||
                                                double.parse(val.toString()) <
                                                    double.parse(lastPaidAmount
                                                        .toString())) {
                                              setState(() {
                                                maxAmountError = true;
                                              });
                                            } else {
                                              setState(() {
                                                maxAmountError = false;
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              maxAmountError = true;
                                            });
                                          }
                                        },
                                        validator: (inputValue) {
                                          if (inputValue!.isEmpty) {
                                            return "Bill Name Should Not be Empty";
                                          }
                                        },
                                        decoration: InputDecoration(
                                            fillColor: const Color(0xffD1D9E8)
                                                .withOpacity(0.2),
                                            filled: true,
                                            labelStyle: TextStyle(
                                                color: limitGroupRadio == 1
                                                    ? TXT_CLR_LITE
                                                    : TXT_CLR_PRIMARY),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: limitGroupRadio == 1
                                                      ? TXT_CLR_LITE
                                                      : Color(0xff1B438B)),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff1B438B)),
                                            ),
                                            border:
                                                const UnderlineInputBorder(),
                                            labelText: 'Maximum Amount',
                                            prefixText: '₹  ',
                                            hintText: "Enter maximum amount"),
                                      ),
                                    ),
                                    if (maxAmountError)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w, top: 0.h, right: 20.w),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Amount Should be Between  ₹ ${NumberFormat('#,##,##0.00').format(double.parse(lastPaidAmount.toString()))} to ₹ ${NumberFormat('#,##,##0.00').format(double.parse(maximumAmount.toString()))}',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: CLR_ERROR,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 16.h),
                                      child: TextFormField(
                                        // maxLength: 20,
                                        controller: dateController,
                                        readOnly: true,
                                        // key: _billnameKey,
                                        autocorrect: false,
                                        enableSuggestions: false,
                                        keyboardType: TextInputType.text,
                                        // inputFormatters: [
                                        //   FilteringTextInputFormatter.allow(
                                        //       RegExp(r'^[a-z0-9A-Z ]*'))
                                        // ],
                                        onChanged: (val) {},
                                        onTap: () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DateDialog(
                                                defaultDate: selectedDate,
                                                onDateSelected: (Date) {
                                                  setState(() {
                                                    selectedDate = Date;
                                                    dateController.text =
                                                        '$selectedDate${getDaySuffix(Date)}';
                                                  });
                                                },
                                              );
                                            },
                                          );
                                        },
                                        validator: (inputValue) {},
                                        decoration: InputDecoration(
                                            fillColor: const Color(0xffD1D9E8)
                                                .withOpacity(0.2),
                                            filled: true,
                                            labelStyle: const TextStyle(
                                                color: Color(0xff1b438b)),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff1B438B)),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff1B438B)),
                                            ),
                                            border:
                                                const UnderlineInputBorder(),
                                            labelText: 'Date of Payment',
                                            hintText: "Date of Payment"),
                                      ),
                                    ),
                                    if (selectedDate == "30")
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 18.0.w, right: 18.w),
                                        child: Text(
                                          "In the month of February, payment will be done on 1st of March",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff808080),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    if ((widget.autopayData!.pAYMENTDATE ==
                                                todayDate ||
                                            selectedDate == todayDate) &&
                                        activatesFrom == "Immediately")
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 18.0.w, right: 18.w),
                                        child: Text(
                                          "Cannot edit auto payment if selected/set date is today's date",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600,
                                            color: CLR_ERROR,
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 16.h),
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        isDense: true,
                                        value: activatesFrom,
                                        decoration: InputDecoration(
                                          border: const UnderlineInputBorder(),
                                          filled: true,
                                          fillColor: Color(0xffD1D9E8)
                                              .withOpacity(0.2),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff1B438B)),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff1B438B)),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0.h,
                                              horizontal: 10.w),
                                          labelText:
                                              'Changes To Be Reflected From',
                                          labelStyle: const TextStyle(
                                              color: Color(0xff1b438b)),
                                          hintText:
                                              'Changes To Be Reflected From',
                                          hintStyle: const TextStyle(
                                              color: Color(0xff1b438b)),
                                        ),
                                        // hint: Text('Changes To Be Reflected From'),
                                        onChanged: (String? newValue) {},
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.grey,
                                        ),
                                        items: EffectiveFrom.map<
                                            DropdownMenuItem<String>>((value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                activatesFrom = value;
                                              });

                                              if (activatesFrom ==
                                                  "Immediately") {
                                                setState(() {
                                                  isActive = 1;
                                                });
                                              } else {
                                                setState(() {
                                                  isActive = 0;
                                                });
                                              }
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 18.0.w, right: 18.w),
                                        child: Text(
                                          "We Pay Your Bills Once ",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff808080),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: RadioListTile(
                                            value: 0,
                                            groupValue: billPayGroupRadio,
                                            activeColor: TXT_CLR_PRIMARY,
                                            onChanged: (val) {
                                              setState(() {
                                                billPayGroupRadio = 0;
                                                activatesFrom = "Immediately";
                                              });
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: Text(
                                              "Every Month",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff313131),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: RadioListTile(
                                            value: 1,
                                            groupValue: billPayGroupRadio,
                                            onChanged: (val) {
                                              setState(() {
                                                billPayGroupRadio = 1;
                                                activatesFrom = "Immediately";
                                              });
                                            },
                                            activeColor: TXT_CLR_PRIMARY,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: Text(
                                              "Every Two Month",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff313131),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (activatesFrom == getMonthName(0)[0]!)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 18.0.w, right: 18.w),
                                        child: Text(
                                          "Your auto pay will stay inactive and we will resume paying your bills only from ${numberPrefixSetter(selectedDate!)}, ${getMonthName(0)[0]!}. If you want us to pay your bills on the  ${numberPrefixSetter(selectedDate!)} of this (current) month, please select Immediately from the dropdown.",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff808080),
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    SizedBox(
                                      height: 10.h,
                                    )
                                  ],
                                )),
                            Container(
                                clipBehavior: Clip.hardEdge,
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: 18.0.w,
                                    right: 18.w,
                                    top: 5.h,
                                    bottom: 10.h),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(6.0.r + 2.r),
                                  border: Border.all(
                                    color: Color(0xffD1D9E8),
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 18.0.w,
                                          right: 18.w,
                                          top: 18.h,
                                          bottom: 4.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Select Account Number",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff1b438b),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.refresh,
                                                color: Colors.grey),
                                            onPressed: () {
                                              setState(() {
                                                selectedAcc = null;
                                                accError = false;
                                              });
                                              BlocProvider.of<HomeCubit>(
                                                      context)
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
                                    if (!isAccLoading && myAccounts!.length > 0)
                                      Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: accountInfo!.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            // itemCount: accountInfo!.length,
                                            childAspectRatio: 5 / 3.1,
                                            mainAxisSpacing: 10.0,
                                          ),
                                          itemBuilder: (context, index) {
                                            return AccountInfoCard(
                                              showAccDetails: true,
                                              accountNumber: accountInfo![index]
                                                  .accountNumber
                                                  .toString(),
                                              balance:
                                                  accountInfo![index].balance,
                                              onAccSelected: (Date) {
                                                setState(() {
                                                  selectedAcc = index;
                                                });
                                                // if (accountInfo![index].balance ==
                                                //     "Unable to fetch balance") {
                                                //   setState(() {
                                                //     accError = true;
                                                //   });
                                                // } else {
                                                //   setState(() {
                                                //     accError = false;
                                                //   });
                                                // }
                                              },
                                              index: index,
                                              AccErr: accError,
                                              isSelected: selectedAcc,
                                            );
                                          },
                                        ),
                                      ),
                                    // if (accError)
                                    //   Padding(
                                    //     padding: EdgeInsets.only(
                                    //         left: 20.w, top: 10.h, right: 20.w),
                                    //     child: Align(
                                    //       alignment: Alignment.centerLeft,
                                    //       child: Text(
                                    //         'Insufficient balance in the account',
                                    //         style: TextStyle(
                                    //           fontSize: 12.sp,
                                    //           fontWeight: FontWeight.w600,
                                    //           color: CLR_ERROR,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.w, top: 10.h, right: 20.w),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: TXT_CLR_DEFAULT,
                                            fontWeight: FontWeight.w500),
                                        text:
                                            "By continuing, you agree to accept our "),
                                    TextSpan(
                                      text: "Terms and Conditions.",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          goToData(
                                              context, tERMANDCONDITIONSROUTE, {
                                            "BbpsSettingInfo": BbpsSettingInfo
                                          });
                                        },
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: TXT_CLR_PRIMARY,
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
                          ]),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(
                        left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0.r + 2.r),
                      border: Border.all(
                        color: Color(0xffD1D9E8),
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: 350.h,
                          child: noResult(
                            showTitle: false,
                            ErrIndex: 9,
                            ImgIndex: 5,
                            width: 130.h,
                          )),
                    )),
          ),
        ),
        bottomSheet: !isEditAutoPayPageError
            ? Container(
                decoration: const BoxDecoration(
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
                            onPressed: () async {
                              handleAutopayUpdate();
                            },
                            buttonText: "Update",
                            buttonTxtColor: BTN_CLR_ACTIVE,
                            buttonBorderColor: Colors.transparent,
                            buttonColor:
                                handleButton() ? CLR_PRIMARY : Colors.grey,
                            buttonSizeX: 10.h,
                            buttonSizeY: 40.w,
                            buttonTextSize: 14.sp,
                            buttonTextWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
