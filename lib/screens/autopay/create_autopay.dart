import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getDaySuffix.dart';
import 'package:ebps/helpers/getDecodedAccount.dart';
import 'package:ebps/helpers/getMonthName.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getNearstHundered.dart';
import 'package:ebps/helpers/numberPrefixSetter.dart';
import 'package:ebps/models/account_info_model.dart';
import 'package:ebps/models/bbps_settings_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/services/api.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/date_picker_dialog.dart';
import 'package:ebps/widget/loader.dart';
import 'package:ebps/widget/getAccountInfoCard.dart';
import 'package:ebps/widget/get_biller_detail.dart';
import 'package:ebps/widget/loader_overlay.dart';
import 'package:ebps/widget/no_result.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class createAutopay extends StatefulWidget {
  String billerName;
  String categoryName;
  String billName;
  String customerBillID;
  String? lastPaidAmount;
  SavedBillersData? savedBillersdata;

  createAutopay(
      {super.key,
      required this.billerName,
      required this.categoryName,
      required this.billName,
      required this.customerBillID,
      required this.lastPaidAmount,
      this.savedBillersdata});

  @override
  State<createAutopay> createState() => _createAutopayState();
}

class _createAutopayState extends State<createAutopay> {
  int? limitGroupRadio = 1;
  int billPayGroupRadio = 0;
  String activatesFrom = "Immediately";
  bool isCreateAutopayPageError = false;

  bool isAccLoading = true;
  String? maximumAmount = "0";
  bool isMaxAmountEmpty = false;
  List<AccountsData>? accountInfo = [];

  dynamic maxAmountController = TextEditingController();
  dynamic dateController = TextEditingController();

  String? selectedDate = "1";
  dynamic selectedAcc = null;
  bool accError = false;
  bool maxAmountError = false;
  // bool isInputItemsLoading = true;
  // List<InputSignaturess>? InputItems = [];
  bool isMaxAmountLoading = true;
  bool isBbpsSettingsLoading = true;
  bbpsSettingsData? BbpsSettingInfo;
  final FocusNode MaxiFocusNode = FocusNode();

  // List<String> EffectiveFrom = <String>[
  //   'Immediately',
  //   getMonthName(billPayGroupRadio)[0]!,
  //   getMonthName(billPayGroupRadio)[1]!
  // ];

  @override
  void initState() {
    dateController.text = '1${getDaySuffix("1")}';
    BlocProvider.of<HomeCubit>(context).getBbpsSettings();

    BlocProvider.of<HomeCubit>(context).getAccountInfo(myAccounts);
    BlocProvider.of<MybillersCubit>(context).getAutoPayMaxAmount();
    super.initState();
  }

  var todayDate = DateTime.parse(DateTime.now().toString()).day.toString();

  @override
  void dispose() {
    MaxiFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: AppColors.CLR_BACKGROUND,
        appBar: MyAppBar(
            context: context,
            title: "Setup Autopay",
            onLeadingTap: () => GoBack(context),
            showActions: true,
            actions: [
              Tooltip(
                textStyle: TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                    color: AppColors.CLR_BLUE_LITE,
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
                    color: AppColors.CLR_ICON,
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

                      setState(() {
                        isAccLoading = false;
                      });
                    } else if (state is AccountInfoFailed) {
                      setState(() {
                        isAccLoading = false;
                      });
                    } else if (state is AccountInfoError) {
                      setState(() {
                        isAccLoading = false;
                      });
                    }

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
                    // if (state is EditBillLoading) {
                    //   isInputItemsLoading = true;
                    // } else if (state is EditBillSuccess) {
                    //   InputItems = state.EditBillList?.inputSignaturess;
                    //   isInputItemsLoading = false;
                    // } else if (state is EditBillFailed) {
                    //   isInputItemsLoading = false;
                    // } else if (state is EditBillError) {
                    //   isInputItemsLoading = false;
                    // }
                    if (state is FetchAutoPayMaxAmountLoading) {
                      isMaxAmountLoading = true;
                    } else if (state is FetchAutoPayMaxAmountSuccess) {
                      setState(() {
                        maximumAmount =
                            state.fetchAutoPayMaxAmountModel!.data.toString();
                        maxAmountController.text = maximumAmount;
                      });
                      isCreateAutopayPageError = false;
                      isMaxAmountLoading = false;
                    } else if (state is FetchAutoPayMaxAmountFailed) {
                      isCreateAutopayPageError = true;
                      isMaxAmountLoading = false;
                    } else if (state is FetchAutoPayMaxAmountError) {
                      isCreateAutopayPageError = true;
                      isMaxAmountLoading = false;
                    }
                  },
                ),
              ],
              child: !isCreateAutopayPageError
                  ? isMaxAmountLoading || isBbpsSettingsLoading
                      ? Container(
                          height: 500.h,
                          child: Center(child: Loader()),
                        )
                      : Column(children: [
                          ReusableContainer(
                              bottomMargin: 15.h,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Container(
                                      height: 40.h,
                                      padding: EdgeInsets.all(9.r),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(80.r),
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomRight,
                                              stops: [
                                                0.1,
                                                0.9
                                              ],
                                              colors: [
                                                AppColors.CLR_BLUE_LITE
                                                    .withOpacity(.16),
                                                Colors.transparent
                                              ])),
                                      width: 45.w,
                                      child: SvgPicture.asset(BILLER_LOGO(
                                          widget.billerName.toString())),
                                    ),
                                    title: Text(
                                      widget.billerName,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.TXT_CLR_BLACK_W,
                                      ),
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      widget.categoryName,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.TXT_CLR_LITE,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Divider(
                                    color: AppColors.CLR_CON_BORDER,
                                    height: 10.h,
                                    thickness: 0.5,
                                  ),
                                  billerdetail(
                                      widget.savedBillersdata!.pARAMETERS![0]
                                          .pARAMETERNAME
                                          .toString(),
                                      widget.savedBillersdata!.pARAMETERS![0]
                                          .pARAMETERVALUE
                                          .toString(),
                                      context),
                                  billerdetail(
                                      "Bill Name", widget.billName, context),
                                  if (widget.savedBillersdata!.bILLDATE != null)
                                    billerdetail(
                                        "Bill Date",
                                        DateFormat.yMMMMd('en_US').format(
                                            DateTime.parse(widget
                                                    .savedBillersdata!.bILLDATE!
                                                    .toString()
                                                    .substring(0, 10))
                                                .toLocal()
                                                .add(const Duration(days: 1))),
                                        context),
                                  if (widget.savedBillersdata!.dUEDATE != null)
                                    billerdetail(
                                        "Due Date",
                                        DateFormat.yMMMMd('en_US').format(
                                            DateTime.parse(widget
                                                    .savedBillersdata!.dUEDATE!
                                                    .toString()
                                                    .substring(0, 10))
                                                .toLocal()
                                                .add(const Duration(days: 1))),
                                        context),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 24.w, right: 24.w, bottom: 10.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Maximum Limit for Auto Payment: ",
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: AppColors.TXT_CLR_DEFAULT,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₹ ${NumberFormat('#,##,##0.00').format(double.parse(maximumAmount.toString()))}",
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: AppColors.CLR_GREEN,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),

                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: Padding(
                          //     padding:
                          //         EdgeInsets.only(left: 18.0.w, right: 18.w),
                          //     child: Text(
                          //       "Maximum Limit for Auto Payment: ₹ ${NumberFormat('#,##,##0.00').format(double.parse(maximumAmount.toString()))}",
                          //       style: TextStyle(
                          //         fontSize: 14.sp,
                          //         fontWeight: FontWeight.w600,
                          //         color: Color(0xff1b438b),
                          //       ),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          // ),
                          ReusableContainer(
                              topMargin: 5.h,
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
                                          activeColor:
                                              AppColors.TXT_CLR_PRIMARY,
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          fillColor:
                                              MaterialStateProperty.resolveWith(
                                            (states) {
                                              if (states.contains(
                                                  MaterialState.selected)) {
                                                return AppColors
                                                    .TXT_CLR_PRIMARY;
                                              }
                                              return AppColors.TXT_CLR_LITE;
                                            },
                                          ),
                                          title: Text(
                                            "Default Limit",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.TXT_CLR_SECONDARY,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: RadioListTile(
                                          value: 0,
                                          groupValue: limitGroupRadio,
                                          activeColor:
                                              AppColors.TXT_CLR_PRIMARY,
                                          fillColor:
                                              MaterialStateProperty.resolveWith(
                                            (states) {
                                              if (states.contains(
                                                  MaterialState.selected)) {
                                                return AppColors
                                                    .TXT_CLR_PRIMARY;
                                              }
                                              return AppColors.TXT_CLR_LITE;
                                            },
                                          ),
                                          onChanged: (val) {
                                            MaxiFocusNode.requestFocus();

                                            setState(() {
                                              limitGroupRadio = 0;
                                              final dataAmount = (double.parse(
                                                          widget.lastPaidAmount
                                                                      .toString() !=
                                                                  "null"
                                                              ? widget
                                                                  .lastPaidAmount
                                                                  .toString()
                                                              : "10000") +
                                                      (double.parse(widget
                                                                      .lastPaidAmount
                                                                      .toString() !=
                                                                  "null"
                                                              ? widget
                                                                  .lastPaidAmount
                                                                  .toString()
                                                              : "10000") *
                                                          0.3))
                                                  .toStringAsFixed(2);
                                              maxAmountController
                                                  .text = NearestHunderer(
                                                      double.parse(dataAmount))
                                                  .toStringAsFixed(0);
                                            });
                                            if (maximumAmount != null) {
                                              if (double.parse(
                                                          maxAmountController
                                                              .text
                                                              .toString()) >
                                                      double.parse(maximumAmount
                                                          .toString()) ||
                                                  double.parse(
                                                          maxAmountController
                                                              .text
                                                              .toString()) <
                                                      double.parse(widget
                                                          .lastPaidAmount
                                                          .toString())) {
                                                setState(() {
                                                  maxAmountError = true;
                                                });
                                              } else {
                                                setState(() {
                                                  maxAmountError = false;
                                                });
                                              }
                                            }
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          title: Text(
                                            "Your Custom Limit",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.TXT_CLR_SECONDARY,
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
                                      focusNode: MaxiFocusNode,
                                      // key: _billnameKey,
                                      autocorrect: false,
                                      readOnly:
                                          limitGroupRadio == 1 ? true : false,
                                      enableSuggestions: false,
                                      style: TextStyle(
                                          color: limitGroupRadio == 1
                                              ? AppColors.TXT_CLR_LITE
                                              : AppColors.TXT_CLR_BLACK),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(6),
                                        // DecimalTextInputFormatter(
                                        //     decimalRange: 2),
                                        // // getInputAmountFormatter(),
                                        // FilteringTextInputFormatter.allow(
                                        //     RegExp(r'^[0-9]*[.]{0,1}[0-9]*'))

                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9]*'))
                                      ],
                                      onChanged: (val) {
                                        if (val.isNotEmpty) {
                                          if (double.parse(val.toString()) >
                                              double.parse("0.00".toString())) {
                                            setState(() {
                                              isMaxAmountEmpty = false;
                                            });
                                          } else {
                                            isMaxAmountEmpty = true;
                                          }
                                          // isMaxAmountEmpty = false;

                                          if (double.parse(val.toString()) >
                                                  double.parse(maximumAmount
                                                      .toString()) ||
                                              double.parse(val.toString()) <
                                                  double.parse(widget
                                                      .lastPaidAmount
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
                                            isMaxAmountEmpty = true;
                                            maxAmountError = true;
                                          });
                                        }
                                      },
                                      validator: (inputValue) {
                                        if (inputValue!.isEmpty) {
                                          return "";
                                        }
                                      },
                                      decoration: InputDecoration(
                                          fillColor: limitGroupRadio == 0
                                              ? AppColors.CLR_INPUT_FILL
                                              : AppColors.TXT_CLR_GREY
                                                  .withOpacity(0.1),
                                          filled: true,
                                          prefixStyle: TextStyle(
                                              color: AppColors.TXT_CLR_DEFAULT),
                                          hintStyle: TextStyle(
                                              color: AppColors.TXT_CLR_LITE),
                                          labelStyle: TextStyle(
                                              color: limitGroupRadio == 1
                                                  ? AppColors.TXT_CLR_LITE
                                                  : AppColors.TXT_CLR_PRIMARY),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: limitGroupRadio == 1
                                                    ? AppColors.TXT_CLR_LITE
                                                    : AppColors
                                                        .TXT_CLR_PRIMARY),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: limitGroupRadio == 1
                                                    ? AppColors.TXT_CLR_LITE
                                                    : AppColors
                                                        .TXT_CLR_PRIMARY),
                                          ),
                                          border: const UnderlineInputBorder(),
                                          labelText: limitGroupRadio == 1
                                              ? 'Maximum Amount'
                                              : "Enter amount to be set as Limit",
                                          prefixText: '₹  ',
                                          hintText: "Maximum amount"),
                                    ),
                                  ),
                                  if (maxAmountError)
                                    if (isMaxAmountEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w, top: 0.h, right: 20.w),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Maximum Amount Can\'t be Empty or Zero.',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.CLR_ERROR,
                                            ),
                                          ),
                                        ),
                                      )
                                    else if (double.parse(
                                            maxAmountController.text.length > 0
                                                ? maxAmountController.text
                                                : "0".toString()) >
                                        double.parse(maximumAmount.toString()))
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w, top: 0.h, right: 20.w),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Entered Amount Should be not More than of ₹ ${NumberFormat('#,##,##0.00').format(double.parse(maximumAmount.toString()))}',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.CLR_ERROR,
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w, top: 0.h, right: 20.w),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Entered Amount is less than Latest or Last Bill Amount of ₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.lastPaidAmount.toString()))}',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.CLR_ORANGE,
                                            ),
                                          ),
                                        ),
                                      ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(
                                  //       left: 20.w, top: 10.h, right: 20.w),
                                  //   child: Align(
                                  //     alignment: Alignment.centerLeft,
                                  //     child: Text(
                                  //       'Amount Should be Between  ₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.lastPaidAmount.toString()))} to ₹ ${NumberFormat('#,##,##0.00').format(double.parse(maximumAmount.toString()))}',
                                  //       style: TextStyle(
                                  //         fontSize: 12.sp,
                                  //         fontWeight: FontWeight.w600,
                                  //         color: CLR_ERROR,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
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
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          color: AppColors.TXT_CLR_BLACK),

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
                                          fillColor: AppColors.CLR_INPUT_FILL,
                                          filled: true,
                                          labelStyle: TextStyle(
                                              fontSize: 15.sp,
                                              color: AppColors.TXT_CLR_PRIMARY),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    AppColors.TXT_CLR_PRIMARY),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    AppColors.TXT_CLR_PRIMARY),
                                          ),
                                          border: const UnderlineInputBorder(),
                                          labelText: 'Date of Payment',
                                          hintText: "Date of Payment"),
                                    ),
                                  ),
                                  if (selectedDate == "30")
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 18.0.w,
                                          right: 18.w,
                                          bottom: 10.h),
                                      child: Text(
                                        "In the month of February, payment will be done on 1st of March",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.TXT_CLR_LITE,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  if (selectedDate == todayDate &&
                                      activatesFrom == "Immediately")
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 18.0.w, right: 18.w),
                                      child: Text(
                                        "Cannot create auto payment if selected/set date is today's date",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.CLR_ERROR,
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 16.h),
                                    child: DropdownButtonFormField<String>(
                                      dropdownColor:
                                          AppColors.BTN_CLR_ACTIVE_TEXT,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0.r)),

                                      isExpanded: true,
                                      isDense: true,
                                      value: activatesFrom,
                                      decoration: InputDecoration(
                                        border: const UnderlineInputBorder(),
                                        filled: true,
                                        fillColor: AppColors.CLR_INPUT_FILL,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.TXT_CLR_PRIMARY),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.TXT_CLR_PRIMARY),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0.h, horizontal: 10.w),
                                        labelText:
                                            'Changes To Be Reflected From',
                                        labelStyle: TextStyle(
                                            color: AppColors.TXT_CLR_PRIMARY),
                                        hintText:
                                            'Changes To Be Reflected From',
                                        hintStyle: TextStyle(
                                            color: AppColors.TXT_CLR_PRIMARY),
                                      ),
                                      // hint: Text('Changes To Be Reflected From'),
                                      onChanged: (String? newValue) {},
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppColors.CLR_GREY,
                                      ),
                                      // style: TextStyle(
                                      //     color: AppColors.TXT_CLR_DEFAULT),
                                      items: [
                                        'Immediately',
                                        getMonthName(billPayGroupRadio)[0]!,
                                        getMonthName(billPayGroupRadio)[1]!
                                      ].map<DropdownMenuItem<String>>((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color:
                                                    AppColors.TXT_CLR_DEFAULT),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              activatesFrom = value;
                                            });
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
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.TXT_CLR_LITE,
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
                                          activeColor:
                                              AppColors.TXT_CLR_PRIMARY,
                                          fillColor:
                                              MaterialStateProperty.resolveWith(
                                            (states) {
                                              if (states.contains(
                                                  MaterialState.selected)) {
                                                return AppColors
                                                    .TXT_CLR_PRIMARY;
                                              }
                                              return AppColors.TXT_CLR_LITE;
                                            },
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              billPayGroupRadio = 0;
                                              activatesFrom = "Immediately";
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          title: Text(
                                            "Every Month",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.TXT_CLR_SECONDARY,
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
                                          activeColor:
                                              AppColors.TXT_CLR_PRIMARY,
                                          fillColor:
                                              MaterialStateProperty.resolveWith(
                                            (states) {
                                              if (states.contains(
                                                  MaterialState.selected)) {
                                                return AppColors
                                                    .TXT_CLR_PRIMARY;
                                              }
                                              return AppColors.TXT_CLR_LITE;
                                            },
                                          ),
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          title: Text(
                                            "Every Two Month",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.TXT_CLR_SECONDARY,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 18.0.w, right: 18.w),
                                    child: Text(
                                      "You can choose when you want to activate your auto pay setup by selecting an option from the dropdown. Based on your current selections, we will start attempting to pay your bills from ${activatesFrom == "Immediately" ? "the next" : ""} ${numberPrefixSetter(selectedDate!)} ${activatesFrom != "Immediately" ? activatesFrom : ""} and once ${billPayGroupRadio == 0 ? "every month" : "every two months"} after that.",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.TXT_CLR_LITE,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  )
                                ],
                              )),
                          ReusableContainer(
                              child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 18.0.w,
                                    right: 18.w,
                                    top: 18.h,
                                    bottom: 0.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Select Account Number",
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
                                      ? GridView.builder(
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
                                  color: AppColors.TXT_CLR_DEFAULT,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: AppColors.TXT_CLR_DEFAULT,
                                          fontWeight: FontWeight.w500),
                                      text:
                                          "By continuing, you agree to accept our "),
                                  TextSpan(
                                    text: "Terms and Conditions.",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        GoToData(
                                            context, tERMANDCONDITIONSROUTE, {
                                          "BbpsSettingInfo": BbpsSettingInfo
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
                        ])
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.only(
                          left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                      decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //   begin: Alignment.bottomCenter,
                        //   end: Alignment.topCenter,
                        //   colors: [
                        //     CLR_BLUESHADE.withOpacity(0.9),
                        //     Colors.white,
                        //   ],
                        //   stops: const [
                        //     0,
                        //     0.2,
                        //   ],
                        // ),
                        borderRadius: BorderRadius.circular(6.0.r + 2.r),
                        border: Border.all(
                          color: AppColors.CLR_CON_BORDER,
                          width: 0.50,
                        ),
                      ),
                      child: Center(
                        child: Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            height: 350.h,
                            child: noResult(
                              showTitle: false,
                              ErrIndex: 7,
                              ImgIndex: 5,
                              width: 130.h,
                            )),
                      ))),
        ),
        bottomSheet: !isCreateAutopayPageError
            ? Container(
                decoration: BoxDecoration(
                    color: AppColors.CLR_BACKGROUND,
                    border: Border(
                        top: BorderSide(
                            color: AppColors.CLR_CON_BORDER_LITE, width: 1))),
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
                            onPressed: () async {
                              if (selectedAcc != null &&
                                  !isMaxAmountEmpty &&
                                  !((double.parse(
                                          maxAmountController.text.length > 0
                                              ? maxAmountController.text
                                              : "0".toString()) >
                                      double.parse(
                                          maximumAmount.toString()))) &&
                                  !(selectedDate == todayDate &&
                                      activatesFrom == "Immediately")) {
                                Map<String, dynamic> decodedToken =
                                    await getDecodedToken();
                                List decodedToken2 =
                                    decodedToken["accounts"].toList();
                                var accID;
                                for (var i = 0; i < decodedToken2.length; i++) {
                                  if (decodedToken2[i]["accountID"] ==
                                      accountInfo![selectedAcc].accountNumber) {
                                    setState(() {
                                      accID = decodedToken2[i]["id"];
                                    });
                                  }
                                }
                                GoToData(context, oTPPAGEROUTE, {
                                  "from": "create-auto-pay",
                                  "templateName": "create-auto-pay",
                                  "context": context,
                                  "BillerName": widget.billerName,
                                  "BillName": widget.billName,
                                  "data": {
                                    "accountNumber": accID,
                                    "maximumAmount": maxAmountController.text,
                                    "paymentDate": selectedDate,
                                    "isBimonthly": billPayGroupRadio,
                                    "activatesFrom":
                                        activatesFrom == "Immediately"
                                            ? null
                                            : activatesFrom.toLowerCase(),
                                    "isActive":
                                        activatesFrom == "Immediately" ? 1 : 0,
                                    "billID": widget.customerBillID,
                                    "billerName": widget.billerName,
                                    "amountLimit": limitGroupRadio
                                  }
                                });
                              }
                            },
                            buttonText: "Create",
                            buttonTxtColor: selectedAcc != null &&
                                    !isMaxAmountEmpty &&
                                    !((double.parse(
                                            maxAmountController.text.length > 0
                                                ? maxAmountController.text
                                                : "0".toString()) >
                                        double.parse(
                                            maximumAmount.toString()))) &&
                                    !(selectedDate == todayDate &&
                                        activatesFrom == "Immediately")
                                ? AppColors.BTN_CLR_ACTIVE_ALTER_TEXT
                                : AppColors.BTN_CLR_DISABLE_TEXT,
                            buttonBorderColor: Colors.transparent,
                            buttonColor: selectedAcc != null &&
                                    !isMaxAmountEmpty &&
                                    !((double.parse(
                                            maxAmountController.text.length > 0
                                                ? maxAmountController.text
                                                : "0".toString()) >
                                        double.parse(
                                            maximumAmount.toString()))) &&
                                    !(selectedDate == todayDate &&
                                        activatesFrom == "Immediately")
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
              )
            : null,
      ),
    );
  }
}
