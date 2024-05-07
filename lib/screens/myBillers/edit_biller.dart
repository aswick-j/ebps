import 'dart:ui';

import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/MyBillers/bill_details_container.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/NavigationService.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getPopupMsg.dart';
import 'package:ebps/models/edit_bill_modal.dart';
import 'package:ebps/models/input_signatures_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/services/api_client.dart';
import 'package:ebps/widget/animated_dialog.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/custom_dialog.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:ebps/widget/loader_overlay.dart';
import 'package:flutter/cupertino.dart';
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
  final GlobalKey<FormFieldState> _editbillnameKey =
      GlobalKey<FormFieldState>();

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
      builder: (BuildContext ctx) {
        return WillPopScope(
            onWillPop: () async => false,
            child: CustomDialog(
              showActions: true,
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: MyAppButton(
                      onPressed: () {
                        goBack(ctx);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => BottomNavBar(
                                      SelectedIndex: 1,
                                    )),
                            (Route<dynamic> route) => false,
                          );
                        });
                      },
                      buttonText: "Okay",
                      buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
                      buttonSizeX: 10.h,
                      buttonSizeY: 40.w,
                      buttonTextSize: 14.sp,
                      buttonTextWeight: FontWeight.w500),
                ),
              ],
              child: AnimatedDialog(
                  showImgIcon: success ? true : false,
                  showRichText: true,
                  RichTextContent: success
                      ? getPopupSuccessMsg(
                          7,
                          widget.savedbillersData.bILLERNAME.toString(),
                          widget.savedbillersData.bILLNAME.toString())
                      : getPopupFailedMsg(
                          7,
                          widget.savedbillersData.bILLERNAME.toString(),
                          widget.savedbillersData.bILLERNAME.toString()),
                  subTitle: "",
                  showSub: false,
                  shapeColor: AppColors.CLR_ERROR,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: AppColors.CLR_BACKGROUND,
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
                handleDialog(success: false);

                LoaderOverlay.of(context).hide();
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // Container(
                  //     clipBehavior: Clip.hardEdge,
                  //     width: double.infinity,
                  //     margin: EdgeInsets.only(
                  //         left: 18.0.w, right: 18.w, top: 10.h, bottom: 15.h),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(6.0.r + 2.r),
                  //       border: Border.all(
                  //         color: Color(0xffD1D9E8),
                  //         width: 1.0,
                  //       ),
                  //     ),
                  //     child: Column(
                  //       children: [
                  //         ListTile(
                  //           leading: Container(
                  //             width: 50.w,
                  //             child: Padding(
                  //               padding: EdgeInsets.all(8.0.r),
                  //               child: SvgPicture.asset(BILLER_LOGO(widget
                  //                   .savedbillersData.bILLERNAME
                  //                   .toString())),
                  //             ),
                  //           ),
                  //           title: Text(
                  //             widget.savedbillersData.bILLERNAME.toString(),
                  //             style: TextStyle(
                  //               fontSize: 14.sp,
                  //               fontWeight: FontWeight.w500,
                  //               color: Color(0xff191919),
                  //             ),
                  //             textAlign: TextAlign.left,
                  //           ),
                  //           subtitle: Text(
                  //             widget.savedbillersData.bILLERCOVERAGE.toString(),
                  //             style: TextStyle(
                  //               fontSize: 14.sp,
                  //               fontWeight: FontWeight.w400,
                  //               color: Color(0xff808080),
                  //             ),
                  //             textAlign: TextAlign.left,
                  //           ),
                  //         ),
                  //         // Divider(
                  //         //   height: 10.h,
                  //         //   thickness: 1,
                  //         //   indent: 10.w,
                  //         //   endIndent: 10.w,
                  //         // ),
                  //         // billDetailsContainer(
                  //         //     title: widget.savedbillersData.pARAMETERNAME
                  //         //         .toString(),
                  //         //     subTitle: widget.savedbillersData.pARAMETERVALUE
                  //         //         .toString()),
                  //         // billDetailsContainer(
                  //         //     title: "Biller Name",
                  //         //     subTitle:
                  //         //         widget.savedbillersData.bILLERNAME.toString())
                  //       ],
                  //     )),
                  ReusableContainer(
                      bottomMargin: 15.h,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 50.w,
                              child: Padding(
                                padding: EdgeInsets.all(8.0.r),
                                child: SvgPicture.asset(BILLER_LOGO(widget
                                    .savedbillersData.bILLERNAME
                                    .toString())),
                              ),
                            ),
                            title: Text(
                              widget.savedbillersData.bILLERNAME.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.TXT_CLR_BLACK_W,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            subtitle: Text(
                              widget.savedbillersData.cATEGORYNAME.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.TXT_CLR_LITE,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Divider(
                            color: AppColors.CLR_CON_BORDER,
                            height: 10.h,
                            thickness: 0.50,
                          ),
                          if (!isEditBillDetailsLoading)
                            Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 16.h),
                                    child: ListView.builder(
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
                                                InputSignatureControllers[
                                                    index],
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            style: TextStyle(
                                                color: AppColors.TXT_CLR_LITE),
                                            enabled: true,
                                            autocorrect: false,
                                            readOnly: true,
                                            enableSuggestions: false,
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                    color:
                                                        AppColors.TXT_CLR_LITE),
                                                fillColor: AppColors
                                                    .TXT_CLR_GREY
                                                    .withOpacity(0.1),
                                                filled: true,
                                                hintStyle: TextStyle(
                                                    color:
                                                        AppColors.TXT_CLR_LITE),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors
                                                          .TXT_CLR_LITE),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors
                                                          .TXT_CLR_LITE),
                                                ),
                                                border:
                                                    const UnderlineInputBorder(),
                                                labelText:
                                                    EditInputItems![index]
                                                        .pARAMETERNAME
                                                        .toString()),
                                          ),
                                        );
                                      },
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 16.h),
                                  child: TextFormField(
                                    maxLength: 20,
                                    controller: billNameController,
                                    key: _editbillnameKey,
                                    style: TextStyle(
                                        color: AppColors.TXT_CLR_DEFAULT),
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
                                      counterStyle: TextStyle(
                                          color:
                                              billNameController.text.length <=
                                                      3
                                                  ? AppColors.CLR_ERROR
                                                  : AppColors.TXT_CLR_DEFAULT),
                                      fillColor: AppColors.CLR_INPUT_FILL,
                                      filled: true,
                                      labelStyle: TextStyle(
                                          color: AppColors.TXT_CLR_PRIMARY),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.TXT_CLR_PRIMARY),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.TXT_CLR_PRIMARY),
                                      ),
                                      border: const UnderlineInputBorder(),
                                      labelText: 'Bill Name (Nick Name)',
                                    ),
                                  ),
                                )
                              ],
                            )
                          else
                            Center(
                              child: Container(
                                height: 200,
                                width: 200,
                                child: FlickrLoader(),
                              ),
                            ),
                        ],
                      )),
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
          decoration: BoxDecoration(
              color: AppColors.CLR_BACKGROUND,
              border: Border(
                  top: BorderSide(
                      color: AppColors.CLR_CON_BORDER_LITE, width: 0.50))),
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
                        if (isButtonActive &&
                            isValidBillName &&
                            billNameController.text.length > 3) {
                          submitForm();
                        }
                      },
                      buttonText: "Update",
                      buttonTxtColor: isButtonActive &&
                              isValidBillName &&
                              billNameController.text.length > 3
                          ? AppColors.BTN_CLR_ACTIVE_ALTER_TEXT
                          : AppColors.BTN_CLR_DISABLE_TEXT,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: isButtonActive &&
                              isValidBillName &&
                              billNameController.text.length > 3
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
        ),
      ),
    );
  }
}
