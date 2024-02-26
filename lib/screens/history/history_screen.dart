import 'dart:async';

import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/History/history_container.dart';
import 'package:ebps/common/Text/MyAppText.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getTransactionStatus.dart';
import 'package:ebps/models/history_model.dart';
import 'package:ebps/screens/history/history_filter.dart';
import 'package:ebps/screens/nodataFound.dart';
import 'package:ebps/services/api_client.dart';
import 'package:ebps/widget/date_picker.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HistoryCubit(repository: apiClient)),
        BlocProvider(create: (_) => HomeCubit(repository: apiClient)),
      ],
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

  DateTime? fromDate;
  DateTime? toFirstDate;
  DateTime? toDate;

  String? categoryID;
  String? billerID;
  String? categoryName;
  String? billerName;
  bool showClrFltr = false;
  bool showToDateErr = false;
  bool MoreLoading = true;
  late int _pageNumber;
  late int _totalPages;
  List<String> Periods = [
    "Today",
    'Yesterday',
    "This Week",
    "Last Week",
    "This Month",
    'Last Month',
    "Custom"
  ];

  var dragController = DraggableScrollableController();
  final infiniteScrollController = ScrollController();

  List<HistoryData>? historyData = [];

  bool isCategoryLoading = false;
  bool isHistoryLoading = true;
  bool isHistoryMoreLoading = false;
  bool isHistoryFilterLoading = false;
  @override
  void initState() {
    _pageNumber = 1;
    _totalPages = 1;
    BlocProvider.of<HistoryCubit>(context).getHistoryDetails({
      "startDate": DateTime(2016).toLocal().toIso8601String(),
      "endDate": DateTime.now().toLocal().toIso8601String(),
    }, "", "", _pageNumber, true);
    // BlocProvider.of<HomeCubit>(context).getAllCategories();
    initScrollController(context);
    super.initState();
  }

  void initScrollController(context) {
    infiniteScrollController.addListener(() {
      if (infiniteScrollController.position.atEdge) {
        if (infiniteScrollController.position.pixels != 0) {
          if (_totalPages != _pageNumber) {
            MoreLoading = true;
            _pageNumber = _pageNumber + 1;
            BlocProvider.of<HistoryCubit>(context).getHistoryDetails({
              "startDate": fromDate != null
                  ? fromDate!.toLocal().toIso8601String()
                  : DateTime(2016).toLocal().toIso8601String(),
              "endDate": toDate != null
                  ? toDate!.toLocal().toIso8601String()
                  : DateTime.now().toLocal().toIso8601String(),
            }, categoryID, billerID, _pageNumber, true);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    handleFilterModal(biller_id, biller_name, category_ID, category_name) {
      setState(() {
        billerID = biller_id;
        categoryID = category_ID;
        billerName = biller_name;
        categoryName = category_name;
      });
    }

    handleFilter() {
      BlocProvider.of<HistoryCubit>(context).getHistoryDetails({
        "startDate": fromDate != null
            ? fromDate!.toLocal().toIso8601String()
            : DateTime(2016).toLocal().toIso8601String(),
        "endDate": toDate != null
            ? toDate!.toLocal().toIso8601String()
            : DateTime.now().toLocal().toIso8601String(),
      }, categoryID, billerID, _pageNumber, true);
      goBack(context);
      setState(() {
        showClrFltr = true;
      });
    }

    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'History',
        onLeadingTap: () => WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => BottomNavBar(
                      SelectedIndex: 1,
                    )),
          );
        }),
        showActions: true,
        actions: [
          InkWell(
              onTap: () => {goTo(context, cOMPLAINTLISTROUTE)},
              child: Container(
                  margin: EdgeInsets.only(right: 15.w),
                  decoration: ShapeDecoration(
                    color: Color(0xff4969A2),
                    shape: CircleBorder(),
                  ),
                  child: Container(
                    width: 30.w,
                    height: 30.h,
                    child: SvgPicture.asset(ICON_COMPLAINTS),
                  )))
        ],
      ),
      body: SingleChildScrollView(
          child: MultiBlocListener(
              listeners: [
            BlocListener<HistoryCubit, HistoryState>(
                listener: (context, state) {
              if (state is HistoryLoading && state.isFirstFetch) {
                isHistoryLoading = true;
              }
              setState(() {
                isHistoryMoreLoading = true;
                historyData = [];
              });

              if (state is HistoryLoading) {
                setState(() {
                  historyData = state.prevData;
                  MoreLoading = true;
                  if (historyData!.length > 1) {
                    _totalPages =
                        historyData![historyData!.length - 1].tOTALPAGES!;
                  }
                  isHistoryMoreLoading = true;
                });
              } else if (state is HistorySuccess) {
                setState(() {
                  historyData = state.historyData;
                  if (historyData!.length > 1) {
                    _totalPages =
                        historyData![historyData!.length - 1].tOTALPAGES!;
                  }
                  isHistoryLoading = false;
                  MoreLoading = false;
                });
              } else if (state is HistoryFailed) {
                setState(() {
                  isHistoryLoading = false;
                  isHistoryMoreLoading = false;
                });
              } else if (state is HistoryError) {
                setState(() {
                  isHistoryLoading = false;
                  isHistoryMoreLoading = false;
                });
              }
            }),
          ],
              child: Column(
                children: [
                  if (!isHistoryLoading && showClrFltr)
                    InkWell(
                      onTap: () =>
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => BottomNavBar(
                                    SelectedIndex: 2,
                                  )),
                        );
                      }),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 18.0.w, right: 18.w, top: 0.h, bottom: 5.h),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: MyAppText(
                            data: "Clear Filters",
                            size: 14.0.sp,
                            color: CLR_PRIMARY,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (!isHistoryLoading)
                    Container(
                      height: showClrFltr ? 500.h : 530.h,
                      child: historyData!.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount:
                                  historyData!.length + (MoreLoading ? 1 : 0),
                              physics: const PageScrollPhysics(),
                              controller: infiniteScrollController,
                              itemBuilder: (context, index) {
                                if (index < historyData!.length) {
                                  return HistoryContainer(
                                    historyData: historyData![index],
                                    // billerFilterData: billerFilterData,
                                    titleText: 'Paid to',
                                    subtitleText: historyData![index]
                                        .bILLERNAME
                                        .toString(),
                                    dateText: DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(historyData![index]
                                                .cOMPLETIONDATE
                                                .toString())
                                            .toLocal()),
                                    amount:
                                        "₹ ${NumberFormat('#,##,##0.00').format(double.parse(historyData![index].bILLAMOUNT.toString()))}",
                                    // '₹ ${historyData![index].bILLAMOUNT.toString()}',
                                    statusText: getTransactionStatus(
                                        historyData![index]
                                            .tRANSACTIONSTATUS
                                            .toString()),
                                    iconPath: LOGO_BBPS,
                                    containerBorderColor: Color(0xffD1D9E8),
                                  );
                                } else {
                                  Timer(Duration(milliseconds: 30), () {
                                    infiniteScrollController.jumpTo(
                                        infiniteScrollController
                                            .position.maxScrollExtent);
                                  });

                                  return FlickrLoader();
                                }
                              })
                          : NoDataFound(
                              message: "No Transactions Found",
                            ),
                    ),
                  // if (isHistoryMoreLoading)
                  //   Container(
                  //       height: 50.h,
                  //       width: double.infinity,
                  //       child: Center(child: FlickrLoader())),
                  if (isHistoryLoading)
                    Container(
                        height: 500.h,
                        width: double.infinity,
                        child: Center(child: FlickrLoader())),
                  SizedBox(
                    height: 100.h,
                  )
                ],
              ))),
      floatingActionButton: BlocConsumer<HistoryCubit, HistoryState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  isDismissible: false,
                  elevation: 10,
                  isScrollControlled: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0.r),
                    ),
                  ),
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 15.h,
                                bottom: 15.h,
                                left: 15.w,
                                right: 15.w),
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
                                DateTime? pickedDate = await DatePicker(
                                    context, fromdateController.text, null);

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);
                                  setState(() {
                                    fromdateController.text = formattedDate;
                                    todateController.clear();
                                    fromDate = pickedDate;
                                    toFirstDate = pickedDate;
                                  });
                                }
                              },
                              // validator: (inputValue) {},
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              onChanged: (val) {},
                              onTap: () async {
                                if (fromdateController.text.isNotEmpty) {
                                  setState(() {
                                    showToDateErr = false;
                                  });
                                  DateTime? pickedDate = await DatePicker(
                                      context,
                                      fromdateController.text,
                                      toFirstDate);
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    setState(() {
                                      todateController.text = formattedDate;
                                      toDate = pickedDate;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    showToDateErr = true;
                                  });
                                }
                              },
                              validator: (inputValue) {
                                if (fromdateController.text.isEmpty) {
                                  return "Please select 'From Date' first.";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                fillColor:
                                    const Color(0xffD1D9E8).withOpacity(0.2),
                                filled: true,
                                errorText: showToDateErr
                                    ? "Please select From Date first."
                                    : null,
                                // errorStyle: TextStyle(color: Colors.green),
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
                                labelText: 'To Date',
                                hintText: "To Date",
                              ),
                            ),
                          ),
                          HistoryFilter(
                              billerName: billerName,
                              categoryName: categoryName,
                              handleFilterModal: handleFilterModal),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0.h,
                                bottom: 16.h,
                                left: 16.w,
                                right: 16.w),
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
                                      onPressed: () {
                                        setState(() {
                                          _pageNumber = 1;
                                        });
                                        if ((fromDate != null &&
                                                toDate != null) ||
                                            categoryID != null) {
                                          handleFilter();
                                        }
                                      },
                                      buttonText: "Apply",
                                      buttonTxtColor: BTN_CLR_ACTIVE,
                                      buttonBorderColor: Colors.transparent,
                                      buttonColor: ((fromDate != null &&
                                                  toDate != null) ||
                                              categoryID != null)
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
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      );
                    });
                  });
            },
            backgroundColor: CLR_PRIMARY,
            child: Padding(
              padding: EdgeInsets.only(top: 5.0.h),
              child: SvgPicture.asset(
                ICON_FILTER,
              ),
            ),
          );
        },
      ),
    );
  }
}
