import 'dart:async';

import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/services/api.dart';
import 'package:ebps/widget/animated_dialog.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  AllConfigurationsData? autopayData;
  String? id;
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
      this.data});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final txtOtpController = TextEditingController();
  final focusNode = FocusNode();
  String? OTP_ERR_MSG;
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
    handleIntial();
    getAccountDetails();
    super.initState();
  }

  @override
  void dispose() {
    if (!mounted) {
      txtOtpController.clear();
    }

    super.dispose();
  }

  handleSubmit() {
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
      OTP_ERR_MSG = null;
    });
  }

  resendCode() async {
    try {
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
    showModalDialog({required String title}) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0.r)),
              child: Container(
                height: 200.h,
                child: Padding(
                  padding: EdgeInsets.all(12.0.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline_sharp,
                          color: CLR_GREEN, size: 50.r),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: CLR_GREEN,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      MyAppButton(
                          onPressed: () {
                            goBack(context);

                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              Navigator.of(widget.ctx).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => BottomNavBar(
                                          SelectedIndex: 1,
                                        )),
                              );
                            });
                          },
                          buttonText: "Okay",
                          buttonTxtColor: BTN_CLR_ACTIVE,
                          buttonBorderColor: Colors.transparent,
                          buttonColor: CLR_PRIMARY,
                          buttonSizeX: 10.h,
                          buttonSizeY: 40.w,
                          buttonTextSize: 14.sp,
                          buttonTextWeight: FontWeight.w500),
                    ],
                  ),
                ),
              ),
            );
          });
      // return showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       content: AnimatedDialog(
      //         title: title,
      //         subTitle: "",
      //         child: Icon(
      //           Icons.check,
      //           color: Colors.white,
      //         ),
      //       ),
      //       actions: <Widget>[
      //         Align(
      //           alignment: Alignment.center,
      //           child: MyAppButton(
      //               onPressed: () {
      //                 goBack(context);

      //                 WidgetsBinding.instance?.addPostFrameCallback((_) {
      //                   Navigator.of(widget.ctx).pushReplacement(
      //                     MaterialPageRoute(
      //                         builder: (context) => BottomNavBar(
      //                               SelectedIndex: 1,
      //                             )),
      //                   );
      //                 });
      //               },
      //               buttonText: "Okay",
      //               buttonTxtColor: BTN_CLR_ACTIVE,
      //               buttonBorderColor: Colors.transparent,
      //               buttonColor: CLR_PRIMARY,
      //               buttonSizeX: 10,
      //               buttonSizeY: 40,
      //               buttonTextSize: 14,
      //               buttonTextWeight: FontWeight.w500),
      //         ),
      //       ],
      //     );
      //   },
      // );
    }

    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.h,
      textStyle: TextStyle(
        fontSize: 14.sp,
        letterSpacing: 16.0,
        fontWeight: FontWeight.bold,
        color: TXT_CLR_PRIMARY,
      ),
      decoration: BoxDecoration(
        color: BTN_CLR_ACTIVE,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey),
      ),
    );

    return LoaderOverlay(
      child: Scaffold(
        appBar: MyAppBar(
          context: context,
          title: widget.data!['billerName'],
          onLeadingTap: () => goBack(context),
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
              });
            } else if (state is OtpError) {
              setState(() {
                isLoading = false;
                OTP_ERR_MSG = state.message;
              });
              // goToUntil(context, hOMEROUTE);
            }

            if (state is OtpValidateLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is OtpValidateSuccess) {
              LoaderOverlay.of(context).hide();

              handleOTPSuccess();
            } else if (state is OtpValidateFailed) {
              txtOtpController.clear();
              setState(() {
                isLoading = false;
                OTP_ERR_MSG = state.message;
              });
              if (state.message!.contains('OTP validation exceeded')) {
                triggerTimer(0);
                setState(() {
                  showTimer = false;
                  enableResend = false;
                  showResend = false;
                  showGenerateOtpSuccessMsg = false;
                  secondsRemaining = 20;
                });
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
                goToData(context, tRANSROUTE, {
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
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: AnimatedDialog(
                        title: "Your Payment Has Been Successful.",
                        subTitle: "",
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        shapeColor: CLR_GREEN),
                    actions: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: MyAppButton(
                            onPressed: () {
                              goBack(context);

                              handleRedirect();
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
                  );
                },
              );
            } else if (state is PayBillFailed) {
              LoaderOverlay.of(context).hide();

              handleRedirect() {
                goToData(context, tRANSROUTE, {
                  "billName": widget.data!["billName"],
                  "billerName": widget.data!['billerName'],
                  "categoryName": widget.data!["categoryName"],
                  "billerData": state.data ?? widget.data!["billerData"],
                  "inputParameters": widget.data!['inputSignature'],
                  "SavedinputParameters": widget.data!["SavedinputParameters"],
                  "isSavedBill": widget.data!['isSavedBill'],
                });
              }

              if (state.data!["res"]["reason"] ==
                  'Bill Payment failed from BBPS') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: AnimatedDialog(
                          title: "Your Payment Has Been Failed.",
                          subTitle: "",
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                          shapeColor: CLR_ERROR),
                      actions: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: MyAppButton(
                              onPressed: () {
                                goBack(context);

                                handleRedirect();
                              },
                              buttonText: "Okay",
                              buttonTxtColor: BTN_CLR_ACTIVE,
                              buttonBorderColor: Colors.transparent,
                              buttonColor: CLR_PRIMARY,
                              buttonSizeX: 10,
                              buttonSizeY: 40,
                              buttonTextSize: 14,
                              buttonTextWeight: FontWeight.w500),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      content: AnimatedDialog(
                          title: "Your Payment is Pending",
                          subTitle:
                              "Please, Visit History Section For More Information",
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.white,
                          ),
                          showSub: true,
                          shapeColor: Colors.orange),
                      actions: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: MyAppButton(
                              onPressed: () {
                                goBack(ctx);

                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => BottomNavBar(
                                              SelectedIndex: 0,
                                            )),
                                    (Route<dynamic> route) => false,
                                  );
                                });
                              },
                              buttonText: "Okay",
                              buttonTxtColor: BTN_CLR_ACTIVE,
                              buttonBorderColor: Colors.transparent,
                              buttonColor: CLR_PRIMARY,
                              buttonSizeX: 10,
                              buttonSizeY: 40,
                              buttonTextSize: 14,
                              buttonTextWeight: FontWeight.w500),
                        ),
                      ],
                    );
                  },
                );
              }
            } else if (state is PayBillError) {}

            if (state is deleteBillerLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is deleteBillerSuccess) {
              LoaderOverlay.of(context).hide();
              showModalDialog(
                  title: "Your Biller Has Been Deleted Successfully");
            } else if (state is deleteBillerFailed) {
              LoaderOverlay.of(context).hide();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: AnimatedDialog(
                        title: "Your Biller Has Been Deleted Successfully.",
                        subTitle: "",
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        shapeColor: CLR_GREEN),
                    actions: <Widget>[
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
                            buttonSizeX: 10,
                            buttonSizeY: 40,
                            buttonTextSize: 14,
                            buttonTextWeight: FontWeight.w500),
                      ),
                    ],
                  );
                },
              );
            } else if (state is deleteBillerError) {
              LoaderOverlay.of(context).hide();
            }

            if (state is createAutopayLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is createAutopaySuccess) {
              LoaderOverlay.of(context).hide();

              showModalDialog(title: "Autopay Created Successfully");
            } else if (state is createAutopayFailed) {
              LoaderOverlay.of(context).hide();
            } else if (state is createAutopayError) {
              LoaderOverlay.of(context).hide();
            }
            if (state is editAutopayLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is editAutopaySuccess) {
              LoaderOverlay.of(context).hide();

              showModalDialog(title: "Autopay Updated Successfully");
            } else if (state is editAutopayFailed) {
              LoaderOverlay.of(context).hide();
            } else if (state is editAutopayError) {
              LoaderOverlay.of(context).hide();
            }
            if (state is deleteAutopayLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is deleteAutopaySuccess) {
              LoaderOverlay.of(context).hide();

              showModalDialog(title: "Autopay Deleted Successfully");
            } else if (state is deleteAutopayFailed) {
              LoaderOverlay.of(context).hide();
            } else if (state is deleteAutopayError) {
              LoaderOverlay.of(context).hide();
            }
            if (state is modifyAutopayLoading) {
              LoaderOverlay.of(context).show();
            } else if (state is modifyAutopaySuccess) {
              LoaderOverlay.of(context).hide();

              showModalDialog(
                  title:
                      "Autopay ${widget.templateName == "disable-auto-pay" ? "Paused" : "Resume"} Successfully");
            } else if (state is modifyAutopayFailed) {
              LoaderOverlay.of(context).hide();
            } else if (state is modifyAutopayError) {
              LoaderOverlay.of(context).hide();
            }
          },
          builder: (context, state) {
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
                          color: Color(0xffD1D9E8),
                          width: 1.0,
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
                                    Color(0xff768EB9).withOpacity(.7),
                                    Color(0xff463A8D).withOpacity(.7),
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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Enter the OTP we sent to your preferd channel \n by Equitas Bank",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff808080),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Reference No :  ",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: TXT_CLR_PRIMARY,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      REF_NO.toString(),
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: CLR_ERROR,
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
                                controller: txtOtpController,
                                readOnly: enableReadOnly,
                                focusNode: focusNode,
                                androidSmsAutofillMethod:
                                    AndroidSmsAutofillMethod.none,
                                listenForMultipleSmsOnAndroid: true,
                                defaultPinTheme: defaultPinTheme,
                                onChanged: (s) {
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
                                  decoration:
                                      defaultPinTheme.decoration!.copyWith(
                                    border: Border.all(color: CLR_PRIMARY),
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
                                    color: CLR_ERROR,
                                    borderRadius: BorderRadius.circular(8.r),
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
                                  color: CLR_GREEN,
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
                                  color: CLR_ERROR,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                          ),
                          if (showTimer)
                            Padding(
                              padding: EdgeInsets.only(top: 24.0.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    REF_NO!.isNotEmpty ? "OTP valid for" : '',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff808080),
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
                                      color: TXT_CLR_PRIMARY,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't recieve the OTP?",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff808080),
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
                                          ? TXT_CLR_PRIMARY
                                          : Colors.grey,
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
                      )),
                  SizedBox(
                    height: 100.h,
                  ),
                  BbpsLogoContainer(
                    showEquitasLogo: false,
                  ),
                  // SizedBox(
                  //   height: 70.h,
                  // )
                ],
              ),
            );
          },
        ),
        bottomSheet: Container(
          decoration: BoxDecoration(
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
                        // BlocProvider.of<HomeCubit>(context).validateOTP(0000);
                        if (!isBtnDisable) {
                          handleSubmit();
                        }
                      },
                      buttonText: "Verify",
                      buttonTxtColor: BTN_CLR_ACTIVE,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: isBtnDisable ? Colors.grey : CLR_PRIMARY,
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
