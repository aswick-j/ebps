String checkIsExact(num userAmount, num billAmount, paymentExactness) {
  var isErrorMsg = "";

  switch (paymentExactness) {
    // If the exactness is Exact then set the error message
    case "Exact":
      if (userAmount != billAmount) {
        isErrorMsg = "Only Exact Payment Amount Accepted";
      }
      break;
    // If the exactness is Exact and below then set the error message
    case "Exact and below":
      if (userAmount > billAmount) {
        isErrorMsg =
            "Payment amount should be less than or equal to the bill amount";
      }
      break;
    // If the exactness is Exact and Above then set the error message
    case "Exact and Above":
      if (userAmount < billAmount) {
        isErrorMsg =
            "Payment amount should be more than or equal to the bill amount";
      }
      break;
    default:
      break;
  }
  return isErrorMsg;
}
