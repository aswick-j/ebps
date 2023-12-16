import 'package:ebps/domain/models/account_info_model.dart';
import 'package:ebps/domain/models/auto_schedule_pay_model.dart';
import 'package:ebps/domain/models/saved_biller_model.dart';
import 'package:ebps/domain/services/api.dart';
import 'package:ebps/shared/constants/assets.dart';
import 'package:ebps/shared/constants/colors.dart';
import 'package:ebps/shared/constants/routes.dart';

import 'package:ebps/shared/helpers/getDaySuffix.dart';
import 'package:ebps/shared/helpers/getDecodedAccount.dart';
import 'package:ebps/shared/helpers/getMonthName.dart';
import 'package:ebps/shared/helpers/getNavigators.dart';
import 'package:ebps/shared/common/AppBar/MyAppBar.dart';
import 'package:ebps/shared/common/Button/MyAppButton.dart';
import 'package:ebps/shared/common/Container/MyBillers/bill_details_container.dart';
import 'package:ebps/shared/widget/bbps_logo.dart';
import 'package:ebps/shared/widget/date_picker_dialog.dart';
import 'package:ebps/shared/widget/flickr_loader.dart';
import 'package:ebps/shared/widget/getAccountInfoCard.dart';
import 'package:ebps/shared/widget/loader_overlay.dart';
import 'package:ebps/ui/controllers/bloc/home/home_cubit.dart';
import 'package:ebps/ui/controllers/bloc/myBillers/mybillers_cubit.dart';
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

  List<PARAMETERS>? savedInputSignatures;

  editAutopay(
      {super.key,
      required this.billerName,
      required this.categoryName,
      required this.billName,
      required this.customerBillID,
      this.autopayData,
      required this.savedInputSignatures});

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

  // final GlobalKey<FormFieldState> _billnameKey = GlobalKey<FormFieldState>();
  dynamic maxAmountController = TextEditingController();
  dynamic dateController = TextEditingController();

  String? selectedDate = "1";
  dynamic selectedAcc = null;

  List<String> EffectiveFrom = <String>[
    'Immediately',
    getMonthName(0)[0]!,
    getMonthName(0)[1]!
  ];

  int? isActive = 0;

  @override
  void initState() {
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
          showActions: false,
        ),
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
              Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      left: 18.0.w, right: 18.w, top: 10.h, bottom: 15.h),
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
                      billDetailsContainer(
                          title: "Customer No", subTitle: "3445556666"),
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
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            // getInputAmountFormatter(),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-z0-9A-Z ]*'))
                          ],
                          onChanged: (val) {},
                          validator: (inputValue) {
                            if (inputValue!.isEmpty) {
                              return "Bill Name Should Not be Empty";
                            }
                          },
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
                              labelText: 'Maximum Amount',
                              prefixText: '₹  ',
                              hintText: "Enter maximum amount"),
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
                              icon:
                                  const Icon(Icons.refresh, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  selectedAcc = null;
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
                            height: 200.h,
                            width: 200.w,
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
                                },
                                index: index,
                                isSelected: selectedAcc,
                              );
                            },
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
                        Map<String, dynamic> decodedToken =
                            await getDecodedToken();
                        List decodedToken2 = decodedToken["accounts"].toList();
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
                      },
                      buttonText: "Update",
                      buttonTxtColor: BTN_CLR_ACTIVE,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: CLR_PRIMARY,
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
