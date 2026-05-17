import 'package:blood_synergy_app/Cubits/DashboardCubit/dashboard_cubit.dart';
import 'package:blood_synergy_app/Cubits/doctors_cubit/doctors_cubit.dart';
import 'package:blood_synergy_app/Cubits/supplements_cubit/supplements_cubit.dart';
import 'package:blood_synergy_app/views/home/homeScreen.dart';
import 'package:blood_synergy_app/views/screens/Find%20Doctor/findDoctors.dart';
import 'package:blood_synergy_app/views/screens/PorfileScreen/ProfileScreen.dart';
import 'package:blood_synergy_app/views/screens/Supplement/supplements_Screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

import 'dart:io' show Platform;

import '../../Cubits/home_cubit/home_cubit.dart';
import '../../Repositories/HomeRepository.dart';
import '../../helpers/Constants.dart';
import '../../network_helpers/network.dart';

enum TabScreens { Home, Wellness, findDoctor, Profile }

extension Screens on TabScreens {
  Widget get screen {
    switch (this) {
      case TabScreens.Home:
        return BlocProvider(
          create: (context) =>
              HomeCubit(HomeRepository(NetworkClient(Client(), dio: Dio()))),
          child: HomeScreen(),
        );
      case TabScreens.Wellness:
        return BlocProvider(
          create: (context) => SupplementsCubit(
              HomeRepository(NetworkClient(Client(), dio: Dio()))),
          child: SupplementsScreen(),
        );
      case TabScreens.findDoctor:
        return FindDoctorScreen();
      case TabScreens.Profile:
        return ProfileScreen();

      default:
        return Container(
          color: Colors.blue,
        );
    }
  }

  String get appBarTitle {
    switch (this) {
      case TabScreens.Home:
        return 'Explore Feeds';
      case TabScreens.Wellness:
        return 'Matches & Bookings';
      case TabScreens.findDoctor:
        return 'Explore Venue';
      case TabScreens.Profile:
        return 'Profile';
      default:
        return 'N/A';
    }
  }

  int get index {
    switch (this) {
      case TabScreens.Home:
        return 0;
      case TabScreens.Wellness:
        return 1;
      case TabScreens.findDoctor:
        return 2;
      case TabScreens.Profile:
        return 3;

      default:
        return -1;
    }
  }

  void talk() {
    print('meow');
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          body: state.screen.screen,
          key: Constants.scaffoldGlobalKey,
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
            ),
            // child: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(30.0)),
            child: BottomNavigationBar(
              key: Constants.bottomNavGlobalKey,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color.fromARGB(255, 246, 246, 246),
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              selectedIconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor,
                  opacity: 1.0,
                  size: 18.0),
              unselectedIconTheme:
                  IconThemeData(color: Colors.grey, opacity: 1.0, size: 18.0),
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
                        height: 17.w,
                        width: 17.w,
                      ),
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: SvgPicture.asset(
                        'assets/tabIcons/ic_supplements.svg',
                        color: state.screen.index == 1
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        height: 17.w,
                        width: 17.w,
                      ),
                    ),
                    label: 'Wellness'),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: SvgPicture.asset(
                        'assets/tabIcons/ic_doctor.svg',
                        color: state.screen.index == 4
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        height: 17.w,
                        width: 17.w,
                      ),
                    ),
                    label: 'Practitioners'),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: SvgPicture.asset(
                        'assets/tabIcons/ic_profile.svg',
                        color: state.screen.index == 4
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        height: 17.w,
                        width: 17.w,
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
