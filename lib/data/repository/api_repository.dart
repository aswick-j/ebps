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
}
