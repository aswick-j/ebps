dynamic getMonthName(int? isBimonthly) {
  var month = [
    "",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  var todaysDate = DateTime.parse(DateTime.now().toString()).day.toString();
  var monthNumber = DateTime.parse(DateTime.now().toString()).month;
  var year = DateTime.parse(DateTime.now().toString()).year;

  // declaring nextMonth and nextToNextMonth variables
  String nextMonth, nextToNextMonth;
  // if the value of isBimonthly is zero select nextMonth and nextToNextMonth
  if (isBimonthly == 0) {
    //if monthNumber is less than or equal to 10 add 1 to the current month and 2 to the next month
    if (monthNumber >= 1 && monthNumber <= 10) {
      nextMonth = '${month[monthNumber + 1]} $year';
      nextToNextMonth = '${month[monthNumber + 2]} $year';
      return [nextMonth, nextToNextMonth];
    }
    // if monthNumber is 11 set nextMonth as 12 and nextToNextMonth 11 - 10 = 1 and year = year + 1
    else if (monthNumber == 11) {
      nextMonth = '${month[monthNumber + 1]} $year';
      nextToNextMonth = '${month[monthNumber - 10]} ${year + 1}';
      return [nextMonth, nextToNextMonth];
    }
    // if monthNumber is 12 set nextMonth as 12 - 11 = 1 and 12 - 10 = 2 and year = year + 1
    else {
      nextMonth = '${month[monthNumber - 11]} ${year + 1}';
      nextToNextMonth = '${month[monthNumber - 10]} ${year + 1}';
      return [nextMonth, nextToNextMonth];
    }
  }
  //if the value of isBimonthly is one select second and fourth month from current month
  else if (isBimonthly == 1) {
    // if monthNumber is less than or equal to 8, add 2 for nextMonth and 4 for nextToNextMonth
    if (monthNumber >= 1 && monthNumber <= 8) {
      nextMonth = '${month[monthNumber + 2]} $year';
      nextToNextMonth = '${month[monthNumber + 4]} $year';
      return [nextMonth, nextToNextMonth];
    }
    // if monthNumber is 9 or 10, add 2 for nextMonth and subtract 8 for nextToNextMonth and add one for next year
    else if (monthNumber == 9 || monthNumber == 10) {
      nextMonth = '${month[monthNumber + 2]} $year';
      nextToNextMonth = '${month[monthNumber - 8]} ${year + 1}';
      return [nextMonth, nextToNextMonth];
    }
    // if monthNumber is 11 or 12, subtract 10 for nextMonth and 8 for nextToNextMonth as well add 1 for the next year
    else {
      nextMonth = '${month[monthNumber - 10]} ${year + 1}';
      nextToNextMonth = '${month[monthNumber - 8]} ${year + 1}';
      return [nextMonth, nextToNextMonth];
    }
  }
  // condition to display the nextMonth only while editing the autopay
  else {
    // if monthNumber is less than equal to 11 add 1 for the nextMonth
    if (monthNumber >= 1 && monthNumber <= 11) {
      nextMonth = '${month[monthNumber + 1]} $year';
      return [nextMonth];
    }
    // if monthNumber is 12 set nextMonth as 12 - 11 = 1 and 12 - 10 = 2 and year = year + 1
    else {
      nextMonth = '${month[monthNumber - 11]} ${year + 1}';
      return [nextMonth];
    }
  }
}
