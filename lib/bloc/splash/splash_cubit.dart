import 'package:bloc/bloc.dart';
import 'package:ebps/data/models/login_model.dart';
import 'package:ebps/data/repository/api_repository.dart';
import 'package:ebps/data/services/api.dart';
import 'package:ebps/utils/logger.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final Repository repository;

  SplashCubit({required this.repository}) : super(SplashInitial());

  void login(String id, String hash) async {
    try {
      emit(SplashLoading());

      final value = await repository.login(id, hash);

      logger.d(value, error: "LOGIN API RESPONSE ===> lib/bloc/splash");

      if (value != null &&
          value is Map<String, dynamic> &&
          value['status'] == 200) {
        final loginModel = LoginModel.fromJson(value);
        await setSharedValue(TOKEN, loginModel.data!.token);
        await setSharedValue(ENCRYPTION_KEY, loginModel.data!.encryptionKey);

        if (validateJWT() != 'restart') {
          emit(SplashSuccess());
        }
      } else {
        logger.e(error: "LOGIN API ERROR ===> lib/bloc/splash", value);
        emit(SplashError());
      }
    } catch (e, stackTrace) {
      logger.e(
          error: "LOGIN API ERROR ===> lib/bloc/splash",
          e,
          stackTrace: stackTrace);
      emit(SplashError());
    }
  }
}
