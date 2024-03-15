import 'package:bloc/bloc.dart';
import 'package:ebps/helpers/getDateValues.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:ebps/models/category_biller_filter_history._model.dart';
import 'package:ebps/models/history_model.dart';
import 'package:ebps/models/transaction_status_model.dart';
import 'package:ebps/models/transaction_status_update_model.dart';
import 'package:ebps/repository/api_repository.dart';

import 'package:flutter/material.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  Repository? repository;
  HistoryCubit({@required this.repository}) : super(HistoryInitial());

  Future<void> getHistoryDetails(
      dateValues, categoryId, billerId, pageNumber, custom) async {
    Map<String, dynamic> payload = {};
    if (custom) {
      var newEndDate = DateTime.parse(dateValues['endDate']);
      var finalEndDate = DateTime(
          newEndDate.year, newEndDate.month, newEndDate.day, 23, 59, 59);

      payload = {
        "startDate": dateValues['startDate'],
        "endDate": finalEndDate.toString(),
        "categoryId": categoryId,
        "billerId": billerId,
        "pageNumber": pageNumber
      };
    } else {
      Map<String, dynamic> dateData =
          await getTransactionHistoryDate(dateValues);
      payload = {
        "startDate": dateData['startDate'],
        "endDate": dateData['endDate'],
        "categoryId": categoryId,
        "billerId": billerId,
        "pageNumber": pageNumber
      };
    }

    if (state is HistoryLoading) return;

    final currentState = state;
    List<HistoryData>? prevHistoryData = <HistoryData>[];

    if (currentState is HistorySuccess) {
      prevHistoryData = currentState.historyData;
    }

    emit(HistoryLoading(prevHistoryData!, isFirstFetch: pageNumber == 1));
    try {
      final value = await repository!.getHistory(payload);
      // logger.d(value,
      //     error:
      //         "HISTORY API RESPONSE ===> lib/bloc/history/getHistoryDetails");
      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            HistoryModel? historyModel = HistoryModel.fromJson(value);
            if (!isClosed) {
              prevHistoryData
                  .addAll(historyModel.data as Iterable<HistoryData>);
              if (pageNumber == 1) {
                emit(HistorySuccess(historyData: historyModel.data));
              } else {
                emit(HistorySuccess(historyData: prevHistoryData));
              }
            }
          } else {
            if (!isClosed) {
              emit(HistoryFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(HistoryError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(HistoryFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  void billerFilter(
    String categoryID,
  ) async {
    if (!isClosed) {
      emit(billerFilterLoading());
    }
    try {
      final value = await repository!.getBillerHistoryFilter(categoryID);
      logger.d(value,
          error: " BILLER FILTER API RESPONSE ===> lib/bloc/home/billerFilter");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            CategoryBillerHistoryFilter? BilerFilter =
                CategoryBillerHistoryFilter.fromJson(value);
            if (!isClosed) {
              emit(billerFilterSuccess(billerFilterData: BilerFilter.data));
            }
          } else {
            if (!isClosed) {
              emit(billerFilterFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(billerFilterError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(billerFilterFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  void getTransactionStatusdetails(id) async {
    if (!isClosed) {
      emit(TransactionStatusLoading());
    }
    try {
      final value = await repository!.getTransactionStatus(id);

      logger.d(value,
          error:
              "Transaction STATUIS API RESPONSE ===> lib/bloc/history/getTransactionStatusdetails");
      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            TransactionStatus? TransactionStatusDetailsResult =
                TransactionStatus.fromJson(value);
            if (!isClosed) {
              emit(TransactionStatusSuccess(
                  TransactionStatusDetails: TransactionStatusDetailsResult));
            }
          } else {
            if (!isClosed) {
              emit(TransactionStatusFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(TransactionStatusError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(TransactionStatusFailed(message: value['message']));
        }
      }
    } catch (e) {
      logger.e(e,
          error:
              "TRANSACTION STATUS API ERROR RESPONSE ===> lib/bloc/history/getTransactionStatusdetails");
    }
  }

  //UPDATER TXN STATUS

  void updateTxnStatus(payload) async {
    if (!isClosed) {
      emit(TxnStatusUpdateLoading());
    }
    try {
      final value = await repository!.updateTransactionStatus(payload);
      logger.d(value,
          error:
              "UPDATE TXN STATUS API RESPONSE ===> lib/bloc/history/updateTxnStatus");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            TransactionStatusUpdateModel TxnStatusDetails =
                TransactionStatusUpdateModel.fromJson(value);
            if (!isClosed) {
              emit(TxnStatusUpdateSuccess(
                  TxnStatusUpdateDetails: TxnStatusDetails));
            }
          } else {
            if (!isClosed) {
              emit(TxnStatusUpdateFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(TxnStatusUpdateError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(TxnStatusUpdateFailed(message: value['message']));
        }
      }
    } catch (e) {
      logger.d(e,
          error:
              "UPDATE TXN STATUS API RESPONSE ===> lib/bloc/history/updateTxnStatus");
    }
  }
}
