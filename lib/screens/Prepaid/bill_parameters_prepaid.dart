import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/biller_details_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/add_biller_model.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/input_signatures_model.dart';
import 'package:ebps/models/prepaid_fetch_plans_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/screens/Prepaid/prepaid_plans.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillParametersPrepaid extends StatefulWidget {
  BillersData? billerData;
  List<PARAMETERS>? inputSignatureData;

  BillParametersPrepaid({Key? key, this.billerData, this.inputSignatureData})
      : super(key: key);

  @override
  State<BillParametersPrepaid> createState() => _BillParametersPrepaidState();
}

class _BillParametersPrepaidState extends State<BillParametersPrepaid> {
  final GlobalKey<FormFieldState> _billnameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _MobileNumberKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _OperatorKey = GlobalKey<FormFieldState>();
  dynamic billNameController = TextEditingController();
  dynamic operatorController = TextEditingController();
  dynamic mobileNumberController = TextEditingController();

  List CircleData = [];

  String? CircleValue;
  bool isPrepaidPlansLoading = true;
  List<PrepaidPlansData>? prepaidPlansData = [];

  bool isBillNameNotValid = true;
  bool isMobileNumberNotValid = true;
  List<InputSignaturesData>? inputSignatureItems = [];
  bool isInpuSignLoading = false;

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context)
        .getInputSingnature(widget.billerData!.bILLERID);
    BlocProvider.of<HomeCubit>(context)
        .PrepaidFetchPlans(widget.billerData!.bILLERID.toString());
    operatorController.text = widget.billerData!.bILLERNAME.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: widget.billerData!.bILLERNAME.toString(),
          onLeadingTap: () => goBack(context),
          showActions: false,
        ),
        body: SingleChildScrollView(
            child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is InputSignatureLoading) {
              isInpuSignLoading = true;
            } else if (state is InputSignatureSuccess) {
              inputSignatureItems = state.InputSignatureList;

              isInpuSignLoading = false;
            } else if (state is InputSignatureFailed) {
              isInpuSignLoading = false;
            } else if (state is InputSignatureError) {
              isInpuSignLoading = false;
            }
            if (state is PrepaidFetchPlansLoading) {
              setState(() {
                isPrepaidPlansLoading = true;
              });
            } else if (state is PrepaidFetchPlansSuccess) {
              prepaidPlansData = state.prepaidPlansData;
              List dropdownStates = [];
              for (var i = 0; i < prepaidPlansData!.length; i++) {
                dropdownStates
                    .add(prepaidPlansData![i].planAdditionalInfo!.circle);
              }
              List withoutDuplicateStates = dropdownStates.toSet().toList();

              CircleData = withoutDuplicateStates;
              setState(() {
                CircleValue = null;
              });

              // FilterPlans();

              // handleCatgoryList();
              setState(() {
                isPrepaidPlansLoading = false;
              });
            } else if (state is PrepaidFetchPlansFailed) {
              setState(() {
                isPrepaidPlansLoading = false;
              });
            } else if (state is PrepaidFetchPlansError) {
              setState(() {
                isPrepaidPlansLoading = false;
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0.r + 2.r),
                      border: Border.all(
                        color: const Color(0xffD1D9E8),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BillerDetailsContainer(
                          icon: LOGO_BBPS,
                          billerName: widget.billerData!.bILLERNAME.toString(),
                          categoryName:
                              widget.billerData!.cATEGORYNAME.toString(),
                        ),
                        if (isPrepaidPlansLoading)
                          Center(
                            child: Container(
                              height: 200,
                              width: 200,
                              child: FlickrLoader(),
                            ),
                          ),
                        if (!isPrepaidPlansLoading &&
                            prepaidPlansData!.length > 0)
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                                child: TextFormField(
                                  // maxLength: 10,
                                  controller: mobileNumberController,
                                  key: _MobileNumberKey,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[0-9]*'))
                                  ],
                                  onChanged: (s) {
                                    if (mobileNumberController
                                            .text.isNotEmpty &&
                                        mobileNumberController.text.length ==
                                            10) {
                                      setState(() {
                                        isMobileNumberNotValid = false;
                                      });
                                    } else {
                                      setState(() {
                                        isMobileNumberNotValid = true;
                                      });
                                    }
                                  },
                                  validator: (inputValue) {
                                    if (inputValue!.isEmpty) {
                                      return "Mobile Number Should Not be Empty";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      fillColor: const Color(0xffD1D9E8)
                                          .withOpacity(0.2),
                                      filled: true,
                                      labelStyle: const TextStyle(
                                          color: Color(0xff1b438b)),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff1B438B)),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff1B438B)),
                                      ),
                                      border: const UnderlineInputBorder(),
                                      labelText: 'Mobile Number',
                                      prefixText: '+91 '),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                                child: TextFormField(
                                  style: TextStyle(color: TXT_CLR_LITE),
                                  readOnly: true,
                                  controller: operatorController,
                                  key: _OperatorKey,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.text,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[a-z0-9A-Z ]*'))
                                  ],
                                  onChanged: (s) {},
                                  validator: (inputValue) {},
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        color: Color(0xffa2a2a2)),
                                    fillColor: const Color(0xffD1D9E8)
                                        .withOpacity(0.2),
                                    filled: true,
                                    hintStyle: const TextStyle(
                                        color: Color(0xffa2a2a2)),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffa2a2a2)),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffa2a2a2)),
                                    ),
                                    border: const UnderlineInputBorder(),
                                    labelText: 'Operator',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  isDense: true,
                                  value: CircleValue,
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    filled: true,
                                    fillColor:
                                        Color(0xffD1D9E8).withOpacity(0.2),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff1B438B)),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff1B438B)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0.h, horizontal: 10.w),
                                    labelText: 'Select a Circle',
                                    labelStyle: const TextStyle(
                                        color: Color(0xff1b438b)),
                                    hintText: 'Select a Circle',
                                    hintStyle: const TextStyle(
                                        color: Color(0xff1b438b)),
                                  ),
                                  onChanged: (String? newValue) {},
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  items:
                                      CircleData.map<DropdownMenuItem<String>>(
                                          (value) {
                                    print(value);
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          CircleValue = value;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        if (prepaidPlansData!.length > 0)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            child: TextFormField(
                              maxLength: 20,
                              controller: billNameController,
                              key: _billnameKey,
                              autocorrect: false,
                              enableSuggestions: false,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-z0-9A-Z ]*'))
                              ],
                              onChanged: (s) {
                                if (billNameController.text.isNotEmpty) {
                                  setState(() {
                                    isBillNameNotValid = false;
                                  });
                                } else {
                                  setState(() {
                                    isBillNameNotValid = true;
                                  });
                                }
                              },
                              validator: (inputValue) {
                                if (inputValue!.isEmpty) {
                                  return "Bill Name Should Not be Empty";
                                }
                                return null;
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
                                labelText: 'Bill Name (Nick Name)',
                              ),
                            ),
                          ),
                        if (!isPrepaidPlansLoading &&
                            prepaidPlansData!.length == 0)
                          Text(
                              "No Plans Found for this Operator. Please Choose a diffrent Operator")
                      ],
                    )),
              ],
            );
          },
        )),
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
                      onPressed: () {
                        if (!isBillNameNotValid &&
                            CircleValue != null &&
                            !isMobileNumberNotValid) {
                          handlePlans() {
                            List<PrepaidPlansData> FilterPlans = [];
                            if (CircleValue != null) {
                              FilterPlans = prepaidPlansData!
                                  .where((element) =>
                                      element.planAdditionalInfo!.circle ==
                                      CircleValue)
                                  .toList();
                            } else {
                              FilterPlans = prepaidPlansData!;
                            }
                            return FilterPlans;
                          }

                          List<AddbillerpayloadModel> inputPayloadData = [];

                          for (var i = 0;
                              i < inputSignatureItems!.length;
                              i++) {
                            AddbillerpayloadModel makeInput;
                            makeInput = AddbillerpayloadModel(
                                bILLERID: inputSignatureItems![i].bILLERID,
                                pARAMETERID:
                                    inputSignatureItems![i].pARAMETERID,
                                pARAMETERNAME:
                                    inputSignatureItems![i].pARAMETERNAME,
                                pARAMETERTYPE:
                                    inputSignatureItems![i].pARAMETERTYPE,
                                mINLENGTH: inputSignatureItems![i].mINLENGTH,
                                mAXLENGTH: inputSignatureItems![i].mAXLENGTH,
                                // rEGEX: inputSignatureItems![i].rEGEX,
                                rEGEX: null,
                                oPTIONAL: inputSignatureItems![i].oPTIONAL,
                                eRROR: '',
                                pARAMETERVALUE: inputSignatureItems![i]
                                            .pARAMETERNAME
                                            .toString()
                                            .toLowerCase() ==
                                        'mobile number'
                                    ? mobileNumberController.text
                                    : inputSignatureItems![i]
                                                .pARAMETERNAME
                                                .toString()
                                                .toLowerCase() ==
                                            'circle'
                                        ? CircleValue
                                        : inputSignatureItems![i]
                                                    .pARAMETERNAME
                                                    .toString()
                                                    .toLowerCase() ==
                                                'id'
                                            ? "1"
                                            : "");
                            inputPayloadData.add(makeInput);
                          }

                          goToData(context, pREPAIDPLANSROUTE, {
                            "prepaidPlans": handlePlans(),
                            "isFetchPlans": false,
                            "billerData": widget.billerData,
                            "mobileNumber": mobileNumberController.text,
                            "operator": operatorController.text,
                            "circle": CircleValue,
                            "billName": billNameController.text,
                            "inputParameters": inputPayloadData,
                            "SavedinputParameters": [],
                            'isSavedBill': false
                          });
                        }
                      },
                      buttonText: "Confirm",
                      buttonTxtColor: BTN_CLR_ACTIVE,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: !isBillNameNotValid &&
                              CircleValue != null &&
                              !isMobileNumberNotValid
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
        ));
  }
}
