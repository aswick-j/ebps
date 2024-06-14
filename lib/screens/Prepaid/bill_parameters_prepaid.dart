import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/biller_details_container.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/add_biller_model.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/input_signatures_model.dart';
import 'package:ebps/models/prepaid_fetch_plans_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/loader.dart';
import 'package:ebps/widget/no_result.dart';
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
  final GlobalKey<FormFieldState> _billnameParamKey =
      GlobalKey<FormFieldState>();
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
        backgroundColor: AppColors.CLR_BACKGROUND,
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
                ReusableContainer(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BillerDetailsContainer(
                      icon:
                          BILLER_LOGO(widget.billerData!.bILLERNAME.toString()),
                      title: widget.billerData!.bILLERNAME.toString(),
                      subTitle: widget.billerData!.cATEGORYNAME.toString(),
                      subTitle2: widget.billerData!.bILLERCOVERAGE.toString(),
                    ),
                    if (isPrepaidPlansLoading)
                      Container(
                        height: 200,
                        width: 200,
                        child: Center(child: Loader()),
                      ),
                    if (!isPrepaidPlansLoading && prepaidPlansData!.length > 0)
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
                                if (mobileNumberController.text.isNotEmpty &&
                                    mobileNumberController.text.length == 10) {
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
                              style:
                                  TextStyle(color: AppColors.TXT_CLR_DEFAULT),
                              decoration: InputDecoration(
                                  prefixStyle: TextStyle(
                                      color: AppColors.TXT_CLR_DEFAULT),
                                  hintStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                  fillColor: AppColors.CLR_INPUT_FILL,
                                  filled: true,
                                  labelStyle:
                                      TextStyle(color: AppColors.CLR_PRIMARY),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.TXT_CLR_PRIMARY),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.TXT_CLR_PRIMARY),
                                  ),
                                  border: UnderlineInputBorder(),
                                  labelText: 'Mobile Number',
                                  prefixText: '+91 '),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            child: TextFormField(
                              style: TextStyle(color: AppColors.TXT_CLR_LITE),
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
                                labelStyle:
                                    TextStyle(color: AppColors.CLR_PRIMARY),
                                fillColor: AppColors.CLR_INPUT_FILL,
                                filled: true,
                                hintStyle:
                                    const TextStyle(color: Color(0xffa2a2a2)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.TXT_CLR_PRIMARY),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.TXT_CLR_PRIMARY),
                                ),
                                border: UnderlineInputBorder(),
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
                              dropdownColor: AppColors.BTN_CLR_ACTIVE_TEXT,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0.r)),
                              style:
                                  TextStyle(color: AppColors.TXT_CLR_DEFAULT),
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
                                labelText: 'Select a Circle',
                                labelStyle:
                                    TextStyle(color: AppColors.CLR_PRIMARY),
                                hintText: 'Select a Circle',
                                hintStyle:
                                    TextStyle(color: AppColors.TXT_CLR_DEFAULT),
                              ),
                              onChanged: (String? newValue) {},
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.CLR_GREY,
                              ),
                              items: CircleData.map<DropdownMenuItem<String>>(
                                  (value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value ?? "No Circles Found",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.TXT_CLR_DEFAULT),
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
                          key: _billnameParamKey,
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
                          style: TextStyle(color: AppColors.TXT_CLR_DEFAULT),
                          decoration: InputDecoration(
                            counterStyle: TextStyle(
                                color: billNameController.text.length <= 3
                                    ? AppColors.CLR_ERROR
                                    : AppColors.TXT_CLR_BLACK_W),
                            fillColor: AppColors.CLR_INPUT_FILL,
                            filled: true,
                            labelStyle: TextStyle(color: AppColors.CLR_PRIMARY),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.TXT_CLR_PRIMARY),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.TXT_CLR_PRIMARY),
                            ),
                            border: UnderlineInputBorder(),
                            labelText: 'Bill Name (Nick Name)',
                          ),
                        ),
                      ),
                    if (!isPrepaidPlansLoading && prepaidPlansData!.length == 0)
                      Center(
                        child: Container(
                            width: double.infinity,
                            height: 350.h,
                            child: noResult(
                                showTitle: true, ErrIndex: 3, ImgIndex: 3)),
                      )
                  ],
                )),
                SizedBox(
                  height: 80.h,
                )
              ],
            );
          },
        )),
        bottomSheet: Container(
          decoration: BoxDecoration(
              color: AppColors.CLR_BACKGROUND,
              border: Border(
                  top: BorderSide(
                      color: AppColors.CLR_CON_BORDER_LITE, width: 1))),
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
                      buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT_C,
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
                        if (!isBillNameNotValid &&
                            billNameController.text.length > 3 &&
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
                                rEGEX: inputSignatureItems![i].rEGEX,
                                //  rEGEX: null,
                                oPTIONAL: inputSignatureItems![i].oPTIONAL,
                                eRROR: '',
                                pARAMETERVALUE: inputSignatureItems![i]
                                                .pARAMETERNAME
                                                .toString()
                                                .toLowerCase() ==
                                            'mobile number' ||
                                        inputSignatureItems![i]
                                                .pARAMETERNAME
                                                .toString()
                                                .toLowerCase() ==
                                            'customer mobile number'
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
                            'isSavedBill': false
                          });
                        }
                      },
                      buttonText: "Confirm",
                      buttonTxtColor: !isBillNameNotValid &&
                              CircleValue != null &&
                              billNameController.text.length > 3 &&
                              !isMobileNumberNotValid
                          ? AppColors.BTN_CLR_ACTIVE_ALTER_TEXT
                          : AppColors.BTN_CLR_DISABLE_TEXT,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: !isBillNameNotValid &&
                              CircleValue != null &&
                              billNameController.text.length > 3 &&
                              !isMobileNumberNotValid
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
        ));
  }
}
