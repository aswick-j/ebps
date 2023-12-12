part of 'mybillers_cubit.dart';

@immutable
sealed class MybillersState {}

final class MybillersInitial extends MybillersState {}

//AUTOPAY MAX AMOUNT

class FetchAutoPayMaxAmountLoading extends MybillersState {}

class FetchAutoPayMaxAmountSuccess extends MybillersState {
  FetchAutoPayMaxAmountModel? fetchAutoPayMaxAmountModel;
  FetchAutoPayMaxAmountSuccess({@required this.fetchAutoPayMaxAmountModel});
}

class FetchAutoPayMaxAmountFailed extends MybillersState {
  final String? message;
  FetchAutoPayMaxAmountFailed({@required this.message});
}

class FetchAutoPayMaxAmountError extends MybillersState {
  final String? message;
  FetchAutoPayMaxAmountError({@required this.message});
}

//GET ALL UPCOMING DUES

class UpcomingDuesLoading extends MybillersState {}

class UpcomingDuesSuccess extends MybillersState {
  List<UpcomingDuesData>? upcomingDuesData;
  UpcomingDuesSuccess({@required this.upcomingDuesData});
}

class UpcomingDuesFailed extends MybillersState {
  final String? message;
  UpcomingDuesFailed({@required this.message});
}

class UpcomingDuesError extends MybillersState {
  final String? message;
  UpcomingDuesError({@required this.message});
}

//GET ALL AUTOPAY

class AutoPayLoading extends MybillersState {}

class AutopaySuccess extends MybillersState {
  AutoSchedulePayData? autoScheduleData;

  AutopaySuccess({@required this.autoScheduleData});
}

class AutopayFailed extends MybillersState {
  final String? message;
  AutopayFailed({@required this.message});
}

class AutopayError extends MybillersState {
  final String? message;
  AutopayError({@required this.message});
}

//GET ALL SAVED BILLRS

class SavedBillerLoading extends MybillersState {}

class SavedBillersLoading extends MybillersState {}

class SavedBillersSuccess extends MybillersState {
  List<SavedBillersData>? savedBillersData;
  SavedBillersSuccess({@required this.savedBillersData});
}

class SavedBillersFailed extends MybillersState {
  final String? message;
  SavedBillersFailed({@required this.message});
}

class SavedBillersError extends MybillersState {
  final String? message;
  SavedBillersError({@required this.message});
}

//GET EDIT BILLER SAVED

class EditBillLoading extends MybillersState {}

class EditBillSuccess extends MybillersState {
  EditbillData? EditBillList;
  EditBillSuccess({@required this.EditBillList});
}

class EditBillFailed extends MybillersState {
  final String? message;
  EditBillFailed({@required this.message});
}

class EditBillError extends MybillersState {
  final String? message;
  EditBillError({@required this.message});
}

//UPDATE EDIT  BILLER

class UpdateBillLoading extends MybillersState {}

class UpdateBillSuccess extends MybillersState {
  UpdateBillModel? UpdateBillDetails;
  UpdateBillSuccess({@required this.UpdateBillDetails});
}

class UpdateBillFailed extends MybillersState {
  final String? message;
  UpdateBillFailed({@required this.message});
}

class UpdateBillError extends MybillersState {
  final String? message;
  UpdateBillError({@required this.message});
}
