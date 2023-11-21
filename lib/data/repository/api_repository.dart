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
}
