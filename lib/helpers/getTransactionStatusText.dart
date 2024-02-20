String getTransactionStatusText(String transactionStatus) {
  if (transactionStatus == 'success') {
    return "Transaction Details";
  } else if (transactionStatus == 'bbps-timeout' ||
      transactionStatus == 'bbps-in-progress') {
    return "Transaction Pending";
  } else {
    return "Transaction Failure";
  }
}
