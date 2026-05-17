import 'package:blood_synergy_app/Cubits/reports_bloc/reports_bloc.dart';
import 'package:blood_synergy_app/Cubits/statistics_cubit/statistics_cubit.dart';
import 'package:blood_synergy_app/Models/Catergories.dart';
import 'package:blood_synergy_app/Models/UserModel.dart';
import 'package:blood_synergy_app/Repositories/StatisticsRepository.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/AppNetworkImage.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:blood_synergy_app/helpers/utils.dart';
import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:blood_synergy_app/views/screens/widgets/MsgWidget.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' show Client;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/statistics/statistic.dart';

// class LipidPanelScreen extends StatefulWidget {
//   const LipidPanelScreen({Key? key}) : super(key: key);

//   @override
//   State<LipidPanelScreen> createState() => _LipidPanelScreenState();
// }

class LipidPanelScreen extends StatelessWidget {
  final Categories category;
  LipidPanelScreen({required this.category, Key? key}) : super(key: key);

  // @override
  // void initState() {
  //   super.initState();
  //  }

  // @override
  // void dispose() {
  //   super.dispose();
  //  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Container(
                height: 190.h,
                width: 375.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(30),
                      bottomRight: const Radius.circular(30).w),
                  color: const Color.fromRGBO(207, 27, 33, 1),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, top: 30).r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              'assets/images/backImgRed.png',
                              height: 46.h,
                              width: 46.w,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Util.push(
                                  context,
                                  BlocProvider(
                                    create: (context) => StatisticsCubit(
                                        StatisticsRepository(NetworkClient(
                                            Client(),
                                            dio: Dio()))),
                                    child: StatisticsScreen(),
                                  ));
                            },
                            child: Container(
                              height: 43.h,
                              width: 91.w,
                              //  margin: EdgeInsets.only(left: 0, right: 0, top: 20).r,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(243, 243, 243, 1),
                                borderRadius: BorderRadius.all(
                                  const Radius.circular(12.0).w,
                                ),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Color(0xffe2e2e2),
                                //     offset: const Offset(
                                //       1.0,
                                //       1.0,
                                //     ),
                                //     blurRadius: 10.0,
                                //     spreadRadius: 2.0,
                                //   ), //BoxShadow

                                //   //BoxShadow
                                // ]
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'View Stats',
                                  style: appTextTheme.giloryBold12AppTheme,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25).r,
                        child: Text(
                          category.name ?? '',
                          style: appTextTheme.giloryBold22White,
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        category.shortDescription ?? '',
                        style: appTextTheme.gilorySemiBold12White,
                      )
                    ],
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 18).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Test Reports',
                    style: appTextTheme.giloryBold22Black,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                    style: appTextTheme.giloryRegular12lightGrey,
                  ),
                ],
              ),
            ),
            Expanded(child: _reportsList()),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  AppNavigator.navigateToCreateForm(
                      context, category, BlocProvider.of<ReportsBloc>(context));
                },
                child: Container(
                  width: 345.w,
                  height: 51.h,
                  margin: const EdgeInsets.only(
                          top: 0, left: 15, right: 15, bottom: 20)
                      .r,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(92, 174, 65, 1),
                    borderRadius: BorderRadius.all(const Radius.circular(12).w),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Input your blood lab values',
                      style: appTextTheme.gilorySemiBold16White,
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

// Assuming you have the necessary imports for EasyLoading, msgWidget, and other dependencies.

  Widget _reportsList() {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        print(state.runtimeType);
        if (state.screen == ReportsBlocScreens.reportListScreen) {
          print("reportListScreen observing");
          EasyLoading.dismiss();
          if (state.status.isInitial ||
              context.read<ReportsBloc>().shouldRefreshReports) {
            BlocProvider.of<ReportsBloc>(context)
                .add(FetchReports(category.id));
          } else if (state.status.isLoading) {
            EasyLoading.show(status: "Loading Reports...");
          } else if (state.status.isError) {
            return MsgWidget(msg: state.errorMessage);
          }

          return createList(state, context);
        }
        return SizedBox.shrink();
      },
    );
  }

  Future<void> _refresh(BuildContext context) async {
    BlocProvider.of<ReportsBloc>(context).add(FetchReports(category.id));
  }

  Widget createList(ReportsState state, BuildContext context) {
    ReportsBloc bloc = BlocProvider.of<ReportsBloc>(context);
    final CurrentUser user = AppStateManagerState.shared.UserData!;

    return (bloc.allReports.isEmpty && state.status == ReportsStatus.success)
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No reports found.'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(fontSize: 12.sp)),
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        _refresh(context);
                      },
                      label: const Text('reload'),
                    ),
                  ],
                ),
              ],
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: bloc.allReports.length,
            itemBuilder: (context, i) {
              var item = bloc.allReports[i];
              return GestureDetector(
                onTap: () {
                  AppNavigator.navigateToShowReport(
                      context,
                      BlocProvider.of<ReportsBloc>(context),
                      category.id,
                      item.reportId,
                      item.reportName);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Container(
                    height: 85.h,
                    width: 345.w,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(250, 250, 250, 1),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(15.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 21).r,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 45.w,
                            width: 45.w,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                              child: AppNetworkImage(path: item.user.image),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.reportName, // Assuming there is a 'name' property in ReportsModel
                                    style: appTextTheme.giloryBold15Black,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    item.createdAt,
                                    style: appTextTheme.giloryMedium8BlackTheme,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 25.h,
                            width: 65.w,
                            decoration: BoxDecoration(
                              color: item.isPositive == 1
                                  ? const Color.fromRGBO(238, 113, 113, 1)
                                  : const Color.fromRGBO(92, 174, 65, 1),
                              borderRadius: BorderRadius.all(
                                const Radius.circular(5.0),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                item.isPositive == 1 ? 'Positive' : 'Negative',
                                style: appTextTheme.giloryMedium9White,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
