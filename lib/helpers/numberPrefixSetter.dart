dynamic numberPrefixSetter(String inputNumber) {
  return '${inputNumber}${inputNumber.split("").last == "1" && inputNumber != "11" ? "st" : inputNumber.split("").last == "2" && inputNumber != "12" ? "nd" : inputNumber.split("").last == "3" && inputNumber != "13" ? "rd" : "th"}';
}