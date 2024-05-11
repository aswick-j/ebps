import 'package:ebps/helpers/logger.dart';
import 'package:ebps/models/account_info_model.dart';
import 'package:ebps/models/amount_by_date_model.dart';
import 'package:ebps/models/bbps_settings_model.dart';
import 'package:ebps/models/billers_model.dart';
import 'package:ebps/models/categories_model.dart';
import 'package:ebps/models/fetch_bill_model.dart';
import 'package:ebps/models/input_signatures_model.dart';
import 'package:ebps/models/otp_model.dart';
import 'package:ebps/models/paymentInformationModel.dart';
import 'package:ebps/models/prepaid_fetch_plans_model.dart';
import 'package:ebps/models/validate_bill_model.dart';
import 'package:ebps/repository/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Repository? repository;
  int pageNumber = 1;
  List<CategorieData>? categoriesData = [];

  HomeCubit({
    required this.repository,
  }) : super(HomeInitial());

  // CATEGORY CUBIT

  void getAllCategories() async {
    if (isClosed) return;

    emit(CategoriesLoading());

    try {
      final value = await repository!.getCategories();

      if (value != null && !value.toString().contains("Invalid token")) {
        final status = value['status'];
        final message = value['message'];

        if (status == 200) {
          final categoriesModel = CategoriesModel.fromJson(value);
          categoriesData = categoriesModel.data;
          emit(CategoriesSuccess(CategoriesList: categoriesModel.data));
        } else {
          emit(CategoriesFailed(message: message));
          logger.e(
            error:
                "GET ALL CATEGORY API ERROR ===> lib/bloc/home/getAllCategories",
            value,
          );
        }
      } else {
        emit(CategoriesError(
            message: value != null
                ? value['message']
                : 'Failed to retrieve response'));
        logger.e(
          error:
              "GET ALL CATEGORY API ERROR ===> lib/bloc/home/getAllCategories",
          value,
        );
      }
    } catch (e) {
      logger.e(
        error: "GET ALL CATEGORY API ERROR ===> lib/bloc/home/getAllCategories",
        e,
      );
    }
  }

  //BILLER CUBIT
  void getAllBiller(cid, pageNumber) async {
    if (state is AllbillerListLoading) return;

    final currentState = state;
    List<BillersData>? prevBillerData = <BillersData>[];

    if (pageNumber != 1 && currentState is AllbillerListSuccess) {
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

  void getInputSingnature(billID) async {
    if (!isClosed) {
      emit(InputSignatureLoading());
    }
    try {
      final value = await repository!.getInputSignature(billID);
      logger.d(value,
          error:
              "GET INPUT SIGN API RESPONSE ===> lib/bloc/home/getInputSingnature");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            InputSignaturesModel? InputDetails =
                InputSignaturesModel.fromJson(value);
            if (!isClosed) {
              emit(
                  InputSignatureSuccess(InputSignatureList: InputDetails.data));
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
    dynamic customerBillId,
    String? billName,
    dynamic forChannel,
    String? planId,
    String? planType,
    String? supportPlan,
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
        customerBillId,
      );

      // value = {
      //   "message":
      //       "You have no pending bill. Please contact biller for more information.",
      //   "status": 400,
      // };
      // value = {
      //   "message": "no bill data. Please contact biller for more information.",
      //   "status": 400,
      // };
      // value = {
      //   "message": "You. Please contact biller for more information.",
      //   "status": 400,
      // };
      logger.d(value,
          error: "FETCH BILL API RESPONSE ===> lib/bloc/home/fetchBill");

      if (value != null && !value.toString().contains("Invalid token")) {
        if (value['status'] == 200) {
          FetchBillModel? fetchBillModel = FetchBillModel.fromJson(value);
          if (!isClosed) {
            emit(FetchBillSuccess(fetchBillResponse: fetchBillModel.data));
          }
        } else {
          logger.e(
              error: "FETCH BILL API ERROR ===> lib/bloc/home/fetchBill",
              value);
          if (!isClosed) emit(FetchBillFailed(message: value?['message']));
        }
      } else {
        logger.e(
            error: "FETCH BILL API ERROR ===> lib/bloc/home/fetchBill", value);
        if (!isClosed) {
          emit(FetchBillError(message: value?['message'] ?? 'Unknown error'));
        }
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
              "PAYMENT API RESPONSE ===> lib/bloc/home/getPaymentInformation");
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
                  "PAYMENT API  API ERROR ===> lib/bloc/home/getPaymentInformation");
          emit(PaymentInfoFailed(message: value['message']));
        }
      }
    } catch (e) {
      logger.e(e,
          error:
              "PAYMENT API  API ERROR ===> lib/bloc/home/getPaymentInformation");
    }
  }

  //AMOUNT BY DATE

  void getAmountByDate() async {
    if (!isClosed) {
      emit(AmountByDateLoading());
    }
    try {
      final value = await repository!.getAmountByDate();
      logger.d(value,
          error:
              "AMOUNT BY DATE API RESPONSE ===> lib/bloc/home/getAmountByDate");
      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            AmountByDateModel? amountByDateModel =
                AmountByDateModel.fromJson(value);
            if (!isClosed) {
              emit(AmountByDateSuccess(amountByDate: amountByDateModel.data));
            }
          } else {
            if (!isClosed) {
              emit(AmountByDateFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AmountByDateError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(AmountByDateFailed(message: value['message']));
        }
      }
    } catch (e) {
      logger.e(e,
          error: "AMOUNT BY DATE API ERROR ===> lib/bloc/home/getAmountByDate");
    }
  }

  //BBPS SETTING

  void getBbpsSettings() async {
    if (!isClosed) {
      emit(BbpsSettingsLoading());
    }
    try {
      final value = await repository!.getBbpsSettings();

      logger.d(value,
          error:
              "BBPS SETTINGS API RESPONSE ===> lib/bloc/home/getBbpsSettings");
      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            bbpsSettingsModel? BbpsSettingsDetails =
                bbpsSettingsModel.fromJson(value);
            if (!isClosed) {
              emit(
                  BbpsSettingsSuccess(BbpsSettingsDetail: BbpsSettingsDetails));
            }
          } else {
            if (!isClosed) {
              emit(BbpsSettingsFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(BbpsSettingsError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(BbpsSettingsFailed(message: value['message']));
        }
      }
    } catch (e) {
      logger.e(e,
          error:
              "BBPS SETTINGS API ERROR RESPONSE ===> lib/bloc/home/getBbpsSettings");
    }
  }

  //FETCH VAIDATE BIL

  void fetchValidateBill(dynamic payload) async {
    if (isClosed) return;

    emit(ValidateBillLoading());

    try {
      final value = await repository!.validateBill(payload);

      logger.d(value,
          error: "VALIDATE BILL API ===> lib/bloc/home/fetchValidateBill");

      if (value != null && !value.toString().contains("Invalid token")) {
        final status = value['status'];
        final message = value['message'];

        if (status == 200) {
          final validateBillModel = ValidateBillModel.fromJson(value);
          emit(
            ValidateBillSuccess(
              validateBillResponseData: validateBillModel.data,
              bbpsTranlogId: validateBillModel.data?.data?.bbpsTranlogId,
            ),
          );
        } else {
          emit(ValidateBillFailed(message: message));
        }
      } else {
        emit(ValidateBillError(
            message: value != null
                ? value['message']
                : 'Failed to retrieve response'));
      }
    } catch (e) {
      emit(ValidateBillError(message: 'Failed to retrieve response'));
      // Handle exceptions
    }
  }

  //GENERATE OTP

  void generateOtp({templateName, billerName}) async {
    try {
      if (!isClosed) {
        emit(OtpLoading());
      }
      final value = await repository!
          .generateOtp(templateName: templateName, billerName: billerName);
      logger.d(
        value,
        error: "GEN OTP API RESPONSE ===> lib/bloc/home/generateOTP",
      );

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            OtpModel otpModel = OtpModel.fromJson(value);
            if (!isClosed) {
              emit(OtpSuccess(
                  refrenceNumber: otpModel.data, message: otpModel.message));
            }
          } else {
            if (!isClosed) {
              emit(OtpFailed(
                  message: value['message'],
                  limitReached: value["limitReached"] ?? false));
            }
          }
        } else {
          if (!isClosed) {
            emit(OtpError(
                message: value['message'],
                limitReached: value["limitReached"] ?? false));
          }
        }
      } else {
        if (!isClosed) {
          emit(OtpFailed(message: "Please try again later"));
        }
      }
    } catch (e) {}
  }

  //VALIDATE-OTP

  void validateOTP(String otp) async {
    try {
      if (isClosed) return;

      emit(OtpValidateLoading());

      final value = await repository!.validateOtp(otp);
      logger.d(value,
          error: "VALIDATE OTP API RESPONSE ===> lib/bloc/home/validateOTP");

      if (value != null) {
        if (value.toString().contains("Invalid token")) {
          emit(OtpValidateError(message: value['message']));
        } else {
          final status = value['status'];
          final message = value['message'];

          if (status == 200) {
            emit(OtpValidateSuccess());
          } else if (status == 400 || status == 500) {
            emit(OtpValidateFailed(message: message));
          } else {
            emit(OtpValidateFailed(message: message));
          }
        }
      } else {
        emit(OtpValidateFailed(message: "Failed to retrieve response"));
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  //DELETE BILLER
  void deleteBiller(String cusbillID, String customerId, String otp) async {
    if (!isClosed) {
      emit(deleteBillerLoading());
    }
    try {
      final value = await repository!.deleteBiller(cusbillID, customerId, otp);
      logger.d(value,
          error: "DELETE BILLER API RESPONSE ===> lib/bloc/home/deleteBiller");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            if (!isClosed) {
              emit(deleteBillerSuccess());
            }
          } else {
            if (!isClosed) {
              emit(deleteBillerFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(deleteBillerError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(deleteBillerFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //CREATE AUTOPAY

  void createAutopay(data) async {
    if (!isClosed) {
      emit(createAutopayLoading());
    }
    try {
      final value = await repository!.createAutopayData(data);

      logger.d(value,
          error:
              "CREATE AUTOPAY API RESPONSE ===> lib/bloc/home/createAutopay");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 400) {
            if (!isClosed) {
              emit(createAutopayFailed(
                  message: "Auto pay already enabled for this biller."));
            }
          } else if (value['status'] == 200) {
            if (!isClosed) {
              emit(createAutopaySuccess(message: data['billerName']));
            }
          } else {
            if (!isClosed) {
              emit(createAutopayFailed(message: "Unable to Create Auto Pay."));
            }
          }
        } else {
          if (!isClosed) {
            emit(createAutopayError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(createAutopayFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //DELETE AUTOPAY

  void deleteAutoPay(id, otp) async {
    if (!isClosed) {
      emit(deleteAutopayLoading());
    }
    try {
      final value = await repository!.removeAutoPay(id, otp);

      logger.d(value,
          error:
              "DELETE AUTOPAY API RESPONSE ===> lib/bloc/home/deleteAutoPay");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            if (!isClosed) {
              emit(deleteAutopaySuccess(message: value['message']));
            }
          } else {
            if (!isClosed) {
              emit(deleteAutopayFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(deleteAutopayError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(deleteAutopayFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //EDIT AUTOPAY

  void editAutoPay(id, data) async {
    if (!isClosed) {
      emit(editAutopayLoading());
    }
    try {
      final value = await repository!.editAutopayData(id, data);

      logger.d(value,
          error: "EDIT AUTOPAY API RESPONSE ===> lib/bloc/home/editAutoPay");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            if (!isClosed) {
              emit(editAutopaySuccess(message: data['billerName']));
            }
          } else {
            if (!isClosed) {
              emit(editAutopayFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(editAutopayError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(editAutopayFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //MODIFY AUTOPAY

  void modifyAutopay(id, status, otp) async {
    if (!isClosed) {
      emit(modifyAutopayLoading());
    }
    try {
      final value = await repository!.modifyAutopay(id, status, otp);
      logger.d(value,
          error:
              "MODIFY STATUS AUTOPAY API RESPONSE ===> lib/bloc/home/modifyAutopay");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            if (!isClosed) {
              emit(modifyAutopaySuccess(message: value['message']));
            }
          } else {
            if (!isClosed) {
              emit(modifyAutopayFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(modifyAutopayError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(modifyAutopayFailed(message: value['message']));
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
    int? customerBillID,
    String tnxRefKey,
    bool quickPay,
    dynamic inputSignature,
    bool otherAmount,
    bool autopayStatus,
    dynamic billerData,
    String otp,
  ) async {
    if (isClosed) return;

    emit(PayBillLoading());

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
        otp,
      );

      logger.d(value,
          error: "PAY BILL API RESPONSE ===> lib/bloc/home/payBIll");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          final status = value['status'];
          final message = value['message'];
          final data = value['data'];

          if (status == 400) {
            emit(PayBillFailed(
              from: "fromConfirmPaymentOtp",
              message: message,
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
            ));
          } else if (status == 200) {
            final paymentDetails = value['data']['paymentDetails'];

            if (paymentDetails.containsKey('success') &&
                paymentDetails['success']) {
              emit(
                PayBillSuccess(
                  from: "fromConfirmPaymentOtp",
                  message: message,
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
            } else {
              emit(
                PayBillFailed(
                  from: "fromConfirmPaymentOtp",
                  message: message,
                  data: {
                    "res": value['data'],
                    "billerID": billerID,
                    "acNo": acNo,
                    "billerName": billerName,
                    "billAmount": billAmount,
                    "customerBillID": customerBillID,
                    "inputSignature": inputSignature,
                    "billerData": billerData,
                  },
                ),
              );
            }
          } else if (status == 500) {
            if (message.toLowerCase().contains("timed out") && data == null) {
              emit(PayBillFailed(
                  from: "fromConfirmPaymentOtp",
                  message: "timeout",
                  data: null));
            } else if (!message.toLowerCase().contains("timed out")) {
              emit(PayBillFailed(
                from: "fromConfirmPaymentOtp",
                message: "status_500",
                data: {
                  "res": value['data'],
                  "billerID": billerID,
                  "acNo": acNo,
                  "billerName": billerName,
                  "billAmount": billAmount,
                  "customerBillID": customerBillID,
                  "inputSignature": inputSignature,
                  "billerData": billerData,
                },
              ));
            } else {
              emit(
                PayBillFailed(
                  from: "fromConfirmPaymentOtp",
                  message: message,
                  data: {
                    "res": value['data'],
                    "billerID": billerID,
                    "acNo": acNo,
                    "billerName": billerName,
                    "billAmount": billAmount,
                    "customerBillID": customerBillID,
                    "inputSignature": inputSignature,
                    "billerData": billerData,
                  },
                ),
              );
            }
          } else {
            emit(
              PayBillFailed(
                from: "fromConfirmPaymentOtp",
                message: message,
                data: {
                  "res": value['data'],
                  "billerID": billerID,
                  "acNo": acNo,
                  "billerName": billerName,
                  "billAmount": billAmount,
                  "customerBillID": customerBillID,
                  "inputSignature": inputSignature,
                },
              ),
            );
          }
        } else {
          emit(PayBillError(message: value['message']));
        }
      } else {
        emit(PayBillFailed(
          from: "fromConfirmPaymentOtp",
          message: "Failed to retrieve response",
        ));
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  //SEARCH

  void searchBiller(queryString, Category, pageNumber) async {
    if (state is BillersSearchLoading) return;

    final currentState = state;
    List<BillersData>? prevSearchBillerData = <BillersData>[];

    if (pageNumber != 1 && currentState is BillersSearchSuccess) {
      prevSearchBillerData = currentState.searchResultsData;
    }

    emit(BillersSearchLoading(prevSearchBillerData!,
        isFirstFetch: pageNumber == 1));

    Map<String, dynamic> searchPayload = {
      "searchString": queryString,
      "category": Category,
      "location": "All",
      "pageNumber": pageNumber
    };
    //{"searchString":"test","category":"All","location":"All","pageNumber":1}

    try {
      final value = await repository!.getSearchedBillers(
          searchPayload['searchString'],
          searchPayload['category'],
          searchPayload['location'],
          searchPayload['pageNumber']);

      // logger.d(value,
      //     error: "SEARCH BILLER API RESPONSE ===> lib/bloc/home/searchBiller");
      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            BillerModel? billersSearchModel = BillerModel.fromJson(value);
            // final List<BillersData> billdata =
            //     (state as AllbillerListLoading).prevData;
            prevSearchBillerData
                .addAll(billersSearchModel.billData as Iterable<BillersData>);
            if (!isClosed) {
              emit(BillersSearchSuccess(
                  searchResultsData: prevSearchBillerData));
            }
            //
            //  success emit
            // if (!isClosed) {
            //   emit(BillersSearchSuccess(
            //       searchResultsData: billersSearchModel.billData));
            // }
          } else {
            //  failed emit
            if (!isClosed) {
              emit(BillersSearchFailed(message: value['message']));
            }
          }
        } else {
          //  error emit
          if (!isClosed) {
            emit(BillersSearchError(message: value['message']));
          }
        }
      } else {
        //  failed emit

        if (!isClosed) {
          emit(BillersSearchFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //FETCH PREPAID PLANS

  void PrepaidFetchPlans(dynamic id) async {
    if (!isClosed) {
      emit(PrepaidFetchPlansLoading());
    }

    try {
      final value = await repository!.PrepaidFetchPlans(id);

      logger.d(value,
          error:
              "PREPAID FETCH PLANS API RESPONSE ===> lib/bloc/home/PrepaidFetchPlans");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            PrepaidFetchPlansModel? prepaidFetchPlansModel =
                PrepaidFetchPlansModel.fromJson(value);
            //  success emit
            if (!isClosed) {
              emit(PrepaidFetchPlansSuccess(
                  prepaidPlansData: prepaidFetchPlansModel.data!.data));
            }
          } else {
            //  failed emit
            if (!isClosed) {
              emit(PrepaidFetchPlansFailed(message: value['message']));
            }
          }
        } else {
          //  error emit
          if (!isClosed) {
            emit(PrepaidFetchPlansError(message: value['message']));
          }
        }
      } else {
        //  failed emit

        if (!isClosed) {
          emit(PrepaidFetchPlansFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }
}
