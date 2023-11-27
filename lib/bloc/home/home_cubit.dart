import 'package:ebps/data/models/account_info_model.dart';
import 'package:ebps/data/models/billers_model.dart';
import 'package:ebps/data/models/categories_model.dart';
import 'package:ebps/data/models/confirm_fetch_bill_model.dart';
import 'package:ebps/data/models/fetch_bill_model.dart';
import 'package:ebps/data/models/input_signatures_model.dart';
import 'package:ebps/data/models/paymentInformationModel.dart';
import 'package:ebps/data/models/validate_bill_model.dart';
import 'package:ebps/data/repository/api_repository.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Repository? repository;
  int pageNumber = 1;

  HomeCubit({required this.repository}) : super(HomeInitial());

  //CATEGORY CUBIT

  void getAllCategories() async {
    if (!isClosed) {
      emit(CategoriesLoading());
    }
    try {
      final value = await repository!.getCategories();

      // logger.d(value,
      //     error:
      //         "GET ALL CATEGORIES API RESPONSE ===> lib/bloc/home/getAllCategories");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            CategoriesModel? categoriesModel = CategoriesModel.fromJson(value);
            if (!isClosed) {
              emit(CategoriesSuccess(CategoriesList: categoriesModel.data));
            }
          } else {
            if (!isClosed) {
              emit(CategoriesFailed(message: value['message']));
              logger.e(
                  error:
                      "GET ALL CATEGORY API ERROR ===> lib/bloc/home/getAllCategories",
                  value);
            }
          }
        } else {
          if (!isClosed) {
            logger.e(
                error:
                    "GET ALL CATEGORY API ERROR ===> lib/bloc/home/getAllCategories",
                value);

            emit(CategoriesError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(CategoriesFailed(message: value['message']));
          logger.e(
              error:
                  "GET ALL CATEGORY API ERROR ===> lib/bloc/home/getAllCategories",
              value);
        }
      }
    } catch (e) {
      logger.e(
          error:
              "GET ALL CATEGORY API ERROR ===> lib/bloc/home/getAllCategories",
          e);
    }
  }

  //BILLER CUBIT
  void getAllBiller(cid) async {
    if (state is AllbillerListLoading) return;

    final currentState = state;
    List<BillersData>? prevBillerData = <BillersData>[];

    if (currentState is AllbillerListSuccess) {
      prevBillerData = currentState.allbillerList;
    }

    emit(AllbillerListLoading(prevBillerData!, isFirstFetch: pageNumber == 1));

    try {
      final value = await repository!.getBillers(cid, pageNumber);

      // logger.d(value,
      //     error:
      //         "GET ALL BILLER API RESPONSE ===> lib/bloc/home/getAllBillers");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            BillerModel? all_biller = BillerModel.fromJson(value);
            pageNumber++;
            // final List<BillersData> billdata =
            //     (state as AllbillerListLoading).prevData;
            prevBillerData.addAll(all_biller.billData as Iterable<BillersData>);
            if (!isClosed) {
              emit(AllbillerListSuccess(allbillerList: prevBillerData));
            }
          } else {
            if (!isClosed) {
              emit(AllbillerListFailed(message: value['message']));
              logger.e(
                  error:
                      "GET ALL BILLER API ERROR ===> lib/bloc/home/getAllBiller",
                  value);
            }
          }
        } else {
          if (!isClosed) {
            emit(AllbillerListError(message: value['message']));
            logger.e(
                error:
                    "GET ALL BILLER API ERROR ===> lib/bloc/home/getAllBiller",
                value);
          }
        }
      } else {
        if (!isClosed) {
          logger.e(
              error: "GET ALL BILLER API ERROR ===> lib/bloc/home/getAllBiller",
              value);
          emit(AllbillerListFailed(message: value['message']));
        }
      }
    } catch (e) {
      logger.e(
          error: "GET ALL BILLER API ERROR ===> lib/bloc/home/getAllBiller", e);
    }
  }

  //INPUT SIGN

  void getInputSingnature(billID) {
    if (!isClosed) {
      emit(InputSignatureLoading());
    }
    try {
      repository!.getInputSignature(billID).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              InputSignaturesModel? InputDetails =
                  InputSignaturesModel.fromJson(value);
              if (!isClosed) {
                emit(InputSignatureSuccess(
                    InputSignatureList: InputDetails.data));
              }
            } else {
              if (!isClosed) {
                emit(InputSignatureFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(InputSignatureError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            //     logger.e(
            // error: "GET ALL BILLER API ERROR ===> lib/bloc/home/getAllBiller", e);

            emit(InputSignatureFailed(message: value['message']));
          }
        }
      });
    } catch (e) {}
  }

  //FETCH BILL
  void fetchBill({
    String? billerID,
    bool? quickPay,
    String? quickPayAmount,
    String? adHocBillValidationRefKey,
    bool? validateBill,
    Map<String, dynamic>? billerParams,
    String? billName,
  }) async {
    if (isClosed) return;

    emit(FetchBillLoading());

    try {
      var value = await repository!.fetchBill(
        validateBill,
        billerID,
        billerParams,
        quickPay,
        quickPayAmount,
        adHocBillValidationRefKey,
        billName,
      );

      logger.d(value,
          error: "FETCH BILL API RESPONSE ===> lib/bloc/home/fetchBill");

      if (value != null && !value.toString().contains("Invalid token")) {
        if (value['status'] == 200) {
          FetchBillModel? fetchBillModel = FetchBillModel.fromJson(value);
          if (!isClosed)
            emit(FetchBillSuccess(fetchBillResponse: fetchBillModel.data));
        } else {
          logger.e(
              error: "FETCH BILL API ERROR ===> lib/bloc/home/fetchBill",
              value);
          if (!isClosed) emit(FetchBillFailed(message: value['message']));
        }
      } else {
        logger.e(
            error: "FETCH BILL API ERROR ===> lib/bloc/home/fetchBill", value);
        if (!isClosed)
          emit(FetchBillError(message: value?['message'] ?? 'Unknown error'));
      }
    } catch (e) {
      logger.e(error: "FETCH BILL API ERROR ===> lib/bloc/home/fetchBill", e);
    }
  }

  //ACCOUNT_INFO

  Future<void> getAccountInfo(myAcc) async {
    if (isClosed) return;

    emit(AccountInfoLoading());

    try {
      var value = await repository!.getAccountInfo(myAcc);

      logger.d(value,
          error:
              "GET ACCOUNT DETAILS API RESPONSE ===> lib/bloc/home/getAccountInfo");

      if (value == null || value.toString().contains("Invalid token")) {
        emit(AccountInfoError(
            message: 'Invalid token or failed to get account info'));
      } else if (value['status'] == 200) {
        AccountInfoModel? accountInfoModel = AccountInfoModel.fromJson(value);
        emit(AccountInfoSuccess(accountInfo: accountInfoModel.data));
      } else {
        emit(AccountInfoFailed(message: value['message']));
      }
    } catch (e) {
      logger.e(
          error: "ACCOUNT INFO API ERROR ===> lib/bloc/home/getAccountInfo", e);

      emit(AccountInfoError(message: 'An error occurred'));
    }
  }

  //PAYMENT_INFO
  Future<void> getPaymentInformation(billerID) async {
    if (isClosed) return;

    emit(PaymentInfoLoading());

    try {
      final value = await repository!.getPaymentInformation(billerID);
      logger.d(value,
          error:
              "FETCH BILL API ERROR ===> lib/bloc/home/getPaymentInformation");
      if (value != null &&
          !value.toString().contains("Invalid token") &&
          value['status'] == 200) {
        final paymentInfoDetails = PaymentInformationModel.fromJson(value);
        if (!isClosed) {
          emit(PaymentInfoSuccess(PaymentInfoDetail: paymentInfoDetails));
        }
      } else {
        if (!isClosed) {
          logger.e(value,
              error:
                  "FETCH BILL API ERROR ===> lib/bloc/home/getPaymentInformation");
          emit(PaymentInfoFailed(message: value['message']));
        }
      }
    } catch (e) {
      logger.e(e,
          error:
              "FETCH BILL API ERROR ===> lib/bloc/home/getPaymentInformation");
    }
  }

  //FETCH VAIDATE BIL

  void fetchValidateBill(dynamic payload) async {
    debugPrint("validateBill payload ===>");
    if (!isClosed) {
      emit(ValidateBillLoading());
    }
    try {
      await repository!.validateBill(payload).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              ValidateBillModel? validateBillModel =
                  ValidateBillModel.fromJson(value);
              if (!isClosed) {
                emit(ValidateBillSuccess(
                  validateBillResponseData: validateBillModel.data,
                  bbpsTranlogId: validateBillModel.data!.data!.bbpsTranlogId,
                ));
              }
            } else {
              if (!isClosed) {
                emit(ValidateBillFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(ValidateBillError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(ValidateBillFailed(message: value['message']));
          }
        }
      });
    } catch (e) {}
  }

  //CONFIR FETCH BILL
  void confirmFetchBill(
      {String? billerID,
      bool? quickPay,
      String? quickPayAmount,
      String? adHocBillValidationRefKey,
      bool? validateBill,
      Map<String, dynamic>? billerParams,
      String? billName,

      //prepaid
      dynamic forChannel,
      dynamic planId,
      dynamic planType,
      dynamic supportPlan}) async {
    // String billerParams =
    //     "{\"a\":\"10\",\"a b\":\"20\",\"a b c\":\"30\",\"a b c d\":\"40\",\"a b c d e\":\"50\"}";

    if (!isClosed) {
      emit(ConfirmFetchBillLoading());
    }
    try {
      final value = await repository!.fetchBill(
          validateBill,
          billerID,
          billerParams,
          quickPay,
          quickPayAmount,
          adHocBillValidationRefKey,
          billName);
      logger.d(value,
          error:
              "GET CONFIRM FETCH API RESPONSE ===> lib/bloc/home/confirmFetchBill");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            ConfirmFetchBillModel? confirmfetchBillModel =
                ConfirmFetchBillModel.fromJson(value);
            if (!isClosed) {
              emit(ConfirmFetchBillSuccess(
                ConfirmFetchBillResponse: confirmfetchBillModel.data,
              ));
            }
          } else {
            if (!isClosed) {
              emit(ConfirmFetchBillFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(ConfirmFetchBillError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(ConfirmFetchBillFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //OTP

  void validateOTP(otp) async {
    try {
      if (!isClosed) {
        emit(OtpValidateLoading());
      }
      final value = await repository!.validateOtp('5555');
      logger.d(value,
          error: "VALIDATE OTP API RESPONSE ===> lib/bloc/home/validateOTP");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            if (!isClosed) {
              emit(OtpValidateSuccess());
            }
          } else if (value['status'] == 400) {
            if (!isClosed) {
              emit(OtpValidateFailed(message: value['message']));
            }
          } else if (value['status'] == 500) {
            if (!isClosed) {
              emit(OtpValidateFailed(message: value['message']));
            }
          } else if (value['message'].toString().contains("Invalid token")) {
            if (!isClosed) {
              emit(OtpValidateError(message: value['message']));
            }
          } else {
            if (!isClosed) {
              emit(OtpValidateFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(OtpValidateError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(OtpValidateFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //PAY-BILL

  void payBill(
    String billerID,
    String billerName,
    String billName,
    String acNo,
    String billAmount,
    int customerBillID,
    String tnxRefKey,
    bool quickPay,
    dynamic inputSignature,
    bool otherAmount,
    bool autopayStatus,
    dynamic billerData,
    String otp,
  ) async {
    if (!isClosed) {
      emit(PayBillLoading());
    }
    try {
      final value = await repository!.payBill(
          billerID,
          acNo,
          billAmount,
          customerBillID,
          tnxRefKey,
          quickPay,
          inputSignature,
          otherAmount,
          otp);

      logger.d(value,
          error: "PAY BILL API RESPONSE ===> lib/bloc/home/payBIll");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 400) {
            if (!isClosed) {
              emit(PayBillFailed(
                  from: "fromConfirmPaymentOtp",
                  message: "Your Ac Need to complete KYC"));
            }
          } else if (value['status'] == 200) {
            if (value['data']['paymentDetails'].containsKey('success')) {
              if (value['data']['paymentDetails']['success']) {
                if (!isClosed) {
                  emit(
                    PayBillSuccess(
                      from: "fromConfirmPaymentOtp",
                      message: value['message'],
                      data: {
                        "res": value['data'],
                        "billerID": billerID,
                        "billName": billName,
                        "acNo": acNo,
                        "billAmount": billAmount,
                        "customerBillID": customerBillID,
                        "tnxRefKey": tnxRefKey,
                        "quickPay": quickPay,
                        "inputSignature": inputSignature,
                        "otherAmount": otherAmount,
                        "autopayStatus": autopayStatus,
                        "billerData": billerData,
                      },
                    ),
                  );
                }
              } else {
                if (!isClosed) {
                  emit(
                    PayBillFailed(
                      from: "fromConfirmPaymentOtp",
                      message: value['message'],
                      data: {
                        "errData": value['data'],
                        "billerID": billerID,
                        "acNo": acNo,
                        "billerName": billerName,
                        "billAmount": billAmount,
                        "customerBillID": customerBillID,
                        "inputSignature": inputSignature
                      },
                    ),
                  );
                }
              }
            }
          } else if (value['status'] == 500 &&
              !(value['message']
                  .toString()
                  .toLowerCase()
                  .contains("timed out")) &&
              (value['data'] == null)) {
            if (!isClosed) {
              emit(PayBillFailed(
                  from: "fromConfirmPaymentOtp", message: "status_500"));
            }
          } else if (value['status'] == 500 &&
              (value['message']
                  .toString()
                  .toLowerCase()
                  .contains("timed out"))) {
            if (!isClosed) {
              emit(PayBillFailed(
                  from: "fromConfirmPaymentOtp", message: "timeout"));
            }
          } else {
            if (!isClosed) {
              emit(
                PayBillFailed(
                  from: "fromConfirmPaymentOtp",
                  message: value['message'],
                  data: {
                    "errData": value['data'],
                    "billerID": billerID,
                    "acNo": acNo,
                    "billerName": billerName,
                    "billAmount": billAmount,
                    "customerBillID": customerBillID,
                    "inputSignature": inputSignature
                  },
                ),
              );
            }
          }
        } else {
          //  error emit
          if (!isClosed) {
            emit(PayBillError(message: value['message']));
          }
        }
      } else {
        //  failed emit

        if (!isClosed) {
          emit(PayBillFailed(
              from: "fromConfirmPaymentOtp", message: value['message']));
        }
      }
    } catch (e) {}
  }
}
