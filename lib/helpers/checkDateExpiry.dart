bool checkDateExpiry(String date) {
  try {
    final TodaysDate = DateTime.now().toLocal();

    final recDate = DateTime.parse(date).toLocal();

    final newDate = recDate
        .subtract(Duration(hours: 0, minutes: 0))
        .add(Duration(hours: 23, minutes: 59));
    final bool isExpired = newDate.isBefore(TodaysDate);

    return isExpired;
  } catch (e) {
    print(e);
    return false;
  }
}
