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

class RegisterComplaint extends StatefulWidget {
  String txnRefID;
  RegisterComplaint({
    super.key,
    required this.txnRefID,
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

  handleDialog({required bool success}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
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
              //         buttonColor: CLR_PRIMARY,
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
                padding: EdgeInsets.all(20.r),
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
                          ? "Your Compliant Has Been Registered Successfully"
                          : ComplaintMSG.toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: CLR_PRIMARY,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    if (success)
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          decoration: BoxDecoration(color: Color(0xffE8ECF3)),
                          child: Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Column(children: [
                              Text(
                                "For future detail track compliant ID",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: TXT_CLR_PRIMARY,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "QB145458781589585288",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1b438b),
                                ),
                                textAlign: TextAlign.center,
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
                handleDialog(success: true);
              } else if (state is ComplaintSubmitFailed) {
                ComplaintMSG = state.message.toString();
                LoaderOverlay.of(context).hide();
                handleDialog(success: false);
              } else if (state is ComplaintSubmitError) {}
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
                                    icon: LOGO_BBPS,
                                    billerName: "billerName",
                                    categoryName: "categoryName"),
                                Container(
                                    width: double.infinity,
                                    height: 75.h,
                                    color: Colors.white,
                                    child: GridView.count(
                                      primary: false,
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisSpacing: 10.h,
                                      crossAxisCount: 2,
                                      childAspectRatio: 4 / 2,
                                      mainAxisSpacing: 10.h,
                                      children: [
                                        billerDetail(
                                            "Date", "01/08/2023", context),
                                        billerDetail(
                                            "Refernce ID", "TRAN1234", context),
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 28.0.w, vertical: 16.w),
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    isDense: true,
                                    hint: const Text('Reason'),
                                    onChanged: (String? newValue) {},
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                    ),
                                    items: complaint_reasons!.map<
                                            DropdownMenuItem<String>>(
                                        (ComplaintTransactionReasons value) {
                                      print(value);
                                      return DropdownMenuItem<String>(
                                        value:
                                            value.cOMPLAINTREASONSID.toString(),
                                        child: Text(
                                          value.cOMPLAINTREASON.toString(),
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
                                      horizontal: 28.0.w, vertical: 16.w),
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[a-z0-9A-Z ]*'))
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
                                    decoration: InputDecoration(
                                        labelText: "Description",
                                        hintText: "Type here...",
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
                          handleSubmit();
                        }
                      },
                      buttonText: "Submit",
                      buttonTxtColor: BTN_CLR_ACTIVE,
                      buttonBorderColor: Colors.transparent,
                      buttonColor: cmp_reason != null &&
                              cmp_reasonID != null &&
                              !cmpNotValid
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
