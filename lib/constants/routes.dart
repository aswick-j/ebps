import 'package:ebps/bloc/complaint/complaint_cubit.dart';
import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/splash/splash_cubit.dart';
import 'package:ebps/data/models/categories_model.dart';
import 'package:ebps/data/services/api_client.dart';
import 'package:ebps/presentation/screens/BillFlow/bill_parameters.dart';
import 'package:ebps/presentation/screens/BillFlow/biller_details.dart';
import 'package:ebps/presentation/screens/BillFlow/biller_list.dart';
import 'package:ebps/presentation/screens/Payments/payment_details.dart';
import 'package:ebps/presentation/screens/Payments/transaction_screen.dart';
import 'package:ebps/presentation/screens/complaints/complaint_details.dart';
import 'package:ebps/presentation/screens/complaints/complaint_screen.dart';
import 'package:ebps/presentation/screens/complaints/register_complaint.dart';
import 'package:ebps/presentation/screens/history/history_details.dart';
import 'package:ebps/presentation/screens/history/history_screen.dart';
import 'package:ebps/presentation/screens/home/all_bill_categories.dart';
import 'package:ebps/presentation/screens/home/search_screen.dart';
// import 'package:ebps/presentation/screens/mpin/mpinScreen.dart';
import 'package:ebps/presentation/screens/otp/otp_screen.dart';
import 'package:ebps/presentation/screens/session_expired.dart';
import 'package:ebps/presentation/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const sPLASHROUTE = "/";
const hOMEROUTE = "/home";
const allCATROUTE = "/allCategory";
const bILLERLISTROUTE = "/billerList";
const bILLERPARAMROUTE = "/billerParameters";
const fETCHBILLERDETAILSROUTE = "/fetchBillerDetails";
const pAYMENTCONFIRMROUTE = "/paymentConfirmation";
const sESSIONEXPIREDROUTE = '/SessionExpired';
const oTPPAGEROUTE = '/otp';
const mPINROUTE = '/mpin';
const tRANSROUTE = '/transSuccessful';
const sEARCHROUTE = '/search';
const hISTORYROUTE = '/history';
const hISTORYDETAILSROUTE = '/historyDetails';
const rEGISTERCOMPLAINTROUTE = '/regsiterComplaintRoute';
const cOMPLAINTLISTROUTE = '/complaintListRoute';
const cOMPLAINTDETAILSROUTE = '/complaintDetail';
const cOMPLAINTREGISTERROUTE = '/complaintRegisterRoute';

/// The `MyRouter` class is responsible for generating routes and corresponding page widgets based on
/// the provided route settings.

class MyRouter {
  ApiClient apiClient = ApiClient();

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //SPLASHSCREEN

      case sPLASHROUTE:
        final splashCubit = SplashCubit(repository: apiClient);
        final args = settings.arguments.toString();

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => splashCubit,
                  child: splashScreen(
                    apiData: args,
                  ),
                ));

      //HOME_SCREEN

      case hOMEROUTE:
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: BottomAppBar(),
                ));
      //ALL CATEGORIES PAGE ROUTE

      case allCATROUTE:
        final args = settings.arguments as Map<String, dynamic>;
        List<CategorieData>? catData = args["categoriesData"];

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: AllBillCategories(categoriesData: catData),
                ));

      //BILLER LIST PAGE ROUTE

      case bILLERLISTROUTE:
        final args = settings.arguments as Map<String, dynamic>;
        final cAT_ID = args["cATEGORY_ID"];
        final cAT_NAME = args["cATEGORY_NAME"];

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: BillerList(id: cAT_ID, name: cAT_NAME),
                ));

      //BILLER INPUT SIGN

      case bILLERPARAMROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: BillParameters(
                      billerData: args["BILLER_DATA"],
                      inputSignatureData: null),
                ));

      //FETCH - BILLER DETAILS

      case fETCHBILLERDETAILSROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: BillerDetails(
                    billID: args['billID'],
                    billerName: args['name'],
                    billName: args['billName'],
                    categoryName: args['categoryName'],
                    isSavedBill: args["isSavedBill"],
                    billerData: args['billerData'],
                    inputParameters: args['inputParameters'],
                  ),
                ));

      case pAYMENTCONFIRMROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: PaymentDetails(
                      billID: args['billID'],
                      billerName: args['name'],
                      billName: args['billName'],
                      categoryName: args['categoryName'],
                      isSavedBill: args["isSavedBill"],
                      billerData: args['billerData'],
                      inputParameters: args['inputParameters'],
                      amount: args['amount'],
                      validateBill: args['validateBill'],
                      billerInputSign: args['billerInputSign']),
                ));

      //SESSION EXPIRED

      case sESSIONEXPIREDROUTE:
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: SessionExpired(),
                ));
//MPIN
      // case mPINROUTE:
      //   final args = settings.arguments as Map<String, dynamic>;
      //   return CupertinoPageRoute(
      //       fullscreenDialog: true,
      //       builder: (_) => BlocProvider(
      //             create: (context) => HomeCubit(repository: apiClient),
      //             child: MpinScreen(data: args['data']),
      //           ));

      //OTP
      case oTPPAGEROUTE:
        // Widget otpScreen = OtpScreen(
        //   from: '',
        //   templateName: '',
        // );
        final args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: OtpScreen(
                      from: args['from'],
                      templateName: args['templateName'],
                      data: args['data']),
                ));

      //TRANS_SUCCESS

      case tRANSROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: TransactionScreen(
                    billName: args["billName"],
                    billerName: args['billerName'],
                    categoryName: args["categoryName"],
                    isSavedBill: args["isSavedBill"],
                    billerData: args['billerData'],
                    inputParameters: args['inputParameters'],
                  ),
                ));
      //SEARCH

      case sEARCHROUTE:
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: SearchScreen(),
                ));

      //HISTORY ROUTE

      case hISTORYROUTE:
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HistoryCubit(repository: apiClient),
                  child: HistoryScreen(),
                ));

      //HISTORY DETAILS

      case hISTORYDETAILSROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HistoryCubit(repository: apiClient),
                  child: HistoryDetails(
                      billName: args["billName"],
                      billerName: args['billerName'],
                      categoryName: args["categoryName"],
                      isSavedBill: args["isSavedBill"],
                      historyData: args["historyData"]),
                ));

      //COMPAINT LIST

      case cOMPLAINTLISTROUTE:
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => ComplaintCubit(repository: apiClient),
                  child: ComplaintScreen(),
                ));

      //COMPLAINT DETAILS
      case cOMPLAINTDETAILSROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (_) => BlocProvider(
            create: (context) => ComplaintCubit(repository: apiClient),
            child: ComplaintDetails(complaintData: args["complaintData"]),
          ),
        );

//COMPLAINT REGISTER

      case cOMPLAINTREGISTERROUTE:
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => ComplaintCubit(repository: apiClient),
                  child: RegisterComplaint(),
                ));

      default:
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: BottomAppBar(),
                ));
    }
  }
}
