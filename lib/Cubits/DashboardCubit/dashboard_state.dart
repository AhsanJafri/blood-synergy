part of 'dashboard_cubit.dart';

class DashboardState {
  final AppResultState<dynamic>? result;
  TabScreens screen;
  DashboardState(this.result, {this.screen = TabScreens.Home});

  DashboardState copyWith(
      {AppResultState<dynamic>? result, TabScreens? screen}) {
    return DashboardState(result ?? this.result, screen: screen ?? this.screen);
  }
}
