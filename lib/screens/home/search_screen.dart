import 'dart:async';

import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/screens/nodataFound.dart';
import 'package:ebps/widget/animated_text_field.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<BillersData>? BillerSearchResults = [];
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool isBillSerachLoading = true;
  bool MoreLoading = true;
  late int _pageNumber;
  late int _totalPages;
  final infiniteScrollController = ScrollController();

  @override
  void initState() {
    _pageNumber = 1;
    _totalPages = 1;
    initScrollController(context);

    handleSearch();
    super.initState();
  }

  void initScrollController(context) {
    infiniteScrollController.addListener(() {
      if (infiniteScrollController.position.atEdge) {
        if (infiniteScrollController.position.pixels != 0) {
          if (_totalPages >= _pageNumber) {
            MoreLoading = true;
            if (_searchController.text.isEmpty) {
              BlocProvider.of<HomeCubit>(context)
                  .searchBiller("a", "All", _pageNumber);
            } else {
              BlocProvider.of<HomeCubit>(context)
                  .searchBiller(_searchController.text, "All", _pageNumber);
            }
          }
        }
      }
    });
  }

  handleSearch() {
    if (_searchController.text.isEmpty) {
      BlocProvider.of<HomeCubit>(context).searchBiller("a", "All", _pageNumber);
    } else {
      BlocProvider.of<HomeCubit>(context)
          .searchBiller(_searchController.text, "All", _pageNumber);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.CLR_BACKGROUND,
        appBar: MyAppBar(
            context: context,
            title: "Search",
            onLeadingTap: () => goBack(context),
            showActions: true,
            actions: [
              // InkWell(
              //     onTap: () => {goTo(context, cOMPLAINTLISTROUTE)},
              //     child: Container(
              //         margin: EdgeInsets.only(right: 15.w),
              //         decoration: ShapeDecoration(
              //           color: Color(0xff4969A2),
              //           shape: CircleBorder(),
              //         ),
              //         child: Container(
              //           width: 30.w,
              //           height: 30.h,
              //           child: SvgPicture.asset(ICON_COMPLAINTS),
              //         )))
            ]),
        body: BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
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
          }
          // if (state is BillersSearchLoading) {
          //   MoreLoading = true;
          // } else if (state is BillersSearchSuccess) {
          //   BillerSearchResults = state.searchResultsData;
          //   if (BillerSearchResults!.length > 1 &&
          //       BillerSearchResults![0].tOTALPAGES == 1) {
          //     _totalPages = BillerSearchResults![0].tOTALPAGES!;
          //   }
          //   // if (BillerSearchResults!.isEmpty) alert = true;
          //   isBillSerachLoading = false;
          //   MoreLoading = false;
          else if (state is BillersSearchFailed) {
            isBillSerachLoading = false;
            MoreLoading = false;
          } else if (state is BillersSearchError) {
            isBillSerachLoading = false;
            MoreLoading = false;
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: AnimatedTextField(
                      hintTextStyle: TextStyle(color: AppColors.TXT_CLR_LITE),
                      onChanged: (value) => {
                        _pageNumber = 1,
                        // _searchController.text = value,
                        _searchController.addListener(() {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(
                              const Duration(milliseconds: 500), handleSearch);
                        })
                      },
                      animationType: Animationtype.slide,
                      hintLabelText: "Search for ",
                      hintTexts: const [
                        'Credit Card',
                        'DTH',
                        'Electricity',
                        'Fastag',
                        'LPG Gas',
                        'Mobile Postpaid',
                        'Water'
                      ],
                      keyboardType: TextInputType.text,
                      controller: _searchController,
                      style: TextStyle(color: AppColors.TXT_CLR_LITE),
                      decoration: InputDecoration(
                        fillColor: AppColors.CLR_INPUT_FILL,
                        filled: true,
                        isDense: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                        hintStyle: TextStyle(color: AppColors.TXT_CLR_LITE),
                        hintText: 'Search by Biller',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          iconSize: 25.r,
                          color: CLR_BLUE_LITE,
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
                Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0.r + 2.r),
                      border: Border.all(
                        color: AppColors.CLR_CON_BORDER,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.h),
                        if (isBillSerachLoading)
                          Center(
                            child: Container(
                              height: 500.h,
                              child: FlickrLoader(),
                            ),
                          ),
                        if (!isBillSerachLoading &&
                            BillerSearchResults!.isEmpty &&
                            _searchController.text.isNotEmpty)
                          // LottieAnimation(
                          //   aniJsonIndex: 1,
                          //   secondaryIndex: 0,
                          //   showTitle: false,
                          //   titleIndex: 0,
                          // ),
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
                        if (!isBillSerachLoading &&
                            BillerSearchResults!.isEmpty &&
                            _searchController.text.isEmpty)
                          Container(
                            height: 500.h,
                            child: NoDataFound(
                              message: "No Billers Found",
                            ),
                          ),
                        if (!isBillSerachLoading &&
                            BillerSearchResults!.isNotEmpty)
                          Container(
                            height: 500.h,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: BillerSearchResults!.length +
                                  (MoreLoading ? 1 : 0),
                              physics: PageScrollPhysics(),
                              controller: infiniteScrollController,
                              itemBuilder: (context, index) {
                                if (index < BillerSearchResults!.length) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (BillerSearchResults![index]
                                              .cATEGORYNAME!
                                              .toLowerCase() ==
                                          "mobile prepaid") {
                                        goToData(
                                            context, pREPAIDBILLERPARAMROUTE, {
                                          "BILLER_DATA":
                                              BillerSearchResults![index],
                                          "BILLER_INPUT_SIGN": []
                                        });
                                      } else {
                                        goToData(context, bILLERPARAMROUTE, {
                                          "BILLER_DATA":
                                              BillerSearchResults![index],
                                          "BILLER_INPUT_SIGN": []
                                        });
                                      }
                                      // goToData(context, bILLERPARAMROUTE, {
                                      //   "BILLER_DATA":
                                      //       BillerSearchResults![index],
                                      //   "BILLER_INPUT_SIGN": []
                                      // });
                                    },
                                    child: ListTile(
                                        contentPadding: EdgeInsets.only(
                                            left: 6.w, right: 6.w, top: 0),
                                        leading: Container(
                                          width: 45.w,
                                          child: Padding(
                                            padding: EdgeInsets.all(13.r),
                                            child: SvgPicture.asset(BILLER_LOGO(
                                                BillerSearchResults![index]
                                                    .bILLERNAME
                                                    .toString())),
                                          ),
                                        ),
                                        title: Text(
                                          BillerSearchResults![index]
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
                    )),
              ],
            ),
          );
        }));
  }
}
