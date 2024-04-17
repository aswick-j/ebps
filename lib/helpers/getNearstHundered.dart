double NearestHunderer(double number) {
  double a = number % 100;

  if (a > 0) {
    return number + (100 - number % 100);
  }

  return number;
}
