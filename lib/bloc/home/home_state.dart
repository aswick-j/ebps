part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

//Categories
class CategoriesLoading extends HomeState {}

class CategoriesSuccess extends HomeState {
  List<CategorieData>? CategoriesList;
  CategoriesSuccess({@required this.CategoriesList});
}

class CategoriesFailed extends HomeState {
  final String? message;
  CategoriesFailed({@required this.message});
}

class CategoriesError extends HomeState {
  final String? message;
  CategoriesError({@required this.message});
}

class AllbillerListLoading extends HomeState {
  List<BillersData> prevData;
  bool isFirstFetch;

  AllbillerListLoading(this.prevData, {this.isFirstFetch = false});
}

class AllbillerListSuccess extends HomeState {
  List<BillersData>? allbillerList;
  AllbillerListSuccess({this.allbillerList});
}

class AllbillerListFailed extends HomeState {
  final String? message;
  AllbillerListFailed({@required this.message});
}

class AllbillerListError extends HomeState {
  final String? message;
  AllbillerListError({@required this.message});
}

//INPUT_SIGN

class InputSignatureLoading extends HomeState {}

class InputSignatureSuccess extends HomeState {
  List<InputSignaturesData>? InputSignatureList;
  InputSignatureSuccess({@required this.InputSignatureList});
}

class InputSignatureFailed extends HomeState {
  final String? message;
  InputSignatureFailed({@required this.message});
}

class InputSignatureError extends HomeState {
  final String? message;
  InputSignatureError({@required this.message});
}

//FETCH BILL

class FetchBillLoading extends HomeState {}

class FetchBillSuccess extends HomeState {
  final billerResponseData? fetchBillResponse;
  FetchBillSuccess({@required this.fetchBillResponse});
}

class FetchBillFailed extends HomeState {
  final String? message;
  FetchBillFailed({@required this.message});
}

class FetchBillError extends HomeState {
  final String? message;
  FetchBillError({@required this.message});
}

//ACCOUNT_INFO

class AccountInfoLoading extends HomeState {}

class AccountInfoSuccess extends HomeState {
  final List<AccountsData>? accountInfo;
  AccountInfoSuccess({@required this.accountInfo});
}

class AccountInfoFailed extends HomeState {
  final String? message;
  AccountInfoFailed({@required this.message});
}

class AccountInfoError extends HomeState {
  final String? message;
  AccountInfoError({@required this.message});
}

//PAYMENT INFO

class PaymentInfoLoading extends HomeState {}

class PaymentInfoSuccess extends HomeState {
  PaymentInformationModel? PaymentInfoDetail;
  PaymentInfoSuccess({@required this.PaymentInfoDetail});
}

class PaymentInfoFailed extends HomeState {
  final String? message;
  PaymentInfoFailed({@required this.message});
}

class PaymentInfoError extends HomeState {
  final String? message;
  PaymentInfoError({@required this.message});
}

//VALIDATE BILL

class ValidateBillLoading extends HomeState {}

class ValidateBillSuccess extends HomeState {
  final ValidateBillResponseData? validateBillResponseData;
  String? bbpsTranlogId;
  ValidateBillSuccess(
      {@required this.validateBillResponseData, this.bbpsTranlogId});
}

class ValidateBillFailed extends HomeState {
  final String? message;
  ValidateBillFailed({@required this.message});
}

class ValidateBillError extends HomeState {
  final String? message;
  ValidateBillError({@required this.message});
}

//CONFIRM FETCH BILL

class ConfirmFetchBillLoading extends HomeState {}

class ConfirmFetchBillSuccess extends HomeState {
  final ConfirmFetchBillData? ConfirmFetchBillResponse;
  ConfirmFetchBillSuccess({@required this.ConfirmFetchBillResponse});
}

class ConfirmFetchBillFailed extends HomeState {
  final String? message;
  ConfirmFetchBillFailed({@required this.message});
}

class ConfirmFetchBillError extends HomeState {
  final String? message;
  ConfirmFetchBillError({@required this.message});
}

//GEN - OTP

class OtpInitial extends HomeState {}

class OtpLoading extends HomeState {}

class OtpSuccess extends HomeState {
  final String? refrenceNumber;
  final String? message;
  OtpSuccess({@required this.refrenceNumber, @required this.message});
}

class OtpFailed extends HomeState {
  final String? message;
  OtpFailed({@required this.message});
}

class OtpError extends HomeState {
  final String? message;
  OtpError({@required this.message});
}

//VALIDATE -OTP
class OtpValidateLoading extends HomeState {}

class OtpValidateSuccess extends HomeState {}

class OtpValidateFailed extends HomeState {
  final String? message;
  OtpValidateFailed({@required this.message});
}

class OtpValidateError extends HomeState {
  final String? message;
  OtpValidateError({@required this.message});
}

//DELETE-BILLER
class deleteBillerLoading extends HomeState {}

class deleteBillerSuccess extends HomeState {
  final String? from;
  Map<String, dynamic>? data;
  final String? message;
  deleteBillerSuccess(
      {@required this.from, @required this.message, @required this.data});
}

class deleteBillerFailed extends HomeState {
  final String? from;
  final String? message;
  Map<String, dynamic>? data;
  deleteBillerFailed(
      {@required this.from, @required this.message, @required this.data});
}

class deleteBillerError extends HomeState {
  final String? message;
  deleteBillerError({@required this.message});
}

//PAY-BILL

class PayBillLoading extends HomeState {}

class PayBillSuccess extends HomeState {
  final String? from;
  Map<String, dynamic>? data;
  final String? message;
  PayBillSuccess(
      {@required this.from, @required this.message, @required this.data});
}

class PayBillFailed extends HomeState {
  final String? from;
  final String? message;
  Map<String, dynamic>? data;
  PayBillFailed(
      {@required this.from, @required this.message, @required this.data});
}

class PayBillError extends HomeState {
  final String? message;
  PayBillError({@required this.message});
}

//SEARCH

class BillersSearchLoading extends HomeState {}

class BillersSearchSuccess extends HomeState {
  List<BillersData>? searchResultsData;
  BillersSearchSuccess({@required this.searchResultsData});
}

class BillersSearchError extends HomeState {
  String? message;
  BillersSearchError({@required this.message});
}

class BillersSearchFailed extends HomeState {
  String? message;
  BillersSearchFailed({@required this.message});
}
