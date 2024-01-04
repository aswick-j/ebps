import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/biller_details_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getInputType.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/add_biller_model.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/input_signatures_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillParameters extends StatefulWidget {
  BillersData? billerData;
  List<PARAMETERS>? inputSignatureData;

  BillParameters({Key? key, this.billerData, this.inputSignatureData})
      : super(key: key);

  @override
  State<BillParameters> createState() => _BillParametersState();
}

class _BillParametersState extends State<BillParameters> {
  bool isButtonActive = false;
  bool isValidBillName = false;

  /// The line `List<InputSignaturesData>? inputSignatureItems = [];` declares a list variable named
  /// `inputSignatureItems` that can hold objects of type `InputSignaturesData`. The `?` indicates that
  /// the variable can also be null. The initial value of the list is an empty list.
  List<InputSignaturesData>? inputSignatureItems = [];

  /// The line `List<GlobalKey<FormFieldState>> _fieldKey = [];` declares a list variable named
  /// `_fieldKey` that can hold objects of type `GlobalKey<FormFieldState>`. This list is used to store
  /// keys for form fields in the UI. Each form field in the UI can be associated with a unique key from
  /// this list. These keys can be used to access and manipulate the state of the form fields, such as
  /// getting the current value or validating the input.
  final List<GlobalKey<FormFieldState>> _fieldKey = [];

  /// The line `List<TextEditingController> inputSignatureControllers = [];` declares a list variable
  /// named `inputSignatureControllers` that can hold objects of type `TextEditingController`. This list
  /// is used to store controllers for text fields in the UI. Each text field in the UI can be associated
  /// with a unique controller from this list. These controllers can be used to access and manipulate the
  /// text entered in the text fields, such as getting the current value or setting a new value.
  List<TextEditingController> inputSignatureControllers = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _billnameKey = GlobalKey<FormFieldState>();
  dynamic billNameController = TextEditingController();
  bool isInpuSignLoading = false;

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context)
        .getInputSingnature(widget.billerData!.bILLERID);

    super.initState();
  }

  FormValidation(int index, bool static) {
    setState(() {
      isButtonActive =
          _fieldKey.every((element) => element.currentState!.isValid);
    });

    if (!static) {
      _fieldKey[index].currentState!.validate();
    } else {
      setState(() {
        isValidBillName = _billnameKey.currentState!.validate();
      });
    }
  }

  submitForm() {
    List<AddbillerpayloadModel> inputPayloadData = [];

    for (var i = 0; i < inputSignatureItems!.length; i++) {
      AddbillerpayloadModel makeInput;
      makeInput = AddbillerpayloadModel(
          bILLERID: inputSignatureItems![i].bILLERID,
          pARAMETERID: inputSignatureItems![i].pARAMETERID,
          pARAMETERNAME: inputSignatureItems![i].pARAMETERNAME,
          pARAMETERTYPE: inputSignatureItems![i].pARAMETERTYPE,
          mINLENGTH: inputSignatureItems![i].mINLENGTH,
          mAXLENGTH: inputSignatureItems![i].mAXLENGTH,
          // rEGEX: inputSignatureItems![i].rEGEX,
          rEGEX: null,
          oPTIONAL: inputSignatureItems![i].oPTIONAL,
          eRROR: '',
          pARAMETERVALUE: inputSignatureControllers[i].text);
      inputPayloadData.add(makeInput);
    }

    goToData(context, fETCHBILLERDETAILSROUTE, {
      "name": widget.billerData!.bILLERNAME,
      "billName": billNameController.text,
      "billerData": widget.billerData,
      "inputParameters": inputPayloadData,
      "categoryName": widget.billerData!.cATEGORYNAME,
      "isSavedBill": false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: widget.billerData!.bILLERNAME,
        onLeadingTap: () => Navigator.pop(context),
        showActions: false,
      ),
      body: BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
        if (state is InputSignatureLoading) {
          isInpuSignLoading = true;
        } else if (state is InputSignatureSuccess) {
          inputSignatureItems = state.InputSignatureList;
          for (int i = 0; i < inputSignatureItems!.length; i++) {
            _fieldKey.add(GlobalKey<FormFieldState>());
            var textEditingController = TextEditingController(text: "");
            inputSignatureControllers.add(textEditingController);
          }
          isInpuSignLoading = false;
        } else if (state is InputSignatureFailed) {
          isInpuSignLoading = false;
        } else if (state is InputSignatureError) {
          isInpuSignLoading = false;
        }
      }, builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
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
                        icon: BILLER_LOGO(
                            widget.billerData!.bILLERNAME.toString()),
                        billerName: widget.billerData!.bILLERNAME.toString(),
                        categoryName:
                            widget.billerData!.cATEGORYNAME.toString(),
                      ),
                      if (isInpuSignLoading)
                        Center(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: FlickrLoader(),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        child: Form(
                            key: _formKey,
                            child: Container(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: inputSignatureItems!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8.0.h),
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      enabled: true,
                                      controller:
                                          inputSignatureControllers[index],
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      keyboardType: getInputType(
                                          inputSignatureItems![index]
                                              .pARAMETERTYPE),
                                      onChanged: (s) {
                                        FormValidation(index, false);
                                      },
                                      key: _fieldKey[index],
                                      validator: (inputValue) {
                                        final regex =
                                            "${inputSignatureItems![index].rEGEX}";
                                        final fieldRegExp = RegExp(
                                            "${inputSignatureItems![index].rEGEX}");

                                        debugPrint(fieldRegExp
                                            .hasMatch(inputValue!)
                                            .toString());
                                        if (inputValue.length <
                                            inputSignatureItems![index]
                                                .mINLENGTH!
                                                .toInt()) {
                                          if (inputSignatureItems![index]
                                                  .mINLENGTH ==
                                              inputSignatureItems![index]
                                                  .mAXLENGTH) {
                                            return ("${inputSignatureItems![index].pARAMETERNAME} should be of ${inputSignatureItems![index].mAXLENGTH} ${inputSignatureItems![index].pARAMETERTYPE!.toLowerCase() == 'numeric' ? 'digits' : 'characters'}");
                                          } else {
                                            return "${inputSignatureItems![index].pARAMETERNAME} should have at least ${inputSignatureItems![index].mINLENGTH} ${inputSignatureItems![index].pARAMETERTYPE!.toLowerCase() == 'numeric' ? 'digits' : 'characters'}";
                                          }
                                        } else if (inputValue.length >
                                            inputSignatureItems![index]
                                                .mAXLENGTH!
                                                .toInt()) {
                                          if (inputSignatureItems![index]
                                                  .mINLENGTH ==
                                              inputSignatureItems![index]
                                                  .mAXLENGTH) {
                                            return ("${inputSignatureItems![index].pARAMETERNAME} should be of ${inputSignatureItems![index].mAXLENGTH} ${inputSignatureItems![index].pARAMETERTYPE!.toLowerCase() == 'numeric' ? 'digits' : 'characters'}");
                                          } else {
                                            return "${inputSignatureItems![index].pARAMETERNAME} should have no more than ${inputSignatureItems![index].mAXLENGTH} ${inputSignatureItems![index].pARAMETERTYPE!.toLowerCase() == 'numeric' ? 'digits' : 'characters'}";
                                          }
                                        } else if (!fieldRegExp
                                                .hasMatch(inputValue) &&
                                            inputSignatureItems![index].rEGEX !=
                                                null) {
                                          return "${inputSignatureItems![index].pARAMETERNAME} Must be Valid";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                              color: Color(0xff1b438b)),
                                          fillColor: const Color(0xffD1D9E8)
                                              .withOpacity(0.2),
                                          filled: true,
                                          errorMaxLines: 5,
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
                                          border: const UnderlineInputBorder(),
                                          labelText: inputSignatureItems![index]
                                              .pARAMETERNAME
                                              .toString()),
                                    ),
                                  );
                                },
                              ),
                            )),
                      ),
                      // Padding(
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      //   child: Text(
                      //     "Enter your registered Mobile no. With Tata Sky or a valid Subscriber ID which starts with 1 nd 10 digits long. To locate your subscriber ID, Press the home button on remote.",
                      //     style: TextStyle(
                      //       fontSize: 10,
                      //       fontWeight: FontWeight.w400,
                      //       color: Color(0xff808080),
                      //     ),
                      //     textAlign: TextAlign.left,
                      //   ),
                      // ),
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
                                isValidBillName = true;
                                isButtonActive = true;
                              });
                            } else {
                              setState(() {
                                isValidBillName = false;
                                isButtonActive = false;
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
                            fillColor: const Color(0xffD1D9E8).withOpacity(0.2),
                            filled: true,
                            labelStyle:
                                const TextStyle(color: Color(0xff1b438b)),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff1B438B)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff1B438B)),
                            ),
                            border: const UnderlineInputBorder(),
                            labelText: 'Bill Name (Nick Name)',
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        );
      }),
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
                      if (isButtonActive && isValidBillName) {
                        submitForm();
                      }
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const BillerDetails()));
                    },
                    buttonText: "Confirm",
                    buttonTxtColor: BTN_CLR_ACTIVE,
                    buttonBorderColor: Colors.transparent,
                    buttonColor: isButtonActive && isValidBillName
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
    );
  }
}
