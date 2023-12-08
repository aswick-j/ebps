import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/data/models/history_model.dart';
import 'package:ebps/data/services/api_client.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getTransactionStatus.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Button/MyAppButton.dart';
import 'package:ebps/presentation/common/Container/History/history_container.dart';
import 'package:ebps/presentation/widget/date_picker.dart';
import 'package:ebps/presentation/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(repository: apiClient),
      child: HistoryScreenUI(),
    );
  }
}

class HistoryScreenUI extends StatefulWidget {
  const HistoryScreenUI({super.key});

  @override
  State<HistoryScreenUI> createState() => _HistoryScreenUIState();
}

class _HistoryScreenUIState extends State<HistoryScreenUI> {
  dynamic fromdateController = TextEditingController();
  dynamic todateController = TextEditingController();
  dynamic catController = TextEditingController();
  dynamic billerController = TextEditingController();

  List<String> Periods = [
    "Today",
    'Yesterday',
    "This Week",
    "Last Week",
    "This Month",
    'Last Month',
    "Custom"
  ];

  List<HistoryData>? historyData = [];
  bool isHistoryLoading = false;
  @override
  void initState() {
    BlocProvider.of<HistoryCubit>(context)
        .getHistoryDetails('This Week', false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'History',
        onLeadingTap: () => Navigator.pop(context),
        showActions: true,
        actions: [
          InkWell(
              onTap: () => {goTo(context, cOMPLAINTLISTROUTE)},
              child: Container(
                  margin: EdgeInsets.only(top: 20.h, bottom: 20.h, right: 15.w),
                  width: 30.w,
                  decoration: ShapeDecoration(
                    color: Color(0xff4969A2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: Container(
                    width: 20.w,
                    height: 40.h,
                    child: Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: Icon(
                        Icons.comment,
                        color: Colors.white,
                      ),
                    ),
                  )))
        ],
      ),
      body: BlocConsumer<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state is HistoryLoading) {
            isHistoryLoading = true;
          } else if (state is HistorySuccess) {
            historyData = state.historyData;
            isHistoryLoading = false;
          } else if (state is HistoryFailed) {
            isHistoryLoading = false;
          } else if (state is HistoryError) {}
        },
        builder: (context, state) {
          return SingleChildScrollView(
              child: Column(
            children: [
              !isHistoryLoading
                  ? Container(
                      height: 550.h,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: historyData!.length,
                        physics: const BouncingScrollPhysics(),
                        // controller: infiniteScrollController,
                        itemBuilder: (context, index) {
                          return HistoryContainer(
                            historyData: historyData![index],
                            titleText: 'Paid to',
                            subtitleText:
                                historyData![index].bILLERNAME.toString(),
                            dateText: DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(historyData![index]
                                        .cOMPLETIONDATE
                                        .toString())
                                    .toLocal()),
                            amount:
                                "₹ ${NumberFormat('#,##,##0.00').format(double.parse(historyData![index].bILLAMOUNT.toString()))}",
                            // '₹ ${historyData![index].bILLAMOUNT.toString()}',
                            statusText: historyData![index]
                                        .tRANSACTIONSTATUS
                                        .toString() ==
                                    'success'
                                ? null
                                : getTransactionStatus(historyData![index]
                                    .tRANSACTIONSTATUS
                                    .toString()),
                            iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
                            containerBorderColor: Color(0xffD1D9E8),
                          );
                        },
                      ),
                    )
                  : Container(
                      height: 500,
                      width: double.infinity,
                      child: Center(child: FlickrLoader())),
            ],
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16.0.r),
                ),
              ),
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15.h, bottom: 15.h, left: 15.w, right: 15.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_alt_outlined,
                            color: Color(0xff1b438b),
                          ),
                          Text(
                            "Filters",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1b438b),
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.6,
                              blurRadius: 4,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Divider(
                        height: 1.h,
                        thickness: 1,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: TextFormField(
                        controller: fromdateController,
                        readOnly: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                        onTap: () async {
                          DateTime? pickedDate = await DatePicker(context);
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            setState(() {
                              fromdateController.text = formattedDate;
                              todateController.clear();
                            });
                          }
                        },
                        validator: (inputValue) {},
                        decoration: InputDecoration(
                          fillColor: const Color(0xffD1D9E8).withOpacity(0.2),
                          filled: true,
                          labelStyle: const TextStyle(color: Color(0xff1b438b)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff1B438B)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff1B438B)),
                          ),
                          border: const UnderlineInputBorder(),
                          labelText: 'From Date',
                          hintText: "From Date",
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: TextFormField(
                        controller: todateController,
                        readOnly: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                        onTap: () async {
                          if (fromdateController.text.isNotEmpty) {
                            DateTime? pickedDate = await DatePicker(context);
                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              setState(() {
                                todateController.text = formattedDate;
                              });
                            }
                          } else {
                            print("Please select 'From Date' first.");
                          }
                        },
                        validator: (inputValue) {
                          if (fromdateController.text.isEmpty) {
                            return "Please select 'From Date' first.";
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: const Color(0xffD1D9E8).withOpacity(0.2),
                          filled: true,
                          // errorText: fromdateController.text.isEmpty
                          //     ? "Please select 'From Date' first."
                          //     : null,
                          labelStyle: const TextStyle(color: Color(0xff1b438b)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff1B438B)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff1B438B)),
                          ),
                          border: const UnderlineInputBorder(),
                          labelText: 'To Date',
                          hintText: "To Date",
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: TextFormField(
                        controller: catController,
                        readOnly: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                        onTap: () {},
                        validator: (inputValue) {},
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
                            labelText: 'Selcet Categories',
                            hintText: "Selcet Categories"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 0.h, bottom: 16.h, left: 16.w, right: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                onPressed: () {},
                                buttonText: "Apply",
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
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                );
              });
        },
        backgroundColor: CLR_PRIMARY,
        child: Icon(Icons.filter_alt_outlined),
      ),
    );
  }
}
