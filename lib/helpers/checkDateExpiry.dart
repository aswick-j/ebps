bool checkDateExpiry(String date) {
  try {
<<<<<<< HEAD
    final TodaysDate = DateTime.now().toLocal();

    final recDate = DateTime.parse(date).toLocal();

    final newDate = recDate
        .subtract(Duration(hours: 0, minutes: 0))
        .add(Duration(hours: 23, minutes: 59));
    final bool isExpired = newDate.isBefore(TodaysDate);
=======
    final TodaysDate = DateTime.now();

    final recDate = DateTime.parse(date);

    final bool isExpired = recDate.isBefore(TodaysDate);
>>>>>>> d12fc2fb59afbe76173dceb07a01aa8ac44013ad

    return isExpired;
  } catch (e) {
    print(e);
    return false;
  }
}
