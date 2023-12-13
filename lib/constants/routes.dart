import 'package:ebps/bloc/MyBillers/mybillers_cubit.dart';
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
import 'package:ebps/presentation/screens/autopay/create_autopay.dart';
import 'package:ebps/presentation/screens/autopay/edit_autopay.dart';
import 'package:ebps/presentation/screens/complaints/complaint_details.dart';
import 'package:ebps/presentation/screens/complaints/complaint_screen.dart';
import 'package:ebps/presentation/screens/complaints/register_complaint.dart';
import 'package:ebps/presentation/screens/history/history_details.dart';
import 'package:ebps/presentation/screens/history/history_screen.dart';
import 'package:ebps/presentation/screens/home/all_bill_categories.dart';
import 'package:ebps/presentation/screens/home/all_upcoming_dues.dart';
import 'package:ebps/presentation/screens/home/search_screen.dart';
import 'package:ebps/presentation/screens/myBillers/bill_history.dart';
import 'package:ebps/presentation/screens/myBillers/edit_biller.dart';
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
                      allUpcomingDues: args["allUpcomingDues"],
                      SavedBiller: args["savedBiller"]),
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
                    savedBillersData: args['savedBillersData'],
                    inputParameters: args['inputParameters'],
                    SavedinputParameters: args['SavedinputParameters'],
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
                      savedBillersData: args['savedBillersData'],
                      inputParameters: args['inputParameters'],
                      SavedinputParameters: args['SavedinputParameters'],
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
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => BlocProvider(
                  create: (context) => ComplaintCubit(repository: apiClient),
                  child: RegisterComplaint(txnRefID: args["txnRefID"]),
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
                    customerBillID: args["customerBillID"],
                    savedInputSignatures: args["savedInputSignatures"],
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
                    billerName: args["billerName"],
                    categoryName: args["categoryName"],
                    billName: args["billName"],
                    customerBillID: args["customerBillID"],
                    savedInputSignatures: args["savedInputSignatures"],
                  ),
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
