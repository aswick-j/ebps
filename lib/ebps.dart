import 'package:ebps/constants/ebps_theme.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getBaseurl.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppExit {
  AppExit._privateConstructor();

  static final AppExit instance = AppExit._privateConstructor();

  Function? mainAppExit;

  void setMainAppExit(final Function? Trigger) {
    mainAppExit = Trigger;
  }
}

class AppTrigger {
  AppTrigger._privateConstructor();

  static final AppTrigger instance = AppTrigger._privateConstructor();

  VoidCallback? goBackCallback;

  void GoBack() {
    if (goBackCallback != null) {
      goBackCallback!();
    }
  }

  void setGoBackCallback(VoidCallback callback) {
    goBackCallback = callback;
  }

  // void goSessionExpired() {
  //   if (goBackCallback != null) {
  //     goBackCallback!();
  //   }
  // }

  // void setGoSessionnExpiredCallack(VoidCallback callback) {
  //   goBackCallback = callback;
  // }
}

class ApiConstants {
  ApiConstants._();
  static var BASE_URL = "";
}

class RouteConstants {
  RouteConstants._();
  static List ALLOWED_ROUTES = [];
}

class IsCustomerElite {
  IsCustomerElite._();
  static var isCustomerElite = false;
}

class InternetCheck {
  InternetCheck._();
  static var isConnected = true;
}

class AppLoginFrom {
  AppLoginFrom._();
  static var IsFromSuperApp = true;
}

class EbpsScreen extends StatelessWidget {
  String apiData;
  BuildContext ctx;
  String flavor;
  final VoidCallback? triggerAppExit;
  bool fromSuperApp;

  EbpsScreen(
      {Key? key,
      required this.apiData,
      required this.ctx,
      this.triggerAppExit,
      required this.fromSuperApp,
      required this.flavor})
      : super(key: key) {
    ApiConstants.BASE_URL = getBaseUrl(flavor);
    AppLoginFrom.IsFromSuperApp = fromSuperApp;
    AppTrigger.instance.setGoBackCallback(() {
      Navigator.of(ctx).pop();
    });
    AppExit.instance.setMainAppExit(triggerAppExit);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final router = MyRouter();
    // AppTrigger.instance.setGoBackCallback(() {
    //   Navigator.of(context).pop();
    // });
    // AppTrigger.instance.setGoSessionnExpiredCallack(() {
    //   print("======");
    //   validateJWT(context);
    // });
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        // showPerformanceOverlay: true,

        title: "Bill Payment",
        theme: ebpsTheme,
        // darkTheme: DarkTheme,
        // themeMode: ThemeMode.dark,
        // theme: ThemeData(
        //   fontFamily: GoogleFonts.poppins().fontFamily,
        //   scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        // ),
        initialRoute: sPLASHROUTE,
        onGenerateInitialRoutes: (initialRoute) => [
          router.generateRoute(
            RouteSettings(name: sPLASHROUTE, arguments: apiData),
          )!
        ],
        debugShowCheckedModeBanner: false,
        onGenerateRoute: router.generateRoute,
        navigatorKey: NavigationService.instance.navigationKey,

        // home: splashScreen(apiData: apiData)
      ),
    );
  }
}
