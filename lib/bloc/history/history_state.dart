part of 'history_cubit.dart';

@immutable
abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {
  List<HistoryData> prevData;
  bool isFirstFetch;

  HistoryLoading(this.prevData, {this.isFirstFetch = false});
}

class HistorySuccess extends HistoryState {
  List<HistoryData>? historyData;
  HistorySuccess({@required this.historyData});
}

class HistoryFailed extends HistoryState {
  final String? message;
  HistoryFailed({@required this.message});
}

class HistoryError extends HistoryState {
  final String? message;
  HistoryError({@required this.message});
}

//HISTORY FILTER

class billerFilterLoading extends HistoryState {}

class billerFilterSuccess extends HistoryState {
  List<Data>? billerFilterData;
  billerFilterSuccess({@required this.billerFilterData});
}

class billerFilterFailed extends HistoryState {
  final String? message;
  billerFilterFailed({@required this.message});
}

class billerFilterError extends HistoryState {
  final String? message;
  billerFilterError({@required this.message});
}

//TRANSACTION STATUS

class TransactionStatusLoading extends HistoryState {}

class TransactionStatusSuccess extends HistoryState {
  TransactionStatus? TransactionStatusDetails;
  TransactionStatusSuccess({@required this.TransactionStatusDetails});
}

class TransactionStatusFailed extends HistoryState {
  final String? message;
  TransactionStatusFailed({@required this.message});
}

class TransactionStatusError extends HistoryState {
  final String? message;
  TransactionStatusError({@required this.message});
}

//UPDATE TRANSACTION STATUS

class TxnStatusUpdateLoading extends HistoryState {}

class TxnStatusUpdateSuccess extends HistoryState {
  TransactionStatusUpdateModel? TxnStatusUpdateDetails;
  TxnStatusUpdateSuccess({@required this.TxnStatusUpdateDetails});
}

class TxnStatusUpdateFailed extends HistoryState {
  final String? message;
  TxnStatusUpdateFailed({@required this.message});
}

class TxnStatusUpdateError extends HistoryState {
  final String? message;
  TxnStatusUpdateError({@required this.message});
}
