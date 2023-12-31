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
