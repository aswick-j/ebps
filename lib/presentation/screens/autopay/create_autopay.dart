import 'package:ebps/bloc/MyBillers/mybillers_cubit.dart';
import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/data/models/account_info_model.dart';
import 'package:ebps/helpers/getDecodedAccount.dart';
import 'package:ebps/helpers/getMonthName.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:ebps/presentation/widget/bbps_logo.dart';
import 'package:ebps/presentation/widget/flickr_loader.dart';
import 'package:ebps/presentation/widget/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class createAutopay extends StatefulWidget {
  const createAutopay({super.key});

  @override
  State<createAutopay> createState() => _createAutopayState();
}

class _createAutopayState extends State<createAutopay> {
  int? limitGroupRadio = 0;
  int? billPayGroupRadio = 0;
  bool isAccLoading = true;
  String? maximumAmount = "0";

  List<AccountsData>? accountInfo = [];

  // final GlobalKey<FormFieldState> _billnameKey = GlobalKey<FormFieldState>();
  dynamic maxAmountController = TextEditingController();
  dynamic dateController = TextEditingController();

  String? selectedDate;
  dynamic selectedAcc = null;

  List<String> EffectiveFrom = <String>[
    'Immediately',
    getMonthName(0)[0]!,
    getMonthName(0)[1]!
  ];

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getAccountInfo(myAccounts);
    BlocProvider.of<MybillersCubit>(context).getAutoPayMaxAmount();

    super.initState();
  }

  Widget billDetails({String title = "", String subTitle = ""}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff808080),
              height: 23 / 14,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1b438b),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(width: 10.w),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: MyAppBar(
          context: context,
          title: "Setup Autopay",
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
                      maxAmountController.text = maximumAmount;
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
                            child: SvgPicture.asset(
                                "packages/ebps/assets/icon/icon_jio.svg"),
                          ),
                        ),
                        title: Text(
                          "Airtel Telecom Services",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff191919),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          "Chennai",
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
                      billDetails(title: "Customer No", subTitle: "3445556666"),
                      billDetails(title: "Biller Name", subTitle: "3445556666")
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
                              value: 0,
                              groupValue: limitGroupRadio,
                              onChanged: (val) {
                                setState(() {
                                  limitGroupRadio = 0;
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
                              value: 1,
                              groupValue: limitGroupRadio,
                              activeColor: TXT_CLR_PRIMARY,
                              onChanged: (val) {
                                setState(() {
                                  limitGroupRadio = 1;
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
                          // key: _billnameKey,
                          autocorrect: false,
                          enableSuggestions: false,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-z0-9A-Z ]*'))
                          ],
                          onChanged: (val) {},
                          onTap: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Dialog(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            color: TXT_CLR_PRIMARY,
                                            padding: EdgeInsets.all(16.0),
                                            child: Center(
                                              child: Text(
                                                'Select Date',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 6,
                                                crossAxisSpacing: 8.0,
                                                mainAxisSpacing: 8.0,
                                              ),
                                              itemCount: 30,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedDate =
                                                          '${index + 1}';
                                                      print(selectedDate);
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: selectedDate ==
                                                              '${index + 1}'
                                                          ? TXT_CLR_PRIMARY
                                                          : Color(0xffD1D9E8)
                                                              .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              200.0),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '${index + 1}',
                                                        style: TextStyle(
                                                          color: selectedDate ==
                                                                  '${index + 1}'
                                                              ? Colors.white
                                                              : TXT_CLR_PRIMARY,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Divider(
                                            height: 10.0,
                                            thickness: 1,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 24.0,
                                                vertical: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff1b438b),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    goBack(context);
                                                    dateController.text =
                                                        selectedDate.toString();
                                                  },
                                                  child: Text(
                                                    "Ok",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff1b438b),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          validator: (inputValue) {
                            // if (inputValue!.isEmpty) {
                            //   return "Bill Name Should Not be Empty";
                            // }
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
                                setState(() {});
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 18.0.w,
                              right: 18.w,
                              top: 18.w,
                              bottom: 18.w),
                          child: Text(
                            "Select Payment Account",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1b438b),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      if (isAccLoading)
                        Center(
                          child: Container(
                            height: 200,
                            width: 200,
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
                                mainAxisSpacing: 10.h,
                                // mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAcc = index;
                                    });
                                  },
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          left: 20.0.w,
                                          right: 20.w,
                                          top: 0.h,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.0.r + 2.r),
                                        border: Border.all(
                                          color: selectedAcc == index
                                              ? CLR_GREEN
                                              : Color(0xffD1D9E8),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15.w, 10.h, 0, 0),
                                              child: Text(
                                                accountInfo![index]
                                                    .accountNumber
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: selectedAcc == index
                                                      ? CLR_GREEN
                                                      : Color(0xff808080),
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15.w, 5.h, 0, 0),
                                              child: Text(
                                                "Balance Amount",
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff808080),
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15.w, 0, 0, 0),
                                              child: Text(
                                                accountInfo![index].balance !=
                                                        "Unable to fetch balance"
                                                    ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(accountInfo![index].balance.toString()))}"
                                                    : "-",

                                                // "₹ ${accountInfo![index].balance.toString()}",
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff0e2146),
                                                ),
                                                textAlign: TextAlign.left,
                                              ))
                                        ],
                                      )),
                                );
                              }),
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
                      onPressed: () {},
                      buttonText: "Create",
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
