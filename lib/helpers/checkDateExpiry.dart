bool checkDateExpiry(String date) {
  try {
    final TodaysDate = DateTime.now();

    final recDate = DateTime.parse(date);

    final bool isExpired = recDate.isBefore(TodaysDate);

    return isExpired;
  } catch (e) {
    print(e);
    return false;
  }
}
