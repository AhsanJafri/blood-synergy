part of 'home_cubit.dart';

@immutable
class HomeState {}

class HomeInitial extends HomeState {}

class HomeScreenStates extends HomeState {
  final AppResultState<dynamic>? result;
  HomeScreenStates(this.result);
}

// class HomeScreenStateCategories extends HomeState {
//   final List<Categories>? categories;
//   HomeScreenStateCategories(this.categories);
// }
