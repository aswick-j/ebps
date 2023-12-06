import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/data/models/history_model.dart';
import 'package:ebps/data/services/api_client.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getTransactionStatus.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Container/History/history_container.dart';
import 'package:ebps/presentation/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'History',
        onLeadingTap: () => Navigator.pop(context),
        showActions: true,
        actions: [
          InkWell(
              onTap: () => {goTo(context, cOMPLAINTLISTROUTE)},
              child: Container(
                  margin: EdgeInsets.only(top: 20.h, bottom: 20.h, right: 15.w),
                  width: 30.w,
                  decoration: ShapeDecoration(
                    color: Color(0xff4969A2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: Container(
                    width: 20.w,
                    height: 40.h,
                    child: Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: Icon(
                        Icons.comment,
                        color: Colors.white,
                      ),
                    ),
                  )))
        ],
      ),
      body: BlocProvider(
        create: (context) => HistoryCubit(repository: apiClient),
        child: HistoryScreenUI(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.filter_alt_outlined),
        backgroundColor: CLR_PRIMARY,
      ),
    );
  }
}

class HistoryScreenUI extends StatefulWidget {
  const HistoryScreenUI({super.key});

  @override
  State<HistoryScreenUI> createState() => _HistoryScreenUIState();
}

class _HistoryScreenUIState extends State<HistoryScreenUI> {
  List<String> Periods = [
    "Today",
    'Yesterday',
    "This Week",
    "Last Week",
    "This Month",
    'Last Month',
    "Custom"
  ];

  List<HistoryData>? historyData = [];
  bool isHistoryLoading = false;
  @override
  void initState() {
    BlocProvider.of<HistoryCubit>(context)
        .getHistoryDetails('Last Week', false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryCubit, HistoryState>(
      listener: (context, state) {
        if (state is HistoryLoading) {
          isHistoryLoading = true;
        } else if (state is HistorySuccess) {
          historyData = state.historyData;
          isHistoryLoading = false;
        } else if (state is HistoryFailed) {
          isHistoryLoading = false;
        } else if (state is HistoryError) {}
      },
      builder: (context, state) {
        return SingleChildScrollView(
            child: Column(
          children: [
            !isHistoryLoading
                ? Container(
                    height: 550.h,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: historyData!.length,
                      physics: const BouncingScrollPhysics(),
                      // controller: infiniteScrollController,
                      itemBuilder: (context, index) {
                        return HistoryContainer(
                          historyData: historyData![index],
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
                          iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
                          containerBorderColor: Color(0xffD1D9E8),
                        );
                      },
                    ),
                  )
                : Container(
                    height: 500,
                    width: double.infinity,
                    child: Center(child: FlickrLoader())),
          ],
        ));
      },
    );
  }
}
