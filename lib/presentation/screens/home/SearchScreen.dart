import 'dart:async';

import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/data/models/billers_model.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/widget/noResult.dart';
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

  @override
  void initState() {
    handleSearch();
    super.initState();
  }

  handleSearch() {
    if (_searchController.text.isEmpty) {
      BlocProvider.of<HomeCubit>(context).searchBiller("", "");
    } else {
      BlocProvider.of<HomeCubit>(context)
          .searchBiller(_searchController.text, "All");
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
        appBar: MyAppBar(
          context: context,
          title: "Search",
          onLeadingTap: () => goBack(context),
          showActions: false,
        ),
        body: BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
          if (state is BillersSearchLoading) {
          } else if (state is BillersSearchSuccess) {
            BillerSearchResults = state.searchResultsData;
            // if (BillerSearchResults!.isEmpty) alert = true;
          } else if (state is BillersSearchFailed) {
          } else if (state is BillersSearchError) {}
        }, builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: TextField(
                    onChanged: (value) => {
                      _searchController.text = value,
                      _searchController.addListener(() {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();
                        _debounce = Timer(
                            const Duration(milliseconds: 500), handleSearch);
                      })
                    },
                    keyboardType: TextInputType.text,
                    controller: _searchController,
                    decoration: InputDecoration(
                      fillColor: CLR_PRIMARY_LITE.withOpacity(0.2),
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
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

                  // height: height(context) * 0.7,
                  margin: EdgeInsets.only(
                      left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0.r + 2.r),
                    border: Border.all(
                      color: Color(0xffD1D9E8),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      // if (isAllBiller) Text("Loading...."),
                      // if (!isAllBiller)
                      if (BillerSearchResults!.isEmpty)
                        Container(
                            width: double.infinity,
                            height: 500,
                            child: const noResult()),
                      Container(
                        height: 500.h,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: BillerSearchResults!.length,
                          physics: const BouncingScrollPhysics(),
                          // controller: infiniteScrollController,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                goToData(context, bILLERPARAMROUTE, {
                                  "BILLER_DATA": BillerSearchResults![index],
                                  "BILLER_INPUT_SIGN": []
                                });
                              },
                              child: ListTile(
                                  contentPadding: EdgeInsets.only(
                                      left: 6.w, right: 6.w, top: 0),
                                  leading: Container(
                                    width: 45.w,
                                    child: Padding(
                                      padding: EdgeInsets.all(13.r),
                                      child: SvgPicture.asset(LOGO_BBPS),
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
                                      color: Color(0xff4c4c4c),
                                    ),
                                    textAlign: TextAlign.left,
                                  )),
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            ],
          );
        }));
  }
}
