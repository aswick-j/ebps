// const String BASE_URL = "http://192.168.192.186:5000/api";
// ignore_for_file: constant_identifier_names
import 'package:ebps/ebps.dart';

const String ACCOUNT_INFO_URL = "/payment/account-info";
const String AUTOPAY_DELETE_URL = "/auto-pay/delete/";
String get BASE_URL => ApiConstants.BASE_URL;

const String BILLER_URL = "/billers/billers-by-category/";
const String CATEGORIES_URL = "/categories/";
const String CATEGORY_BILLER_HISTORY_FILTER_URL =
    "/transactions/getcategorybiller";
const String CHART_URL = '/charts';

const String COMLPAINT_CONFIG_URL = '/complaints/config';
const String COMLPAINT_URL = "/complaints/";
const String DELETE_BILLER_URL = "/billers/delete/";
const String DELETE_UPCOMING_URL = "/billers/upcoming-due/";
const String FETCH_BILL_URL = "/payment/fetch-bill";
const String GEN_OTP_URL = "/user-services/generate-otp";
const String GET_ALL_UPCOMING_URL = "/billers/all-upcoming-dues/";
const String GET_AUTOPAY_MAXAMOUNT_URL = "/auto-pay/max-amount/";
const String GET_AUTOPAY_URL = "/auto-pay/";
const String GET_EDIT_SAVED_URL = "/billers/get-saved-details/";
const String GET_SAVED_BILLERS_URL = "/billers/saved/";
const String GET_COMPLAINT_STATUS = "/complaints/status/";
const String HISTORY_URL = "/transactions/";
const String INPUT_SIGN_URL = "/billers/input-signatures/";
const String LOGIN_URL = "/auth/login/";
const String PAY_BILL_URL = "/payment/bill";
const String PAYMENT_INFO_URL = "/billers/payment-information/";
const String SEARCH_URL = "/billers/search";
const String UPDATE_BILL_URL = "/billers/update";
const String VALIDATE_BILL_URL = "/payment/validate-bill";
const String VALIDATE_OTP_URL = "/user-services/validate-otp";
const String ADDUPDATE_UPCOMING_URL = "/billers/add-update-upcoming-due";
const String UPDATE_UPCOMING_URL = "/billers/update-upcoming-dues";
const String AUTOPAY_MODIFY_URL = "/auto-pay/status/";
const String PREPAID_PLANS_URL = "/payment/prepaid-fetch-plans";
const String AMOUNT_BY_DATE_URL = "/payment/amount-by-date/";
const String BBPS_SETTINGS_URL = "/user-services/bbps-settings";

const String redirectUrl = "/auth/redirect";
const String transactionUrl = "/transactions/";

const String allLocation = "/billers/location";
const String statesDataUrl = "/billers/states-data/";

const String addNewBillerUrl = "/billers/add-biller";
