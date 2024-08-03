import 'package:ebps/constants/routes.dart';
import 'package:ebps/ebps.dart';
import 'package:ebps/models/decoded_model.dart';

List fetchBillRoutes = [
  bILLERPARAMROUTE,
  pREPAIDBILLERPARAMROUTE,
  pREPAIDPLANSROUTE,
  fETCHBILLERDETAILSROUTE,
  bILLERHISTORYROUTE,
  hISTORYROUTE,
  hISTORYDETAILSROUTE,
  rEGISTERCOMPLAINTROUTE,
  cOMPLAINTLISTROUTE,
  cOMPLAINTDETAILSROUTE,
  cOMPLAINTREGISTERROUTE,
];

List payBillRoutes = [
  pAYMENTCONFIRMROUTE,
  tRANSROUTE,
];

List viewBBPSRoutes = [
  sPLASHROUTE,
  hOMEROUTE,
  allCATROUTE,
  bILLERLISTROUTE,
  sESSIONEXPIREDROUTE,
  sEARCHROUTE,
  uPCOMINGDUESROUTE,
  nOTPERMITTEDROUTE,
  tERMANDCONDITIONSROUTE
];

List autoPayRoutes = [cREATEAUTOPAYROUTE, eDITAUTOPAYROUTE];

List modifyBillerRoutes = [eDITBILLERROUTE];

List otpRoutes = [oTPPAGEROUTE];

authRoutes(AuthRole? Role) {
  try {
    List<String> allowedRoutes = [
      if (Role!.viewBbps) ...viewBBPSRoutes,
      if (Role.fetchBiller) ...fetchBillRoutes,
      if (Role.modifyBiller) ...modifyBillerRoutes,
      if (Role.payBill) ...payBillRoutes,
      if (Role.autoPayment) ...autoPayRoutes,
      ...otpRoutes
    ];

    RouteConstants.ALLOWED_ROUTES = allowedRoutes;
  } catch (e) {
    RouteConstants.ALLOWED_ROUTES = [];
  }
}

bool VerifyOtpRoute(String RouteName) {
  try {
    if (RouteName == "confirm-payment" &&
        RouteConstants.ALLOWED_ROUTES.contains(pAYMENTCONFIRMROUTE)) {
      return true;
    } else if (RouteName == "disable-auto-pay" ||
        RouteName == "enable-auto-pay" &&
            RouteConstants.ALLOWED_ROUTES.contains(eDITAUTOPAYROUTE)) {
      return true;
    } else if (RouteName == "delete-biller-otp" &&
        RouteConstants.ALLOWED_ROUTES.contains(eDITBILLERROUTE)) {
      return true;
    } else if (RouteName == "create-auto-pay" ||
        RouteName == "edit-auto-pay" ||
        RouteName == "delete-auto-pay" &&
            RouteConstants.ALLOWED_ROUTES.contains(cREATEAUTOPAYROUTE) ||
        RouteConstants.ALLOWED_ROUTES.contains(eDITAUTOPAYROUTE)) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
