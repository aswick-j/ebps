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
  Future fetchBill(
      validateBill,
      billerID,
      billerParams,
      quickPay,
      quickPayAmount,
      adHocBillValidationRefKey,
      billName,
      customerBillId) async {}

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
      int? customerBillID,
      String tnxRefKey,
      bool quickPay,
      dynamic inputSignature,
      bool otherAmount,
      String otp) async {}

  //SEARCH
  Future getSearchedBillers(String searchString, String category,
      String location, int pageNumber) async {}

  //PREPAID PLANS

  Future PrepaidFetchPlans(dynamic id) async {}

  //HISTORY

  Future getHistory(day) async {}

  //TRANSACTION STATUS

  Future getTransactionStatus(id) async {}

  //UPDATE TRANSACTION STATUS

  Future updateTransactionStatus(payload) async {}

  //UPDATE COMLAINT STATUS
  Future updateComplaintStatus(payload) async {}

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

  //GET EDIT SAVED BILLER

  Future getEditSavedBillDetails(id) async {}

  //UPDATE EDIT BILLER

  Future updateBillDetails(payload) async {}

  //DELETE BILLER
  Future deleteBiller(customerBillID, customerID, otp) async {}

  //CATEGORY BILLER HISTORY FILTER

  Future getBillerHistoryFilter(categoryID) async {}

  //CREATE AUTOPAY

  Future createAutopayData(playload) async {}

  //DELETE AUTOPAY

  Future removeAutoPay(id, otp) async {}

  //EDIT AUTOPAY

  Future editAutopayData(id, data) async {}

  //DELETE UPCOMING DUE

  Future deleteUpcomingDue(customerBillID);

  //ADD OR UPDATE UPCOMING DUE

  Future getAddUpdateUpcomingDue(
      customerBillID, dueAmount, dueDate, billDate, billPeriod) async {}

//MODIFY AUTOPAY

  Future modifyAutopay(id, status, otp) async {}

//AMOUNT BY DATE

  Future getAmountByDate() async {}

//BBPS SETTINGS

  Future getBbpsSettings() async {}

//GET CHARTS

  Future getChartData() async {}
}
