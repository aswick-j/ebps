String checkIsExact(num userAmount, num billAmount, paymentExactness) {
  var isErrorMsg = "";

  switch (paymentExactness) {
    // If the exactness is Exact then set the error message
    case "Exact":
      if (userAmount != billAmount) {
        isErrorMsg = "The payment amount should be equal to the bill amount.";
      }
      break;
    // If the exactness is Exact and below then set the error message
    case "Exact and below":
      if (userAmount > billAmount) {
        isErrorMsg =
            "The payment amount must be less than or equal to the bill amount.";
      }
      break;
    // If the exactness is Exact and Above then set the error message
    case "Exact and above":
      if (userAmount < billAmount) {
        isErrorMsg =
            "The payment amount must be greater than or equal to the bill amount.";
      }
      break;
    default:
      break;
  }
  return isErrorMsg;
}
