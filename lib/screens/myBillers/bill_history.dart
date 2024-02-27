import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/History/history_container.dart';
import 'package:ebps/constants/assets.dart';
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
  BillHistory({super.key, required this.billerID, required this.categoryID});

  @override
  State<BillHistory> createState() => _BillHistoryState();
}

class _BillHistoryState extends State<BillHistory> {
  List<HistoryData>? historyData = [];

  bool isHistoryLoading = true;
  @override
  void initState() {
    BlocProvider.of<HistoryCubit>(context)
        .getHistoryDetails('This Month', "", widget.billerID, "-1", false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              if (state is HistoryLoading) {
                isHistoryLoading = true;
              } else if (state is HistorySuccess) {
                setState(() {
                  historyData = state.historyData;
                });
                isHistoryLoading = false;
              } else if (state is HistoryFailed) {
                isHistoryLoading = false;
              } else if (state is HistoryError) {
                isHistoryLoading = false;
              }
            })
          ],
          child: Column(
            children: [
              if (!isHistoryLoading)
                historyData!.isNotEmpty
                    ? Container(
                        height: 600.h,
                        child: ListView.builder(
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
                              statusText: getTransactionStatus(
                                  historyData![index]
                                      .tRANSACTIONSTATUS
                                      .toString()),
                              amount:
                                  "₹ ${NumberFormat('#,##,##0.00').format(double.parse(historyData![index].bILLAMOUNT.toString()))}",
                              // '₹ ${historyData![index].bILLAMOUNT.toString()}',

                              iconPath: LOGO_BBPS,
                              containerBorderColor: Color(0xffD1D9E8),
                            );
                          },
                        ),
                      )
                    : NoDataFound(
                        message: "No Transactions Found",
                      ),
              if (isHistoryLoading)
                Container(
                    height: 500,
                    width: double.infinity,
                    child: Center(child: FlickrLoader())),
            ],
          ),
        ),
      ),
    );
  }
}
