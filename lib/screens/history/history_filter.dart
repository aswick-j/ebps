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
  final void Function(String?, String?, String?, String?) handleFilterModal;
  const HistoryFilter(
      {super.key,
      required this.handleFilterModal,
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
      ),
    );
  }
}

class HistoryFilterUI extends StatefulWidget {
  final void Function(String?, String?, String?, String?) handleFilterModal;
  final String? billerName;
  final String? categoryName;
  const HistoryFilterUI(
      {super.key,
      required this.handleFilterModal,
      this.billerName,
      this.categoryName});

  @override
  State<HistoryFilterUI> createState() => _HistoryFilterUIState();
}

class _HistoryFilterUIState extends State<HistoryFilterUI> {
  var dragController = DraggableScrollableController();
  dynamic catController = TextEditingController();
  dynamic billerController = TextEditingController();
  List<CategorieData>? categoriesData = [];

  List<Data>? billerFilterData = [];
  bool isCategoryLoading = false;
  bool isHistoryFilterLoading = false;
  String? categoryID;
  String? billerID;
  @override
  void initState() {
    if (widget.billerName != null) {
      billerController.text = widget.billerName;
    }
    if (widget.categoryName != null) {
      catController.text = widget.categoryName;
    }
    BlocProvider.of<HomeCubit>(context).getAllCategories();
    super.initState();
  }

  handleBiller(categoryName, category_ID) {
    setState(() {
      catController.text = categoryName;
      categoryID = category_ID;
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
          BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              categoriesData = context.read<HomeCubit>().categoriesData;

              // if (state is CategoriesLoading) {
              //   isCategoryLoading = true;
              // } else if (state is CategoriesSuccess) {
              //   categoriesData = state.CategoriesList;
              //   isCategoryLoading = false;
              // } else if (state is CategoriesFailed) {
              //   isCategoryLoading = false;
              // } else if (state is CategoriesError) {
              //   isCategoryLoading = false;
              // }
            },
          )
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
                                              Icon(
                                                Icons.menu_outlined,
                                                color: Color(0xff1b438b),
                                              ),
                                              SizedBox(width: 20.w),
                                              Text(
                                                "Select Category",
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
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
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
                                        Container(
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: categoriesData!.length,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            // controller: infiniteScrollController,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                  onTap: () {
                                                    catController.text =
                                                        categoriesData![index]
                                                            .cATEGORYNAME
                                                            .toString();
                                                    handleBiller(
                                                      categoriesData![index]
                                                          .cATEGORYNAME
                                                          .toString(),
                                                      categoriesData![index]
                                                          .iD
                                                          .toString(),
                                                    );
                                                    widget.handleFilterModal(
                                                        null,
                                                        null,
                                                        categoriesData![index]
                                                            .iD
                                                            .toString(),
                                                        categoriesData![index]
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
                                                                    LOGO_BBPS),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          categoriesData![index]
                                                              .cATEGORYNAME
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xff000000),
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
                                                    buttonTxtColor: CLR_PRIMARY,
                                                    buttonBorderColor:
                                                        Colors.transparent,
                                                    buttonColor: BTN_CLR_ACTIVE,
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
                    labelText: 'Select Category',
                    hintText: "Select Category"),
              ),
            ),
            if (isHistoryFilterLoading)
              Container(height: 200, width: 200, child: FlickrLoader()),
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
                                                Icon(
                                                  Icons.menu_outlined,
                                                  color: Color(0xff1b438b),
                                                ),
                                                SizedBox(width: 20.w),
                                                Text(
                                                  "Select Billers",
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
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 0.6,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2)),
                                              ],
                                            ),
                                            child: Divider(
                                              height: 1.h,
                                              thickness: 1,
                                              color:
                                                  Colors.grey.withOpacity(0.1),
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
                                                          categoriesData![index]
                                                              .iD
                                                              .toString(),
                                                          categoriesData![index]
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
                                                                  EdgeInsets
                                                                      .all(
                                                                          13.r),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      LOGO_BBPS),
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
                                                              color: Color(
                                                                  0xff000000),
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
                                                      buttonTxtColor:
                                                          CLR_PRIMARY,
                                                      buttonBorderColor:
                                                          Colors.transparent,
                                                      buttonColor:
                                                          BTN_CLR_ACTIVE,
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
                      labelText: 'Select Billers',
                      hintText: "Select Billers"),
                ),
              ),
          ],
        ));
  }
}
