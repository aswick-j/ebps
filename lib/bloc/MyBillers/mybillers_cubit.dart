import 'package:bloc/bloc.dart';
import 'package:ebps/data/models/fetch_auto_pay_max_amount_model.dart';
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
}
