import 'package:ebps/bloc/complaint/complaint_cubit.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/data/models/complaints_config_model.dart';
import 'package:ebps/data/services/api_client.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:ebps/presentation/common/Container/Home/biller_details_container.dart';
import 'package:ebps/presentation/widget/get_biller_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterComplaint extends StatefulWidget {
  const RegisterComplaint({super.key});

  @override
  State<RegisterComplaint> createState() => _RegisterComplaintState();
}

class _RegisterComplaintState extends State<RegisterComplaint> {
  List<ComplaintTransactionDurations>? complaint_durations = [];
  List<ComplaintTransactionReasons>? complaint_reasons = [];
  String? cmp_reason;
  String? cmp_reasonID;

  bool isComplaintConfigLoading = false;

  final txtDescController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<ComplaintCubit>(context).getComplaintConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComplaintCubit, ComplaintState>(
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
    }, builder: (context, state) {
      return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: 'Raise For Complaint',
          actions: [],
          onLeadingTap: () => Navigator.pop(context),
          showActions: true,
          onSearchTap: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
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
                      ? Text("Loading")
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
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  childAspectRatio: 4 / 2,
                                  children: [
                                    billerDetail("Date", "01/08/2023", context),
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
                                items: complaint_reasons!
                                    .map<DropdownMenuItem<String>>(
                                        (ComplaintTransactionReasons value) {
                                  print(value);
                                  return DropdownMenuItem<String>(
                                    value: value.cOMPLAINTREASONSID.toString(),
                                    child: Text(
                                      value.cOMPLAINTREASON.toString(),
                                    ),
                                    onTap: () {
                                      cmp_reason =
                                          value.cOMPLAINTREASON.toString();
                                      cmp_reasonID =
                                          value.cOMPLAINTREASONSID.toString();
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
                                  // if (s.isEmpty != "") {
                                  //   setState(() {
                                  //     desField = true;
                                  //   });
                                  // } else {
                                  //   setState(() {
                                  //     desField = false;
                                  //   });
                                  // }
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
                height: 70.h,
              )
            ],
          ),
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
                      onPressed: () {},
                      buttonText: "Submit",
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
      );
    });
  }
}
