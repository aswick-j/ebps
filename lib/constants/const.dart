import 'package:ebps/data/models/decoded_model.dart';
import 'package:ebps/data/services/api.dart';
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
    Navigator.of(context).pushNamed(routeName, arguments: arg);
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

Map<String, dynamic> getBillerType(
    String? fetchRequirement,
    String? blrAcceptsAdhoc,
    String? supportBillValidation,
    String? paymentExactness) {
  bool fetchBill = false;
  bool amountEditable = false;
  bool validateBill = false;
  String billerType = "";
  bool isAdhoc = false;
  bool quickPay = true;

  switch (fetchRequirement) {
    //   If the case is MANDATORY and OPTIONAL then check the adhoc parameter
    case "MANDATORY":
    case "OPTIONAL":
      // If the biller accepts adhoc then mark fetch Bill and amount Editable as true
      if (blrAcceptsAdhoc == "Y") {
        fetchBill = true;
        amountEditable = true;
        billerType = "adhoc";
        validateBill = false;
        isAdhoc = true;
        quickPay = true;
      } else {
        //   Checking the payment exactness field to make the field editable
        if (paymentExactness == "Exact") {
          amountEditable = false;
        } else if (paymentExactness == "Exact and Above") {
          amountEditable = true;
        } else {
          amountEditable = true;
        }
        billerType = "billFetch";
        fetchBill = true;
        validateBill = false;
        isAdhoc = false;
        quickPay = false;
      }
      break;
    //   If the case is NOT_SUPPORTED then check for supportBillValidation
    case "NOT_SUPPORTED":
      // If the billvalidation is MANDATORY then mark validateBill , amountEditable and fetchBill
      if (supportBillValidation == "MANDATORY") {
        validateBill = true;
        fetchBill = false;
        amountEditable = true;
        billerType = "validate";
        isAdhoc = true;
        quickPay = true;
      }
      //   Else mark all the fields as false
      else {
        validateBill = false;
        amountEditable = true;
        fetchBill = false;
        billerType = "instant";
        isAdhoc = true;
        quickPay = true;
      }
      break;
    default:
      break;
  }
  //   Return the all the fields
  return {
    "fetchBill": fetchBill,
    "amountEditable": amountEditable,
    "validateBill": validateBill,
    "billerType": billerType,
    "isAdhoc": isAdhoc,
    "quickPay": quickPay,
  };
}

billerDetail(pARAMETERNAME, pARAMETERVALUE) {
  return Container(
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
              child: Text(
                pARAMETERNAME,
                // "Subscriber ID",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff808080),
                ),
                textAlign: TextAlign.center,
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
              child: Text(
                pARAMETERVALUE,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1b438b),
                ),
                textAlign: TextAlign.left,
              ))
        ],
      ));
}

Future<List<Accounts>> getDecodedAccounts() async {
  List<Accounts> decodedAccounts = [];
  try {
    DecodedModel? decodedModel = await validateJWT();

    if (decodedModel.toString() != 'restart') {
      decodedAccounts = decodedModel!.accounts!;
    }
  } catch (e) {
    print(e);
  }

  return decodedAccounts;
}

List<Accounts>? myAccounts = [];
