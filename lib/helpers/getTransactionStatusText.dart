String getTransactionStatusText(String transactionStatus) {
  if (transactionStatus == 'success') {
    return "Transaction Details";
  } else if (transactionStatus == 'pending') {
    return "Transaction Pending";
  } else {
    return "Transaction Failure";
  }
}
