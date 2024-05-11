import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/chart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoryCharts extends StatefulWidget {
  const HistoryCharts({super.key});

  @override
  State<HistoryCharts> createState() => _HistoryChartsState();
}

class _HistoryChartsState extends State<HistoryCharts> {
  bool isChartLoading = true;
  List<ChartData>? chartdata = [];
  List<_ChartDataFilter> chartFilterdata = [];

  bool isColumnchart = false;
  DateTimeRange? dateRange;

  @override
  void initState() {
    BlocProvider.of<HistoryCubit>(context).getCharts();
    super.initState();
  }

  void chartFilter() {
    List<ChartData> ChartDataPast = chartdata!
        .where((item) => DateTime.parse(item.cOMPLETIONDATE.toString())
            .isBefore(
                DateTime.parse(DateFormat('y-MM-d').format(dateRange!.end))))
        .toList();
    // List<ChartData> ChartDataFuture = ChartDataPast.where((item) =>
    //         DateTime.parse(item.cOMPLETIONDATE.toString()).isAfter(
    //             DateTime.parse(DateFormat('y-MM-d').format(dateRange!.start))))
    //     .toList();
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      saveText: "Select",
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2016),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.CLR_PRIMARY,
              onPrimary: Colors.white,
              onSurface: AppColors.CLR_SECONDARY,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    setState(() {
      dateRange = newDateRange ?? dateRange;
      if (dateRange != null) {
        chartFilter();
      }
    });
  }

  void getChartData() {
    List<_ChartDataFilter>? chartFilterdataTemp = [];
    List<ChartData>? chartdataTemp = chartdata!
        .where(
            (element) => element.tRANSACTIONSTATUS!.toLowerCase() == "success")
        .toList();

    bool checkCategoryName(String categoryName) {
      final elementsFound = chartFilterdataTemp
          .where((element) => element.categoryName == categoryName);
      if (elementsFound.isEmpty) {
        return false;
      } else {
        return true;
      }
    }

    for (var i = 0; i < chartdataTemp.length; i++) {
      if (!checkCategoryName(chartdataTemp[i].cATEGORYNAME.toString())) {
        chartFilterdataTemp.add(_ChartDataFilter(
            categoryName: chartdataTemp[i].cATEGORYNAME,
            billAmount: chartdataTemp[i].bILLAMOUNT));
      } else {
        final index = chartFilterdataTemp.indexWhere((item) =>
            item.categoryName == chartdataTemp[i].cATEGORYNAME.toString());
        chartFilterdataTemp[index] = _ChartDataFilter(
            categoryName: chartdataTemp[i].cATEGORYNAME,
            billAmount: chartFilterdataTemp[index].billAmount! +
                chartdataTemp[i].bILLAMOUNT);
      }
    }
    chartFilterdata = chartFilterdataTemp.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Transactions Summary',
        onLeadingTap: () => goBack(context),
        showActions: false,
        actions: [],
      ),
      body: SingleChildScrollView(
          child: BlocConsumer<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state is HistoryChartLoading) {
            isChartLoading = true;
          } else if (state is HistoryChartSuccess) {
            chartdata = state.chartModel!.data ?? [];
            getChartData();
            isChartLoading = false;
          } else if (state is HistoryChartFailed) {
            isChartLoading = false;
          } else if (state is HistoryChartError) {
            isChartLoading = false;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Center(
                  child: Container(
                      clipBehavior: Clip.hardEdge,
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 20.h),
                      margin: EdgeInsets.only(
                          left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0.r + 2.r),
                        border: Border.all(
                          color: Color(0xffD1D9E8),
                          width: 1.0,
                        ),
                      ),
                      height: 500.h,
                      child: isColumnchart
                          ? SfCartesianChart(
                              zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  zoomMode: ZoomMode.x,
                                  enablePanning: true,
                                  enableDoubleTapZooming: true),
                              primaryXAxis: CategoryAxis(labelRotation: 90),
                              primaryYAxis: NumericAxis(
                                  numberFormat: NumberFormat.compactCurrency(
                                      locale: "en_In", symbol: "₹"),
                                  rangePadding: ChartRangePadding.auto),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <CartesianSeries<_ChartDataFilter,
                                  String>>[
                                  ColumnSeries<_ChartDataFilter, String>(
                                      dataSource: chartFilterdata,
                                      // isVisibleInLegend: true,

                                      xValueMapper:
                                          (_ChartDataFilter data, _) =>
                                              data.categoryName,
                                      yValueMapper:
                                          (_ChartDataFilter data, _) =>
                                              data.billAmount,
                                      name: 'Spends',
                                      color: AppColors.CLR_PRIMARY)
                                ])
                          : SfCircularChart(
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                              ),
                              legend: Legend(
                                orientation: LegendItemOrientation.vertical,
                                title: LegendTitle(
                                    text: 'Categories',
                                    textStyle: TextStyle(
                                        color: AppColors.CLR_PRIMARY,
                                        fontSize: 15.sp,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w900)),
                                isVisible: false,
                                overflowMode: LegendItemOverflowMode.scroll,
                                toggleSeriesVisibility: true,
                                position: LegendPosition.bottom,
                                alignment: ChartAlignment.center,
                              ),
                              series: <CircularSeries>[
                                  DoughnutSeries<_ChartDataFilter, String>(
                                      legendIconType: LegendIconType.seriesType,
                                      dataLabelMapper: (_ChartDataFilter data,
                                              _) =>
                                          "₹ ${NumberFormat('#,##,##0.00').format(
                                            double.parse(
                                                data.billAmount.toString()),
                                          )}",
                                      radius: '70%',
                                      dataSource: chartFilterdata,
                                      name: "Spends",
                                      explodeOffset: '10%',
                                      // groupMode: CircularChartGroupMode.point,
                                      explode: true,
                                      explodeGesture: ActivationMode.singleTap,
                                      dataLabelSettings: DataLabelSettings(
                                          textStyle: TextStyle(fontSize: 10.sp),
                                          overflowMode: OverflowMode.shift,
                                          labelAlignment:
                                              ChartDataLabelAlignment.bottom,
                                          labelIntersectAction:
                                              LabelIntersectAction.shift,
                                          labelPosition:
                                              ChartDataLabelPosition.inside,
                                          connectorLineSettings:
                                              ConnectorLineSettings(
                                            width: 1.5,
                                            length: '15%',
                                            type: ConnectorType.line,
                                          ),
                                          useSeriesColor: true,
                                          isVisible: true),
                                      pointColorMapper:
                                          (_ChartDataFilter data, _) => null,
                                      xValueMapper:
                                          (_ChartDataFilter data, _) =>
                                              data.categoryName,
                                      yValueMapper:
                                          (_ChartDataFilter data, _) =>
                                              data.billAmount)
                                ])))
            ],
          );
        },
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "calDate",
            onPressed: pickDateRange,
            backgroundColor: AppColors.CLR_PRIMARY,
            child: Icon(Icons.calendar_month_outlined),
          ),
          SizedBox(
            width: 20.w,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isColumnchart = !isColumnchart;
              });
            },
            backgroundColor: AppColors.CLR_PRIMARY,
            child: Icon(isColumnchart ? Icons.pie_chart : Icons.bar_chart),
          ),
        ],
      ),
    );
  }
}

class _ChartDataFilter {
  final String? categoryName;
  final num? billAmount;

  _ChartDataFilter({
    this.categoryName,
    this.billAmount,
  });
}
