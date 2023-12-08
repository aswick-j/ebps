String getDaySuffix(String day) {
  List<List<String>> dateLists = [
    [
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20",
      "24",
      "25",
      '26',
      "27",
      "28",
      "29",
      '30'
    ],
    ["1", "21", '31'],
    ["2", "22"],
    ["3", "23"],
  ];

  for (List<String> list in dateLists) {
    if (list.contains(day)) {
      if (day.endsWith("1") && !day.endsWith("11")) {
        return " st of every month";
      } else if (day.endsWith("2") && !day.endsWith("12")) {
        return " nd of every month";
      } else if (day.endsWith("3") && !day.endsWith("13")) {
        return " rd of every month";
      } else {
        return " th of every month";
      }
    }
  }

  return "";
}

void main() {
  String txtDate = "15"; // replace with your text
  String calDate = getDaySuffix(txtDate);
  print(calDate); // Output: "th of every month"
}
