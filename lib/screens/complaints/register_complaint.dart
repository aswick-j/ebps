import 'package:ebps/bloc/complaint/complaint_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/biller_details_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/complaints_config_model.dart';
import 'package:ebps/widget/bbps_logo.dart';
import 'package:ebps/widget/get_biller_detail.dart';
import 'package:ebps/widget/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class RegisterComplaint extends StatefulWidget {
  String txnRefID;
  String BillerName;
  String CategoryName;
  String Date;
  RegisterComplaint({
    super.key,
    required this.txnRefID,
    required this.BillerName,
    required this.CategoryName,
    required this.Date,
  });

  @override
  State<RegisterComplaint> createState() => _RegisterComplaintState();
}

class _RegisterComplaintState extends State<RegisterComplaint> {
  List<ComplaintTransactionDurations>? complaint_durations = [];
  List<ComplaintTransactionReasons>? complaint_reasons = [];
  String? cmp_reason;
  String? cmp_reasonID;
  String? cmp_desc;
  String? ComplaintMSG;
  bool cmpNotValid = true;

  String? REG_CMP_ID;

  bool isComplaintConfigLoading = false;

  final txtDescController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<ComplaintCubit>(context).getComplaintConfig();
    super.initState();
  }

  handleSubmit() {
    Map<String, dynamic> data = {
      "description": cmp_desc,
      "reason": cmp_reason,
      "complaintReasonsID": cmp_reasonID,
      "type": "transaction",
      "transactionID": widget.txnRefID
    };
    BlocProvider.of<ComplaintCubit>(context).submitComplaint(data);
  }

  handleDialog({required bool success, required BuildContext ctx}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                // actions: [
                //   Align(
                //     alignment: Alignment.center,
                //     child: MyAppButton(
                //         onPressed: () {
                //           goBack(context);
                //         },
                //         buttonText: "Okay",
                //         buttonTxtColor: BTN_CLR_ACTIVE,
                //         buttonBorderColor: Colors.transparent,
                //         buttonColor: AppColors.CLR_PRIMARY,
                //         buttonSizeX: 10.h,
                //         buttonSizeY: 40.w,
                //         buttonTextSize: 14.sp,
                //         buttonTextWeight: FontWeight.w500),
                //   ),
                // ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 3,
                content: SingleChildScrollView(
                  padding: EdgeInsets.all(0.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: 50.h,
                          width: 50.w,
                          child: SvgPicture.asset(
                              success ? ICON_SUCCESS : ICON_FAILED)),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        success
                            ? "Your Complaint Has Been Registered Successfully"
                            : ComplaintMSG.toString(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.CLR_PRIMARY,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (success)
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0.r + 2.r),
                              color: Color(0xffE8ECF3),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0.r),
                              child: Column(children: [
                                Text(
                                  "For future detail track complaint ID",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: TXT_CLR_PRIMARY,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      REG_CMP_ID.toString(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff1b438b),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: REG_CMP_ID.toString()))
                                              .then((_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Complaint ID copied to clipboard')));
                                          });
                                        },
                                        child: Icon(Icons.copy,
                                            color: Color(0xff1b438b), size: 20))
                                  ],
                                )
                              ]),
                            )),
                      SizedBox(
                        height: 10.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: MyAppButton(
                            onPressed: () {
                              goBack(context);
                              goBack(ctx);
                            },
                            buttonText: "Okay",
                            buttonTxtColor: BTN_CLR_ACTIVE,
                            buttonBorderColor: Colors.transparent,
                            buttonColor: AppColors.CLR_PRIMARY,
                            buttonSizeX: 10.h,
                            buttonSizeY: 40.w,
                            buttonTextSize: 14.sp,
                            buttonTextWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: MyAppBar(
          context: context,
          title: 'Raise a Complaint',
          actions: [],
          onLeadingTap: () => Navigator.pop(context),
          showActions: true,
          onSearchTap: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: BlocConsumer<ComplaintCubit, ComplaintState>(
                listener: (context, state) {
              if (state is ComplaintConfigLoading) {
                isComplaintConfigLoading = true;
              } else if (state is ComplaintConfigSuccess) {
                complaint_durations =
                    state.ComplaintConfigList!.complaintTransactionDurations;
                complaint_reasons =
                    state.ComplaintConfigList!.complaintTransactionReasons;
                isComplaintConfigLoading = false;
              } else if (state is ComplaintConfigFailed) {
                isComplaintConfigLoading = false;
              } else if (state is ComplaintConfigError) {
                isComplaintConfigLoading = false;
              }

              if (state is ComplaintSubmitLoading) {
                LoaderOverlay.of(context).show();
              } else if (state is ComplaintSubmitSuccess) {
                LoaderOverlay.of(context).hide();
                REG_CMP_ID = state.data.toString();
                handleDialog(success: true, ctx: context);
              } else if (state is ComplaintSubmitFailed) {
                ComplaintMSG = state.message.toString();
                LoaderOverlay.of(context).hide();
                handleDialog(success: false, ctx: context);
              } else if (state is ComplaintSubmitError) {
                ComplaintMSG = state.message.toString();

                handleDialog(success: false, ctx: context);

                LoaderOverlay.of(context).hide();
              }
            }, builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: isComplaintConfigLoading
                          ? const Text("Loading")
                          : Column(
                              children: [
                                BillerDetailsContainer(
                                    icon: BILLER_LOGO(widget.BillerName),
                                    billerName: widget.BillerName,
                                    categoryName: widget.CategoryName),
                                Container(
                                    width: double.infinity,
                                    height: 80.h,
                                    color: Colors.white,
                                    child: ListView(
                                      primary: false,
                                      physics: NeverScrollableScrollPhysics(),
                                      // crossAxisSpacing: 10.h,
                                      // crossAxisCount: 2,
                                      // childAspectRatio: 4 / 2,
                                      // mainAxisSpacing: 10.h,
                                      children: [
                                        Container(
                                            // margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.r),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            24.w,
                                                            10.h,
                                                            8.w,
                                                            10.h),
                                                    child: SizedBox(
                                                      width: 70.w,
                                                      child: Text(
                                                        "Date",
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff808080),
                                                        ),
                                                        maxLines: 3,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    )),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(8.w,
                                                            10.h, 24.w, 10.h),
                                                    child: SizedBox(
                                                      width: 130.w,
                                                      child: Text(
                                                        DateFormat(
                                                                'dd/MM/yyyy | hh:mm a')
                                                            .format(DateTime
                                                                    .parse(widget
                                                                            .Date
                                                                        .toString())
                                                                .toLocal()),
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff1b438b),
                                                        ),
                                                        maxLines: 3,
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ))
                                              ],
                                            )),
                                        Container(
                                            // margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.r),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            24.w,
                                                            10.h,
                                                            8.w,
                                                            10.h),
                                                    child: SizedBox(
                                                      width: 110.w,
                                                      child: Text(
                                                        "Transaction ID",
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff808080),
                                                        ),
                                                        maxLines: 3,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    )),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(8.w,
                                                            10.h, 24.w, 10.h),
                                                    child: SizedBox(
                                                      width: 130.w,
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                          widget.txnRefID,
                                                          style: TextStyle(
                                                            fontSize: 11.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff1b438b),
                                                          ),
                                                          maxLines: 3,
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            )),
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.0.w, vertical: 16.w),
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    isDense: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0.r),
                                        ),
                                      ),
                                      fillColor:
                                          Color(0xffD1D9E8).withOpacity(0.2),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: CLR_GREY),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: CLR_GREY),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0.h, horizontal: 10.w),
                                    ),
                                    hint: const Text('Reason'),
                                    onChanged: (String? newValue) {},
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                    ),
                                    items: complaint_reasons!.map<
                                            DropdownMenuItem<String>>(
                                        (ComplaintTransactionReasons value) {
                                      return DropdownMenuItem<String>(
                                        value:
                                            value.cOMPLAINTREASONSID.toString(),
                                        child: Text(
                                          value.cOMPLAINTREASON.toString(),
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            cmp_reason = value.cOMPLAINTREASON
                                                .toString();
                                            cmp_reasonID = value
                                                .cOMPLAINTREASONSID
                                                .toString();
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.0.w, vertical: 16.w),
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[a-z0-9A-Z.,:?!() ]*'))
                                    ],
                                    onChanged: (s) {
                                      setState(() {
                                        if (s.isNotEmpty) {
                                          cmpNotValid = false;
                                        } else {
                                          cmpNotValid = true;
                                        }
                                        cmp_desc = s.toString();
                                      });
                                    },
                                    maxLines: 3,
                                    controller: txtDescController,
                                    cursorColor: CLR_BLUE_LITE,
                                    maxLength: 200,
                                    decoration: InputDecoration(
                                        labelText: "Description",
                                        hintText: "Type here...",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12.0.r),
                                          ),
                                        ),
                                        fillColor:
                                            Color(0xffD1D9E8).withOpacity(0.2),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: CLR_GREY),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: CLR_GREY),
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: 12.sp,
                                          color: TXT_CLR_PRIMARY,
                                        ),
                                        alignLabelWithHint: true,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelStyle: TextStyle(
                                            color: const Color(0xFF424242))),
                                  ),
                                ),
                              ],
                            )),
                  SizedBox(
                    height: 50.h,
                  ),
                  BbpsLogoContainer(showEquitasLogo: false),
                  SizedBox(
                    height: 70.h,
                  )
                ],
              );
            })),
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
                        if (cmp_reason != null &&
                            cmp_reasonID != null &&
                            !cmpNotValid) {
                          // handleDialog(success: true);
                          handleSubmit();
                        }
                      },
                      buttonText: "Submit",
                      buttonTxtColor: BTN_CLR_ACTIVE,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: cmp_reason != null &&
                              cmp_reasonID != null &&
                              !cmpNotValid
                          ? AppColors.CLR_PRIMARY
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
