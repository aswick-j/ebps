const FAILED = "Failed";
const PENDING = "Pending";
const SUCCESS = "Success";

dynamic getTransactionStatus(String? value) {
  switch (value) {
    case "Memo present on Loan Account.":
      return FAILED;
    case "aggregator-failed":
    case "aggregator-response-unknown":
      return FAILED;
    case "Insufficient Balance.":
    case " Insufficient Balance. ":
      return FAILED;
    case "Database Error :":
    case "Called function has had a Fatal Error":
      return FAILED;
    case "fund-transfer-failed":
      return FAILED;
    case "bbps-timeout":
    case "bbps-in-progress":
      return PENDING;
    case "Customer is KYC Pending/KYC Non-Compliant. KYC Documents need to be collected from Customer.":
      return FAILED;
    case "success":
      return SUCCESS;
    default:
      return FAILED;
  }
}
