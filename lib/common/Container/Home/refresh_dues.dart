import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/fetch_bill_model.dart';

import 'package:ebps/services/api_client.dart';

import 'package:ebps/widget/flickr_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

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
            if (!isFetchbillLoading)
              if (AmountPending != null)
                Container(
                  height: 250.h,
                  child: Center(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        SvgPicture.asset(
                          ICON_FAILED,
                          height: 50.h,
                          width: 50.w,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "You Have Pending Bill",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff808080),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "₹ ${NumberFormat('#,##,##0.00').format(
                            double.parse(AmountPending.toString()),
                          )}",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1b438b),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 30.h),
                        MyAppButton(
                            onPressed: () {
                              goBack(context);
                            },
                            buttonText: "Close",
                            buttonTxtColor: CLR_PRIMARY,
                            buttonBorderColor: Color(0xff768EB9),
                            buttonColor: Colors.white,
                            buttonSizeX: 10.h,
                            buttonSizeY: 37.w,
                            buttonTextSize: 14.sp,
                            buttonTextWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                ),
            if (AmountPending == null) Text("Unable to fetch the Fill"),
            if (isFetchbillLoading)
              Center(
                child: Container(
                  height: 250.h,
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
