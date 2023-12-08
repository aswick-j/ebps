import 'package:bloc/bloc.dart';
import 'package:ebps/data/models/auto_schedule_pay_model.dart';
import 'package:ebps/data/models/fetch_auto_pay_max_amount_model.dart';
import 'package:ebps/data/models/saved_biller_model.dart';
import 'package:ebps/data/models/upcoming_dues_model.dart';
import 'package:ebps/data/repository/api_repository.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:meta/meta.dart';

part 'mybillers_state.dart';

class MybillersCubit extends Cubit<MybillersState> {
  Repository? repository;
  MybillersCubit({@required this.repository}) : super(MybillersInitial());

  //AUTOPAY MAX AMOUNT

  void getAutoPayMaxAmount() async {
    if (!isClosed) {
      emit(FetchAutoPayMaxAmountLoading());
    }
    try {
      final value = await repository!.getAutoPayMaxAmount();

      logger.d(value,
          error:
              "AUTOPAY MAX AMOUNT API RESPONSE ===> lib/bloc/mybillers/getAutoPayMaxAmount");
      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            FetchAutoPayMaxAmountModel? fetchAutoPayMaxAmountModel =
                FetchAutoPayMaxAmountModel.fromJson(value);

            if (!isClosed) {
              emit(FetchAutoPayMaxAmountSuccess(
                  fetchAutoPayMaxAmountModel: fetchAutoPayMaxAmountModel));
            }
          } else {
            if (!isClosed) {
              emit(FetchAutoPayMaxAmountFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(FetchAutoPayMaxAmountError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(FetchAutoPayMaxAmountFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //GET ALL UPCOMING DUES
  void getAllUpcomingDues() async {
    if (!isClosed) {
      emit(UpcomingDuesLoading());
    }
    try {
      final value = await repository!.getAllUpcomingDues();

      logger.d(value,
          error:
              "GET ALL UPCOMING DUES API RESPONSE ===> lib/bloc/mybillers/getAllUpcomingDues");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            UpcomingDuesModel? upcomingDuesModel =
                UpcomingDuesModel.fromJson(value);
            //  success emit
            if (!isClosed) {
              emit(UpcomingDuesSuccess(
                  upcomingDuesData: upcomingDuesModel.data));
            }
          } else {
            //  failed emit
            if (!isClosed) {
              emit(UpcomingDuesFailed(message: value['message']));
            }
          }
        } else {
          //  error emit
          if (!isClosed) {
            emit(UpcomingDuesError(message: value['message']));
          }
        }
      } else {
        //  failed emit
        if (!isClosed) {
          emit(UpcomingDuesFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //GET ALL AUTOPAY
  void getAutopay() async {
    if (!isClosed) {
      emit(AutoPayLoading());
    }
    try {
      final value = await repository!.getAutoPay();

      logger.d(value,
          error:
              "GET ALL AUTOPAY API RESPONSE ===> lib/bloc/mybillers/getAutopay");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            AutoSchedulePayModel? autoSchedulePayModel =
                AutoSchedulePayModel.fromJson(value);
            if (!isClosed) {
              emit(AutopaySuccess(autoScheduleData: autoSchedulePayModel.data));
            }
          } else {
            if (!isClosed) {
              emit(AutopayFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AutopayError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(AutopayFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //GET ALL SAVED BILLERS

  void getSavedBillers() async {
    if (!isClosed) {
      emit(SavedBillersLoading());
    }
    try {
      final value = await repository!.getSavedBillers();
      logger.d(value,
          error:
              "GET ALL SAVED BILLER API RESPONSE ===> lib/bloc/mybillers/getSavedBillers");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            SavedBillersModel? savedBillersModel =
                SavedBillersModel.fromJson(value);
            //  success emit
            if (!isClosed) {
              emit(SavedBillersSuccess(
                  savedBillersData: savedBillersModel.data));
            }
          } else {
            //  failed emit
            if (!isClosed) {
              emit(SavedBillersFailed(message: value['message']));
            }
          }
        } else {
          //  error emit
          if (!isClosed) {
            emit(SavedBillersError(message: value['message']));
          }
        }
      } else {
        //  failed emit

        if (!isClosed) {
          emit(SavedBillersFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }
}
