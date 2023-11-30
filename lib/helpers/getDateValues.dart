// ignore_for_file: file_names

DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

dynamic getTransactionHistoryDate(transactionType) async {
  try {
    final Map<String, dynamic> returnResponse = {
      "startDate": "",
      "endDate": ""
    };

    var curDateTime = DateTime.now();
    var parsetoday = getDate(curDateTime);
    var thisWeekDay = curDateTime.weekday;
    var thisMonthFirstDay = DateTime(curDateTime.year, curDateTime.month, 1);
    DateTime last3MonthLastDay = thisMonthFirstDay.subtract(Duration(days: 90));

    DateTime last3MonthFirstDay = DateTime(
        last3MonthLastDay.year, last3MonthLastDay.month, last3MonthLastDay.day);
    DateTime lastMonthlastDay = DateTime(curDateTime.year, curDateTime.month, 1)
        .subtract(Duration(days: 0));
    DateTime lastMonthFirstDay =
        DateTime(lastMonthlastDay.year, lastMonthlastDay.month - 1, 1);
    lastMonthFirstDay = lastMonthFirstDay.subtract(Duration(days: 0));
    var thisWeekStartDate = parsetoday.subtract(Duration(days: thisWeekDay));
    DateTime thisWeekFirstDay =
        getDate(curDateTime.subtract(Duration(days: curDateTime.weekday)));
    DateTime prevWeekFirstDay = thisWeekFirstDay.subtract(Duration(days: 7));
    var parseyesterday = getDate(curDateTime.subtract(Duration(days: 1)));

    var lastWeekFirstDay = getDate(prevWeekFirstDay);
    var lastWeekLastDay = getDate(prevWeekFirstDay.add(Duration(days: 6)));

    var today = parsetoday.toLocal().toIso8601String();
    var yesterday = parseyesterday.toLocal().toIso8601String();
    var thisWeekStartDt = thisWeekStartDate.toLocal().toIso8601String();
    var lastWeekStartDt = lastWeekFirstDay.toLocal().toIso8601String();
    var lastWeekEndDt = lastWeekLastDay.toLocal().toIso8601String();
    var thisMonthStartDt = thisMonthFirstDay.toLocal().toIso8601String();
    var lastMonthStartDt = lastMonthFirstDay.toLocal().toIso8601String();
    var lastMonthEndDt = lastMonthlastDay.toLocal().toIso8601String();
    var last3MonthStartDt = last3MonthFirstDay.toLocal().toIso8601String();

    var currTime = curDateTime.toLocal().toIso8601String();

    if (transactionType == "Today") {
      returnResponse['startDate'] = today;
      returnResponse['endDate'] = currTime;
    }
    if (transactionType == "Yesterday") {
      returnResponse['startDate'] = yesterday;
      returnResponse['endDate'] = today;
    } else if (transactionType == "This Week") {
      returnResponse['startDate'] = thisWeekStartDt;
      returnResponse['endDate'] = currTime;
    } else if (transactionType == "Last Week") {
      returnResponse['startDate'] = lastWeekStartDt;
      returnResponse['endDate'] = lastWeekEndDt;
    } else if (transactionType == "This Month") {
      returnResponse['startDate'] = thisMonthStartDt;
      returnResponse['endDate'] = currTime;
    } else if (transactionType == "Last Month") {
      returnResponse['startDate'] = lastMonthStartDt;
      returnResponse['endDate'] = lastMonthEndDt;
    } else if (transactionType == "last 3 Months") {
      returnResponse['startDate'] = last3MonthStartDt;
      returnResponse['endDate'] = lastMonthEndDt;
    } else if (transactionType == "customDate") {}
    return returnResponse;
  } catch (e) {}
}
