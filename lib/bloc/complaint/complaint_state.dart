part of 'complaint_cubit.dart';

@immutable
sealed class ComplaintState {}

final class ComplaintInitial extends ComplaintState {}

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
