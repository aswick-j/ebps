
const FAILED = "FAILED";
const PENDING = "PENDING";

dynamic getTransactionStatus(String? value) {
  switch (value) {
    case "aggregator-response-unknown":
      return FAILED;
    case "BackendError":
      return FAILED;
    default:
      return FAILED;
  }
}
