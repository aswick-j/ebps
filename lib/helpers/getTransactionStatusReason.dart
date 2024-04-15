String getTransactionReason(String status) {
  switch (status) {
    case "Memo present on Loan Account.":
      return "Memo present on Loan Account";
    case "aggregator-failed":
    case "aggregator-response-unknown":
      return "Bill Payment failed";
    case "Insufficient Balance.":
    case " Insufficient Balance. ":
      return "Insufficient Balance";
    case "Database Error :":
    case "Called function has had a Fatal Error":
      return "Internal Failure";
    case "XfaceGenericFundTransferRequestDTO/fromAccountInvalid String Value in field fromAccount.":
    case "fund-transfer-failed":
      return "Fund Transfer failed from Bank";
    case "pending":
    case "bbps-timeout":
    case "bbps-in-progress":
      return "Waiting Confirmation from Biller";
    case "Customer is KYC Pending/KYC Non-Compliant. KYC Documents need to be collected from Customer.":
      return "KYC Pending";
    default:
      return "Bill Payment Failed";
  }
}
