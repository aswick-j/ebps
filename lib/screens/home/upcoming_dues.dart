import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/Container/Home/home_banners.dart';
import 'package:ebps/common/Container/Home/upcoming_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/models/upcoming_dues_model.dart';
import 'package:ebps/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UpcomingDues extends StatefulWidget {
  const UpcomingDues({super.key});

  @override
  State<UpcomingDues> createState() => _UpcomingDuesState();
}

class _UpcomingDuesState extends State<UpcomingDues> {
  final ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MybillersCubit(repository: apiClient)),
        BlocProvider(create: (_) => HomeCubit(repository: apiClient)),
      ],
      child: const UpcomingDuesUI(),
    );
  }
}

class UpcomingDuesUI extends StatefulWidget {
  const UpcomingDuesUI({super.key});

  @override
  State<UpcomingDuesUI> createState() => _UpcomingDuesUIState();
}

class _UpcomingDuesUIState extends State<UpcomingDuesUI> {
  List<UpcomingDuesData>? upcomingDuesData = [];
  List<UpcomingPaymentsData>? upcomingAutoPaymentData = [];
  List<SavedBillersData>? SavedBiller = [];

  List<Map<String, dynamic>> allUpcomingDues = [];

  bool isUpcomingDuesLoading = true;
  bool isUpcomingAutopaymentLoading = true;
  bool isSavedBillerLoading = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MybillersCubit>(context).getAllUpcomingDues();
    BlocProvider.of<MybillersCubit>(context).getAutopay();
    BlocProvider.of<MybillersCubit>(context).getSavedBillers();
  }

  bool isDataExist(List list, int? value) {
    var data = list.where((row) => (row["customerBillId"] == value));
    if (data.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void generateDuesList() {
    allUpcomingDues = [];
    if (upcomingDuesData!.isNotEmpty) {
      upcomingDuesData?.forEach((item) {
        final tempUpcoming = {
          "itemType": "upcomingDue",
          "billName": item.billName ?? "",
          "billerName": item.billerName ?? "",
          "dueAmount": item.dueAmount ?? "",
          "dueDate": item.dueDate ?? "",
          "paymentDate": "",
          "customerBillId": item.customerBillID ?? "-",
          "categoryName": item.categoryName,
          "iSACTIVE": "",
          "billerParams": item.billerParams
        };

        if (!isDataExist(
            allUpcomingDues, int.parse(item.customerBillID.toString()))) {
          allUpcomingDues.add(tempUpcoming);
        }
      });
    }

    if (upcomingAutoPaymentData!.isNotEmpty) {
      upcomingAutoPaymentData?.forEach((item) {
        final tempUpcomingAutoPayment = {
          "itemType": "upcomingPayments",
          "billName": item.bILLNAME ?? "",
          "billerName": item.bILLERNAME ?? "",
          "dueAmount": item.dUEAMOUNT ?? "",
          "dueDate": item.dUEDATE ?? "",
          "paymentDate": item.pAYMENTDATE ?? "",
          "categoryName": item.cATEGORYNAME ?? "",
          "iSACTIVE": item.iSACTIVE ?? "",
          "customerBillId": item.cUSTOMERBILLID ?? "",
          "billerParams": ""
        };

        if (isDataExist(
            allUpcomingDues, int.parse(item.cUSTOMERBILLID.toString()))) {
          allUpcomingDues.removeWhere(
              (element) => element["customerBillId"] == item.cUSTOMERBILLID);
        }
        allUpcomingDues.add(tempUpcomingAutoPayment);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            // TODO: implement listener
          },
        ),
        BlocListener<MybillersCubit, MybillersState>(
          listener: (context, state) {
            if (state is UpcomingDuesLoading) {
              setState(() {
                isUpcomingDuesLoading = true;
              });
            } else if (state is UpcomingDuesSuccess) {
              List<UpcomingDuesData>? tempUpcomingDuesData =
                  state.upcomingDuesData;

              List<UpcomingDuesData>? NullTemp = [];
              List<UpcomingDuesData>? DueDateTemp = [];
              List<UpcomingDuesData>? ExpiredDueDateTemp = [];

              bool isDateExpired(DateTime date) {
                DateTime currentDate = DateTime.now();
                return date.isBefore(currentDate);
              }

              for (var i = 0; i < tempUpcomingDuesData!.length; i++) {
                if (tempUpcomingDuesData[i].dueDate == null) {
                  NullTemp.add(tempUpcomingDuesData[i]);
                } else if (isDateExpired(DateTime.parse(
                    tempUpcomingDuesData[i].dueDate.toString()))) {
                  ExpiredDueDateTemp.add(tempUpcomingDuesData[i]);
                } else {
                  DueDateTemp.add(tempUpcomingDuesData[i]);
                }
              }

              ExpiredDueDateTemp.sort((a, b) =>
                  DateTime.parse(a.dueDate.toString())
                      .compareTo(DateTime.parse(b.dueDate.toString())));
              DueDateTemp.sort((a, b) => DateTime.parse(a.dueDate.toString())
                  .compareTo(DateTime.parse(b.dueDate.toString())));

              List<UpcomingDuesData>? sortedData = [
                ...DueDateTemp,
                ...ExpiredDueDateTemp,
                ...NullTemp
              ];

              setState(() {
                upcomingDuesData = sortedData;
                isUpcomingDuesLoading = false;
              });
              generateDuesList();
            } else if (state is UpcomingDuesFailed) {
              setState(() {
                isUpcomingDuesLoading = false;
              });
            } else if (state is UpcomingDuesError) {
              setState(() {
                isUpcomingDuesLoading = false;
              });
            }
            if (state is AutoPayLoading) {
              setState(() {
                isUpcomingAutopaymentLoading = true;
              });
            } else if (state is AutopaySuccess) {
              if (state.autoScheduleData!.upcomingPayments!.isNotEmpty) {
                upcomingAutoPaymentData =
                    state.autoScheduleData!.upcomingPayments![0].data;
              }
              setState(() {
                isUpcomingAutopaymentLoading = false;
              });
              generateDuesList();
            } else if (state is AutopayFailed) {
              setState(() {
                isUpcomingAutopaymentLoading = false;
              });
            } else if (state is AutopayError) {
              setState(() {
                isUpcomingAutopaymentLoading = false;
              });
            }
            if (state is SavedBillerLoading) {
              setState(() {
                isSavedBillerLoading = true;
              });
            } else if (state is SavedBillersSuccess) {
              SavedBiller = state.savedBillersData;
              setState(() {
                isSavedBillerLoading = false;
              });
            } else if (state is SavedBillersFailed) {
              setState(() {
                isSavedBillerLoading = false;
              });
            } else if (state is SavedBillersError) {
              setState(() {
                isSavedBillerLoading = false;
              });
            }
          },
        ),
      ],
      child: Column(
        children: [
          if (!isUpcomingAutopaymentLoading &&
              !isUpcomingDuesLoading &&
              !isSavedBillerLoading)
            if (allUpcomingDues.length > 0)
              Padding(
                padding: EdgeInsets.only(
                    left: 18.0.w, right: 18.w, top: 10.h, bottom: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      allUpcomingDues.length > 1
                          ? 'Upcoming Dues'
                          : 'Upcoming Due',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1b438b),
                      ),
                    ),
                    if (!isUpcomingAutopaymentLoading && !isUpcomingDuesLoading)
                      if (allUpcomingDues.length > 2)
                        InkWell(
                          onTap: () {
                            goToData(context, uPCOMINGDUESROUTE, {
                              "allUpcomingDues": allUpcomingDues,
                              "savedBiller": SavedBiller,
                              "ctx": context
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1b438b),
                                ),
                                textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                textAlign: TextAlign.center,
                                softWrap: false,
                              ),
                              Icon(Icons.arrow_forward,
                                  color: Color(0xff1b438b)),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
          if (!isUpcomingAutopaymentLoading &&
              !isUpcomingDuesLoading &&
              !isSavedBillerLoading &&
              allUpcomingDues.isEmpty)
            HomeBanners(),
          if (!isUpcomingAutopaymentLoading &&
              !isUpcomingDuesLoading &&
              !isSavedBillerLoading &&
              allUpcomingDues.isNotEmpty)
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: allUpcomingDues.isEmpty
                    ? 0
                    : allUpcomingDues.length == 1
                        ? 1
                        : 2,
                itemBuilder: (BuildContext context, int index) {
                  return UpcomingDuesContainer(
                    savedBillersData: SavedBiller!
                        .where((element) =>
                            element.cUSTOMERBILLID.toString().toLowerCase() ==
                            allUpcomingDues[index]["customerBillId"]
                                .toString()
                                .toLowerCase())
                        .toList()[0],
                    dateText: allUpcomingDues[index]["dueDate"] != ""
                        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                allUpcomingDues[index]["dueDate"]!
                                    .toString()
                                    .substring(0, 10))
                            .toLocal()
                            .add(const Duration(days: 1)))
                        : "-",
                    buttonText:
                        allUpcomingDues[index]["itemType"] == 'upcomingDue'
                            ? "Pay Now"
                            : 'Upcoming Auto Payment',
                    onPressed: () {
                      SavedBillersData savedBillersData;
                      List<SavedBillersData> billerDataTemp = [];

                      billerDataTemp = SavedBiller!
                          .where((element) =>
                              element.cUSTOMERBILLID.toString().toLowerCase() ==
                              allUpcomingDues[index]["customerBillId"]
                                  .toString()
                                  .toLowerCase())
                          .toList();
                      if (billerDataTemp.isNotEmpty) {
                        savedBillersData = billerDataTemp[0];
                        goToData(context, fETCHBILLERDETAILSROUTE, {
                          "name": allUpcomingDues[index]["billerName"],
                          "billName": allUpcomingDues[index]["billName"],
                          "savedBillersData": savedBillersData,
                          "SavedinputParameters": savedBillersData.pARAMETERS,
                          "categoryName": savedBillersData.cATEGORYNAME,
                          "isSavedBill": true,
                        });
                      }
                    },
                    amount:
                        "₹ ${NumberFormat('#,##,##0.00').format(double.parse(allUpcomingDues[index]["dueAmount"]!.toString()))}",
                    iconPath: BILLER_LOGO(allUpcomingDues[index]["billerName"]),
                    containerBorderColor: Color(0xffD1D9E8),
                    buttonColor:
                        allUpcomingDues[index]["itemType"] == 'upcomingDue'
                            ? Color(0xFF1B438B)
                            : Color.fromARGB(255, 255, 255, 255),
                    buttonTxtColor:
                        allUpcomingDues[index]["itemType"] == 'upcomingDue'
                            ? Color.fromARGB(255, 255, 255, 255)
                            : Color(0xff00AB44),
                    buttonTextWeight: FontWeight.normal,
                    buttonBorderColor:
                        allUpcomingDues[index]["itemType"] == 'upcomingDue'
                            ? null
                            : Color(0xff00AB44),
                  );
                }),
          // if (isUpcomingAutopaymentLoading ||
          //     isUpcomingDuesLoading ||
          //     isSavedBillerLoading)
          //   Center(
          //     child: Container(
          //       height: 200.h,
          //       width: 200.w,
          //       child: FlickrLoader(),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
