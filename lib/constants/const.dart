import 'package:flutter/material.dart';

/// the Navigator class.
///
/// Args:
///   context: The context parameter is a reference to the current BuildContext. It is typically
/// obtained from the build method of a widget or from the context parameter of a callback function. The
/// context is used by the Navigator to determine the current route and to perform navigation actions.
///   routeName: The name of the route to navigate to. This is typically a string that corresponds to a
/// specific route in your app's navigation configuration.

goTo(context, routeName) => Navigator.of(context).pushNamed(routeName);
goToReplace(context, routeName) =>
    Navigator.pushReplacementNamed(context, routeName);
goToData(context, routeName, arg) =>
    Navigator.pushNamed(context, routeName, arguments: arg);
goToReplaceData(context, routeName, arg) =>
    Navigator.pushReplacementNamed(context, routeName, arguments: arg);
goToUntil(context, routeName) =>
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
goBack(context) => Navigator.of(context).pop();

/// The code defines three lists: `RechargeCat`, `UtilCat`, and `FinCat`. Each list contains a set of
/// categories related to different types of services.

List RechargeCat = [
  "Mobile Postpaid",
  "Mobile Prepaid",
  "DTH",
  "Cable TV",
  "Broadband Postpaid",
];
List UtilCat = [
  "ELECTRICITY",
  "Water",
  "LPG Gas",
  "Gas",
  "Landline Postpaid",
  "Subscription",
  "Education Fees",
  "Credit Card"
];
List FinCat = [
  "Insurance",
  "Loan Repayment",
  "Health Insurance",
  "Life Insurance",
  "Municipal Services",
  "Municipal Taxes"
];

List ExcludedCategories = [...RechargeCat, ...FinCat, ...UtilCat];

/// The below code defines two functions in Dart that return a SizedBox widget with a specified width or
/// height.
///
/// Args:
///   width (double): The width parameter is the desired width of the horizontal spacer.
///
/// Returns:
///   The code is returning a SizedBox widget with the specified width or height.

horizontalSpacer(double width) {
  return SizedBox(
    width: width,
  );
}

verticalSpacer(double height) {
  return SizedBox(
    height: height,
  );
}

dynamic getInputType(String? value) {
  switch (value) {
    case "NUMERIC":
      return TextInputType.number;
    case "ALPHANUMERIC":
      return TextInputType.text;
    default:
      TextInputType.text;
  }
}
