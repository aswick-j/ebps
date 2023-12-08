abstract class Repository {
  //Login
  Future login(id, hash) async {}

  //Category
  Future getCategories() async {}

  //All Billers
  Future getBillers(
    categoryId,
    pageNumber,
  ) async {}

  //Biller Input Sign
  Future getInputSignature(id) async {}

  //Fetch Bill
  Future fetchBill(validateBill, billerID, billerParams, quickPay,
      quickPayAmount, adHocBillValidationRefKey, billName) async {}

  //Account-info
  Future getAccountInfo(account) async {}

  //Payment-info
  Future getPaymentInformation(id) async {}

  //Validate-bill
  Future validateBill(payload) async {}

  //GEN-OTP
  Future generateOtp({templateName, billerName}) async {}

  //Validate - OTP
  Future validateOtp(otp) async {}

  //pay-bill
  Future payBill(
      String billerID,
      String acNo,
      String billAmount,
      int customerBillID,
      String tnxRefKey,
      bool quickPay,
      dynamic inputSignature,
      bool otherAmount,
      String otp) async {}

  //SEARCH
  Future getSearchedBillers(String searchString, String category,
      String location, int pageNumber) async {}

  //HISTORY

  Future getHistory(day) async {}

  //COMPLAINT_LIST
  Future getComplaints() async {}

  //COMPLAINT CONFIG
  Future getComplaintConfig() async {}

  //COMPLAINT SUBMIT
  Future submitComplaint(complaint) async {}

  //AUTOPAY MAX AMOUNT

  Future getAutoPayMaxAmount() async {}

  //GET ALL UPCOMING DUES

  Future getAllUpcomingDues() async {}

  //GET ALL AUTOPAY

  Future getAutoPay() async {}

  //GET ALL SAVED BILLERS

  Future getSavedBillers() async {}
}
