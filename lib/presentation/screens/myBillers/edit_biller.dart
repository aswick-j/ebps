import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/data/models/edit_bill_modal.dart';
import 'package:ebps/data/models/input_signatures_model.dart';
import 'package:ebps/data/models/saved_biller_model.dart';
import 'package:ebps/data/services/api_client.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:ebps/presentation/common/Container/MyBillers/bill_details_container.dart';
import 'package:ebps/presentation/widget/bbps_logo.dart';
import 'package:ebps/presentation/widget/flickr_loader.dart';
import 'package:ebps/presentation/widget/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class EditBiller extends StatefulWidget {
  SavedBillersData savedbillersData;

  EditBiller({super.key, required this.savedbillersData});

  @override
  State<EditBiller> createState() => _EditBillerState();
}

class _EditBillerState extends State<EditBiller> {
  final ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MybillersCubit(repository: apiClient),
      child: EditBillerUI(savedbillersData: widget.savedbillersData),
    );
  }
}

class EditBillerUI extends StatefulWidget {
  SavedBillersData savedbillersData;
  EditBillerUI({super.key, required this.savedbillersData});

  @override
  State<EditBillerUI> createState() => _EditBillerUIState();
}

class _EditBillerUIState extends State<EditBillerUI> {
  List<TextEditingController> InputSignatureControllers = [];
  List<InputSignaturess>? EditInputItems = [];
  List<InputSignaturesData>? InputSignatureItems = [];
  dynamic billNameController = TextEditingController();
  final GlobalKey<FormFieldState> _billnameKey = GlobalKey<FormFieldState>();

  bool isEditBillDetailsLoading = true;
  bool isButtonActive = false;
  bool isValidBillName = false;
  @override
  void initState() {
    BlocProvider.of<MybillersCubit>(context)
        .getEditBillItems(widget.savedbillersData.cUSTOMERBILLID);
    super.initState();
  }

  submitForm() {
    Map<String, dynamic> inputParameters = {
      "billName": billNameController.text,
      "categoryName": widget.savedbillersData.cATEGORYNAME,
      "customerBillId": widget.savedbillersData.cUSTOMERBILLID,
    };

    BlocProvider.of<MybillersCubit>(context).updateBill(inputParameters);
  }

  handleDialog({required bool success}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: MyAppButton(
                      onPressed: () {
                        goBack(context);
                      },
                      buttonText: "Okay",
                      buttonTxtColor: BTN_CLR_ACTIVE,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: CLR_PRIMARY,
                      buttonSizeX: 10.h,
                      buttonSizeY: 40.w,
                      buttonTextSize: 14.sp,
                      buttonTextWeight: FontWeight.w500),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              content: SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 50.h,
                        width: 50.w,
                        child: SvgPicture.asset(
                            success ? ICON_SUCCESS : LOGO_BBPS)),
                    Text(
                      success
                          ? "Bill Name Updated Successfully"
                          : "Bill Name Update  Failed",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: MyAppBar(
          context: context,
          title: "Edit Biller",
          onLeadingTap: () => goBack(context),
          showActions: false,
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<MybillersCubit, MybillersState>(
            listener: (context, state) {
              if (state is EditBillLoading) {
                isEditBillDetailsLoading = true;
              } else if (state is EditBillSuccess) {
                EditInputItems = state.EditBillList?.inputSignaturess;

                for (int i = 0; i < EditInputItems!.length; i++) {
                  var textEditingController = TextEditingController(
                      text: EditInputItems![i].pARAMETERVALUE);
                  billNameController = TextEditingController(
                      text: state.EditBillList!.billName![0].bILLNAME);
                  InputSignatureControllers.add(textEditingController);
                }
                isEditBillDetailsLoading = false;
              } else if (state is EditBillFailed) {
                isEditBillDetailsLoading = false;
              } else if (state is EditBillError) {
                isEditBillDetailsLoading = false;
              }

              if (state is UpdateBillLoading) {
                LoaderOverlay.of(context).show();
              } else if (state is UpdateBillSuccess) {
                handleDialog(success: true);
                LoaderOverlay.of(context).hide();
              } else if (state is UpdateBillFailed) {
                handleDialog(success: false);

                LoaderOverlay.of(context).hide();
              } else if (state is UpdateBillError) {
                LoaderOverlay.of(context).hide();
              }
            },
            builder: (context, state) {
              return Column(
                children: [
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
                              widget.savedbillersData.bILLERNAME.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff191919),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            subtitle: Text(
                              widget.savedbillersData.bILLERCOVERAGE.toString(),
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
                              title: widget.savedbillersData.pARAMETERNAME
                                  .toString(),
                              subTitle: widget.savedbillersData.pARAMETERVALUE
                                  .toString()),
                          billDetailsContainer(
                              title: "Biller Name",
                              subTitle:
                                  widget.savedbillersData.bILLERNAME.toString())
                        ],
                      )),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          child: !isEditBillDetailsLoading
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: EditInputItems!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 8.0.h),
                                      child: TextFormField(
                                        controller:
                                            InputSignatureControllers[index],
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        enabled: true,
                                        autocorrect: false,
                                        readOnly: true,
                                        enableSuggestions: false,
                                        decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                                color: Color(0xffa2a2a2)),
                                            fillColor: const Color(0xffD1D9E8)
                                                .withOpacity(0.2),
                                            filled: true,
                                            hintStyle: const TextStyle(
                                                color: Color(0xffa2a2a2)),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffa2a2a2)),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffa2a2a2)),
                                            ),
                                            border:
                                                const UnderlineInputBorder(),
                                            labelText: EditInputItems![index]
                                                .pARAMETERNAME
                                                .toString()),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    child: FlickrLoader(),
                                  ),
                                ),
                        ),
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
                      ],
                    ),
                  ),
                  BbpsLogoContainer(showEquitasLogo: false),
                  SizedBox(
                    height: 80.h,
                  )
                ],
              );
            },
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
                      onPressed: () {
                        if (isButtonActive && isValidBillName) {
                          submitForm();
                        }
                      },
                      buttonText: "Update",
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
      ),
    );
  }
}
