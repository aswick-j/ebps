import 'package:bloc/bloc.dart';
import 'package:ebps/domain/models/category_biller_filter_history._model.dart';
import 'package:ebps/domain/models/history_model.dart';
import 'package:ebps/domain/repository/api_repository.dart';

import 'package:ebps/shared/helpers/getDateValues.dart';
import 'package:ebps/shared/helpers/logger.dart';
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

    if (!isClosed) {
      emit(HistoryLoading());
    }
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
              emit(HistorySuccess(historyData: historyModel!.data));
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
}
