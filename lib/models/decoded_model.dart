class DecodedModel {
  String platform;
  String customerId;
  String mobileNumber;
  String elite;
  List<Accounts> accounts;
  AuthRole role;
  int iat;
  int exp;

  DecodedModel({
    required this.platform,
    required this.customerId,
    required this.mobileNumber,
    required this.elite,
    required this.accounts,
    required this.role,
    required this.iat,
    required this.exp,
  });

  factory DecodedModel.fromJson(Map<String, dynamic> json) => DecodedModel(
        platform: json["platform"],
        customerId: json["customerID"],
        mobileNumber: json["mobileNumber"],
        elite: json["elite"],
        accounts: List<Accounts>.from(
            json["accounts"].map((x) => Accounts.fromJson(x))),
        role: AuthRole.fromJson(json["role"]),
        iat: json["iat"],
        exp: json["exp"],
      );

  Map<String, dynamic> toJson() => {
        "platform": platform,
        "customerID": customerId,
        "mobileNumber": mobileNumber,
        "elite": elite,
        "accounts": List<dynamic>.from(accounts.map((x) => x.toJson())),
        "role": role.toJson(),
        "iat": iat,
        "exp": exp,
      };
}

class Accounts {
  String accountId;
  int id;

  Accounts({
    required this.accountId,
    required this.id,
  });

  factory Accounts.fromJson(Map<String, dynamic> json) => Accounts(
        accountId: json["accountID"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "accountID": accountId,
        "id": id,
      };
}

class AuthRole {
  bool viewBbps;
  bool fetchBiller;
  bool autoPayment;
  bool modifyBiller;
  bool payBill;

  AuthRole({
    required this.viewBbps,
    required this.fetchBiller,
    required this.autoPayment,
    required this.modifyBiller,
    required this.payBill,
  });

  factory AuthRole.fromJson(Map<String, dynamic> json) => AuthRole(
        viewBbps: json["VIEW_BBPS"],
        fetchBiller: json["FETCH_BILLER"],
        autoPayment: json["AUTO_PAYMENT"],
        modifyBiller: json["MODIFY_BILLER"],
        payBill: json["PAY_BILL"],
      );

  Map<String, dynamic> toJson() => {
        "VIEW_BBPS": viewBbps,
        "FETCH_BILLER": fetchBiller,
        "AUTO_PAYMENT": autoPayment,
        "MODIFY_BILLER": modifyBiller,
        "PAY_BILL": payBill,
      };
}
