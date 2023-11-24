import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/splash/splash_cubit.dart';
import 'package:ebps/data/models/categories_model.dart';
import 'package:ebps/data/services/api_client.dart';
import 'package:ebps/presentation/screens/BillFlow/BillParameters.dart';
import 'package:ebps/presentation/screens/BillFlow/BillerDetails.dart';
import 'package:ebps/presentation/screens/BillFlow/BillerList.dart';
import 'package:ebps/presentation/screens/Payments/PaymentDetails.dart';
import 'package:ebps/presentation/screens/home/AllBillCategories.dart';
import 'package:ebps/presentation/screens/splashScreen.dart';
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
const sESSIONEXPIRED = '/SessionExpired';

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
            builder: (_) => BlocProvider(
                  create: (context) => splashCubit,
                  child: splashScreen(
                    apiData: args,
                  ),
                ));

      //HOME_SCREEN

      case hOMEROUTE:
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: BottomAppBar(),
                ));
      //ALL CATEGORIES PAGE ROUTE

      case allCATROUTE:
        final args = settings.arguments as Map<String, dynamic>;
        List<CategorieData>? catData = args["categoriesData"];

        return CupertinoPageRoute(
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
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: BillerList(id: cAT_ID, name: cAT_NAME),
                ));

      //BILLER INPUT SIGN

      case bILLERPARAMROUTE:
        final args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
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
                  ),
                ));

      default:
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apiClient),
                  child: BottomAppBar(),
                ));
    }
  }
}
