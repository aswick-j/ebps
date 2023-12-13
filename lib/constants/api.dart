// ignore_for_file: constant_identifier_names

const String BASE_URL = "https://digiservicesuat.equitasbank.com/api";
// const String BASE_URL = "http://192.168.192.186:5000/api";

const String LOGIN_URL = "/auth/login/";
const String CATEGORIES_URL = "/categories/";
const String BILLER_URL = "/billers/billers-by-category/";
const String INPUT_SIGN_URL = "/billers/input-signatures/";
const String FETCH_BILL_URL = "/payment/fetch-bill";
const String ACCOUNT_INFO_URL = "/payment/account-info";
const String PAYMENT_INFO_URL = "/billers/payment-information/";
const String VALIDATE_BILL_URL = "/payment/validate-bill";
const String GEN_OTP_URL = "/user-services/generate-otp";
const String SEARCH_URL = "/billers/search";
const String HISTORY_URL = "/transactions/";

const String VALIDATE_OTP_URL = "/user-services/validate-otp";
const String PAY_BILL_URL = "/payment/bill";
const String COMLPAINT_URL = "/complaints/";
const String COMLPAINT_CONFIG_URL = '/complaints/config';
const String GET_AUTOPAY_MAXAMOUNT_URL = "/auto-pay/max-amount/";

const String GET_ALL_UPCOMING_URL = "/billers/all-upcoming-dues/";
const String GET_AUTOPAY_URL = "/auto-pay/";
const String GET_SAVED_BILLERS_URL = "/billers/saved/";

const String GET_EDIT_SAVED_URL = "/billers/get-saved-details/";
const String UPDATE_BILL_URL = "/billers/update";
const String DELETE_BILLER_URL = "/billers/delete/";
const String CATEGORY_BILLER_HISTORY_FILTER_URL =
    "/transactions/getcategorybiller";

const String redirectUrl = "/auth/redirect";
const String transactionUrl = "/transactions/";

const String upcomingDisableUrl = "/auto-pay/status/";
const String removeAutoPayUrl = "/auto-pay/delete/";

const String allLocation = "/billers/location";
const String statesDataUrl = "/billers/states-data/";

const String amountByDateUrl = "/payment/amount-by-date/";
const String prepaidFetchPlansUrl = "/payment/prepaid-fetch-plans";
const String addUpdateUpcomingDueUrl = "/billers/add-update-upcoming-due";
const String updateUpcomingDueUrl = "/billers/update-upcoming-dues";

const String chartUrl = '/charts';
const String addNewBillerUrl = "/billers/add-biller";
const String bbpsSettings = "/user-services/bbps-settings";
const String deleteUpcomingDueUrl = "/billers/upcoming-due/";
