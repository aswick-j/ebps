import 'package:ebps/data/models/account_info_model.dart';
import 'package:ebps/data/models/billers_model.dart';
import 'package:ebps/data/models/categories_model.dart';
import 'package:ebps/data/models/fetch_bill_model.dart';
import 'package:ebps/data/models/input_signatures_model.dart';
import 'package:ebps/data/repository/api_repository.dart';
import 'package:ebps/utils/logger.dart';
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
            final List<BillersData> billdata =
                (state as AllbillerListLoading).prevData;
            prevBillerData!
                .addAll(all_biller.billData as Iterable<BillersData>);
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
      emit(AccountInfoError(message: 'An error occurred'));
    }
  }
}
