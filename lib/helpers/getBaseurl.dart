String getBaseUrl(String flavor) {
  switch (flavor.toLowerCase()) {
    case "prd":
      return "https://digiservices.equitasbank.com/bbps/api";
    case "pre-prd":
      return "https://digiservices.equitasbank.com/bbps/api";
    case "uat":
      return "https://digiservicesuat.equitasbank.com/bbps/api";
    case "dev":
      return "https://digiservicesuat.equitasbank.com/bbps/api";
    default:
      return "https://digiservices.equitasbank.com/--";
  }
}
