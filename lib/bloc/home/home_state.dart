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

// InputSignature
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
