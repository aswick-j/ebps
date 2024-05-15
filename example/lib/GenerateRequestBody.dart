Map<String, Object> RequestBody(
    List accounts,
    String otpPreference,
    String gender,
    String mobileNumber,
    String dob,
    String customerID,
    String mailId,
    String elite) {
  return {
    "IPAddress": "1.1.1.1",
    "platform": "MB",
    "service": "bbps",
    "data": {
      "accounts": accounts,
      "otpPreference": otpPreference,
      "customer": {
        "gndr": gender,
        "mblNb": mobileNumber,
        "dob": dob,
        "custId": customerID,
        "emailId": mailId,
        "eliteFlag": elite
      }
    }
  };
}
