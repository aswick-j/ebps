import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/fetch_bill_model.dart';
import 'package:ebps/services/api_client.dart';
import 'package:ebps/widget/loader.dart';
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
  dynamic customerBillID;
  RefreshDues(
      {super.key,
      required this.billerID,
      required this.quickPay,
      required this.quickPayAmount,
      required this.adHocBillValidationRefKey,
      required this.validateBill,
      required this.customerBillID,
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
          customerBillID: widget.customerBillID,
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
  dynamic customerBillID;
  RefreshDuesUI(
      {super.key,
      required this.billerID,
      required this.quickPay,
      required this.quickPayAmount,
      required this.adHocBillValidationRefKey,
      required this.customerBillID,
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
  String? ErrorMsg = "";
  int ErrIndex = 0;
  bool gotoHome = false;

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).fetchBill(
        billerID: widget.billerID,
        quickPay: widget.quickPay,
        quickPayAmount: widget.quickPayAmount,
        adHocBillValidationRefKey: widget.adHocBillValidationRefKey,
        validateBill: widget.validateBill,
        billerParams: widget.billerParams,
        billName: widget.billName,
        customerBillId: widget.customerBillID);
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
            ErrorMsg = "";
            _billerResponseData =
                state.fetchBillResponse!.data!.data!.billerResponse;

            AmountPending = _billerResponseData!.amount.toString();
            isFetchbillLoading = false;
          });
        } else if (state is FetchBillFailed) {
          if (state.message.toString().contains("Unable to fetch")) {
            setState(() {
              ErrIndex = 1;
              ErrorMsg =
                  "It seems there is a problem fetching the\nbill at the moment.Kindly try again later.";
            });
          } else if (state.message
              .toString()
              .contains("Something went wrong")) {
            setState(() {
              ErrIndex = 2;

              ErrorMsg =
                  "The bank is experiencing some issues right now. Kindly try again later.";
            });
          } else if (state.message
              .toString()
              .toLowerCase()
              .contains("no pending bill")) {
            setState(() {
              ErrIndex = 3;
              gotoHome = true;
              ErrorMsg =
                  "You have no pending bill.\nPlease contact biller for more information.";
            });
            BlocProvider.of<MybillersCubit>(context)
                .deleteUpcomingDue(widget.customerBillID);
          } else if (state.message
              .toString()
              .toLowerCase()
              .contains("no bill data")) {
            BlocProvider.of<MybillersCubit>(context)
                .deleteUpcomingDue(widget.customerBillID);
            setState(() {
              ErrIndex = 4;
              gotoHome = true;
              ErrorMsg =
                  "No bill data available at the moment.\nPlease contact biller for more information.";
            });
            BlocProvider.of<MybillersCubit>(context)
                .deleteUpcomingDue(widget.customerBillID);
          } else {
            setState(() {
              ErrIndex = 5;

              ErrorMsg =
                  "Something went wrong.\nPlease try again after sometime.";
            });
          }

          setState(() {
            isFetchbillLoading = false;
          });
        } else if (state is FetchBillError) {
          setState(() {
            setState(() {
              ErrIndex = 5;

              ErrorMsg =
                  "Something went wrong.\nPlease try again after sometime.";
            });
            isFetchbillLoading = false;
          });
        }
        if (state is DeleteUpcomingDueLoading) {
        } else if (state is DeleteUpcomingDueSuccess) {
          DelightToastBar(
            position: DelightSnackbarPosition.top,
            autoDismiss: true,
            animationDuration: Duration(milliseconds: 300),
            builder: (context) => ToastCard(
              color: AppColors.CLR_BACKGROUND,
              shadowColor: Colors.grey.withOpacity(0.2),
              leading: Icon(
                Icons.check_circle_outline,
                size: 28.r,
                color: AppColors.CLR_GREEN,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due Deleted Successfully",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.CLR_PRIMARY,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ).show(context);
        } else if (state is DeleteUpcomingDueFailed) {
          DelightToastBar(
            autoDismiss: true,
            animationDuration: Duration(milliseconds: 300),
            builder: (context) => ToastCard(
              color: AppColors.CLR_BACKGROUND,
              shadowColor: Colors.grey.withOpacity(0.2),
              leading: Icon(
                Icons.cancel_outlined,
                size: 28.r,
                color: AppColors.CLR_ERROR,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due Deletion Failed",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.CLR_PRIMARY,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ).show(context);
        } else if (state is DeleteUpcomingDueError) {
          DelightToastBar(
            autoDismiss: true,
            animationDuration: Duration(milliseconds: 300),
            builder: (context) => ToastCard(
              color: AppColors.CLR_BACKGROUND,
              shadowColor: Colors.grey.withOpacity(0.2),
              leading: Icon(
                Icons.cancel_outlined,
                size: 28.r,
                color: AppColors.CLR_ERROR,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due Deletion Failed",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.CLR_PRIMARY,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ).show(context);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            if (!isFetchbillLoading)
              if (AmountPending != null && ErrorMsg == "")
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
                            color: AppColors.TXT_CLR_LITE,
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
                            color: AppColors.TXT_CLR_PRIMARY,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 30.h),
                        MyAppButton(
                            onPressed: () {
                              GoBack(context);
                            },
                            buttonText: "Okay",
                            buttonTxtColor:
                                AppColors.BTN_CLR_ACTIVE_ALTER_TEXT_C,
                            buttonBorderColor: AppColors.BTN_CLR_ACTIVE_BORDER,
                            buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER_C,
                            buttonSizeX: 10.h,
                            buttonSizeY: 37.w,
                            buttonTextSize: 14.sp,
                            buttonTextWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                ),
            if (!isFetchbillLoading && AmountPending == null && ErrorMsg != "")
              Container(
                height: 200.h,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      SvgPicture.asset(
                        ErrIndex == 2
                            ? ICON_ERROR
                            : ErrIndex == 3
                                ? ICON_SUCCESS
                                : ErrIndex == 4
                                    ? ICON_ERROR
                                    : ErrIndex == 5
                                        ? ICON_ERROR
                                        : ICON_FAILED,
                        height: 50.h,
                        width: 50.w,
                      ),
                      Spacer(),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                            child: Text(
                              ErrorMsg.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.TXT_CLR_PRIMARY,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      MyAppButton(
                          onPressed: () {
                            if (gotoHome) {
                              GoToReplaceData(context, hOMEROUTE, {
                                "index": 0,
                              });
                            } else {
                              GoBack(context);
                            }
                          },
                          buttonText: "Close",
                          buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT_C,
                          buttonBorderColor: AppColors.BTN_CLR_ACTIVE_BORDER,
                          buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER_C,
                          buttonSizeX: 10.h,
                          buttonSizeY: 37.w,
                          buttonTextSize: 14.sp,
                          buttonTextWeight: FontWeight.w500),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            if (isFetchbillLoading)
              Center(
                child: Container(
                  height: 250.h,
                  width: 200.w,
                  child: Center(child: Loader()),
                ),
              ),
          ],
        );
      },
    );
  }
}
