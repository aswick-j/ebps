import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/Container/Home/home_banners.dart';
import 'package:ebps/common/Container/Home/upcoming_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UpcomingDues extends StatefulWidget {
  List<Map<String, dynamic>> allUpcomingDues;
  List<SavedBillersData>? SavedBiller;
  List<AllConfigurations>? allautoPaymentList;
  UpcomingDues(
      {super.key,
      required this.allUpcomingDues,
      required this.SavedBiller,
      required this.allautoPaymentList});

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
        child: Column(
          children: [
            if (widget.allUpcomingDues.length > 0)
              Padding(
                padding: EdgeInsets.only(
                    left: 18.0.w, right: 18.w, top: 10.h, bottom: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.allUpcomingDues.length > 1
                          ? 'Upcoming Dues'
                          : 'Upcoming Due',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.CLR_PRIMARY,
                      ),
                    ),
                    if (widget.allUpcomingDues.length > 2)
                      InkWell(
                        onTap: () {
                          goToData(context, uPCOMINGDUESROUTE, {
                            "allUpcomingDues": widget.allUpcomingDues,
                            "savedBiller": widget.SavedBiller,
                            "ctx": context,
                            "autopayData": widget.allautoPaymentList
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.CLR_PRIMARY_LITE,
                              ),
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              textAlign: TextAlign.center,
                              softWrap: false,
                            ),
                            Icon(Icons.arrow_forward,
                                color: AppColors.CLR_PRIMARY_LITE),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            if (widget.allUpcomingDues.isEmpty) HomeBanners(),
            if (widget.allUpcomingDues.isNotEmpty)
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.allUpcomingDues.isEmpty
                      ? 0
                      : widget.allUpcomingDues.length == 1
                          ? 1
                          : 2,
                  itemBuilder: (BuildContext context, int index) {
                    return UpcomingDuesContainer(
                      savedBillersData: widget.SavedBiller!
                          .where((element) =>
                              element.cUSTOMERBILLID.toString().toLowerCase() ==
                              widget.allUpcomingDues[index]["customerBillId"]
                                  .toString()
                                  .toLowerCase())
                          .toList()[0],
                      dateText: widget.allUpcomingDues[index]["dueDate"] != ""
                          ? DateFormat('MMM dd, yyyy').format(DateTime.parse(
                                  widget.allUpcomingDues[index]["dueDate"]!
                                      .toString()
                                      .substring(0, 10))
                              .toLocal()
                              .add(const Duration(days: 1)))
                          : "-",
                      dueDate: widget.allUpcomingDues[index]["dueDate"] != ""
                          ? DateTime.parse(widget.allUpcomingDues[index]
                                  ["dueDate"]!
                              .toString())
                          : "-",
                      dueStatus:
                          widget.allUpcomingDues[index]["dueStatus"] != ""
                              ? widget.allUpcomingDues[index]["dueStatus"]
                              : 0,
                      buttonText: widget.allUpcomingDues[index]["itemType"] ==
                              'upcomingDue'
                          ? "Pay Now"
                          : widget.allUpcomingDues[index]["itemType"] ==
                                  'upcomingAutopaused'
                              ? "Upcoming Autopay Paused"
                              : 'Upcoming Auto Payment',
                      onPressed: () {
                        SavedBillersData savedBillersData;
                        List<SavedBillersData> billerDataTemp = [];

                        billerDataTemp = widget.SavedBiller!
                            .where((element) =>
                                element.cUSTOMERBILLID
                                    .toString()
                                    .toLowerCase() ==
                                widget.allUpcomingDues[index]["customerBillId"]
                                    .toString()
                                    .toLowerCase())
                            .toList();
                        if (billerDataTemp.isNotEmpty) {
                          savedBillersData = billerDataTemp[0];
                          goToData(context, fETCHBILLERDETAILSROUTE, {
                            "name": widget.allUpcomingDues[index]["billerName"],
                            "billName": widget.allUpcomingDues[index]
                                ["billName"],
                            "savedBillersData": savedBillersData,
                            "SavedinputParameters": savedBillersData.pARAMETERS,
                            "categoryName": savedBillersData.cATEGORYNAME,
                            "isSavedBill": true,
                          });
                        }
                      },
                      amount:
                          "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.allUpcomingDues[index]["dueAmount"]!.toString()))}",
                      iconPath: BILLER_LOGO(
                          widget.allUpcomingDues[index]["billerName"]),
                      containerBorderColor: AppColors.CLR_CON_BORDER,
                      buttonColor: widget.allUpcomingDues[index]["itemType"] ==
                              'upcomingDue'
                          ? AppColors.CLR_PRIMARY_NC
                          : AppColors.CLR_GREEN,
                      buttonTxtColor: widget.allUpcomingDues[index]
                                  ["itemType"] ==
                              'upcomingDue'
                          ? AppColors.CLR_PRIMARY_NC
                          : widget.allUpcomingDues[index]["itemType"] ==
                                  'upcomingAutopaused'
                              ? AppColors.CLR_ERROR
                              : AppColors.CLR_GREEN,
                      buttonTextWeight: FontWeight.normal,
                      buttonBorderColor: widget.allUpcomingDues[index]
                                  ["itemType"] ==
                              'upcomingDue'
                          ? null
                          : widget.allUpcomingDues[index]["itemType"] ==
                                  'upcomingAutopaused'
                              ? AppColors.CLR_ERROR
                              : AppColors.CLR_GREEN,
                    );
                  }),
            // if (isUpcomingAutopaymentLoading ||
            //     isUpcomingDuesLoading ||
            //     isSavedBillerLoading)
            //   Center(
            //     child: Container(
            //       height: 200.h,
            //       width: 200.w,
            //       child: Loader(),
            //     ),
            //   ),
          ],
        ));
  }
}
