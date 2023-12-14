import 'package:ebps/domain/models/decoded_model.dart';
import 'package:ebps/domain/services/api.dart';

Future<List<Accounts>> getDecodedAccounts() async {
  List<Accounts> decodedAccounts = [];
  try {
    DecodedModel? decodedModel = await validateJWT();

    if (decodedModel.toString() != 'restart') {
      decodedAccounts = decodedModel!.accounts!;
    }
  } catch (e) {
    print(e);
  }

  return decodedAccounts;
}

List<Accounts>? myAccounts = [];