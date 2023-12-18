import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/models/fetch_bill_model.dart';

import 'package:ebps/services/api_client.dart';

import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RefreshDues extends StatefulWidget {
  String? billerID;
  bool? quickPay;
  String? quickPayAmount;
  String? adHocBillValidationRefKey;
  bool? validateBill;
  dynamic billerParams;
  String? billName;
  RefreshDues(
      {super.key,
      required this.billerID,
      required this.quickPay,
      required this.quickPayAmount,
      required this.adHocBillValidationRefKey,
      required this.validateBill,
      required this.billerParams,
      required this.billName});

  @override
  State<RefreshDues> createState() => _RefreshDuesState();
}

class _RefreshDuesState extends State<RefreshDues> {
  ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MybillersCubit(repository: apiClient)),
        BlocProvider(create: (_) => HomeCubit(repository: apiClient)),
      ],
      child: RefreshDuesUI(
          billerID: widget.billerID,
          quickPay: widget.quickPay,
          quickPayAmount: widget.quickPayAmount,
          adHocBillValidationRefKey: widget.adHocBillValidationRefKey,
          validateBill: widget.validateBill,
          billerParams: widget.billerParams,
          billName: widget.billName),
    );
  }
}

class RefreshDuesUI extends StatefulWidget {
  String? billerID;
  bool? quickPay;
  String? quickPayAmount;
  String? adHocBillValidationRefKey;
  bool? validateBill;
  dynamic billerParams;
  String? billName;
  RefreshDuesUI(
      {super.key,
      required this.billerID,
      required this.quickPay,
      required this.quickPayAmount,
      required this.adHocBillValidationRefKey,
      required this.validateBill,
      required this.billerParams,
      required this.billName});

  @override
  State<RefreshDuesUI> createState() => _RefreshDuesUIState();
}

class _RefreshDuesUIState extends State<RefreshDuesUI> {
  BillerResponse? _billerResponseData;
  String? AmountPending;

  bool isFetchbillLoading = true;

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).fetchBill(
        billerID: widget.billerID,
        quickPay: widget.quickPay,
        quickPayAmount: widget.quickPayAmount,
        adHocBillValidationRefKey: widget.adHocBillValidationRefKey,
        validateBill: widget.validateBill,
        billerParams: widget.billerParams,
        billName: widget.billName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is FetchBillLoading) {
          setState(() {
            isFetchbillLoading = true;
          });
        } else if (state is FetchBillSuccess) {
          setState(() {
            _billerResponseData =
                state.fetchBillResponse!.data!.data!.billerResponse;

            AmountPending = _billerResponseData!.amount.toString();
            isFetchbillLoading = false;
          });
        } else if (state is FetchBillFailed) {
          setState(() {
            isFetchbillLoading = false;
          });
        } else if (state is FetchBillError) {
          setState(() {
            isFetchbillLoading = false;
          });
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Container(),
            !isFetchbillLoading
                ? AmountPending!.isNotEmpty
                    ? Column(
                        children: [
                          Text(
                            "Pending",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: CLR_ERROR,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "You Have Pending Bill",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff808080),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(AmountPending.toString()),
                        ],
                      )
                    : Text("Unable to fetch the Fill")
                : Center(
                    child: Container(
                      height: 200.h,
                      width: 200.w,
                      child: FlickrLoader(),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
