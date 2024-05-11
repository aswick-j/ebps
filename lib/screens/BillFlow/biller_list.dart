import 'dart:async';

import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/screens/nodataFound.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BillerList extends StatefulWidget {
  dynamic id;
  String name;
  BillerList({super.key, required this.id, required this.name});

  @override
  State<BillerList> createState() => _BillerListState();
}

class _BillerListState extends State<BillerList> {
  final infiniteScrollController = ScrollController();
  List<BillersData>? BillerSearchResults = [];
  bool isBillSerachLoading = true;

  List<BillersData>? Allbiller = [];
  bool isAllBiller = true;
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool MoreLoading = true;
  late int _pageNumber;
  late int _totalPages;
  @override
  void initState() {
    _pageNumber = 1;
    _totalPages = 1;
    BlocProvider.of<HomeCubit>(context).getAllBiller(widget.id, 1);

    initScrollController(context);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void initScrollController(context) {
    infiniteScrollController.addListener(() {
      if (infiniteScrollController.position.atEdge) {
        if (infiniteScrollController.position.pixels != 0) {
          if (_totalPages >= _pageNumber) {
            MoreLoading = true;
            if (_searchController.text.isEmpty) {
              BlocProvider.of<HomeCubit>(context)
                  .getAllBiller(widget.id, _pageNumber);
            } else {
              BlocProvider.of<HomeCubit>(context)
                  .searchBiller("", widget.name, _pageNumber);
            }
          }
        }
      }
    });
  }

  handleSearch() {
    if (_searchController.text.isEmpty) {
      BlocProvider.of<HomeCubit>(context).getAllBiller(widget.id, _pageNumber);
    } else {
      BlocProvider.of<HomeCubit>(context)
          .searchBiller(_searchController.text, widget.name, _pageNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.CLR_BACKGROUND,
        appBar: MyAppBar(
          context: context,
          title: widget.name,
          onLeadingTap: () => goBack(context),
          showActions: false,
        ),
        body: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          if (state is AllbillerListLoading && state.isFirstFetch) {
            isAllBiller = true;
          }
          if (state is AllbillerListLoading) {
            MoreLoading = true;

            Allbiller = state.prevData;
            if (Allbiller!.length > 1) {
              _totalPages = Allbiller![Allbiller!.length - 1].tOTALPAGES!;
            }
            isAllBiller = false;
          } else if (state is AllbillerListSuccess) {
            Allbiller = state.allbillerList;
            if (Allbiller!.length > 1) {
              _totalPages = Allbiller![Allbiller!.length - 1].tOTALPAGES!;
            }
            isAllBiller = false;
            isBillSerachLoading = false;
            MoreLoading = false;
            _pageNumber = _pageNumber + 1;
          } else if (state is AllbillerListFailed) {
            isAllBiller = false;
            isBillSerachLoading = false;
          } else if (state is AllbillerListError) {
            if (state.message!.contains('Invalid')) {
              goTo(context, sESSIONEXPIREDROUTE);
            }
            isBillSerachLoading = false;

            isAllBiller = false;
          }

          if (state is BillersSearchLoading && state.isFirstFetch) {
            isBillSerachLoading = true;
          }

          if (state is BillersSearchLoading) {
            BillerSearchResults = state.prevData;
            MoreLoading = true;
            if (BillerSearchResults!.length > 1) {
              _totalPages =
                  BillerSearchResults![BillerSearchResults!.length - 1]
                      .tOTALPAGES!;
            }
          } else if (state is BillersSearchSuccess) {
            BillerSearchResults = state.searchResultsData;
            if (BillerSearchResults!.length > 1) {
              _totalPages =
                  BillerSearchResults![BillerSearchResults!.length - 1]
                      .tOTALPAGES!;
            }
            _pageNumber = _pageNumber + 1;

            isBillSerachLoading = false;
            MoreLoading = false;
          } else if (state is BillersSearchFailed) {
            isBillSerachLoading = false;
          } else if (state is BillersSearchError) {
            isBillSerachLoading = false;
          }
          return Column(children: [
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: TextField(
                  onChanged: (value) => {
                    _pageNumber = 1,
                    // _searchController.text = value,
                    _searchController.addListener(() {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(
                          const Duration(milliseconds: 500), handleSearch);
                    })
                  },
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.left,
                  controller: _searchController,
                  style: TextStyle(color: AppColors.TXT_CLR_LITE),
                  decoration: InputDecoration(
                    fillColor: AppColors.CLR_INPUT_FILL,
                    filled: true,
                    isDense: true,
                    hintStyle: TextStyle(color: AppColors.TXT_CLR_LITE),
                    contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
                    hintText: 'Search by Biller',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      iconSize: 25.r,
                      color: AppColors.CLR_BLUE_LITE,
                      onPressed: () => (),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50.0.r),
                    ),
                  ),
                ),
              ),
            ),
            // Container(
            // clipBehavior: Clip.hardEdge,
            // width: double.infinity,
            // // height: height(context) * 0.,
            // margin: EdgeInsets.only(
            //     left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(6.0.r + 2.r),
            //   border: Border.all(
            //     color: Color(0xffD1D9E8),
            //     width: 1.0,
            //   ),
            // ),
            // child:Text("")),
            ReusableContainer(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(6.0.r),
                      topLeft: Radius.circular(6.0.r)),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 33.0.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        stops: const [0.001, 19],
                        colors: [
                          AppColors.CLR_GRD_1.withOpacity(.7),
                          AppColors.CLR_GRD_2.withOpacity(.7),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                      child: Row(
                        children: [
                          SvgPicture.asset(ICON_ALL_BILLER),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "All Billers",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffffffff),
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                if (isBillSerachLoading || isAllBiller)
                  Center(
                    child: Container(
                      height: 500.h,
                      child: FlickrLoader(),
                    ),
                  ),
                if (_searchController.text.isEmpty && Allbiller!.isEmpty)
                  Container(
                    height: 500.h,
                    child: NoDataFound(
                      message: "No Billers Found",
                    ),
                  ),
                if (_searchController.text.isNotEmpty &&
                    BillerSearchResults!.isEmpty)
                  Container(
                    height: 500.h,
                    child: NoDataFound(
                      showRichText: true,
                      message1: _searchController.text,
                      message2:
                          "Try checking for typos or using complete words.",
                      message: "No Billers Found for ",
                    ),
                  ),
                if ((!isAllBiller && Allbiller!.isNotEmpty) ||
                    (!isBillSerachLoading && BillerSearchResults!.isNotEmpty))
                  Container(
                    height: 480.h,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _searchController.text.isEmpty
                          ? Allbiller!.length + (MoreLoading ? 1 : 0)
                          : BillerSearchResults!.length + (MoreLoading ? 1 : 0),
                      physics: const PageScrollPhysics(),
                      controller: infiniteScrollController,
                      itemBuilder: (context, index) {
                        if (_searchController.text.isEmpty
                            ? index < Allbiller!.length
                            : index < BillerSearchResults!.length) {
                          return GestureDetector(
                            onTap: () {
                              if (_searchController.text.isEmpty
                                  ? Allbiller![index]
                                          .cATEGORYNAME!
                                          .toLowerCase() ==
                                      "mobile prepaid"
                                  : BillerSearchResults![index]
                                          .cATEGORYNAME!
                                          .toLowerCase() ==
                                      "mobile prepaid") {
                                goToData(context, pREPAIDBILLERPARAMROUTE, {
                                  "BILLER_DATA": _searchController.text.isEmpty
                                      ? Allbiller![index]
                                      : BillerSearchResults![index],
                                  "BILLER_INPUT_SIGN": []
                                });
                              } else {
                                goToData(context, bILLERPARAMROUTE, {
                                  "BILLER_DATA": _searchController.text.isEmpty
                                      ? Allbiller![index]
                                      : BillerSearchResults![index],
                                  "BILLER_INPUT_SIGN": []
                                });
                              }
                            },
                            child: ListTile(
                                contentPadding: EdgeInsets.only(
                                    left: 6.w, right: 6.w, top: 0),
                                leading: Container(
                                  width: 45.w,
                                  child: Padding(
                                    padding: EdgeInsets.all(13.r),
                                    child: SvgPicture.asset(BILLER_LOGO(
                                        _searchController.text.isEmpty
                                            ? Allbiller![index]
                                                .bILLERNAME
                                                .toString()
                                            : BillerSearchResults![index]
                                                .bILLERNAME
                                                .toString())),
                                  ),
                                ),
                                title: Text(
                                  _searchController.text.isEmpty
                                      ? Allbiller![index].bILLERNAME.toString()
                                      : BillerSearchResults![index]
                                          .bILLERNAME
                                          .toString(),
                                  // "Airtel Digital TV",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.TXT_CLR_GREY,
                                  ),
                                  textAlign: TextAlign.left,
                                )),
                          );
                        } else {
                          Timer(Duration(milliseconds: 30), () {
                            infiniteScrollController.jumpTo(
                                infiniteScrollController
                                    .position.maxScrollExtent);
                          });

                          return FlickrLoader();
                        }
                      },
                    ),
                  ),
              ],
            ))
          ]);
        }));
  }
}
