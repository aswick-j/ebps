part of 'complaint_cubit.dart';

@immutable
sealed class ComplaintState {}

final class ComplaintInitial extends ComplaintState {}

//COMPLAINT LIST

class ComplaintLoading extends ComplaintState {}

class ComplaintSuccess extends ComplaintState {
  List<ComplaintsData>? ComplaintList;
  ComplaintSuccess({@required this.ComplaintList});
}

class ComplaintFailed extends ComplaintState {
  final String? message;
  ComplaintFailed({@required this.message});
}

class ComplaintError extends ComplaintState {
  final String? message;
  ComplaintError({@required this.message});
}

//COMPLAINT CONFIG

class ComplaintConfigLoading extends ComplaintState {}

class ComplaintConfigSuccess extends ComplaintState {
  configData? ComplaintConfigList;
  ComplaintConfigSuccess({@required this.ComplaintConfigList});
}

class ComplaintConfigFailed extends ComplaintState {
  final String? message;
  ComplaintConfigFailed({@required this.message});
}

class ComplaintConfigError extends ComplaintState {
  final String? message;
  ComplaintConfigError({@required this.message});
}

//COMPLAINT SUBMIT

class ComplaintSubmitLoading extends ComplaintState {}

class ComplaintSubmitSuccess extends ComplaintState {
  final String? message;
  final String? data;

  ComplaintSubmitSuccess({@required this.message, @required this.data});
}

class ComplaintSubmitFailed extends ComplaintState {
  final String? message;
  ComplaintSubmitFailed({@required this.message});
}

class ComplaintSubmitError extends ComplaintState {
  final String? message;
  ComplaintSubmitError({@required this.message});
}
