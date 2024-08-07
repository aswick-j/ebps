import 'dart:async';

import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getOTPInfoMsg.dart';
import 'package:ebps/helpers/getPopupMsg.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/services/api.dart';
import 'package:ebps/widget/animated_dialog.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/custom_dialog.dart';
import 'package:ebps/widget/loader.dart';
import 'package:ebps/widget/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  AllConfigurationsData? autopayData;
  String? id;
  String? BillerName;
  String? BillName;
  String? from;
  String? templateName;
  Map<String, dynamic>? data;
  BuildContext ctx;
  OtpScreen(
      {super.key,
      this.autopayData,
      this.from,
      required this.ctx,
      this.templateName,
      this.id,
      this.BillerName,
      this.BillName,
      this.data});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final txtOtpController = TextEditingController();
  final focusNode = FocusNode();
  String? OTP_ERR_MSG;
  bool? limitReached = false;
  bool showRedBorder = false;
  String? customerID;
  bool isLoading = true;
  String? REF_NO = '';
  String? OTP_MSG = '';
  bool isBtnDisable = true;
  Timer? timer;
  int secondsRemaining = 180;
  bool enableResend = false;
  bool showTimer = true;
  bool showResend = true;
  bool showGenerateOtpSuccessMsg = true;
  bool enableReadOnly = false;
  bool showOTPverify = false;
  bool enableRedirect = false;
  String? BillerName;
  String? BillName;

  handleIntial() {
    if (widget.from == pAYMENTCONFIRMROUTE) {
      BlocProvider.of<HomeCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.data!['billAmount']);
    } else if (widget.from == "delete-biller") {
      BlocProvider.of<HomeCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.data!['billerName']);
    } else if (widget.from == "create-auto-pay") {
      BlocProvider.of<HomeCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.data!['billerName']);
    } else if (widget.from == "delete-auto-pay") {
      BlocProvider.of<HomeCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.autopayData!.bILLERNAME.toString());
    } else if (widget.from == "edit-auto-pay") {
      BlocProvider.of<HomeCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.autopayData!.bILLERNAME.toString());
    } else if (widget.from == "modify-auto-pay") {
      BlocProvider.of<HomeCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.autopayData!.bILLERNAME.toString());
    }
  }

  @override
  void initState() {
    BillerName = widget.BillerName;
    BillName = widget.BillName;
    handleIntial();
    getAccountDetails();
    super.initState();
  }

  @override
  void dispose() {
    if (!mounted) {
      txtOtpController.clear();
    }
    focusNode.dispose();

    super.dispose();
  }

  handleSubmit() {
    showRedBorder = false;
    OTP_ERR_MSG = null;
    BlocProvider.of<HomeCubit>(context).validateOTP(txtOtpController.text);
  }

  void triggerTimer(dynamic durationValue) {
    try {
      timer = Timer.periodic(Duration(seconds: durationValue), (timer) {
        if (secondsRemaining != 0) {
          if (mounted) {
            setState(() {
              secondsRemaining--;
              enableResend = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              timer.cancel();
              showTimer = false;
              enableResend = true;
            });
          }
        }
        if (!mounted) {
          timer.cancel();
        }
      });
    } catch (e) {}
  }

  resetOtpErr() {
    setState(() {
      showRedBorder = false;
      OTP_ERR_MSG = null;
    });
  }

  resendCode() async {
    try {
      showTimer = true;
      resetOtpErr();
      if (widget.from == pAYMENTCONFIRMROUTE) {
        BlocProvider.of<HomeCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.data!['billAmount']);
      } else if (widget.from == "delete-biller") {
        BlocProvider.of<HomeCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.data!['billerName']);
      } else if (widget.from == "create-auto-pay") {
        BlocProvider.of<HomeCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.data!['billerName']);
      } else if (widget.from == "delete-auto-pay") {
        BlocProvider.of<HomeCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.autopayData!.bILLERNAME.toString());
      } else if (widget.from == "edit-auto-pay") {
        BlocProvider.of<HomeCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.autopayData!.bILLERNAME.toString());
      } else if (widget.from == "modify-auto-pay") {
        BlocProvider.of<HomeCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.autopayData!.bILLERNAME.toString());
      }

      if (mounted) {
        setState(() {
          secondsRemaining = 180;
          // secondsRemaining = otpTimerDuration;
          enableResend = false;
        });
      }
    } catch (e) {}
  }

  getAccountDetails() async {
    Map<String, dynamic> decodedToken = await getDecodedToken();
    setState(() {
      customerID = decodedToken['customerID'];
    });
  }

  handleOTPSuccess() {
    setState(() {
      enableReadOnly = true;
      showOTPverify = true;
    });
    if (widget.from == pAYMENTCONFIRMROUTE) {
      BlocProvider.of<HomeCubit>(context).payBill(
          widget.data!['billerID'],
          widget.data!['billerName'],
          widget.data!['billName'],
          widget.data!['acNo'],
          widget.data!['billAmount'],
          widget.data!['customerBillID'],
          widget.data!['tnxRefKey'],
          widget.data!['quickPay'],
          widget.data!['isSavedBill']
              ? widget.data!["SavedinputParameters"]
              : widget.data!['inputSignature'],
          widget.data!['otherAmount'],
          false,
          widget.data!['isSavedBill']
              ? widget.data!['savedBillersData']
              : widget.data!['billerData'],
          txtOtpController.text.toString());
    } else if (widget.from == "delete-biller") {
      BlocProvider.of<HomeCubit>(context).deleteBiller(
          widget.data!['cUSTOMERBILLID'],
          customerID!,
          txtOtpController.text.toString());
    } else if (widget.from == "create-auto-pay") {
      dynamic payload = widget.data;
      payload['otp'] = txtOtpController.text.toString();
      BlocProvider.of<HomeCubit>(context).createAutopay(payload);
    } else if (widget.from == "delete-auto-pay") {
      BlocProvider.of<HomeCubit>(context).deleteAutoPay(
          widget.autopayData!.iD, txtOtpController.text.toString());
    } else if (widget.from == "edit-auto-pay") {
      dynamic payload = widget.data;
      payload['otp'] = txtOtpController.text.toString();
      BlocProvider.of<HomeCubit>(context)
          .editAutoPay(widget.autopayData!.iD, payload);
    } else if (widget.from == "modify-auto-pay") {
      BlocProvider.of<HomeCubit>(context).modifyAutopay(widget.autopayData!.iD,
          widget.data!['status'], txtOtpController.text.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    showModalDialog({required int index, required bool Success}) {
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
                          GoBack(ctx);
                          GoToReplaceData(context, hOMEROUTE, {
                            "index": 1,
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
                    showImgIcon: Success ? true : false,
                    showRichText: true,
                    RichTextContent: Success
                        ? getPopupSuccessMsg(
                            index, BillerName.toString(), BillName.toString())
                        : getPopupFailedMsg(
                            index, BillerName.toString(), BillName.toString()),
                    subTitle: "",
                    showSub: false,
                    shapeColor:
                        Success ? AppColors.CLR_GREEN : AppColors.CLR_ERROR,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              ));
        },
      );
    }

    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.h,
      textStyle: TextStyle(
        fontSize: 14.sp,
        letterSpacing: 16.0,
        fontWeight: FontWeight.bold,
        color: AppColors.TXT_CLR_PRIMARY,
      ),
      decoration: BoxDecoration(
        color: AppColors.BTN_CLR_ACTIVE,
        borderRadius: BorderRadius.circular(8.r),
        border: !showRedBorder
            ? Border.all(color: AppColors.TXT_CLR_LITE)
            : Border.all(color: AppColors.CLR_ERROR),
      ),
    );

    handleUnknownDialog() {
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
                          GoBack(ctx);

                          GoToReplaceData(context, hOMEROUTE, {
                            "index": 0,
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
                    showImgIcon: false,
                    title: "Unable to Process Payment",
                    subTitle:
                        "We're sorry. We were unable to process your payment. Please try again later.",
                    showSub: true,
                    shapeColor: AppColors.CLR_ERROR,
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.white,
                    )),
              ));
        },
      );
    }

    List<Widget> tabInfoItems = [
      Container(
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        margin:
            EdgeInsets.only(left: 18.0.w, right: 18.w, top: 20.h, bottom: 0.h),
        decoration: BoxDecoration(
          color: AppColors.CLR_GREY.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6.0.r + 2.r),
          border: Border.all(
            color: AppColors.CLR_CON_BORDER,
            width: 0.50,
          ),
        ),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: 10.h, left: 14.w, bottom: 10.h, right: 10.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.TXT_CLR_PRIMARY,
                      size: 15.r,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 0.h, left: 5.w, bottom: 0.h),
                      child: SizedBox(
                        width: 260.w,
                        child: RichText(
                          maxLines: 5,
                          text: getOTPInfoMsg(
                              widget.templateName.toString(),
                              widget.data!['billAmount'].toString(),
                              widget.BillerName.toString(),
                              widget.BillName.toString()),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    ];

    handleDialog() {
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
                          GoBack(ctx);

                          GoToReplaceData(context, hOMEROUTE, {
                            "index": 2,
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
                    showImgIcon: false,
                    title: "Your Payment is Pending",
                    subTitle:
                        "Please, Visit History Section For More Information",
                    showSub: true,
                    shapeColor: Colors.orange,
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.white,
                    )),
              ));
        },
      );
    }

    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: AppColors.CLR_BACKGROUND,
        appBar: MyAppBar(
          context: context,
          title: widget.data!['billerName'],
          onLeadingTap: () => GoBack(context),
          showActions: false,
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is OtpLoading) {
              setState(() {
                isLoading = true;
                REF_NO = '';
                OTP_MSG = '';
              });
            } else if (state is OtpSuccess) {
              triggerTimer(1);

              isLoading = false;
              REF_NO = state.refrenceNumber;
              OTP_MSG = state.message;

              txtOtpController.clear();
            } else if (state is OtpFailed) {
              txtOtpController.clear();
              setState(() {
                isLoading = false;
                OTP_ERR_MSG = state.message;
                limitReached = state.limitReached;
                showRedBorder = true;
              });
            } else if (state is OtpError) {
              setState(() {
                isLoading = false;
                OTP_ERR_MSG = state.message;
                limitReached = state.limitReached;

                showRedBorder = true;
              });
              // goToUntil(context, hOMEROUTE);
            }

            if (state is OtpValidateLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is OtpValidateSuccess) {
              showTimer = false;

              LoaderOverlay.of(context).hide();

              handleOTPSuccess();
            } else if (state is OtpValidateFailed) {
              txtOtpController.clear();
              setState(() {
                isLoading = false;
                OTP_ERR_MSG = state.message;
                showRedBorder = true;
              });
              if (state.message!.contains('OTP validation exceeded')) {
                triggerTimer(0);
                setState(() {
                  showTimer = false;
                  enableResend = false;
                  showResend = false;
                  showGenerateOtpSuccessMsg = false;
                  secondsRemaining = 180;
                });
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
                                    GoBack(ctx);
                                    GoToReplaceData(context, hOMEROUTE, {
                                      "index": 0,
                                    });
                                  },
                                  buttonText: "Okay",
                                  buttonTxtColor:
                                      AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                                  buttonBorderColor: Colors.transparent,
                                  buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
                                  buttonSizeX: 10.h,
                                  buttonSizeY: 40.w,
                                  buttonTextSize: 14.sp,
                                  buttonTextWeight: FontWeight.w500),
                            ),
                          ],
                          child: AnimatedDialog(
                              showImgIcon: false,
                              title: state.message.toString(),
                              subTitle: "",
                              showSub: false,
                              shapeColor: Colors.orange,
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.white,
                              )),
                        ));
                  },
                );
              }
              LoaderOverlay.of(context).hide();
            } else if (state is OtpValidateError) {
              LoaderOverlay.of(context).hide();
            }

            if (state is PayBillLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is PayBillSuccess) {
              LoaderOverlay.of(context).hide();

              handleRedirect() {
                GoToData(context, tRANSROUTE, {
                  "billName": widget.data!["billName"],
                  "billerName": widget.data!['billerName'],
                  "categoryName": widget.data!["categoryName"],
                  "billerData": state.data ?? widget.data!["billerData"],
                  "inputParameters": widget.data!['inputSignature'],
                  "SavedinputParameters": widget.data!["SavedinputParameters"],
                  "isSavedBill": widget.data!['isSavedBill'],
                });
              }

              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                      onWillPop: () async => false,
                      child: CustomDialog(
                        showActions: true,
                        actions: [
                          Align(
                            alignment: Alignment.center,
                            child: MyAppButton(
                                onPressed: () {
                                  GoBack(context);

                                  handleRedirect();
                                },
                                buttonText: "Okay",
                                buttonTxtColor:
                                    AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                                buttonBorderColor: Colors.transparent,
                                buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
                                buttonSizeX: 10.h,
                                buttonSizeY: 40.w,
                                buttonTextSize: 14.sp,
                                buttonTextWeight: FontWeight.w500),
                          ),
                        ],
                        child: AnimatedDialog(
                            showImgIcon: true,
                            title: "Your Payment Has Been Successful.",
                            subTitle: "",
                            shapeColor: AppColors.CLR_GREEN,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            )),
                      ));
                },
              );
            } else if (state is PayBillFailed) {
              LoaderOverlay.of(context).hide();

              handleRedirect() {
                GoToData(context, tRANSROUTE, {
                  "billName": widget.data!["billName"],
                  "billerName": widget.data!['billerName'],
                  "categoryName": widget.data!["categoryName"],
                  "billerData": state.data ?? widget.data!["billerData"],
                  "inputParameters": widget.data!['inputSignature'],
                  "SavedinputParameters": widget.data!["SavedinputParameters"],
                  "isSavedBill": widget.data!['isSavedBill'],
                });
              }

              if (state.data != null) {
                if (state.data!["res"] == null) {
                  handleUnknownDialog();
                } else if (state.data!["res"]!["paymentDetails"]!["message"]
                    .toString()
                    .contains("Transaction initiated")) {
                  handleDialog();
                } else {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                          onWillPop: () async => false,
                          child: CustomDialog(
                              showActions: true,
                              actions: [
                                Align(
                                  alignment: Alignment.center,
                                  child: MyAppButton(
                                      onPressed: () {
                                        GoBack(context);

                                        handleRedirect();
                                      },
                                      buttonText: "Okay",
                                      buttonTxtColor:
                                          AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                                      buttonBorderColor: Colors.transparent,
                                      buttonColor:
                                          AppColors.BTN_CLR_ACTIVE_ALTER,
                                      buttonSizeX: 10.h,
                                      buttonSizeY: 40.w,
                                      buttonTextSize: 14.sp,
                                      buttonTextWeight: FontWeight.w500),
                                ),
                              ],
                              child: AnimatedDialog(
                                  showImgIcon: false,
                                  title: "Your Payment Has Been Failed.",
                                  subTitle: "",
                                  shapeColor: AppColors.CLR_ERROR,
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                  ))));
                    },
                  );
                }
              } else {
                handleUnknownDialog();
              }
            } else if (state is PayBillError) {}

            if (state is deleteBillerLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is deleteBillerSuccess) {
              LoaderOverlay.of(context).hide();
              showModalDialog(index: 0, Success: true);
            } else if (state is deleteBillerFailed) {
              LoaderOverlay.of(context).hide();
              showModalDialog(index: 0, Success: false);
            } else if (state is deleteBillerError) {
              LoaderOverlay.of(context).hide();
              showModalDialog(index: 0, Success: false);
            }

            if (state is createAutopayLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is createAutopaySuccess) {
              LoaderOverlay.of(context).hide();

              showModalDialog(index: 1, Success: true);
            } else if (state is createAutopayFailed) {
              LoaderOverlay.of(context).hide();
              showModalDialog(index: 1, Success: false);
            } else if (state is createAutopayError) {
              LoaderOverlay.of(context).hide();
              showModalDialog(index: 1, Success: false);
            }
            if (state is editAutopayLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is editAutopaySuccess) {
              LoaderOverlay.of(context).hide();

              showModalDialog(index: 2, Success: true);
            } else if (state is editAutopayFailed) {
              LoaderOverlay.of(context).hide();
              showModalDialog(index: 2, Success: false);
            } else if (state is editAutopayError) {
              LoaderOverlay.of(context).hide();
              showModalDialog(index: 2, Success: false);
            }
            if (state is deleteAutopayLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is deleteAutopaySuccess) {
              LoaderOverlay.of(context).hide();

              showModalDialog(index: 3, Success: true);
            } else if (state is deleteAutopayFailed) {
              LoaderOverlay.of(context).hide();
              showModalDialog(index: 3, Success: false);
            } else if (state is deleteAutopayError) {
              LoaderOverlay.of(context).hide();
              showModalDialog(index: 3, Success: false);
            }
            if (state is modifyAutopayLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is modifyAutopaySuccess) {
              LoaderOverlay.of(context).hide();

              showModalDialog(
                  index: widget.templateName == "disable-auto-pay" ? 4 : 5,
                  Success: true);
            } else if (state is modifyAutopayFailed) {
              LoaderOverlay.of(context).hide();
              showModalDialog(
                  index: widget.templateName == "disable-auto-pay" ? 4 : 5,
                  Success: false);
            } else if (state is modifyAutopayError) {
              LoaderOverlay.of(context).hide();
              showModalDialog(
                  index: widget.templateName == "disable-auto-pay" ? 4 : 5,
                  Success: false);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              // physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       left: 18.0.w, right: 20.w, top: 0.h, bottom: 0.h),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Text(
                  //         "Editing the Autopay",
                  //         style: TextStyle(
                  //           fontSize: 8.sp,
                  //           fontWeight: FontWeight.w400,
                  //           color: Color(0xff808080),
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //       SizedBox(width: 4),
                  //       Icon(
                  //         Icons.info_outline_rounded,
                  //         size: 9.r,
                  //         color: Color(0xff808080),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                      clipBehavior: Clip.hardEdge,
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0.r + 2.r),
                        border: Border.all(
                          color: AppColors.CLR_CON_BORDER,
                          width: 0.50,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6.0.r),
                                topLeft: Radius.circular(6.0.r)),
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              height: 33.0.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  stops: [0.001, 19],
                                  colors: [
                                    AppColors.CLR_GRD_1.withOpacity(.7),
                                    AppColors.CLR_GRD_2.withOpacity(.7),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "OTP Verification",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffffffff),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!isLoading && limitReached != true)
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 32.0.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Enter the OTP we sent to your preferred channel \n by Equitas Bank",
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.TXT_CLR_LITE,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Reference No :  ",
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.TXT_CLR_PRIMARY,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            REF_NO.toString(),
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.CLR_ERROR,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 20.w),
                                  child: SizedBox(
                                    height: 38.h,
                                    child: Pinput(
                                      length: 6,
                                      obscureText: true,
                                      obscuringCharacter: "*",
                                      controller: txtOtpController,
                                      readOnly: enableReadOnly,
                                      focusNode: focusNode,
                                      androidSmsAutofillMethod:
                                          AndroidSmsAutofillMethod
                                              .smsUserConsentApi,
                                      listenForMultipleSmsOnAndroid: false,
                                      defaultPinTheme: defaultPinTheme,
                                      onChanged: (s) {
                                        showRedBorder = false;
                                        // widget.resetErr();
                                        if (s.isEmpty) {
                                          setState(
                                            () => isBtnDisable = true,
                                          );
                                        } else {
                                          if (s.length < 6) {
                                            setState(
                                              () => isBtnDisable = true,
                                            );
                                          } else {
                                            setState(
                                              () => isBtnDisable = false,
                                            );
                                          }
                                        }
                                      },
                                      focusedPinTheme: defaultPinTheme.copyWith(
                                        width: 52.w,
                                        height: 52.h,
                                        decoration: defaultPinTheme.decoration!
                                            .copyWith(
                                          border: Border.all(
                                              color: AppColors.CLR_PRIMARY),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      enabled: true,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      errorPinTheme: defaultPinTheme.copyWith(
                                        decoration: BoxDecoration(
                                          color: AppColors.CLR_ERROR,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: showOTPverify,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 8.0.h),
                                    child: Text(
                                      "OTP verified Successfully",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.CLR_GREEN,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: OTP_ERR_MSG != null,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 8.0.h),
                                    child: Text(
                                      OTP_ERR_MSG.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.CLR_ERROR,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                if (showTimer)
                                  Padding(
                                    padding: EdgeInsets.only(top: 24.0.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          REF_NO!.isNotEmpty
                                              ? "OTP valid for"
                                              : '',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.TXT_CLR_LITE,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          REF_NO!.isNotEmpty
                                              ? " ${secondsRemaining.toString()} seconds"
                                              : '',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w600,
                                            color: secondsRemaining > 60
                                                ? AppColors.CLR_GREEN
                                                : secondsRemaining > 30
                                                    ? AppColors.CLR_ORANGE
                                                    : AppColors.CLR_ERROR,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                if (enableResend)
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.0.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Didn't recieve the OTP?",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.TXT_CLR_LITE,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 10.h),
                                        GestureDetector(
                                          onTap: () {
                                            if (enableResend) {
                                              resendCode();
                                            }
                                          },
                                          child: Text(
                                            "Resend OTP",
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                              color: enableResend
                                                  ? AppColors.TXT_CLR_PRIMARY
                                                  : AppColors.TXT_CLR_GREY,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(
                                  height: 20.h,
                                )
                              ],
                            )
                          else if (!isLoading && limitReached == true)
                            Container(
                              alignment: Alignment.center,
                              height: 220.h,
                              margin: EdgeInsets.only(
                                  left: 18.0.w,
                                  right: 18.w,
                                  top: 0.h,
                                  bottom: 0.h),
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    Center(
                                      child: SvgPicture.asset(
                                        IMG_SMTWR,
                                        height: 60.h,
                                        width: 60.w,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    Text(
                                      OTP_ERR_MSG.toString(),
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.TXT_CLR_LITE,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Container(
                              height: 220.h,
                              child: Center(child: Loader()),
                            )
                        ],
                      )),
                  // SizedBox(
                  //   height: 100.h,
                  // ),
                  if (!isLoading && limitReached == false)
                    ...tabInfoItems
                        .animate(interval: 600.ms)
                        .fadeIn(duration: 900.ms, delay: 300.ms)
                        .shimmer(
                            blendMode: BlendMode.srcOver, color: Colors.white12)
                        .move(
                            begin: const Offset(-16, 0),
                            curve: Curves.easeOutQuad),

                  BbpsLogoContainer(
                    showEquitasLogo: false,
                  ),
                  SizedBox(
                    height: 70.h,
                  )
                ],
              ),
            );
          },
        ),
        bottomSheet: !isLoading
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
                              // BlocProvider.of<HomeCubit>(context).validateOTP(0000);
                              if (!isBtnDisable) {
                                handleSubmit();
                              }
                            },
                            buttonText: "Verify",
                            buttonTxtColor: isBtnDisable
                                ? AppColors.BTN_CLR_DISABLE_TEXT
                                : AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                            buttonBorderColor: Colors.transparent,
                            buttonColor: isBtnDisable
                                ? AppColors.BTN_CLR_DISABLE
                                : AppColors.BTN_CLR_ACTIVE_ALTER,
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
