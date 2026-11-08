import 'package:blood_synergy_app/Cubits/DashboardCubit/dashboard_cubit.dart';
import 'package:blood_synergy_app/views/home/homeScreen.dart';
import 'package:blood_synergy_app/views/screens/Find%20Doctor/findDoctors.dart';
import 'package:blood_synergy_app/views/screens/PorfileScreen/ProfileScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

import '../../Cubits/home_cubit/home_cubit.dart';
import '../../Repositories/HomeRepository.dart';
import '../../helpers/Constants.dart';
import '../../network_helpers/network.dart';

enum TabScreens { Home, findDoctor, Profile }

extension Screens on TabScreens {
  Widget get screen {
    switch (this) {
      case TabScreens.Home:
        return BlocProvider(
          create: (context) =>
              HomeCubit(HomeRepository(NetworkClient(Client(), dio: Dio()))),
          child: HomeScreen(),
        );
      case TabScreens.findDoctor:
        return FindDoctorScreen();
      case TabScreens.Profile:
        return ProfileScreen();
    }
  }

  String get appBarTitle {
    switch (this) {
      case TabScreens.Home:
        return 'Explore Feeds';
      case TabScreens.findDoctor:
        return 'Explore Venue';
      case TabScreens.Profile:
        return 'Profile';
    }
  }

  int get index {
    switch (this) {
      case TabScreens.Home:
        return 0;
      case TabScreens.findDoctor:
        return 1;
      case TabScreens.Profile:
        return 2;
    }
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
        final iconSize = isTablet ? 22.0 : 17.w;
        final labelStyle = TextStyle(fontSize: isTablet ? 13 : 11.sp);
        return Scaffold(
          body: state.screen.screen,
          key: Constants.scaffoldGlobalKey,
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              key: Constants.bottomNavGlobalKey,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color.fromARGB(255, 246, 246, 246),
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle:
                  labelStyle.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: labelStyle,
              selectedIconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor,
                  opacity: 1.0,
                  size: iconSize),
              unselectedIconTheme: IconThemeData(
                  color: Colors.grey, opacity: 1.0, size: iconSize),
              currentIndex: state.screen.index,
              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: SvgPicture.asset(
                        'assets/tabIcons/ic_home.svg',
                        color: state.screen.index == 0
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        height: iconSize,
                        width: iconSize,
                      ),
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: SvgPicture.asset(
                        'assets/tabIcons/ic_doctor.svg',
                        color: state.screen.index == 1
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        height: iconSize,
                        width: iconSize,
                      ),
                    ),
                    label: 'Practitioners'),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: SvgPicture.asset(
                        'assets/tabIcons/ic_profile.svg',
                        color: state.screen.index == 2
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        height: iconSize,
                        width: iconSize,
                      ),
                    ),
                    label: 'Profile'),
              ],
              onTap: (index) {
                context.read<DashboardCubit>().changeTab(index);
              },
            ),
          ),
        );
      },
    );
  }
}
