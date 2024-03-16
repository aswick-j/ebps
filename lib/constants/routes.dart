import 'package:ebps/bloc/complaint/complaint_cubit.dart';
import 'package:ebps/bloc/history/history_cubit.dart';
import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/bloc/splash/splash_cubit.dart';

import 'package:ebps/models/categories_model.dart';
import 'package:ebps/screens/BillFlow/bill_parameters.dart';
import 'package:ebps/screens/BillFlow/biller_details.dart';
import 'package:ebps/screens/BillFlow/biller_list.dart';
import 'package:ebps/screens/Payments/payment_details.dart';
import 'package:ebps/screens/Payments/terms_and_conditions.dart';
import 'package:ebps/screens/Payments/transaction_screen.dart';
import 'package:ebps/screens/Prepaid/bill_parameters_prepaid.dart';
import 'package:ebps/screens/Prepaid/prepaid_plans.dart';
import 'package:ebps/screens/autopay/create_autopay.dart';
import 'package:ebps/screens/autopay/edit_autopay.dart';
import 'package:ebps/screens/complaints/complaint_details.dart';
import 'package:ebps/screens/complaints/complaint_screen.dart';
import 'package:ebps/screens/complaints/register_complaint.dart';
import 'package:ebps/screens/history/history_details.dart';
import 'package:ebps/screens/history/history_screen.dart';
import 'package:ebps/screens/home/all_bill_categories.dart';
import 'package:ebps/screens/home/all_upcoming_dues.dart';
import 'package:ebps/screens/home/search_screen.dart';
import 'package:ebps/screens/myBillers/bill_history.dart';
import 'package:ebps/screens/myBillers/edit_biller.dart';
import 'package:ebps/screens/otp/otp_screen.dart';
import 'package:ebps/screens/session_expired.dart';
import 'package:ebps/screens/splash_screen.dart';
import 'package:ebps/services/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const sPLASHROUTE = "/";
const hOMEROUTE = "/home";
const allCATROUTE = "/allCategory";
const bILLERLISTROUTE = "/billerList";
const bILLERPARAMROUTE = "/billerParameters";
const pREPAIDBILLERPARAMROUTE = "/preapaidBillerParameters";
const pREPAIDPLANSROUTE = "/prepaidPlansRoute";
const fETCHBILLERDETAILSROUTE = "/fetchBillerDetails";
const pAYMENTCONFIRMROUTE = "/paymentConfirmation";
const sESSIONEXPIREDROUTE = '/SessionExpired';
const oTPPAGEROUTE = '/otp';
const mPINROUTE = '/mpin';
const tRANSROUTE = '/transSuccessful';
const sEARCHROUTE = '/search';
const bILLERHISTORYROUTE = '/billerHistory';
const hISTORYROUTE = '/history';
const hISTORYDETAILSROUTE = '/historyDetails';
const rEGISTERCOMPLAINTROUTE = '/regsiterComplaintRoute';
const cOMPLAINTLISTROUTE = '/complaintListRoute';
const cOMPLAINTDETAILSROUTE = '/complaintDetail';
const cOMPLAINTREGISTERROUTE = '/complaintRegisterRoute';
const cREATEAUTOPAYROUTE = '/createAutopayRoute';
const eDITAUTOPAYROUTE = '/editAutopayRoute';
const eDITBILLERROUTE = '/editBillerRoute';
const uPCOMINGDUESROUTE = '/upcomingDuesRoute';
const tERMANDCONDITIONSROUTE = '/termsAndConditionsRoute';

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
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => MybillersCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => HomeCubit(repository: apiClient)),
                  ],
                  child: BottomAppBar(),
                ));

      //UPCOMING DUES
      case uPCOMINGDUESROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => MybillersCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => HomeCubit(repository: apiClient)),
                  ],
                  child: AllUpcomingDues(
                      autopayData: args["autopayData"],
                      allUpcomingDues: args["allUpcomingDues"],
                      SavedBiller: args["savedBiller"],
                      ctx: args["ctx"]),
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

      //PREPAID BILL PARAMS
      case pREPAIDBILLERPARAMROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: BillParametersPrepaid(
                      billerData: args["BILLER_DATA"],
                      inputSignatureData: null),
                ));

      //PREPAID PLANS

      case pREPAIDPLANSROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => HomeCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => MybillersCubit(repository: apiClient)),
                  ],
                  child: PrepaidPlans(
                      prepaidPlans: args["prepaidPlans"],
                      isFetchPlans: args["isFetchPlans"],
                      billerData: args["billerData"],
                      mobileNumber: args["mobileNumber"],
                      operator: args["operator"],
                      circle: args["circle"],
                      billName: args["billName"],
                      inputParameters: args["inputParameters"],
                      SavedinputParameters: args["SavedinputParameters"],
                      isSavedBill: args["isSavedBill"],
                      savedBillerData: args['savedBillerData']),
                ));

      //FETCH - BILLER DETAILS

      case fETCHBILLERDETAILSROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => HomeCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => MybillersCubit(repository: apiClient)),
                  ],
                  child: BillerDetails(
                    billID: args['billID'],
                    billerName: args['name'],
                    billName: args['billName'],
                    categoryName: args['categoryName'],
                    isSavedBill: args["isSavedBill"],
                    billerData: args['billerData'],
                    savedBillersData: args['savedBillersData'],
                    inputParameters: args['inputParameters'],
                    SavedinputParameters: args['SavedinputParameters'],
                  ),
                ));

      //PAYMENT DETAILS

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
                      BbpsSettingInfo: args['BbpsSettingInfo'],
                      savedBillersData: args['savedBillersData'],
                      inputParameters: args['inputParameters'],
                      SavedinputParameters: args['SavedinputParameters'],
                      amount: args['amount'],
                      validateBill: args['validateBill'],
                      billerInputSign: args['billerInputSign'],
                      planDetails: args["planDetails"],
                      otherAmount: args["otherAmount"]),
                ));

//TERMSANDCONDITIONS
      case tERMANDCONDITIONSROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: TermsAndConditions(
                    BbpsSettingInfo: args['BbpsSettingInfo'],
                  ),
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
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => HistoryCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => HomeCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => MybillersCubit(repository: apiClient)),
                  ],
                  child: OtpScreen(
                      from: args['from'],
                      templateName: args['templateName'],
                      BillerName: args["BillerName"],
                      BillName: args["BillName"],
                      data: args['data'],
                      ctx: args['context'],
                      autopayData: args["autopayData"]),
                ));

      //TRANS_SUCCESS

      case tRANSROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => HistoryCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => HomeCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => MybillersCubit(repository: apiClient)),
                  ],
                  child: TransactionScreen(
                      billName: args["billName"],
                      billerName: args['billerName'],
                      categoryName: args["categoryName"],
                      isSavedBill: args["isSavedBill"],
                      billerData: args['billerData'],
                      inputParameters: args['inputParameters'],
                      SavedinputParameters: args['SavedinputParameters']),
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
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => HistoryCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => HomeCubit(repository: apiClient)),
                  ],
                  child: HistoryScreen(),
                ));

//BILL HISTORY

      case bILLERHISTORYROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => HistoryCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => MybillersCubit(repository: apiClient)),
                  ],
                  child: BillHistory(
                      customerBillID: args["customerBillID"],
                      categoryID: args["categoryID"],
                      billerID: args["billerID"]),
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
                      handleStatus: args["handleStatus"],
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
            child: ComplaintDetails(
                complaintData: args["complaintData"],
                handleStatus: args["handleStatus"]),
          ),
        );

//COMPLAINT REGISTER

      case cOMPLAINTREGISTERROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => ComplaintCubit(repository: apiClient),
                  child: RegisterComplaint(
                    Date: args["Date"],
                    txnRefID: args["txnRefID"],
                    BillerName: args["BillerName"],
                    CategoryName: args["CategoryName"],
                  ),
                ));

//CREATE AUTOPAY
      case cREATEAUTOPAYROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => MybillersCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => HomeCubit(repository: apiClient)),
                  ],
                  child: createAutopay(
                    billerName: args["billerName"],
                    categoryName: args["categoryName"],
                    billName: args["billName"],
                    lastPaidAmount: args["lastPaidAmount"],
                    customerBillID: args["customerBillID"],
                    savedBillersdata: args["savedBillersData"],
                  ),
                ));

//EDIT AUTOPAY
      case eDITAUTOPAYROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => MybillersCubit(repository: apiClient)),
                    BlocProvider(
                        create: (_) => HomeCubit(repository: apiClient)),
                  ],
                  // create: (context) => MybillersCubit(repository: apiClient),
                  child: editAutopay(
                      savedBillerData: args["savedBillerData"],
                      AutoDateMisMatch: args["AutoDateMisMatch"],
                      DebitLimitMisMatch: args["DebitLimitMisMatch"],
                      autopayData: args["autopayData"]),
                ));

      //EDIT BILLER

      case eDITBILLERROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => ComplaintCubit(repository: apiClient),
                  child: EditBiller(savedbillersData: args["SavedBillersData"]),
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
