import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/History/history_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getTransactionStatus.dart';
import 'package:ebps/models/categories_model.dart';
import 'package:ebps/models/category_biller_filter_history._model.dart';
import 'package:ebps/models/history_model.dart';
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
  dynamic catController = TextEditingController();
  dynamic billerController = TextEditingController();

  DateTime? fromDate;
  DateTime? toFirstDate;
  DateTime? toDate;

  String? categoryID;
  String? billerID;

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

  List<HistoryData>? historyData = [];
  List<Data>? billerFilterData = [];
  List<CategorieData>? categoriesData = [];

  bool isCategoryLoading = false;
  bool isHistoryLoading = true;
  bool isHistoryFilterLoading = false;
  @override
  void initState() {
    BlocProvider.of<HistoryCubit>(context)
        .getHistoryDetails('Today', "", "", "-1", false);
    BlocProvider.of<HomeCubit>(context).getAllCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    handleBiller(categoryName, category_ID) {
      setState(() {
        catController.text = categoryName;
        categoryID = category_ID;
      });

      billerController.clear();
      BlocProvider.of<HistoryCubit>(context).billerFilter(category_ID);
    }

    handleFilter() {
      BlocProvider.of<HistoryCubit>(context).getHistoryDetails({
        "startDate": fromDate != null
            ? fromDate!.toLocal().toIso8601String()
            : DateTime(2016).toLocal().toIso8601String(),
        "endDate": toDate != null
            ? toDate!.toLocal().toIso8601String()
            : DateTime.now().toLocal().toIso8601String(),
      }, categoryID, billerID, "1", true);
      goBack(context);
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
              if (state is HistoryLoading) {
                setState(() {
                  isHistoryLoading = true;
                });
              } else if (state is HistorySuccess) {
                setState(() {
                  historyData = state.historyData;
                  isHistoryLoading = false;
                });
              } else if (state is HistoryFailed) {
                setState(() {
                  isHistoryLoading = false;
                });
              } else if (state is HistoryError) {
                setState(() {
                  isHistoryLoading = false;
                });
              }
              if (state is billerFilterLoading) {
                isHistoryFilterLoading = true;
              } else if (state is billerFilterSuccess) {
                setState(() {
                  billerFilterData = state.billerFilterData;
                  isHistoryFilterLoading = false;
                });
              } else if (state is billerFilterFailed) {
                isHistoryFilterLoading = false;
              } else if (state is billerFilterError) {
                isHistoryFilterLoading = false;
              }
            }),
            BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is CategoriesLoading) {
                  isCategoryLoading = true;
                } else if (state is CategoriesSuccess) {
                  categoriesData = state.CategoriesList;

                  isCategoryLoading = false;
                } else if (state is CategoriesFailed) {
                  isCategoryLoading = false;
                } else if (state is CategoriesError) {
                  isCategoryLoading = false;
                }
              },
            )
          ],
              child: Column(
                children: [
                  if (!isHistoryLoading)
                    Container(
                      height: 550.h,
                      child: historyData!.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: historyData!.length,
                              physics: const BouncingScrollPhysics(),
                              // controller: infiniteScrollController,
                              itemBuilder: (context, index) {
                                return HistoryContainer(
                                  historyData: historyData![index],
                                  // billerFilterData: billerFilterData,
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
                                  iconPath: LOGO_BBPS,
                                  containerBorderColor: Color(0xffD1D9E8),
                                );
                              },
                            )
                          : NoDataFound(
                              message: "No Transactions Found",
                            ),
                    ),
                  if (isHistoryLoading)
                    Container(
                        height: 500.h,
                        width: double.infinity,
                        child: Center(child: FlickrLoader())),
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
                                  print("Please select 'From Date' first.");
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
                                errorText: fromdateController.text.isEmpty
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
                              onTap: () {
                                showModalBottomSheet(
                                    elevation: 10,
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16.0.r),
                                      ),
                                    ),
                                    builder: (context) {
                                      return DraggableScrollableSheet(
                                          initialChildSize: 0.50,
                                          minChildSize: 0.25,
                                          maxChildSize: 0.95,
                                          expand: false,
                                          controller: dragController,
                                          builder:
                                              (context, scrollController) =>
                                                  StatefulBuilder(builder:
                                                      (context,
                                                          StateSetter
                                                              setState) {
                                                    return SingleChildScrollView(
                                                      controller:
                                                          scrollController,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 15.h,
                                                                    bottom:
                                                                        15.h,
                                                                    left: 15.w,
                                                                    right:
                                                                        15.w),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .menu_outlined,
                                                                  color: Color(
                                                                      0xff1b438b),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        20.w),
                                                                Text(
                                                                  "Selcet Categories",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xff1b438b),
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        0.6,
                                                                    blurRadius:
                                                                        4,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2)),
                                                              ],
                                                            ),
                                                            child: Divider(
                                                              height: 1.h,
                                                              thickness: 1,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Container(
                                                            child: ListView
                                                                .builder(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  categoriesData!
                                                                      .length,
                                                              physics:
                                                                  const BouncingScrollPhysics(),
                                                              // controller: infiniteScrollController,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return GestureDetector(
                                                                    onTap: () {
                                                                      handleBiller(
                                                                          categoriesData![index]
                                                                              .cATEGORYNAME
                                                                              .toString(),
                                                                          categoriesData![index]
                                                                              .iD
                                                                              .toString());
                                                                      goBack(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: 16
                                                                              .w,
                                                                          vertical:
                                                                              2.h),
                                                                      child: ListTile(
                                                                          contentPadding: EdgeInsets.only(left: 6.w, right: 6.w, top: 0),
                                                                          leading: Container(
                                                                            width:
                                                                                45.w,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.all(13.r),
                                                                              child: SvgPicture.asset(LOGO_BBPS),
                                                                            ),
                                                                          ),
                                                                          title: Text(
                                                                            categoriesData![index].cATEGORYNAME.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.sp,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Color(0xff000000),
                                                                              height: 23 / 14,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                          )),
                                                                    ));
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0.h,
                                                                    bottom:
                                                                        16.h,
                                                                    left: 16.w,
                                                                    right:
                                                                        16.w),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child: MyAppButton(
                                                                      onPressed: () {
                                                                        goBack(
                                                                            context);
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
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }));
                                    });
                              },
                              validator: (inputValue) {
                                return null;
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
                                  labelText: 'Select Categories',
                                  hintText: "Select Categories"),
                            ),
                          ),
                          if (isHistoryFilterLoading)
                            Container(
                                height: 200, width: 200, child: FlickrLoader()),
                          if (billerFilterData!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
                              child: TextFormField(
                                controller: billerController,
                                readOnly: true,
                                autocorrect: false,
                                enableSuggestions: false,
                                keyboardType: TextInputType.text,
                                onChanged: (val) {},
                                onTap: () {
                                  showModalBottomSheet(
                                      elevation: 10,
                                      useRootNavigator: true,
                                      isScrollControlled: true,
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.0.r),
                                        ),
                                      ),
                                      builder: (context) {
                                        return DraggableScrollableSheet(
                                            initialChildSize: 0.50,
                                            minChildSize: 0.25,
                                            maxChildSize: 0.95,
                                            expand: false,
                                            controller: dragController,
                                            builder:
                                                (context, scrollController) =>
                                                    StatefulBuilder(builder:
                                                        (context,
                                                            StateSetter
                                                                setState) {
                                                      return SingleChildScrollView(
                                                        controller:
                                                            scrollController,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 15.h,
                                                                      bottom:
                                                                          15.h,
                                                                      left:
                                                                          15.w,
                                                                      right:
                                                                          15.w),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .menu_outlined,
                                                                    color: Color(
                                                                        0xff1b438b),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          20.w),
                                                                  Text(
                                                                    "Select Billers",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff1b438b),
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          0.6,
                                                                      blurRadius:
                                                                          4,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              2)),
                                                                ],
                                                              ),
                                                              child: Divider(
                                                                height: 1.h,
                                                                thickness: 1,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Container(
                                                              child: ListView
                                                                  .builder(
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    billerFilterData!
                                                                        .length,
                                                                physics:
                                                                    const BouncingScrollPhysics(),
                                                                // controller: infiniteScrollController,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          billerController.text = billerFilterData![index]
                                                                              .bILLERNAME
                                                                              .toString();
                                                                          billerID = billerFilterData![index]
                                                                              .bILLERID
                                                                              .toString();
                                                                        });

                                                                        goBack(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                16.w,
                                                                            vertical: 2.h),
                                                                        child: ListTile(
                                                                            contentPadding: EdgeInsets.only(left: 6.w, right: 6.w, top: 0),
                                                                            leading: Container(
                                                                              width: 45.w,
                                                                              child: Padding(
                                                                                padding: EdgeInsets.all(13.r),
                                                                                child: SvgPicture.asset(LOGO_BBPS),
                                                                              ),
                                                                            ),
                                                                            title: Text(
                                                                              billerFilterData![index].bILLERNAME.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 14.sp,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Color(0xff000000),
                                                                                height: 23 / 14,
                                                                              ),
                                                                              textAlign: TextAlign.left,
                                                                            )),
                                                                      ));
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 0.h,
                                                                      bottom:
                                                                          16.h,
                                                                      left:
                                                                          16.w,
                                                                      right:
                                                                          16.w),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child: MyAppButton(
                                                                        onPressed: () {
                                                                          goBack(
                                                                              context);
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
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }));
                                      });
                                },
                                validator: (inputValue) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                    fillColor: const Color(0xffD1D9E8)
                                        .withOpacity(0.2),
                                    filled: true,
                                    labelStyle: const TextStyle(
                                        color: Color(0xff1b438b)),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff1B438B)),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff1B438B)),
                                    ),
                                    border: const UnderlineInputBorder(),
                                    labelText: 'Select Billers',
                                    hintText: "Select Billers"),
                              ),
                            ),
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
                                        handleFilter();
                                      },
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
