import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:equatable/equatable.dart';

import '../../Models/UserModel.dart';
import '../../helpers/app_result_state.dart';
import '../../views/home/Dashboard.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState(null));
  CurrentUser user = AppStateManagerState.shared.UserData!;

  void changeTab(int selectedTab) {
    var screen = TabScreens.Home;
    switch (selectedTab) {
      case 1:
        screen = TabScreens.Wellness;
        break;
      case 2:
        screen = TabScreens.findDoctor;
        break;
      case 3:
        screen = TabScreens.Profile;
        break;
      default:
        screen = TabScreens.Home;
    }
    emit(state.copyWith(screen: screen));
  }

  void toggleNotification() {
    AppStateManagerState.shared.UserData!.settings?.pushNotification =
        AppStateManagerState.shared.UserData!.settings?.pushNotification == 0
            ? 1
            : 0;
    user = AppStateManagerState.shared.UserData!;
  }
}
