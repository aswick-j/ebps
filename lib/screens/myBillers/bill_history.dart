import 'dart:async';

import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/History/history_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getTransactionStatus.dart';
import 'package:ebps/models/history_model.dart';
import 'package:ebps/screens/nodataFound.dart';
import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BillHistory extends StatefulWidget {
  String? categoryID;
  String? billerID;
  dynamic customerBillID;
  BillHistory(
      {super.key,
      required this.billerID,
      required this.categoryID,
      required this.customerBillID});

  @override
  State<BillHistory> createState() => _BillHistoryState();
}

class _BillHistoryState extends State<BillHistory> {
  List<HistoryData>? historyData = [];
  late int _pageNumber;
  late int _totalPages;
  bool MoreLoading = true;
  final infiniteScrollController = ScrollController();
  bool isHistoryMoreLoading = false;

  bool isHistoryLoading = true;
  @override
  void initState() {
    _pageNumber = 1;
    _totalPages = 1;
    BlocProvider.of<HistoryCubit>(context).getHistoryDetails({
      "startDate": DateTime(2016).toLocal().toIso8601String(),
      "endDate": DateTime.now().toLocal().toIso8601String(),
    }, "", widget.billerID, _pageNumber, true);
    initScrollController(context);

    super.initState();
  }

  void initScrollController(context) {
    infiniteScrollController.addListener(() {
      if (infiniteScrollController.position.atEdge) {
        if (infiniteScrollController.position.pixels != 0) {
          if (_totalPages >= _pageNumber) {
            MoreLoading = true;
            BlocProvider.of<HistoryCubit>(context).getHistoryDetails({
              "startDate": DateTime(2016).toLocal().toIso8601String(),
              "endDate": DateTime.now().toLocal().toIso8601String(),
            }, "", widget.billerID, _pageNumber, true);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.CLR_BACKGROUND,
      appBar: MyAppBar(
        context: context,
        title: 'Bill History',
        onLeadingTap: () => goBack(context),
        showActions: true,
        actions: [],
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
                        historyData![historyData!.length - 1].totalPages!;
                  }
                  isHistoryMoreLoading = true;
                });
              } else if (state is HistorySuccess) {
                setState(() {
                  historyData = state.historyData!
                      .where((item) =>
                          item.customerBillId == widget.customerBillID)
                      .toList();
                  if (historyData!.length > 1) {
                    _totalPages =
                        historyData![historyData!.length - 1].totalPages!;
                  }
                  isHistoryLoading = false;
                  MoreLoading = false;
                  _pageNumber = _pageNumber + 1;
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
            })
          ],
          child: Column(
            children: [
              if (!isHistoryLoading)
                historyData!.isNotEmpty
                    ? Container(
                        height: 590.h,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount:
                                historyData!.length + (MoreLoading ? 1 : 0),
                            physics: const ClampingScrollPhysics(),
                            controller: infiniteScrollController,
                            itemBuilder: (context, index) {
                              if (index < historyData!.length) {
                                return HistoryContainer(
                                  handleStatus: (txnStatus, txnID) {
                                    setState(() {
                                      historyData![index].transactionStatus =
                                          txnStatus;
                                    });
                                  },
                                  historyData: historyData![index],
                                  // billerFilterData: billerFilterData,
                                  titleText: historyData![index].autoPay == 0
                                      ? 'Paid to'
                                      : 'Auto Payment',
                                  subtitleText:
                                      historyData![index].billerName.toString(),
                                  dateText: DateFormat('MMM dd, yyyy').format(
                                      DateTime.parse(historyData![index]
                                              .completionDate
                                              .toString())
                                          .toLocal()),
                                  amount:
                                      "₹ ${NumberFormat('#,##,##0.00').format(double.parse(historyData![index].billAmount.toString()))}",
                                  // '₹ ${historyData![index].bILLAMOUNT.toString()}',
                                  statusText: getTransactionStatus(
                                      historyData![index]
                                          .transactionStatus
                                          .toString()),
                                  iconPath: BILLER_LOGO(historyData![index]
                                      .billerName
                                      .toString()),
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
                            }))
                    : NoDataFound(
                        message: "No Transactions Found",
                      ),
              if (isHistoryLoading)
                Container(
                    height: 500.h,
                    width: double.infinity,
                    child: Center(child: FlickrLoader())),
            ],
          ),
        ),
      ),
    );
  }
}
