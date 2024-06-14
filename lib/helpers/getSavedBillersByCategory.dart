import 'package:ebps/models/saved_biller_model.dart';

List<SavedBillersData>? getSavedBillersByCategory(
    String categoryName, List<SavedBillersData>? savedBiller) {
  try {
    List<SavedBillersData> SavedbillerDataTemp = [];

    SavedbillerDataTemp = savedBiller!
        .where((element) =>
            element.cATEGORYNAME.toString().toLowerCase() ==
            categoryName.toString().toLowerCase())
        .toList();
    // return SavedbillerDataTemp;
    return [];
  } catch (e) {
    return [];
  }
}
