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
import 'package:ebps/models/account_info_model.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/models/edit_bill_modal.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/services/api.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/centralized_grid_view.dart';
import 'package:ebps/widget/date_picker_dialog.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:ebps/widget/getAccountInfoCard.dart';
import 'package:ebps/widget/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class editAutopay extends StatefulWidget {
  String billerName;
  String categoryName;
  String billName;
  String customerBillID;
  AllConfigurationsData? autopayData;
  String? lastPaidAmount;
  bool AutoDateMisMatch;
  bool DebitLimitMisMatch;

  editAutopay(
      {super.key,
      required this.billerName,
      required this.categoryName,
      required this.billName,
      required this.customerBillID,
      required this.AutoDateMisMatch,
      required this.DebitLimitMisMatch,
      this.autopayData,
      required this.lastPaidAmount});

  @override
  State<editAutopay> createState() => _editAutopayState();
}

class _editAutopayState extends State<editAutopay> {
  int? limitGroupRadio = 0;
  int? billPayGroupRadio = 0;
  String activatesFrom = "Immediately";

  bool isAccLoading = true;
  String? maximumAmount = "0";
  List<InputSignaturess>? InputItems = [];

  List<AccountsData>? accountInfo = [];

  // final GlobalKey<FormFieldState> _billnameKey = GlobalKey<FormFieldState>();
  dynamic maxAmountController = TextEditingController();
  dynamic dateController = TextEditingController();

  String? selectedDate = "1";
  dynamic selectedAcc = null;
  bool accError = false;
  bool maxAmountError = false;
  bool isInputItemsLoading = true;

  List<String> EffectiveFrom = <String>[
    'Immediately',
    getMonthName(0)[0]!,
    getMonthName(0)[1]!
  ];

  int? isActive = 0;

  @override
  void initState() {
    selectedDate = widget.autopayData!.pAYMENTDATE;
    dateController.text =
        '${widget.autopayData!.pAYMENTDATE.toString()}${getDaySuffix(widget.autopayData!.pAYMENTDATE.toString())}';
    limitGroupRadio = widget.autopayData!.aMOUNTLIMIT ?? 0;
    maxAmountController.text = widget.autopayData!.mAXIMUMAMOUNT.toString();
    activatesFrom = widget.autopayData!.aCTIVATESFROM != null
        ? widget.autopayData!.aCTIVATESFROM![0].toUpperCase() +
            widget.autopayData!.aCTIVATESFROM!.substring(1)
        : "Immediately";
    isActive = widget.autopayData?.iSACTIVE;
    BlocProvider.of<HomeCubit>(context).getAccountInfo(myAccounts);
    BlocProvider.of<MybillersCubit>(context).getAutoPayMaxAmount();
    BlocProvider.of<MybillersCubit>(context)
        .getEditBillItems(widget.autopayData!.cUSTOMERBILLID);
    super.initState();
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
                showDuration: Duration(milliseconds: 6500),
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
                },
              ),
              BlocListener<MybillersCubit, MybillersState>(
                listener: (context, state) {
                  if (state is EditBillLoading) {
                    isInputItemsLoading = true;
                  } else if (state is EditBillSuccess) {
                    InputItems = state.EditBillList?.inputSignaturess;
                    isInputItemsLoading = false;
                  } else if (state is EditBillFailed) {
                    isInputItemsLoading = false;
                  } else if (state is EditBillError) {
                    isInputItemsLoading = false;
                  }
                  if (state is FetchAutoPayMaxAmountLoading) {
                  } else if (state is FetchAutoPayMaxAmountSuccess) {
                    setState(() {
                      maximumAmount =
                          state.fetchAutoPayMaxAmountModel!.data.toString();
                    });
                  } else if (state is FetchAutoPayMaxAmountFailed) {
                  } else if (state is FetchAutoPayMaxAmountError) {}
                },
              ),
            ],
            child: Column(children: [
              if (widget.AutoDateMisMatch)
                Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 18.0.w, right: 18.w, top: 10.h, bottom: 15.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0.r + 2.r),
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
                        left: 18.0.w, right: 18.w, top: 10.h, bottom: 15.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0.r + 2.r),
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
                      left: 18.0.w, right: 18.w, top: 5.h, bottom: 15.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0.r + 2.r),
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
                            child: SvgPicture.asset(LOGO_BBPS),
                          ),
                        ),
                        title: Text(
                          widget.billerName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff191919),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          widget.billName,
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
                      if (!isInputItemsLoading)
                        billDetailsContainer(
                            title: InputItems![0].pARAMETERNAME.toString(),
                            subTitle: InputItems![0].pARAMETERVALUE.toString()),
                      billDetailsContainer(
                          title: "Bill Name", subTitle: widget.billName)
                    ],
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(left: 18.0.w, right: 18.w),
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
                      left: 18.0.w, right: 18.w, top: 5.h, bottom: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0.r + 2.r),
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
                                  maxAmountController.text = maximumAmount;
                                  limitGroupRadio = 1;
                                  maxAmountError = false;
                                });
                              },
                              activeColor: TXT_CLR_PRIMARY,
                              controlAffinity: ListTileControlAffinity.trailing,
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
                                  maxAmountController.text = widget
                                      .autopayData!.mAXIMUMAMOUNT
                                      .toStringAsFixed(2);
                                });
                              },
                              controlAffinity: ListTileControlAffinity.trailing,
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
                          readOnly: limitGroupRadio == 1 ? true : false,
                          enableSuggestions: false,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color:
                                  limitGroupRadio == 1 ? TXT_CLR_LITE : null),

                          inputFormatters: [
                            // getInputAmountFormatter(),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9]*'))
                          ],
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              if (double.parse(val.toString()) >
                                      double.parse(maximumAmount.toString()) ||
                                  double.parse(val.toString()) <
                                      double.parse(
                                          widget.lastPaidAmount.toString())) {
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
                              fillColor:
                                  const Color(0xffD1D9E8).withOpacity(0.2),
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
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff1B438B)),
                              ),
                              border: const UnderlineInputBorder(),
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
                              'Amount Should be Between  ₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.lastPaidAmount.toString()))} to ₹ ${NumberFormat('#,##,##0.00').format(double.parse(maximumAmount.toString()))}',
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
                              fillColor:
                                  const Color(0xffD1D9E8).withOpacity(0.2),
                              filled: true,
                              labelStyle:
                                  const TextStyle(color: Color(0xff1b438b)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff1B438B)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff1B438B)),
                              ),
                              border: const UnderlineInputBorder(),
                              labelText: 'Date of Payment',
                              hintText: "Date of Payment"),
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
                            fillColor: Color(0xffD1D9E8).withOpacity(0.2),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff1B438B)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff1B438B)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0.h, horizontal: 10.w),
                            labelText: 'Changes To Be Reflected From',
                            labelStyle:
                                const TextStyle(color: Color(0xff1b438b)),
                            hintText: 'Changes To Be Reflected From',
                            hintStyle:
                                const TextStyle(color: Color(0xff1b438b)),
                          ),
                          // hint: Text('Changes To Be Reflected From'),
                          onChanged: (String? newValue) {},
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          items: EffectiveFrom.map<DropdownMenuItem<String>>(
                              (value) {
                            print(value);
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                              onTap: () {
                                setState(() {
                                  activatesFrom = value;
                                });

                                if (activatesFrom == "Immediately") {
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
                          padding: EdgeInsets.only(left: 18.0.w, right: 18.w),
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
                              controlAffinity: ListTileControlAffinity.trailing,
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
                              controlAffinity: ListTileControlAffinity.trailing,
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
                      SizedBox(
                        height: 10.h,
                      )
                    ],
                  )),
              Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      left: 18.0.w, right: 18.w, top: 5.h, bottom: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0.r + 2.r),
                    border: Border.all(
                      color: Color(0xffD1D9E8),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 18.0.w, right: 18.w, top: 18.h, bottom: 4.h),
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
                              icon:
                                  const Icon(Icons.refresh, color: Colors.grey),
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
                              // itemCount: accountInfo!.length,
                              childAspectRatio: 5 / 3.5,
                              mainAxisSpacing: 10.0,
                            ),
                            itemBuilder: (context, index) {
                              return AccountInfoCard(
                                accountNumber: accountInfo![index]
                                    .accountNumber
                                    .toString(),
                                balance: accountInfo![index].balance.toString(),
                                onAccSelected: (Date) {
                                  setState(() {
                                    selectedAcc = index;
                                  });
                                  if (accountInfo![index].balance ==
                                      "Unable to fetch balance") {
                                    setState(() {
                                      accError = true;
                                    });
                                  } else {
                                    setState(() {
                                      accError = false;
                                    });
                                  }
                                },
                                index: index,
                                AccErr: accError,
                                isSelected: selectedAcc,
                              );
                            },
                          ),
                        ),
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
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  )),
              BbpsLogoContainer(
                showEquitasLogo: false,
              ),
              SizedBox(
                height: 80.h,
              )
            ]),
          ),
        ),
        bottomSheet: Container(
          decoration: const BoxDecoration(
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
                        if (selectedAcc != null &&
                            !accError &&
                            !maxAmountError &&
                            (maxAmountController.text.isNotEmpty &&
                                double.parse(widget.autopayData!.mAXIMUMAMOUNT
                                        .toString()) !=
                                    double.parse(
                                        maxAmountController.text.toString()))) {
                          Map<String, dynamic> decodedToken =
                              await getDecodedToken();
                          List decodedToken2 =
                              decodedToken["accounts"].toList();
                          print(decodedToken2);
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
                              "billID": widget.customerBillID,
                              "billerName": widget.billerName,
                              "amountLimit": limitGroupRadio,
                            }
                          });
                        }
                      },
                      buttonText: "Update",
                      buttonTxtColor: BTN_CLR_ACTIVE,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: selectedAcc != null &&
                              !accError &&
                              !maxAmountError &&
                              (maxAmountController.text.isNotEmpty &&
                                  double.parse(widget.autopayData!.mAXIMUMAMOUNT
                                          .toString()) !=
                                      double.parse(
                                          maxAmountController.text.toString()))
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
        ),
      ),
    );
  }
}
