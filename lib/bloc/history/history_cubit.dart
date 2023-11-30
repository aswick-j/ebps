import 'package:bloc/bloc.dart';
import 'package:ebps/data/models/history_model.dart';
import 'package:ebps/data/repository/api_repository.dart';
import 'package:ebps/helpers/getDateValues.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:flutter/material.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  Repository? repository;
  HistoryCubit({@required this.repository}) : super(HistoryInitial());

  Future<void> getHistoryDetails(dateValues, custom) async {
    Map<String, dynamic> payload = {};
    if (custom) {
      var newEndDate = DateTime.parse(dateValues['endDate']);
      var finalEndDate = DateTime(
          newEndDate.year, newEndDate.month, newEndDate.day, 23, 59, 59);
      debugPrint("finalEndDate ::::");

      payload = {
        "startDate": dateValues['startDate'],
        "endDate": finalEndDate.toString()
      };
      // payload = dateValues;
      // }
    } else {
      Map<String, dynamic> dateData =
          await getTransactionHistoryDate(dateValues);

      payload = {
        "startDate": dateData['startDate'],
        "endDate": dateData['endDate'],
      };
    }

    if (!isClosed) {
      emit(HistoryLoading());
    }
    try {
      final value = await repository!.getHistory(payload);
      logger.d(value,
          error:
              "HISTORY API RESPONSE ===> lib/bloc/history/getHistoryDetails");
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
}
