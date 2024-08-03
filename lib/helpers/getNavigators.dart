import 'package:ebps/constants/authRoutes.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/ebps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

GoTo(context, routeName) => RouteConstants.ALLOWED_ROUTES.contains(routeName)
    ? WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(routeName);
      })
    : WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(nOTPERMITTEDROUTE);
      });
GoToReplace(context, routeName) =>
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(routeName);
    });
GoToData(context, routeName, arg) =>
    RouteConstants.ALLOWED_ROUTES.contains(routeName)
        ? routeName == oTPPAGEROUTE
            ? VerifyOtpRoute(arg!['templateName'] ?? "Inavlid Route")
                ? WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushNamed(routeName, arguments: arg);
                  })
                : WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushNamed(nOTPERMITTEDROUTE);
                  })
            : WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamed(routeName, arguments: arg);
              })
        : WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed(nOTPERMITTEDROUTE);
          });

GoToReplaceData(context, routeName, arg) =>
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(routeName, arguments: arg);
    });
GoToUntil(context, routeName, arg) =>
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (context, routeName, (route) => false);
    });
GoBack(context) => WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
    });

//WITHOUT CONTEXT

class NavigationService {
  late GlobalKey<NavigatorState> navigationKey;

  static NavigationService instance = NavigationService();

  NavigationService() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String _rn) {
    return navigationKey.currentState!.pushReplacementNamed(_rn);
  }

  Future<dynamic> navigateTo(String _rn) {
    return navigationKey.currentState!.pushNamed(_rn);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute _rn) {
    return navigationKey.currentState!.push(_rn);
  }

  goback() {
    return navigationKey.currentState!.pop();
  }
}
