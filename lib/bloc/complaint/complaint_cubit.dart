import 'package:bloc/bloc.dart';
import 'package:ebps/data/models/complaints_model.dart';
import 'package:ebps/data/repository/api_repository.dart';
import 'package:ebps/helpers/logger.dart';
import 'package:meta/meta.dart';

part 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  Repository? repository;
  ComplaintCubit({@required this.repository}) : super(ComplaintInitial());

  void getAllComplaints() async {
    if (!isClosed) {
      emit(ComplaintLoading());
    }

    try {
      var value = await repository?.getComplaints();

      logger.d(value,
          error:
              "COMPLAINT API RESPONSE ===> lib/bloc/history/getAllComplaints");

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
    } catch (e) {
      // Handle exceptions if needed
    }
  }
}
