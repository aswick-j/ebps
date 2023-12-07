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
