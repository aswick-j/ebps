dynamic getPopupSuccessMsg(int index, String BillerName, String BillName) {
  switch (index) {
    case 0:
      return "$BillName ($BillerName) Has Been Deleted Successfully";
    case 1:
      return "Autopay for $BillName ($BillerName) Has Been Created";
    case 2:
      return "Autopay for $BillName ($BillerName) Has Been Updated";
    case 3:
      return "Autopay for $BillName ($BillerName) Has Been Deleted";
    case 4:
      return "Autopay for $BillName ($BillerName) Has Been Paused";
    case 5:
      return "Autopay for $BillName ($BillerName) Has Been Resumed";
    default:
      return "Something Went Wrong";
  }
}

dynamic getPopupFailedMsg(int index, String BillerName, String BillName) {
  switch (index) {
    case 0:
      return "$BillName ($BillerName) Has Been Updated";
    case 1:
      return "Autopay Create Failed for $BillName ($BillerName) ";
    case 2:
      return "Autopay Update Failed for $BillName ($BillerName) ";
    case 3:
      return "Autopay Delete Failed for $BillName ($BillerName) ";
    case 4:
      return "Autopay Pause Failed for $BillName ($BillerName) ";
    case 5:
      return "Autopay Resume Failed for $BillName ($BillerName) ";
    default:
      return "Something Went Wrong";
  }
}
