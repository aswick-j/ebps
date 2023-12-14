//LOGO

// ignore_for_file: constant_identifier_names

const LOGO_EQUITAS = "packages/ebps/assets/logo/logo_equitas_normal.png";
const LOGO_BBPS = "packages/ebps/assets/icon/logo_bbps.svg";
const LOGO_BBPS_FULL = "packages/ebps/assets/logo/logo_bbps_full.svg";
const LOGO_BBPS_FULL_PNG = "packages/ebps/assets/logo/logo_bbps_full_png.png";

//JSON

const JSON_BILLPAY = "packages/ebps/assets/icon/billPay.json";

//ICON

//NAVBAR-ICONS
const ICON_BILLERS = 'packages/ebps/assets/icon/icon_billers.svg';
const ICON_BILLERS_INACTIVE =
    'packages/ebps/assets/icon/icon_billers_inactive.svg';

const ICON_CALENDAR = 'packages/ebps/assets/icon/icon_calendar.svg';
const ICON_HISTORY = 'packages/ebps/assets/icon/icon_history.svg';
const ICON_HISTORY_INACTIVE =
    'packages/ebps/assets/icon/icon_history_inactive.svg';

const ICON_HOME = 'packages/ebps/assets/icon/icon_home.svg';
const ICON_HOME_INACTIVE = "packages/ebps/assets/icon/icon_home_inactive.svg";

const ICON_SUCCESS = "packages/ebps/assets/icon/icon_success.svg";
const ICON_ARROW_UP = "packages/ebps/assets/icon/icon_arrow_up.svg";

//CATEGORY-ICONS

const ICON_B2B = "packages/ebps/assets/icon/icon_b2b.svg";
const ICON_BROADBAND = "packages/ebps/assets/icon/icon_broadband-postpaid.svg";
const ICON_CABLE = "packages/ebps/assets/icon/icon_cable-tv.svg";
const ICON_CLUBS = "packages/ebps/assets/icon/icon_clubs-associations.svg";
const ICON_CREDIT_CARD = "packages/ebps/assets/icon/icon_credit-card.svg";
const ICON_DTH = "packages/ebps/assets/icon/icon_dth.svg";
const ICON_EDUCATION = "packages/ebps/assets/icon/icon_education-fees.svg";
const ICON_ELECTRICITY = "packages/ebps/assets/icon/icon_electricity.svg";
const ICON_ELECTRICITYV2 = "packages/ebps/assets/icon/icon_electricity-v2.svg";
const ICON_FASTTAG = "packages/ebps/assets/icon/icon_fastag.svg";
const ICON_GAS = "packages/ebps/assets/icon/icon_gas.svg";
const ICON_HEALTH_INSURANCE =
    "packages/ebps/assets/icon/icon_health-insurance.svg";
const ICON_HOSPITAL = "packages/ebps/assets/icon/icon_hospital-pathology.svg";
const ICON_HOUSING = "packages/ebps/assets/icon/icon_housing-society.svg";
const ICON_INSURANCE = "packages/ebps/assets/icon/icon_insurance.svg";
const ICON_LANDLINE_POSTPAID =
    "packages/ebps/assets/icon/icon_landline-postpaid.svg";

const ICON_LIFE_INSURANCE = "packages/ebps/assets/icon/icon_life-insurance.svg";
const ICON_LOAN = "packages/ebps/assets/icon/icon_loan-repayment.svg";
const ICON_LPG_GAS = "packages/ebps/assets/icon/icon_lpg-gas.svg";
const ICON_METRO = "packages/ebps/assets/icon/icon_metro-recharge.svg";
const ICON_MOBILE_POSTPAID =
    "packages/ebps/assets/icon/icon_mobile-postpaid.svg";

const ICON_MOBILE_PREPAID = "packages/ebps/assets/icon/icon_mobile-prepaid.svg";
const ICON_MUNICIPAL_SERVICES =
    "packages/ebps/assets/icon/icon_municipal-services.svg";

const ICON_MUNICIPAL_TAXES =
    "packages/ebps/assets/icon/icon_municipal-taxes.svg";
const ICON_RECDEBOSIT = "packages/ebps/assets/icon/icon_recurring-deposit.svg";

const ICON_SUBSCRIPTION = "packages/ebps/assets/icon/icon_subscription.svg";
const ICON_WATER = "packages/ebps/assets/icon/icon_water.svg";

//APP-ICONS

const ICON_REFRESH = "packages/ebps/assets/icon/icon_refresh.svg";

//IMAGE

const IMG_NOTFOUND = "packages/ebps/assets/icon/icon_notFound.svg";
const SPLASH_BAG = "packages/ebps/assets/images/splash_background.png";

const LOADER = "packages/ebps/assets/logo/loader.gif";
const LOADER_V1 = "packages/ebps/assets/logo/loaderv1.gif";
const LOADER_V2 = "packages/ebps/assets/logo/loaderv2.gif";

String CATEGORY_ICON(String? CATEGORY_NAME) {
  switch (CATEGORY_NAME!.toLowerCase()) {
    case "b2b":
      return ICON_B2B;
    case "broadband postpaid":
      return ICON_BROADBAND;

    case "Cable TV":
      return ICON_CABLE;

    case "clubs & associations":
    case "clubs and associations":
      return ICON_CLUBS;
    case "credit card":
      return ICON_CREDIT_CARD;

    case "dth":
      return ICON_DTH;

    case "education fees":
      return ICON_EDUCATION;

    case "electricity":
      return ICON_ELECTRICITY;

    case "fastag":
      return ICON_FASTTAG;
    case "gas":
      return ICON_GAS;

    case "health insurance":
      return ICON_HEALTH_INSURANCE;

    case "hospital":
    case "hospital and pathology":
      return ICON_HOSPITAL;
    case "housing society":
      return ICON_HOUSING;
    case "insurance":
      return ICON_INSURANCE;
    case "landline postpaid":
      return ICON_LANDLINE_POSTPAID;

    case "life insurance":
      return ICON_LIFE_INSURANCE;

    case "loan repayment":
      return ICON_LOAN;

    case "lpg gas":
      return ICON_LPG_GAS;

    case "mobile postpaid":
      return ICON_MOBILE_POSTPAID;

    case "mobile prepaid":
      return ICON_MOBILE_PREPAID;

    case "municipal services":
      return ICON_MUNICIPAL_SERVICES;

    case "municipal taxes":
      return ICON_MUNICIPAL_TAXES;
    case "recurring deposit":
      return ICON_RECDEBOSIT;

    case "subscription fees":
    case "subscription":
      return ICON_SUBSCRIPTION;

    case "water":
      return ICON_WATER;

    default:
      return ICON_CABLE;
  }
}