import 'dart:async';

import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/screens/Prepaid/bill_parameters_prepaid.dart';
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

  List<BillersData>? Allbiller = [];
  bool isAllBiller = false;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getAllBiller(widget.id);
    initScrollController(context);
    super.initState();
  }

  void initScrollController(context) {
    infiniteScrollController.addListener(() {
      if (infiniteScrollController.position.atEdge) {
        if (infiniteScrollController.position.pixels != 0) {
          BlocProvider.of<HomeCubit>(context).getAllBiller(widget.id);
        }
      }
    });
  }

  handleSearch() {
    if (_searchController.text.isEmpty) {
    } else {
      BlocProvider.of<HomeCubit>(context)
          .searchBiller(_searchController.text, widget.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: widget.name,
          onLeadingTap: () => goBack(context),
          showActions: false,
        ),
        body: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          if (state is AllbillerListLoading && state.isFirstFetch) {}
          // bool isLoading = false;
          // isAllBiller = true;
          if (state is AllbillerListLoading) {
            Allbiller = state.prevData;
            // isLoading = true;
            isAllBiller = false;
          } else if (state is AllbillerListSuccess) {
            Allbiller = state.allbillerList;
            // isLoading = false;
          } else if (state is AllbillerListFailed) {
            isAllBiller = false;
          } else if (state is AllbillerListError) {
            if (state.message!.contains('Invalid')) {
              goTo(context, sESSIONEXPIREDROUTE);
            }
            isAllBiller = false;
          }

          if (state is BillersSearchLoading) {
          } else if (state is BillersSearchSuccess) {
            BillerSearchResults = state.searchResultsData;
          } else if (state is BillersSearchFailed) {
          } else if (state is BillersSearchError) {}
          return Column(children: [
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
                    contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
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
                // height: height(context) * 0.,
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
                              Color(0xff768EB9).withOpacity(.7),
                              Color(0xff463A8D).withOpacity(.7),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                          child: Row(
                            children: [
                              const Icon(Icons.menu, color: Color(0xffffffff)),
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
                    if (isAllBiller) Text("Loading...."),
                    if (!isAllBiller)
                      Container(
                        height: 480.h,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _searchController.text.isEmpty
                              ? Allbiller!.length
                              : BillerSearchResults!.length,
                          physics: const BouncingScrollPhysics(),
                          controller: _searchController.text.isEmpty
                              ? infiniteScrollController
                              : null,
                          itemBuilder: (context, index) {
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
                                    "BILLER_DATA":
                                        _searchController.text.isEmpty
                                            ? Allbiller![index]
                                            : BillerSearchResults![index],
                                    "BILLER_INPUT_SIGN": []
                                  });
                                } else {
                                  goToData(context, bILLERPARAMROUTE, {
                                    "BILLER_DATA":
                                        _searchController.text.isEmpty
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
                                      child: SvgPicture.asset(LOGO_BBPS),
                                    ),
                                  ),
                                  title: Text(
                                    _searchController.text.isEmpty
                                        ? Allbiller![index]
                                            .bILLERNAME
                                            .toString()
                                        : BillerSearchResults![index]
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
                ))
          ]);
        }));
  }
}
