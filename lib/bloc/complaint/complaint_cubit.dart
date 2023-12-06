import 'package:bloc/bloc.dart';
import 'package:ebps/data/models/complaints_config_model.dart';
import 'package:ebps/data/models/complaints_model.dart';
import 'package:ebps/data/repository/api_repository.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:meta/meta.dart';

part 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  Repository? repository;
  ComplaintCubit({@required this.repository}) : super(ComplaintInitial());

  //GET - ALL COMPLAINTS

  void getAllComplaints() async {
    if (!isClosed) {
      emit(ComplaintLoading());
    }

    try {
      final value = await repository?.getComplaints();

      logger.d(value,
          error:
              "COMPLAINT API RESPONSE ===> lib/bloc/complaint/getAllComplaints");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            complaints_model? complaintsModel =
                complaints_model.fromJson(value);
            if (!isClosed) {
              emit(ComplaintSuccess(ComplaintList: complaintsModel.data));
            }
          } else {
            if (!isClosed) {
              emit(ComplaintFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(ComplaintError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(ComplaintFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }

  //GET COMPLAINTS CONFIG

  void getComplaintConfig() async {
    if (!isClosed) {
      emit(ComplaintConfigLoading());
    }
    try {
      final value = await repository!.getComplaintConfig();

      logger.d(value,
          error:
              "COMPLAINT CONFIG API RESPONSE ===> lib/bloc/complaint/getComplaintConfig");

      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            complaints_config_model? complaints_config_details =
                complaints_config_model.fromJson(value);
            if (!isClosed) {
              emit(ComplaintConfigSuccess(
                  ComplaintConfigList: complaints_config_details.data));
            }
          } else {
            if (!isClosed) {
              emit(ComplaintConfigFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(ComplaintConfigError(message: value['message']));
          }
        }
      } else {
        if (!isClosed) {
          emit(ComplaintConfigFailed(message: value['message']));
        }
      }
    } catch (e) {}
  }
}
