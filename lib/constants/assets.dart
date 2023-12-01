//LOGO

// ignore_for_file: constant_identifier_names

const LOGO_BBPS = "packages/ebps/assets/icon/logo_bbps.svg";

//JSON

const JSON_BILLPAY = "packages/ebps/assets/icon/billPay.json";

//ICON

const ICON_HOME_INACTIVE = "packages/ebps/assets/icon/icon_home_inactive.svg";
const ICON_HOME = 'packages/ebps/assets/icon/icon_home.svg';
const ICON_BILLERS_INACTIVE =
    'packages/ebps/assets/icon/icon_billers_inactive.svg';
const ICON_BILLERS = 'packages/ebps/assets/icon/icon_billers.svg';
const ICON_HISTORY_INACTIVE =
    'packages/ebps/assets/icon/icon_history_inactive.svg';
const ICON_HISTORY = 'packages/ebps/assets/icon/icon_history.svg';
const ICON_CALENDAR = 'packages/ebps/assets/icon/icon_calendar.svg';

const ICON_REFRESH = "packages/ebps/assets/icon/icon_refresh.svg";

const ICON_MOBILE_PREPAID = "packages/ebps/assets/icon/icon_mobile_prepaid.svg";
const ICON_DTH = "packages/ebps/assets/icon/icon_dth.svg";
const ICON_CABLE = "packages/ebps/assets/icon/icon_cable.svg";
const ICON_BROADBAND = "packages/ebps/assets/icon/icon_broadband.svg";
const ICON_LPG_GAS = "packages/ebps/assets/icon/icon_lpg.svg";
const ICON_GAS = "packages/ebps/assets/icon/icon_gas.svg";
const ICON_WATER = "packages/ebps/assets/icon/icon_water.svg";
const ICON_MOBILE_POSTPAID = "packages/ebps/assets/icon/icon_refresh.svg";
const ICON_LANDLINE_POSTPAID = "packages/ebps/assets/icon/icon_landline.svg";
const ICON_EDUCATION = "packages/ebps/assets/icon/icon_education.svg";
const ICON_SUBSCRIPTION = "packages/ebps/assets/icon/icon_sub.svg";
const ICON_ELECTRICITY = "packages/ebps/assets/icon/icon_electricity.svg";
const ICON_CREDIT_CARD = "packages/ebps/assets/icon/icon_credit.svg";
const ICON_LOAN = "packages/ebps/assets/icon/icon_loan.svg";
const ICON_HEALTH_INSURANCE =
    "packages/ebps/assets/icon/icon_health_insurance.svg";
const ICON_LIFE_INSURANCE = "packages/ebps/assets/icon/icon_life_insurance.svg";
const ICON_MUNICIPAL_TAXES = "packages/ebps/assets/icon/icon_municipal.svg";
const ICON_HOUSING = "packages/ebps/assets/icon/icon_refresh.svg";
const ICON_MUNICIPAL_SERVICES = "packages/ebps/assets/icon/icon_municipal.svg";
const ICON_CLUBS = "packages/ebps/assets/icon/icon_refresh.svg";

//IMAGE

const IMG_NOTFOUND = "packages/ebps/assets/icon/icon_notFound.svg";

String CATEGORY_ICON(String? CATEGORY_NAME) {
  switch (CATEGORY_NAME!.toLowerCase()) {
    case "mobile postpaid":
      return ICON_MOBILE_PREPAID;
    case "mobile prepaid":
      return ICON_MOBILE_PREPAID;
    case "education fees":
      return ICON_EDUCATION;
    case "landline postpaid":
      return ICON_LANDLINE_POSTPAID;
    case "dth":
      return ICON_DTH;
    case "electricity":
      return ICON_ELECTRICITY;
    case "broadband postpaid":
      return ICON_BROADBAND;
    case "water":
      return ICON_WATER;
    case "gas":
      return ICON_GAS;
    case "lpg gas":
      return ICON_LPG_GAS;
    case "life insurance":
      return ICON_LIFE_INSURANCE;
    case "loan repayment":
      return ICON_LOAN;
    case "Fastag":
      return ICON_MOBILE_POSTPAID;
    case "Cable TV":
      return ICON_CABLE;
    case "municipal services":
      return ICON_MUNICIPAL_SERVICES;
    case "clubs & associations":
    case "clubs and associations":
      return ICON_WATER;
    case "credit card":
      return ICON_CREDIT_CARD;
    case "hospital":
      return ICON_WATER;
    case "housing society":
      return ICON_WATER;
    case "subscription fees":
    case "subscription":
      return ICON_SUBSCRIPTION;
    case "municipal taxes":
      return ICON_MUNICIPAL_TAXES;
    case "health insurance":
      return ICON_HEALTH_INSURANCE;
    case "insurance":
      return ICON_HEALTH_INSURANCE;
    default:
      return ICON_CABLE;
  }
}
