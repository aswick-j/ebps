import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/categories_model.dart';
import 'package:ebps/models/category_biller_filter_history._model.dart';
import 'package:ebps/services/api_client.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryFilter extends StatefulWidget {
  final String? billerName;
  final String? categoryName;
  String? billerID;
  String? categoryID;

  List<CategorieData>? categoriesData;
  final void Function(String?, String?, String?, String?) handleFilterModal;
  HistoryFilter(
      {super.key,
      required this.handleFilterModal,
      required this.categoriesData,
      this.billerID,
      this.categoryID,
      this.billerName,
      this.categoryName});

  @override
  State<HistoryFilter> createState() => _HistoryFilterState();
}

class _HistoryFilterState extends State<HistoryFilter> {
  ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HistoryCubit(repository: apiClient)),
        BlocProvider(create: (_) => HomeCubit(repository: apiClient)),
      ],
      child: HistoryFilterUI(
        handleFilterModal: widget.handleFilterModal,
        billerName: widget.billerName,
        categoryName: widget.categoryName,
        billerID: widget.billerID,
        categoryID: widget.categoryID,
        categoriesData: widget.categoriesData,
      ),
    );
  }
}

class HistoryFilterUI extends StatefulWidget {
  final void Function(String?, String?, String?, String?) handleFilterModal;
  List<CategorieData>? categoriesData;
  String? billerID;
  String? categoryID;

  final String? billerName;
  final String? categoryName;
  HistoryFilterUI(
      {super.key,
      required this.handleFilterModal,
      required this.categoriesData,
      this.billerID,
      this.categoryID,
      this.billerName,
      this.categoryName});

  @override
  State<HistoryFilterUI> createState() => _HistoryFilterUIState();
}

class _HistoryFilterUIState extends State<HistoryFilterUI> {
  var dragController = DraggableScrollableController();
  dynamic catController = TextEditingController();
  dynamic billerController = TextEditingController();

  List<Data>? billerFilterData = [];
  bool isHistoryFilterLoading = false;
  String? categoryID;
  String? billerID;
  String? CategoryName;

  @override
  void initState() {
    if (widget.billerName != null) {
      billerID = widget.billerID;
      billerController.text = widget.billerName;
      // billerFilterData!.add(data as Data);
    } else {}
    if (widget.categoryName != null) {
      categoryID = widget.categoryID;

      catController.text = widget.categoryName;
      BlocProvider.of<HistoryCubit>(context)
          .billerFilter(widget.categoryID ?? "");
    }
    super.initState();
  }

  handleBiller(categoryName, category_ID) {
    setState(() {
      catController.text = categoryName;
      categoryID = category_ID;
      CategoryName = categoryName;
    });

    billerController.clear();
    BlocProvider.of<HistoryCubit>(context).billerFilter(category_ID);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<HistoryCubit, HistoryState>(listener: (context, state) {
            if (state is billerFilterLoading) {
              setState(() {
                isHistoryFilterLoading = true;
              });
            } else if (state is billerFilterSuccess) {
              setState(() {
                billerFilterData = state.billerFilterData;
                isHistoryFilterLoading = false;
              });
            } else if (state is billerFilterFailed) {
              setState(() {
                isHistoryFilterLoading = false;
              });
            } else if (state is billerFilterError) {
              setState(() {
                isHistoryFilterLoading = false;
              });
            }
          }),
        ],
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: TextFormField(
                controller: catController,
                readOnly: true,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.text,
                onChanged: (val) {},
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: AppColors.CLR_BACKGROUND,
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
                            builder: (context, scrollController) =>
                                StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return SingleChildScrollView(
                                    controller: scrollController,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 15.h,
                                              bottom: 15.h,
                                              left: 15.w,
                                              right: 15.w),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  colorFilter: ColorFilter.mode(
                                                      AppColors.CLR_ICON,
                                                      BlendMode.srcIn),
                                                  ICON_SELECT_CATEGORY),
                                              SizedBox(width: 20.w),
                                              Text(
                                                "Select Category",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .TXT_CLR_PRIMARY),
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 0.2,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2)),
                                            ],
                                          ),
                                          child: Divider(
                                            height: 0.4.h,
                                            thickness: 1,
                                            color: Colors.grey.withOpacity(0.1),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Container(
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount:
                                                widget.categoriesData!.length,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            // controller: infiniteScrollController,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                  onTap: () {
                                                    catController.text = widget
                                                        .categoriesData![index]
                                                        .cATEGORYNAME
                                                        .toString();

                                                    handleBiller(
                                                      widget
                                                          .categoriesData![
                                                              index]
                                                          .cATEGORYNAME
                                                          .toString(),
                                                      widget
                                                          .categoriesData![
                                                              index]
                                                          .iD
                                                          .toString(),
                                                    );
                                                    widget.handleFilterModal(
                                                        null,
                                                        null,
                                                        widget
                                                            .categoriesData![
                                                                index]
                                                            .iD
                                                            .toString(),
                                                        widget
                                                            .categoriesData![
                                                                index]
                                                            .cATEGORYNAME
                                                            .toString());
                                                    goBack(context);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.w,
                                                            vertical: 2.h),
                                                    child: ListTile(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 6.w,
                                                                right: 6.w,
                                                                top: 0),
                                                        leading: Container(
                                                          width: 45.w,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    13.r),
                                                            child: SvgPicture
                                                                .asset(
                                                              colorFilter:
                                                                  ColorFilter.mode(
                                                                      AppColors
                                                                          .CLR_ICON,
                                                                      BlendMode
                                                                          .srcIn),
                                                              CATEGORY_ICON(
                                                                widget
                                                                    .categoriesData![
                                                                        index]
                                                                    .cATEGORYNAME
                                                                    .toString(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          widget
                                                              .categoriesData![
                                                                  index]
                                                              .cATEGORYNAME
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .TXT_CLR_BLACK_W,
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
                                          padding: EdgeInsets.only(
                                              top: 0.h,
                                              bottom: 16.h,
                                              left: 16.w,
                                              right: 16.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: MyAppButton(
                                                    onPressed: () {
                                                      goBack(context);
                                                    },
                                                    buttonText: "Cancel",
                                                    buttonTxtColor: AppColors
                                                        .BTN_CLR_ACTIVE_ALTER_TEXT_C,
                                                    buttonBorderColor: AppColors
                                                        .BTN_CLR_ACTIVE_BORDER,
                                                    buttonColor: AppColors
                                                        .BTN_CLR_ACTIVE_ALTER_C,
                                                    buttonSizeX: 10.h,
                                                    buttonSizeY: 40.w,
                                                    buttonTextSize: 14.sp,
                                                    buttonTextWeight:
                                                        FontWeight.w500),
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
                style: TextStyle(color: AppColors.TXT_CLR_BLACK),
                // validator: (inputValue) {},
                decoration: InputDecoration(
                    fillColor: AppColors.CLR_INPUT_FILL,
                    filled: true,
                    hintStyle: TextStyle(color: AppColors.TXT_CLR_LITE),
                    labelStyle: TextStyle(color: AppColors.TXT_CLR_PRIMARY),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.TXT_CLR_PRIMARY),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.TXT_CLR_PRIMARY),
                    ),
                    labelText: 'Select Category',
                    hintText: "Select Category"),
              ),
            ),
            if (isHistoryFilterLoading)
              Container(height: 100.h, child: FlickrLoader()),
            if (billerFilterData!.isEmpty) SizedBox(height: 85.h),
            if (billerFilterData!.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: TextFormField(
                  controller: billerController,
                  readOnly: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: AppColors.CLR_BACKGROUND,
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
                              builder: (context, scrollController) =>
                                  StatefulBuilder(
                                      builder: (context, StateSetter setState) {
                                    return SingleChildScrollView(
                                      controller: scrollController,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 15.h,
                                                bottom: 15.h,
                                                left: 15.w,
                                                right: 15.w),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            AppColors.CLR_ICON,
                                                            BlendMode.srcIn),
                                                    ICON_SELECT_BILLER),
                                                SizedBox(width: 20.w),
                                                Text(
                                                  "Select Billers",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .TXT_CLR_BLACK_W,
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
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 0.2,
                                                    blurRadius: 2,
                                                    offset: Offset(0, 2)),
                                              ],
                                            ),
                                            child: Divider(
                                              height: 0.4.h,
                                              thickness: 1,
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          if (billerFilterData!.isEmpty)
                                            Text(
                                              "No Billers Found for $CategoryName Category Transactions",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff000000),
                                                height: 23 / 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          Container(
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount:
                                                  billerFilterData!.length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              // controller: infiniteScrollController,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        billerController.text =
                                                            billerFilterData![
                                                                    index]
                                                                .bILLERNAME
                                                                .toString();
                                                        billerID =
                                                            billerFilterData![
                                                                    index]
                                                                .bILLERID
                                                                .toString();
                                                      });

                                                      widget.handleFilterModal(
                                                          billerFilterData![
                                                                  index]
                                                              .bILLERID
                                                              .toString(),
                                                          billerFilterData![
                                                                  index]
                                                              .bILLERNAME
                                                              .toString(),
                                                          categoryID,
                                                          CategoryName == null
                                                              ? widget
                                                                  .categoryName
                                                              : CategoryName);

                                                      goBack(context);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16.w,
                                                              vertical: 2.h),
                                                      child: ListTile(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 6.w,
                                                                  right: 6.w,
                                                                  top: 0),
                                                          leading: Container(
                                                            width: 45.w,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          13.r),
                                                              child: SvgPicture
                                                                  .asset(
                                                                BILLER_LOGO(billerFilterData![
                                                                        index]
                                                                    .bILLERNAME
                                                                    .toString()),
                                                              ),
                                                            ),
                                                          ),
                                                          title: Text(
                                                            billerFilterData![
                                                                    index]
                                                                .bILLERNAME
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppColors
                                                                  .TXT_CLR_BLACK_W,
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
                                            padding: EdgeInsets.only(
                                                top: 0.h,
                                                bottom: 16.h,
                                                left: 16.w,
                                                right: 16.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: MyAppButton(
                                                      onPressed: () {
                                                        goBack(context);
                                                      },
                                                      buttonText: "Cancel",
                                                      buttonTxtColor: AppColors
                                                          .BTN_CLR_ACTIVE_ALTER_TEXT_C,
                                                      buttonBorderColor: AppColors
                                                          .BTN_CLR_ACTIVE_BORDER,
                                                      buttonColor: AppColors
                                                          .BTN_CLR_ACTIVE_ALTER_C,
                                                      buttonSizeX: 10.h,
                                                      buttonSizeY: 40.w,
                                                      buttonTextSize: 14.sp,
                                                      buttonTextWeight:
                                                          FontWeight.w500),
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
                  style: TextStyle(color: AppColors.TXT_CLR_BLACK),
                  // validator: (inputValue) {},
                  decoration: InputDecoration(
                      fillColor: AppColors.CLR_INPUT_FILL,
                      filled: true,
                      hintStyle: TextStyle(color: AppColors.TXT_CLR_LITE),
                      labelStyle: TextStyle(color: AppColors.TXT_CLR_PRIMARY),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.TXT_CLR_PRIMARY),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.TXT_CLR_PRIMARY),
                      ),
                      labelText: 'Select Billers',
                      hintText: "Select Billers"),
                ),
              ),
          ],
        ));
  }
}
