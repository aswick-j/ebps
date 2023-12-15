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
